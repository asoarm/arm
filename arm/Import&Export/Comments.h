//
//  Comments.h
//  arm
//
//  Created by masato on 2014/01/08.
//  Copyright (c) 2014年 jssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject
{
    NSString *sur_id;
    NSString *q_id;
    NSString *qd_id;
    NSString *e_id;
    NSString *comment;
}
@property(nonatomic,retain)NSString *sur_id;
@property(nonatomic,retain)NSString *q_id;
@property(nonatomic,retain)NSString *qd_id;
@property(nonatomic,retain)NSString *e_id;
@property(nonatomic,retain)NSString *comment;
@end