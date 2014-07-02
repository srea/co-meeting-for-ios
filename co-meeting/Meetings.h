//
//  Meetings.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "BaseModel.h"

@protocol Meeting @end
@interface Meetings : BaseModel
@property (strong, nonatomic) NSArray<Meeting> *meetings;
@property (strong, nonatomic) NSNumber *module_version;
@property BOOL has_next;
@property BOOL fulltext;

- (void)markAsReadAll:(NSString *)groupId block:(void (^)(void))block;

@end
