//
//  COTabBarViewController.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/05/03.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "COTabBarViewController.h"

@interface COTabBarViewController ()

@end

@implementation COTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTabIcon];
}

- (void)setupTabIcon
{
    // フォント
    UIFont *normalFont = [UIFont fontWithName:@"HelveticaNeue" size:10.0f];
    NSDictionary *attributesNormal = @{NSFontAttributeName : normalFont,
                                       NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    
    UIFont *selectedFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    NSDictionary *selectedAttributes = @{NSFontAttributeName : selectedFont,
                                         NSForegroundColorAttributeName : [UIColor blackColor]};
    
    [[UITabBarItem appearance] setTitleTextAttributes:attributesNormal
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes
                                             forState:UIControlStateSelected];
    
    // タブバーのアイコンを設定
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    NSInteger tabIconSize = 25;
    CGSize tabIconSizes = CGSizeMake(tabIconSize, tabIconSize);
    NSArray *controllers =  self.viewControllers;
    UIViewController *controller0 = controllers[0];
    UIViewController *controller1 = controllers[1];
    [controller0.tabBarItem setImage:[[FAKFontAwesome listAltIconWithSize:tabIconSize] imageWithSize:tabIconSizes]];
    [controller1.tabBarItem setImage:[[FAKFontAwesome tagsIconWithSize:tabIconSize] imageWithSize:tabIconSizes]];
    [controller0.tabBarItem setImageInsets:imageInsets];
    [controller1.tabBarItem setImageInsets:imageInsets];
    self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                   self.tabBar.frame.origin.y + 5,
                                   self.tabBar.frame.size.width,
                                   self.tabBar.frame.size.height - 5);
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 20)];
}
@end
