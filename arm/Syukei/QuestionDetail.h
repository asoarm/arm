//
//  QuestionDetail.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionDetail : NSObject
{
NSString *sur_id;
NSString *q_id;
NSString *qd_id;
NSString *qd_name;
NSString *cho_kubun;
NSString *cho_id;
NSString *q_c;
}

@property(nonatomic,retain)NSString *sur_id;
@property(nonatomic,retain)NSString *q_id;
@property(nonatomic,retain)NSString *qd_id;
@property(nonatomic,retain)NSString *qd_name;
@property(nonatomic,retain)NSString *cho_kubun;
@property(nonatomic,retain)NSString *cho_id;
@property(nonatomic,retain)NSString *q_c;
@end

@interface q_count : NSObject
{
    int q_cnt;
}
@property int q_cnt;
@end
