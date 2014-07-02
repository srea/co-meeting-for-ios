//
//  MessageCreate.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "JSONModel.h"

@interface MessageCreate : BaseModel
@property (nonatomic, copy) NSString *meeting_id;
@property (nonatomic, copy) NSString *id;
@end
