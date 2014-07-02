//
//  MeetingListViewController.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "MeetingListViewController.h"
#import "MeetingCell.h"
#import "Meetings.h"
#import "Meeting.h"
#import "CWStatusBarNotification.h"
#import "OpenInChromeController.h"

@interface MeetingListViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Meetings *items;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) CWStatusBarNotification *notification;
@end

@implementation MeetingListViewController

- (void)awakeFromNib
{
    _items = nil;
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
    [super viewDidLoad];
    self.title = _group.name;
    
    [self setupNavigationBar];
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
    [self fetchMeetings];
    [self showTutorial];
}

- (void)showTutorial
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL show = [ud boolForKey:@"meeting_tutorial"];
    if (show) {
        return;
    }
    [ud setBool:YES forKey:@"meeting_tutorial"];
    [ud synchronize];
    
    // Setup coach marks
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{218.5,23},{35,35}}],
                                @"caption": @"一括既読はこちらから"
                                },
                            ];
    WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    [self.navigationController.view addSubview:coachMarksView];
    [coachMarksView start];
}

- (void)fetchMeetings
{
    [self.notification displayNotificationWithMessage:@"Loading" completion:nil];
    [COService meetings:_group block:^(Meetings *meetings) {
        _items = meetings;
        [_refreshControl endRefreshing];
        [_tableView reloadData];
        [self.notification dismissNotification];
    }];
}

- (void)setupRefreshControl
{
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_tableView setAlwaysBounceVertical:YES];
    [_tableView addSubview:_refreshControl];
}

- (void)refresh
{
    [self fetchMeetings];
    [_refreshControl endRefreshing];
}

- (void)setupNavigationBar
{
    FAKFontAwesome *icon = [FAKFontAwesome shareSquareOIconWithSize:25];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *image = [icon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(actionTap:)];
    FAKFontAwesome *checkIcon = [FAKFontAwesome checkSquareIconWithSize:25];
    [checkIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *checkButton = [[UIBarButtonItem alloc] initWithImage:checkImage
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(markAsReadAllConfirm:)];
    self.navigationItem.rightBarButtonItems = @[sendButton, checkButton];
    
    // バックアイコンを設定
    //http://stackoverflow.com/questions/19078995/removing-the-title-text-of-an-ios-7-uibarbuttonitem
    FAKFontAwesome *leftIcon = [FAKFontAwesome chevronLeftIconWithSize:25];
    [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *leftIconImage = [leftIcon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:leftIconImage
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(backTap)];
    self.navigationItem.leftBarButtonItems = @[backButton];
    //    self.navigationController.navigationBar.topItem.title = @"";
    
    // MEMO:バックアイコンを設定することで無効になってしまったスワイプバックを再び有効にする
    [self.navigationController.interactivePopGestureRecognizer setDelegate:self];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)markAsReadAllConfirm:(id)sender
{
    UIAlertView *alertView = [UIAlertView bk_showAlertViewWithTitle:@"一括既読しますか？" message:@"イイね等の未読は消せません"
                                                  cancelButtonTitle:@"cancel"
                                                  otherButtonTitles:@[@"ok"]
                                                            handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                                if (buttonIndex == 1) {
                                                                    dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                                   {
                                                                                       __weak typeof(self) wself = self;
                                                                                       [_items markAsReadAll:_group.id block:^{
                                                                                           [wself performSelector:@selector(fetchMeetings) withObject:nil afterDelay:1];
                                                                                       }];
                                                                                   });
                                                                }
                                                            }];
    [alertView show];
}

- (void)backTap
{
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.meetings.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
    //    return [NSString stringWithFormat:@"Group %d", _items.count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Meeting *meeting = _items.meetings[indexPath.row];
    MeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.meeting = meeting;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Meeting *meeting = _items.meetings[indexPath.row];
    [COService openMeeting:meeting parentViewController:self];
}

- (IBAction)actionTap:(id)sender {
    NSString *groupUrl = [NSString stringWithFormat:@"https://www.co-meeting.com/m/#groupPage?group_id=%@", _group.group_id];
    
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"Open Webview" handler:^{
        [COService openGroup:_group parentViewController:self];
    }];
    [actionSheet bk_addButtonWithTitle:@"Open Safari" handler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:groupUrl]];
    }];
    
    OpenInChromeController *chromeCon = [[OpenInChromeController alloc] init];
    if ([chromeCon isChromeInstalled]) {
        [actionSheet bk_addButtonWithTitle:@"Open Chrome" handler:^{
            NSURL *callbackURL = [NSURL URLWithString:@"co-meeting-123://"];
            BOOL success = [chromeCon openInChrome:[NSURL URLWithString:groupUrl]
                                   withCallbackURL:callbackURL
                                      createNewTab:YES];
        }];
    }
    
    [actionSheet bk_setCancelButtonWithTitle:@"cancel" handler:nil];
    [actionSheet showInView:self.view];
}


@end
