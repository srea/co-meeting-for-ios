//
//  Member.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "JSONModel.h"

@interface Member : BaseModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *last_accessed_at;
@property (nonatomic, strong) NSNumber<Optional> *role;
@end


//result/members/role	メンバーの権限
//100:オーナー、80:管理者、60:一般ユーザ
