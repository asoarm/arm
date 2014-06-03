//
//  Answer.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject
{
    NSString *sur_id;
    NSString *q_id;
    NSString *qd_id;
    NSString *e_id;
    NSString *sec_id;
    NSString *ans_date;
    NSString *answerer;
    NSString *charge;
    NSString *cho_id;
    NSString *ans_cho;
    NSString *ans_str;
    NSString *memo;
    NSString *choice1;
    NSString *choice2;
    NSString *choice3;
    NSString *choice4;
    NSString *choice5;
    NSString *choice6;
}

@property(nonatomic,retain)NSString *sur_id;
@property(nonatomic,retain)NSString *q_id;
@property(nonatomic,retain)NSString *qd_id;
@property(nonatomic,retain)NSString *e_id;
@property(nonatomic,retain)NSString *sec_id;
@property(nonatomic,retain)NSString *ans_date;
@property(nonatomic,retain)NSString *answerer;
@property(nonatomic,retain)NSString *charge;
@property(nonatomic,retain)NSString *cho_id;
@property(nonatomic,retain)NSString *ans_cho;
@property(nonatomic,retain)NSString *ans_str;
@property(nonatomic,retain)NSString *memo;
@property(nonatomic,retain)NSString *choice1;
@property(nonatomic,retain)NSString *choice2;
@property(nonatomic,retain)NSString *choice3;
@property(nonatomic,retain)NSString *choice4;
@property(nonatomic,retain)NSString *choice5;
@property(nonatomic,retain)NSString *choice6;
@end