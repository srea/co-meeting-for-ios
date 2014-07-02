//
//  myAccount.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "myAccount.h"

@interface myAccount ()
@property (nonatomic, strong) NXOAuth2Account *account;
@end

@implementation myAccount

// instancetypeにするとm内で定義しているプロパティにアクセスできなかった。
+ (myAccount *)sharedInstance
{
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

+ (void)setAccount:(NXOAuth2Account *)account
{
    [[self sharedInstance] setAccount:account];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:account.identifier forKey:@"account.identifier"];
    [ud synchronize];
}

+ (NXOAuth2Account*)getAccount
{
    // メモリ上にあれば
    NXOAuth2Account *account = [[self sharedInstance] account];
    if (account) {
        return account;
    }

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [ud objectForKey:@"account.identifier"];
    if (!identifier) {
        return nil;
    }
    NXOAuth2Account *restoreAccount = [[NXOAuth2AccountStore sharedStore] accountWithIdentifier:identifier];
    [self sharedInstance].account = restoreAccount;
    return restoreAccount;
}

@end
