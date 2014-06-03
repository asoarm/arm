//
//  Survey.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Survey : NSObject
{
    NSString *sur_id;
    NSString *sur_name;
    NSString *sur_division;
}

@property(nonatomic,retain)NSString *sur_id;
@property(nonatomic,retain)NSString *sur_name;
@property(nonatomic,retain)NSString *sur_division;
@end
