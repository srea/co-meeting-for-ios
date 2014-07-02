//
//  NetworkPublic.h
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "JSONModel.h"

@protocol Group @end
@interface NetworkPublic : BaseModel
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSMutableArray<Optional,Group> *groups;
@end
