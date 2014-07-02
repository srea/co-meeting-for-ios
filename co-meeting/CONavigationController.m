//
//  CONavigationController.m
//  co-meeting
//
//  Created by 玉澤 裕貴 on 2014/04/28.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "CONavigationController.h"
#import "AMPNavigationBar.h"

@interface CONavigationController ()

@end

@implementation CONavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithNavigationBarClass:[AMPNavigationBar class] toolbarClass:[UIToolbar class]];
    if (self) {
        self.viewControllers = @[ rootViewController ];
    }
    return self;
}

@end
