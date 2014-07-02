//
//  Group.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "JSONModel.h"

@protocol Member @end
@interface Group : BaseModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString<Optional> *group_alias;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString<Optional> *icon_url;
@property (nonatomic, copy) NSString<Optional> *description;
@property (nonatomic, strong) NSNumber *privacy_status;
@property (nonatomic, strong) NSNumber *require_approval;
@property (nonatomic, copy) NSString<Optional> *network_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURL<Optional> *public_url;
@property (nonatomic, copy) NSArray<Optional,Member> *members;

@property (nonatomic, strong) NSArray<Optional> *meetings;

// groups/my
@property (nonatomic, strong) NSNumber<Optional> *unread_counts;
@property (nonatomic, strong) NSNumber<Optional> *unread_off;
@end
