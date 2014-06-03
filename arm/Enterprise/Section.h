//
//  Section.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject{
    NSString *e_id;
    NSString *sec_id;
    NSString *sec_name;
}

@property(nonatomic,retain)NSString *e_id;
@property(nonatomic,retain)NSString *sec_id;
@property(nonatomic,retain)NSString *sec_name;
@end
