//
//  ImportTable.h
//  JsonTest
//
//  Created by masato on 2014/06/24.
//  Copyright (c) 2014年 abcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface ImportTable : NSObject<NSURLSessionDataDelegate>
-(void)importSurvey:(FMDatabase*) db;
-(void)importQuestion:(FMDatabase*) db;
-(void)importQuestionDetail:(FMDatabase*) db;
-(void)importChoice:(FMDatabase*) db;
-(void)importEnterprise:(FMDatabase*) db;
-(void)importSection:(FMDatabase*) db;
-(void)importComment:(FMDatabase*) db;
-(void)importAnswer:(FMDatabase*) db;
-(void)importTemporary:(FMDatabase*) db and :(NSString*)sur_id and :(NSString*)e_id and
                      :(NSString*)sec_id and :(NSString*)ans_date;
@end
