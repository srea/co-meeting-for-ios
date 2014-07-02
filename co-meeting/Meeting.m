//
//  Meeting.m
//  co-meeting
//
//  Created by 玉澤 裕貴 on 2014/04/28.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "Meeting.h"
#import "BLIP_META.h"
@implementation Meeting

- (NSInteger)totalCount
{
    return _blip_metas.count;
}

- (NSInteger)unreadCount
{
    NSInteger unreadCount = 0;
    for (BLIP_META *meta in _blip_metas) {
        if (!_mark_as_read[meta.blip_id]) {
            ++unreadCount;
        }
    }
    return unreadCount;
}


/*
 
 var unreadCount = 0;
 var markAsRead = meeting.mark_as_read;
 $.each(meeting.blip_metas, function(){
 var readVersion = markAsRead[this.blip_id];
 if(!readVersion || this.version > readVersion){
 unreadCount++;
 }
 });
 return unreadCount;
 
 */

@end
