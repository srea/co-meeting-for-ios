//
//  Meeting.h
//  co-meeting
//
//  Created by 玉澤 裕貴 on 2014/04/28.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "BaseModel.h"

@protocol BLIP_META @end
@interface Meeting : BaseModel
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray<Optional> *tags;
@property (strong, nonatomic) NSString<Optional> *discussion_id;
@property (strong, nonatomic) NSString<Optional> *document_id;
@property (strong, nonatomic) NSString *group_id;
@property (strong, nonatomic) NSString *updated_at;
@property (strong, nonatomic) NSString *display_updated_at;
@property (strong, nonatomic) NSArray<BLIP_META> *blip_metas;
@property (strong, nonatomic) NSNumber<Optional> *meeting_read_version;
@property (copy, nonatomic) NSDictionary *mark_as_read;
@property (copy, nonatomic) NSString<Optional> *owner_screen_name;
@property (copy, nonatomic) NSString<Optional> *owner_display_name;

- (NSInteger)totalCount;
- (NSInteger) unreadCount;
@end
