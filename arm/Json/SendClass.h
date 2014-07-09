//
//  SendClass.h
//  JsonTest
//
//  Created by masato on 2014/06/25.
//  Copyright (c) 2014年 abcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface SendClass : NSObject<NSURLSessionDataDelegate>
- (void)sendAnswerData:(NSData *)data;
- (void)sendAnswer:(FMDatabase*)db;
- (void)sendCommentData:(NSData *)data;
- (void)sendComment:(NSString*)sur_id and :(NSString*)q_id and
                   :(NSString*)qd_id and :(NSString*)e_id and :(NSString*)comment;
- (void)sendEnterpriseData:(NSData *)data;
- (void)sendEnterprise:(NSString*)e_id and :(NSString*)e_name and :(NSString*)division;
- (void)sendSectionData:(NSData *)data;
- (void)sendSection:(NSString*)e_id and :(NSString*)sec_id and :(NSString*)sec_name;
@end
