//
//  AMPNavigationBar.h
//  co-meeting
//
//  Created by 玉澤 裕貴 on 2014/04/28.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

// https://gist.github.com/chaitanyagupta/7024530

#import <UIKit/UIKit.h>

@interface AMPNavigationBar : UINavigationBar

@property (nonatomic, assign) CGFloat extraColorLayerOpacity UI_APPEARANCE_SELECTOR;

@end


/**

 // the easy way to use it is to subclass UINavigationController and override:
 - (id)initWithRootViewController:(UIViewController *)rootViewController
 {
 self = [super initWithNavigationBarClass:[APNavigationBar class] toolbarClass:[UIToolbar class]];
 if (self) {
 self.viewControllers = @[ rootViewController ];
 }
 return self;
 }

*/