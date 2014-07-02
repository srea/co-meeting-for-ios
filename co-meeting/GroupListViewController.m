//
//  FirstViewController.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "GroupListViewController.h"
#import "MeetingListViewController.h"
#import "CONavigationController.h"
#import "COWebViewController.h"
#import "Cell.h"
#import "Group.h"
#import "COService.h"
#import "CWStatusBarNotification.h"
#import "UnreadView.h"

@interface GroupListViewController () <UITableViewDataSource, UITableViewDelegate, CellDelegate>
@property (nonatomic, strong) UnreadView *titleView;
@property (nonatomic, strong) CustomPBWebViewController *webViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) CWStatusBarNotification *notification;
@end

@implementation GroupListViewController

- (void)awakeFromNib
{
    [COService setup];
    _notification = [CWStatusBarNotification new];
    _notification.notificationLabelBackgroundColor = RGB(28, 28, 28);
    _notification.notificationLabelTextColor = [UIColor whiteColor];
    _notification.notificationStyle = CWNotificationStyleStatusBarNotification;
    _notification.notificationAnimationType = CWNotificationAnimationTypeOverlay;
    _notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    _notification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
}

- (void)viewDidLoad
{
    _items = @[].mutableCopy;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchGroups)
                                                 name:@"reload"
                                               object:nil];
    
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupOAuth2Notifications];
    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([myAccount getAccount]) {
        [self showTutorial];
        [self fetchGroups];
    } else {
        [self initOAuth];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showTutorial
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL show = [ud boolForKey:@"group_tutorial"];
    if (show) {
        return;
    }
    [ud setBool:YES forKey:@"group_tutorial"];
    [ud synchronize];

    // Setup coach marks
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{0.0f,64.0f},{320.0f,44.0f}}],
                                @"caption": @"グループがここに表示されます。数字をタップするとON/OFFの切り替えが出来ます。"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{274,23},{35,35}}],
                                @"caption": @"未読プッシュの設定やサインアウトはこのボタンから行えます。"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{110.0f,24.0f},{100.0f,35.0f}}],
                                @"caption": @"合計未読数がここに表示されます"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{11.0f,24.0f},{35.0f,35.0f}}],
                                @"caption": @"お問い合わせはこちら"
                                },
                            ];
    WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    [self.navigationController.view addSubview:coachMarksView];
    [coachMarksView start];
}

- (void)setupNavigationBar
{
    _titleView = [[UnreadView alloc] init];
    self.navigationItem.titleView = _titleView;
    [_titleView setNeedsUpdateConstraints]; // 位置を調整している

    FAKFontAwesome *icon = [FAKFontAwesome cogIconWithSize:25];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *image = [icon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(signout:)];
    self.navigationItem.rightBarButtonItems = @[sendButton];


    FAKFontAwesome *leftIcon = [FAKFontAwesome infoCircleIconWithSize:25];
    [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *leftImage = [leftIcon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:leftImage
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(info)];
    self.navigationItem.leftBarButtonItems = @[leftButton];
    
}

- (void)didAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    if (interfaceOrientation == UIDeviceOrientationPortrait) {
        
    } else {

    }
}

- (void)info
{
    [self performSegueWithIdentifier:@"info" sender:nil];
}

- (void)setupRefreshControl
{
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(fetchGroups) forControlEvents:UIControlEventValueChanged];
    [_tableView setAlwaysBounceVertical:YES];
    [_tableView addSubview:_refreshControl];
}

- (void)fetchGroups
{
    if (![myAccount getAccount]) {
        return;
    }
    [self.notification displayNotificationWithMessage:@"Loading" completion:nil];
    if ([myAccount getAccount]) {
        [COService myGroups:[myAccount getAccount] block:^(NSArray *groups) {
            [self.refreshControl endRefreshing];
            [self.notification dismissNotification];
            if (!groups) {
                return;
            }
            _items = groups;
            [self refreshApplicationBadge];
            [_tableView reloadData];
        }];
    } else {
        [self.notification dismissNotification];
        [self.refreshControl endRefreshing];
    }
}

- (void)refreshApplicationBadge
{
    int cnt = 0;
    for (Group *group in _items) {
        if (![group.unread_off boolValue]) {
            cnt += [group.unread_counts intValue];
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = cnt;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(cnt) forKey:@"unread_count"];
    [ud synchronize];
    [_titleView setCount:cnt];
}

- (void)setupOAuth2Notifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleSuccessAuth:)
                               name:NXOAuth2AccountStoreAccountsDidChangeNotification
                             object:[NXOAuth2AccountStore sharedStore]];
    [notificationCenter addObserver:self
                           selector:@selector(handleFailedAuth:)
                               name:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                             object:[NXOAuth2AccountStore sharedStore]];
}

- (void)handleSuccessAuth:(NSNotification *)notification {
    NXOAuth2Account *account = notification.userInfo[NXOAuth2AccountStoreNewAccountUserInfoKey];
    [myAccount setAccount:account];
    [self dismissViewControllerAnimated:YES completion:^{
        [self fetchGroups]; 
    }];
}

- (void)handleFailedAuth:(NSNotification *)notification {
    NSError *error = [notification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", error);
    }];
}

- (IBAction)signout:(id)sender {
    [self performSegueWithIdentifier:@"setting" sender:nil];
}

- (void)close{
    [self dismissViewControllerAnimated:NO completion:nil];
}

# pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
    //    return [NSString stringWithFormat:@"Group %d", _items.count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Group *group = _items[indexPath.row];
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.group = group;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Group *group = _items[indexPath.row];
    [self performSegueWithIdentifier:@"meeting" sender:group];
}

# pragma mark - CellDelegate

- (void)notifyTap:(Cell *)cell group:(Group *)group
{
    [COService notifyToggle:group];
    [cell refreshView];
    [self refreshApplicationBadge];
    //    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:nil message:@"未読通知を切り替えますか？"];
    //    [alertView setCancelButtonIndex:[alertView addButtonWithTitle:@"cancel"]];
    //    [alertView bk_addButtonWithTitle:@"ok" handler:^{
    //    }];
    //    [alertView show];
}

# pragma mark - OAuth Init

- (void)initOAuth
{
    // OAuth認証を行う
    [COService setupOAuth:^(NSURL *preparedURL) {
        _webViewController = [[COWebViewController alloc] init];
        _webViewController.URL = preparedURL;
        _webViewController.showsNavigationToolbar = YES;
        CONavigationController *navCon = [[CONavigationController alloc] initWithRootViewController:_webViewController];
        [self presentViewController:navCon animated:YES completion:nil];
    }];
}

# pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"meeting"]) {
        MeetingListViewController *con = segue.destinationViewController;
        con.group = sender;
    }
}
@end
