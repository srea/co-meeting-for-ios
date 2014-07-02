//
//  COAPI.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

// OAuth Settings
#define OAUTH_CLIENT_ID @"OAUTH_CLIENT_ID"
#define OAUTH_SECRET @"OAUTH_SECRET"
#define OAUTH_REDIRECT_URL @"OAUTH_REDIRECT_URL"
#define OAUTH_TOKEN_URL @"OAUTH_TOKEN_URL"
#define OAUTH_AUTHORIZATION_URL @"OAUTH_AUTHORIZATION_URL"
#define OAUTH_ACCOUNT_TYPE @"OAUTH_ACCOUNT_TYPE"

@class Group,Meeting,Meetings,NXOAuth2Account;
@interface COService : NSObject
+ (void)setup;
+ (void)notifyToggle:(Group *)group;
+ (void)myGroups:(NXOAuth2Account *)account block:(void (^)(NSArray *groups))block;
+ (void)meetings:(Group *)group block:(void (^)(Meetings *))block;
+ (void)setupOAuth:(void (^)(NSURL *preparedURL))block;
+ (void)resetOAuth:(NXOAuth2Account *)account;

+ (void)openMeeting:(Meeting *)meeting parentViewController:(UIViewController*)parentViewController;
+ (void)openGroup:(Group *)group parentViewController:(UIViewController*)parentViewController;
@end
