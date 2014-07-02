//
//  Cell.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/28.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;
@protocol CellDelegate;
@interface Cell : UITableViewCell
@property (weak, nonatomic) id<CellDelegate> delegate;
@property (strong, nonatomic) Group *group;
- (void)refreshView;
@end

@protocol CellDelegate <NSObject>
- (void)notifyTap:(Cell *)cell group:(Group *)group;
@end

