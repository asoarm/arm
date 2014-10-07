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
-(NSString*)importSurvey:(FMDatabase*) db;
-(NSString*)importQuestion:(FMDatabase*) db;
-(NSString*)importQuestionDetail:(FMDatabase*) db;
-(NSString*)importChoice:(FMDatabase*) db;
-(NSString*)importEnterprise:(FMDatabase*) db;
-(NSString*)importSection:(FMDatabase*) db;
-(NSString*)importComment:(FMDatabase*) db and :(NSString*)sur_id and :(NSString*)e_id;
//選択した団体とアンケートのコメントをサーバーから内部DBへ
-(NSString*)importAnswer:(FMDatabase*) db and :(NSString*)e_id;
//選択した団体の回答をサーバーから内部DBへ
-(NSString*)importTemporary:(FMDatabase*) db and :(NSString*)sur_id and :(NSString*)e_id and
                      :(NSString*)sec_id and :(NSString*)ans_date;
@end