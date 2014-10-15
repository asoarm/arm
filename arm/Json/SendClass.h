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
- (NSString*)sendAnswerData:(NSData *)data;
- (NSString*)sendAnswer:(FMDatabase*)db;
- (NSString*)sendCommentData:(NSData *)data;
- (NSString*)sendComment:(NSString*)sur_id and :(NSString*)q_id and
                   :(NSString*)qd_id and :(NSString*)e_id and :(NSString*)comment;
- (NSString*)sendEnterpriseData:(NSData *)data;
- (NSString*)sendEnterprise:(NSString*)e_id and :(NSString*)e_name and :(NSString*)division;
- (NSString*)sendSectionData:(NSData *)data;
- (NSString*)sendSection:(NSString*)e_id and :(NSString*)sec_id and :(NSString*)sec_name;
@end
