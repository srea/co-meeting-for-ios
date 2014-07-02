//
//  SettingsViewController.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/05/01.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *pushSwitch;
@property (weak, nonatomic) IBOutlet UILabel *localPushLabel;
@property (weak, nonatomic) IBOutlet UIImageView *localPushSampleImageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *localPushSampleCell;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    FAKFontAwesome *icon = [FAKFontAwesome timesIconWithSize:25];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *image = [icon imageWithSize:CGSizeMake(25, 25)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(close)];
    self.navigationItem.rightBarButtonItem = closeButton;

    BOOL switchState = [self switchState];
    [_pushSwitch setOn:switchState];
    [self refreshLocalPushCells:switchState];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)localNotificationSwitch:(id)sender {
    UISwitch *pushSwitch = (UISwitch*)sender;
    if (!pushSwitch.on) {
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    } else {
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = [NSString stringWithFormat:@"%d件の未読があります(サンプル)", 10];
        notification.alertAction = @"未読チェック";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.userInfo = @{};
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    [self refreshLocalPushCells:pushSwitch.on];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:pushSwitch.on forKey:@"local_push_enable"];
    [ud synchronize];
}

- (void)refreshLocalPushCells:(BOOL)state
{
    [self cell:_localPushSampleCell setHidden:!state];
    [self reloadDataAnimated:YES];
    if (!state) {
        _localPushSampleImageView.alpha = 0.1;
        _localPushLabel.alpha = 0.1;
    } else {
        _localPushSampleImageView.alpha = 1;
        _localPushLabel.alpha = 1;
    }
}

- (BOOL)switchState
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"local_push_enable"];
}

- (IBAction)signout:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] bk_initWithTitle:nil message:@"Are you sure?"];
    [alertView bk_setCancelButtonWithTitle:@"cancel" handler:nil];
    [alertView bk_addButtonWithTitle:@"ok" handler:^{
        [COService resetOAuth:[myAccount getAccount]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView show];
//    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
//    [actionSheet setDestructiveButtonIndex:[actionSheet bk_addButtonWithTitle:@"Sign out" handler:^{
//
//    }]];
//    [actionSheet bk_setCancelButtonWithTitle:@"cancel" handler:nil];
//    [actionSheet showInView:self.view];
}

@end
