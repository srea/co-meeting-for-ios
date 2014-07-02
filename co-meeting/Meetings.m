//
//  Meetings.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "Meetings.h"
#import "Meeting.h"
#import "BLIP_META.h"
#import <AFNetworking.h>

@implementation Meetings

- (instancetype)initWithCoMeetingData:(NSData *)data error:(NSError *__autoreleasing *)err
{
    NSError *jsonError = nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&jsonError];
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}

- (void)markAsReadAll:(NSString *)groupId block:(void (^)(void))block
{
    NSMutableDictionary *payload = @{}.mutableCopy;
    for (Meeting *meeting in _meetings) {
        payload[meeting._id] = @{}.mutableCopy;
        for (BLIP_META *meta in meeting.blip_metas) {
            if (![meeting.mark_as_read objectForKey:meta.blip_id]) {
                payload[meeting._id][meta.blip_id] = @{
                                                       @"blip_id" : meta.blip_id,
                                                       @"version" : meta.version,
                                                       @"event" : @(YES),
                                                       };
            }
        }
    }
    
    NSMutableURLRequest *updateGroupUnreadCount = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                                URLString:@"https://www.co-meeting.com/api/update_group_unread_count"
                                                                                               parameters:@{
                                                                                                            @"group_id" : groupId,
                                                                                                            @"unread_count" : @(0),
                                                                                                            }];
    AFHTTPRequestOperation *updateGroupOperation = [[AFHTTPRequestOperation alloc] initWithRequest:updateGroupUnreadCount];
    [updateGroupOperation setCompletionBlockWithSuccess:nil failure:nil];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:@"https://www.co-meeting.com/api/mark_as_reads"
                                                                                parameters:payload];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:nil failure:nil];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    [queue addOperation:updateGroupOperation];
    [queue addOperationWithBlock:^{
        // Background work
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (block) {
                block();
            }
        }];
    }];
}


/**
 
 {
 "536447aec1a97d54ad0000a7":{
 "b+hXNwwy2SH7L":{"blip_id":"b+hXNwwy2SH7L","version":48,"event":true},
 "b+hXNwwy2SH7M":{"blip_id":"b+hXNwwy2SH7M","version":48,"event":true},
 "b+hXNwwy2SH7N":{"blip_id":"b+hXNwwy2SH7N","version":48,"event":true}
 },
 "5364490fc1a97d7efc000094":{
 "b+hXNwwy2SH7I":{"blip_id":"b+hXNwwy2SH7I","version":402,"event":true},
 "b+hXNwwy2SH7J":{"blip_id":"b+hXNwwy2SH7J","version":402,"event":true},
 "b+hXNwwy2SH7K":{"blip_id":"b+hXNwwy2SH7K","version":402,"event":true},
 "b+hXNwwy2SH7N":{"blip_id":"b+hXNwwy2SH7N","version":48,"event":true},
 "b+hXNwwy2SH7L":{"blip_id":"b+hXNwwy2SH7L","version":48,"event":true},
 "b+hXNwwy2SH7M":{"blip_id":"b+hXNwwy2SH7M","version":48,"event":true}
 }
 }
 
 **/


@end
