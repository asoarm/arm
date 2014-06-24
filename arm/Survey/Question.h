//
//  Question.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
{
    NSString *sur_id;
    NSString *q_id;
    NSString *q_name;
    NSString *qd_id;
    NSString *qd_name;
    NSString *cho_division;
    NSString *cho_id;
}

@property(nonatomic,retain)NSString *sur_id;
@property(nonatomic,retain)NSString *q_id;
@property(nonatomic,retain)NSString *q_name;
@property(nonatomic,retain)NSString *qd_id;
@property(nonatomic,retain)NSString *qd_name;
@property(nonatomic,retain)NSString *cho_division;
@property(nonatomic,retain)NSString *cho_id;
@end
