//
//  BaseModel.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "JSONModel.h"

@interface BaseModel : JSONModel
- (instancetype)initWithCoMeetingData:(NSData*)data error:(NSError**)err;
@end
