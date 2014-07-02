//
//  AppDelegate.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "AppDelegate.h"
#import <Crittercism.h>
// Google Analytics
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import <Parse/Parse.h>
#define GOOGLE_ANALYTICS_ID @"UA-46529892-4"

@implementation AppDelegate

+ (void)initialize
{
    [self setupAppearance];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
        NSLog(@"プッシュから起動");
        [application cancelAllLocalNotifications];
    }
    [self setupGA];
    [Crittercism enableWithAppID:@"535f8ed30729df6277000006"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setupBackgroundFetch:application];
    
    [Parse setApplicationId:PARSE_APPLICATION_ID clientKey:PARSE_CLIENT_ID];
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 7_1_1 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) CriOS/34.0.1847.18 Mobile/11D201 Safari/9537.53" , @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (BOOL)setupBackgroundFetch:(UIApplication *)application
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL state = [ud boolForKey:@"local_push_enable"];
    if (!state) {
        NSLog(@"バックグラウンド処理無効");
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
        return NO;
    } else {
        NSLog(@"バックグラウンド処理有効");
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        return YES;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 約 30 秒の猶予
    if (![myAccount getAccount]) {
        NSLog(@"アカウント無し");
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }
    [COService myGroups:[myAccount getAccount] block:^(NSArray *groups) {
        if (!groups) {
            completionHandler(UIBackgroundFetchResultNoData);
            return;
        }
        int cnt = 0;
        for (Group *group in groups) {
            if (![group.unread_off boolValue]) {
                cnt += [group.unread_counts intValue];
            }
        }
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSNumber *unreadCount = [ud objectForKey:@"unread_count"];
        if (unreadCount && cnt == unreadCount.intValue) {
            NSLog(@"未読数変化なし");
            completionHandler(UIBackgroundFetchResultNoData);
            return;
        } else {
            [ud setObject:@(cnt) forKey:@"unread_count"];
            [ud synchronize];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = cnt;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // 以前の未読数より小さかったら通知しない。
        if (unreadCount.intValue > cnt) {
            NSLog(@"未読数が減っただけ");
            completionHandler(UIBackgroundFetchResultNoData);
            return;
        }
        
        // 通知を作成する
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        notification.timeZone = [NSTimeZone localTimeZone];
        notification.alertBody = [NSString stringWithFormat:@"%d件の未読があります",cnt];
        notification.alertAction = @"未読チェック";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.userInfo = @{};
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        NSLog(@"プッシュするぜー");
        completionHandler(UIBackgroundFetchResultNewData);
    }];
}

+ (void)setupAppearance
{
    UIColor *comiColor = RGB(28, 28, 28); // RGB(20, 100, 140);
    UIColor *navTitleColor = RGB(245, 245, 245);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = RGB(0, 0, 0);
    shadow.shadowOffset = CGSizeMake(0, 0.5);
    NSDictionary *attributes = @{NSForegroundColorAttributeName : navTitleColor,
                                 NSShadowAttributeName : shadow,
                                 NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0]};
    [[UINavigationBar appearance] setTitleTextAttributes: attributes];
    [[UINavigationBar appearance] setBarTintColor:comiColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:comiColor];
    //    [[UINavigationBar appearance] setTranslucent:YES];
}

- (void)setupGA
{
    // initialization: Google Analytics
    // http://bekkou68.hatenablog.com/entry/2013/12/31/112851
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    gai.dispatchInterval = 10;
    [[gai logger] setLogLevel:kGAILogLevelError]; // ログレベルを変えることができる
    [gai trackerWithTrackingId:GOOGLE_ANALYTICS_ID];
}
@end
