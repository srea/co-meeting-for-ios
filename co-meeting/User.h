//
//  user.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "JSONModel.h"

@interface User : BaseModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, strong) NSURL<Optional> *icon_url;
@property (nonatomic, copy) NSString<Optional> *last_accessed_at;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *time_zone;
@end