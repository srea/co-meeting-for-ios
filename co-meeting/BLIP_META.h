//
//  BLIP_META.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/04/29.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "BaseModel.h"

@interface BLIP_META : BaseModel
@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *author_screen_name;
@property (copy, nonatomic) NSString *blip_id;
@property (copy, nonatomic) NSString<Optional> *message;
@property (copy, nonatomic) NSString *version;
@end
