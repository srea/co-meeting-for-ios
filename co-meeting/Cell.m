//
//  Cell.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/28.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "Cell.h"
#import "COService.h"
#import <NSDate+TimeAgo.h>
#import <NSDateMinimalTimeAgo/NSDate+MinimalTimeAgo.h>
@interface Cell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
@property (weak, nonatomic) IBOutlet UIView *badge;
@property (weak, nonatomic) IBOutlet UILabel *timeAgo;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@end

@implementation Cell

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_touchView addGestureRecognizer:tapGesture];
}

- (void)tap
{
    if ([_delegate respondsToSelector:@selector(notifyTap:group:)]) {
        [_delegate performSelector:@selector(notifyTap:group:) withObject:self withObject:_group];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _badge.backgroundColor = _group.unread_off.boolValue ? RGB(227, 227, 227) : RGB(109, 150, 9);
    }
}

- (void)setGroup:(Group *)group
{
    _group = group;
    [self refreshView];
}

- (void) refreshView
{
    _titleLabel.text = _group.name;
    if ([_group.unread_counts isEqualToNumber:@(0)] && [_group.unread_off isEqualToNumber:@(1)]) {
//        _touchView.hidden = YES;
//        _unreadLabel.hidden = YES;
//        _badge.hidden = YES;
    } else {
        _touchView.hidden = NO;
        _unreadLabel.hidden = NO;
        _badge.hidden = NO;
    }
    _unreadLabel.text = [NSString stringWithFormat:@"%@", _group.unread_counts];
    if ([_group.unread_off boolValue]) {
        _unreadLabel.textColor = RGB(123, 123, 123);
        _badge.backgroundColor = RGB(227, 227, 227);
    } else {
        _unreadLabel.textColor = RGB(255, 255, 255);
        _badge.backgroundColor = RGB(109, 150, 9);
    }
    
    _badge.layer.cornerRadius = 3.0f;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZ"];
    NSDate* date = [formatter dateFromString:_group.updated_at];
    NSString *timeAgo = [date timeAgo];
    _timeAgo.text = timeAgo;
}

@end
