//
//  MeetingCell.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "MeetingCell.h"
#import "Meeting.h"
#import <NSDateMinimalTimeAgo/NSDate+MinimalTimeAgo.h>

@interface MeetingCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
@property (weak, nonatomic) IBOutlet UIView *badge;
@property (weak, nonatomic) IBOutlet UILabel *timeAgo;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@end

@implementation MeetingCell

- (void)setMeeting:(Meeting *)meeting
{
    _meeting = meeting;
    [self refreshView];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _badge.backgroundColor = _meeting.unreadCount == 0 ? RGB(227, 227, 227) : RGB(109, 150, 9);
    }
}

- (void) refreshView
{
    _titleLabel.text = _meeting.title;

    if (_meeting.unreadCount == 0) {
        _unreadLabel.text = [NSString stringWithFormat:@"%ld", (long)_meeting.totalCount];
        _unreadLabel.textColor = RGB(123, 123, 123);
        _badge.backgroundColor = RGB(227, 227, 227);
    } else {
        _unreadLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_meeting.unreadCount, (long)_meeting.totalCount];
        _unreadLabel.textColor = RGB(255, 255, 255);
        _badge.backgroundColor = RGB(109, 150, 9);
    }
    
    _badge.layer.cornerRadius = 3.0f;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZ"];
    NSDate* date = [formatter dateFromString:_meeting.updated_at];
    NSString *timeAgo = [date timeAgo];
    _timeAgo.text = timeAgo;
}

@end
