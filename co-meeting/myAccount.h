//
//  myAccount.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NXOAuth2Account;
@interface myAccount : NSObject

+ (void)setAccount:(NXOAuth2Account *)account;
+ (NXOAuth2Account*)getAccount;

@end
