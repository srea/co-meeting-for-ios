//
//  COAPI.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "COService.h"
#import "Meetings.h"
#import "Meeting.h"
#import "COWebViewController.h"
#import <NXOAuth2AccountStore.h>
#import <NXOAuth2Request.h>

#define BASE_URL @"https://www.co-meeting.com/api/"

@implementation COService

+ (void)setup
{
    [[NXOAuth2AccountStore sharedStore] setClientID:OAUTH_CLIENT_ID
                                             secret:OAUTH_SECRET
                                   authorizationURL:[NSURL URLWithString:OAUTH_AUTHORIZATION_URL]
                                           tokenURL:[NSURL URLWithString:OAUTH_TOKEN_URL]
                                        redirectURL:[NSURL URLWithString:OAUTH_REDIRECT_URL]
                                     forAccountType:OAUTH_ACCOUNT_TYPE];
}

+ (NXOAuth2Account *)myAccount
{
    return [myAccount getAccount];
}

+ (void)setupOAuth:(void (^)(NSURL *))block
{
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:OAUTH_ACCOUNT_TYPE
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
                                       if (block) {
                                           block(preparedURL);
                                       }
                                   }];
}

+ (void)resetOAuth:(NXOAuth2Account *)account
{
    [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [myAccount setAccount:nil];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"group_tutorial"];
    [ud synchronize];
}

+ (void)notifyToggle:(Group *)group
{
    NSDictionary *params = @{@"group_id" : group.id, @"unread" : group.unread_off.stringValue };
    group.unread_off = group.unread_off.boolValue ? @(0) : @(1);
//    NSLog(@"%@", params);
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[self createUrl:@"set_unread"]
                   usingParameters:params
                       withAccount:[self myAccount]
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                   }];
}

+ (void)myGroups:(NXOAuth2Account *)account block:(void (^)(NSArray *))block
{
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[self createUrl:@"v1/groups/my"]
                   usingParameters:@{}
                       withAccount:account
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                       NetworkPublic *group = [[NetworkPublic alloc] initWithCoMeetingData:responseData error:nil];
//                       NSLog(@"%@", group.toDictionary);
                       if (block) {
                           block(group.groups);
                       }
                   }];
}

+ (void)user
{
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[self createUrl:@"v1/users/me"]
                   usingParameters:nil
                       withAccount:[self myAccount]
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                       User *user = [[User alloc] initWithCoMeetingData:responseData error:nil];
//                       NSLog(@"%@", [user toDictionary]);
                   }];
}

+ (void)meetings:(Group *)group block:(void (^)(Meetings *))block
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZ"];
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-31];
    NSDate *date = [cal dateByAddingComponents:comps toDate:today options:0];
    NSString *aweekAgoTime = [formatter stringFromDate:date];

    [NXOAuth2Request performMethod:@"POST"
                        onResource:[self createUrl:@"list_meetings"]
                   usingParameters:@{@"group_id" : group.id, @"after" : aweekAgoTime }
                       withAccount:[self myAccount]
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {}
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                       Meetings *meetings = [[Meetings alloc] initWithCoMeetingData:responseData error:&error];
//                       NSLog(@"%@", [meetings toDictionary]);
                       if (block) {
                           block(meetings);
                       }
                   }];
}

+ (NSURL *)createUrl:(NSString *)path
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, path]];
}

// グループ詳細
//NSDictionary *params = @{
//                         @"id": @"4fed75aeab5c377f0f00059d",
//                         @"include_meetings" : @"1",
//                         @"include_public_meetings" : @"1",
//                         };
//[NXOAuth2Request performMethod:@"GET"
//                    onResource:[NSURL URLWithString:@"https://www.co-meeting.com/api/v1/groups/show"]
//               usingParameters:params
//                   withAccount:_account
//           sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {}
//               responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
//                   Group *group = [[Group alloc] initWithCoMeetingData:responseData error:nil];
//                   NSLog(@"%@", [group toDictionary]);
//               }];



//    [NXOAuth2Request performMethod:@"GET"
//                        onResource:[NSURL URLWithString:@"https://www.co-meeting.com/api/get_meeting.json?_id=5344b93fc1a97dec730000b3"]
//                   usingParameters:nil
//                       withAccount:_account
//               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {}
//                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
//                       NSString* string = [NSString stringWithUTF8String:[responseData bytes]];
//                       NSLog(@"%@", string);
//                   }];

+ (void)openMeeting:(Meeting *)meeting parentViewController:(UIViewController*)parentViewController
{
    NSString *meetingUrl = [NSString stringWithFormat:@"https://www.co-meeting.com/m/#meetingPage?id=%@", meeting._id];
    [self openWeb:meetingUrl parentViewController:parentViewController];
}

+ (void)openGroup:(Group *)group parentViewController:(UIViewController*)parentViewController
{
    NSString *groupUrl = [NSString stringWithFormat:@"https://www.co-meeting.com/m/#groupPage?group_id=%@", group.group_id];
    [self openWeb:groupUrl parentViewController:parentViewController];
}

+ (void)openWeb:(NSString *)url parentViewController:(UIViewController*)parentViewController
{
    
    COWebViewController *webView = [[COWebViewController alloc] init];
    webView.URL = [NSURL URLWithString:url];
    webView.showsNavigationToolbar = YES;
    [parentViewController.navigationController pushViewController:webView animated:YES];
}

@end
