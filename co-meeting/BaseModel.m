//
//  BaseModel.m
//  co-meeting
//
//  Created by tamazawayuuki on 2014/02/11.
//  Copyright (c) 2014年 Tamazawa. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithCoMeetingData:(NSData *)data error:(NSError *__autoreleasing *)err
{
    NSString* string = [NSString stringWithUTF8String:[data bytes]];
//    NSLog(@"%@", string);
    
    NSError *jsonError = nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                                  error:&jsonError];
    NSString *status = dict[@"status"];
    if (![status isEqualToString:@"success"]) {
        return nil;
    }
    
    if (![dict objectForKey:@"result"]) {
        return nil;
    }
    
    if (self = [super initWithDictionary:dict[@"result"] error:err]) {
        
    }
    return self;
}

@end
