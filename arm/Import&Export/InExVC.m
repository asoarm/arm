//
//  InExVC.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "InExVC.h"
#import "FMDatabase.h"
#import "Survey.h"
#import "Question.h"
#import "QuestionDetail.h"
#import "Choice.h"
#import "Answer.h"
#import "Enterprise.h"
#import "Comments.h"
@interface InExVC ()

@end

@implementation InExVC
@synthesize mAns;
@synthesize mSur;
@synthesize mQ;
@synthesize mQD;
@synthesize mCho;
@synthesize mEn;
@synthesize mCom;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)survey_import:(NSString *)filestext{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    NSString *existsql = [NSString stringWithFormat :@"SELECT count(*) as count from Survey;"];
    FMResultSet *rs = [db executeQuery:existsql];
    int cnt;
    while ([rs next]){
        cnt = [[rs stringForColumn:@"count"] intValue];
    }
    //テーブルに中身がない場合だけimport
    if(cnt == 0){
        // 改行文字で区切って配列に格納する
        NSMutableArray *lines = (NSMutableArray *)[filestext componentsSeparatedByString:@"\n"];
        [lines removeObjectAtIndex:0];
        NSArray *items;
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            if(!([row isEqual:@""])){
            items = [row componentsSeparatedByString:@","];
                NSString *sql = [NSString stringWithFormat :@"INSERT INTO Survey VALUES(\"%@\",\"%@\",\"%@\");",items[0],items[1],items[2]];
                [db executeUpdate:sql];
            }
        }
    }
    [rs close];
    [db close];
    
    return cnt;
}
-(int)question_import:(NSString *)filestext{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    NSString *existsql = [NSString stringWithFormat :@"SELECT count(*) as count from Question;"];
    FMResultSet *rs = [db executeQuery:existsql];
    int cnt;
    while ([rs next]){
        cnt = [[rs stringForColumn:@"count"] intValue];
    }
    //テーブルに中身がない場合だけimport
    if(cnt == 0){
        // 改行文字で区切って配列に格納する
        NSMutableArray *lines = (NSMutableArray *)[filestext componentsSeparatedByString:@"\n"];
        [lines removeObjectAtIndex:0];
        NSArray *items;
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            if(!([row isEqual:@""])){
                items = [row componentsSeparatedByString:@","];
                NSString *sql = [NSString stringWithFormat :@"INSERT INTO Question VALUES(\"%@\",\"%@\");",items[0],items[1]];
                [db executeUpdate:sql];
            }
        }
    }
    [rs close];
    [db close];
    
    return cnt;
}
-(int)question_d_import:(NSString *)filestext{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    NSString *existsql = [NSString stringWithFormat :@"SELECT count(*) as count from QuestionDetail;"];
    FMResultSet *rs = [db executeQuery:existsql];
    int cnt;
    while ([rs next]){
        cnt = [[rs stringForColumn:@"count"] intValue];
    }
    //テーブルに中身がない場合だけimport
    if(cnt == 0){
        // 改行文字で区切って配列に格納する
        NSMutableArray *lines = (NSMutableArray *)[filestext componentsSeparatedByString:@"\n"];
        [lines removeObjectAtIndex:0];
        NSArray *items;
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            if(!([row isEqual:@""])){
                items = [row componentsSeparatedByString:@","];
                NSString *sql = [NSString stringWithFormat :@"INSERT INTO QuestionDetail VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",items[0],items[1],items[2],items[3],items[4],items[5]];
                [db executeUpdate:sql];
            }
        }
    }
    [rs close];
    [db close];
    
    return cnt;
}
-(int)choice_import:(NSString *)filestext{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    NSString *existsql = [NSString stringWithFormat :@"SELECT count(*) as count from Choice;"];
    FMResultSet *rs = [db executeQuery:existsql];
    int cnt;
    while ([rs next]){
        cnt = [[rs stringForColumn:@"count"] intValue];
    }
    //テーブルに中身がない場合だけimport
    if(cnt == 0){
        // 改行文字で区切って配列に格納する
        NSMutableArray *lines = (NSMutableArray *)[filestext componentsSeparatedByString:@"\n"];
        [lines removeObjectAtIndex:0];
        NSArray *items;
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            if(!([row isEqual:@""])){
                items = [row componentsSeparatedByString:@","];
                NSString *sql = [NSString stringWithFormat :@"INSERT INTO Choice VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",items[0],items[1],items[2],items[3],items[4],items[5],items[6]];
                [db executeUpdate:sql];
            }
        }
    }
    [rs close];
    [db close];
    
    return cnt;
}
-(int)enterprise_import:(NSString *)filestext{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    NSString *existsql = [NSString stringWithFormat :@"SELECT count(*) as count from Enterprise;"];
    FMResultSet *rs = [db executeQuery:existsql];
    int cnt;
    while ([rs next]){
        cnt = [[rs stringForColumn:@"count"] intValue];
    }
    //テーブルに中身がない場合だけimport
    if(cnt == 0){
        // 改行文字で区切って配列に格納する
        NSMutableArray *lines = (NSMutableArray *)[filestext componentsSeparatedByString:@"\n"];
        [lines removeObjectAtIndex:0];
        NSArray *items;
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            if(!([row isEqual:@""])){
                items = [row componentsSeparatedByString:@","];
                NSString *sql = [NSString stringWithFormat :@"INSERT INTO Enterprise VALUES(\"%@\",\"%@\",\"%@\");",items[0],items[1],items[2]];
                [db executeUpdate:sql];
            }
        }
    }
    [rs close];
    [db close];
    
    return cnt;
}
-(int)section_import:(NSString *)filestext{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    NSString *existsql = [NSString stringWithFormat :@"SELECT count(*) as count from Section;"];
    FMResultSet *rs = [db executeQuery:existsql];
    int cnt;
    while ([rs next]){
        cnt = [[rs stringForColumn:@"count"] intValue];
    }
    //テーブルに中身がない場合だけimport
    if(cnt == 0){
        // 改行文字で区切って配列に格納する
        NSMutableArray *lines = (NSMutableArray *)[filestext componentsSeparatedByString:@"\n"];
        [lines removeObjectAtIndex:0];
        NSArray *items;
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            if(!([row isEqual:@""])){
                items = [row componentsSeparatedByString:@","];
                NSString *sql = [NSString stringWithFormat :@"INSERT INTO Section VALUES(\"%@\",\"%@\",\"%@\");",items[0],items[1],items[2]];
                [db executeUpdate:sql];
            }
        }
    }
    [rs close];
    [db close];
    
    return cnt;
}
-(int)answer_import:(NSString *)filestext{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    NSString *existsql = [NSString stringWithFormat :@"SELECT count(*) as count from Answer;"];
    FMResultSet *rs = [db executeQuery:existsql];
    int cnt;
    while ([rs next]){
        cnt = [[rs stringForColumn:@"count"] intValue];
    }
    //テーブルに中身がない場合だけimport
    if(cnt == 0){
        // 改行文字で区切って配列に格納する
        NSMutableArray *lines = (NSMutableArray *)[filestext componentsSeparatedByString:@"\n"];
        [lines removeObjectAtIndex:0];
        NSArray *items;
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            if(!([row isEqual:@""])){
                items = [row componentsSeparatedByString:@","];
                NSString *sql = [NSString stringWithFormat :@"INSERT INTO Answer VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",items[2],items[3],items[4],items[0],items[1],items[5],items[6],items[7],items[8],items[9],items[10]];
                [db executeUpdate:sql];
            }
        }
    }
    [rs close];
    [db close];
    
    return cnt;
}
-(int)comment_import:(NSString *)filestext{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    NSString *existsql = [NSString stringWithFormat :@"SELECT count(*) as count from Comment;"];
    FMResultSet *rs = [db executeQuery:existsql];
    int cnt;
    while ([rs next]){
        cnt = [[rs stringForColumn:@"count"] intValue];
    }
    //テーブルに中身がない場合だけimport
    if(cnt == 0){
        // 改行文字で区切って配列に格納する
        NSMutableArray *lines = (NSMutableArray *)[filestext componentsSeparatedByString:@"\n"];
        [lines removeObjectAtIndex:0];
        NSArray *items;
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            if(!([row isEqual:@""])){
                items = [row componentsSeparatedByString:@","];
                NSString *sql = [NSString stringWithFormat :@"INSERT INTO Comment VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",items[0],items[1],items[2],items[3],items[4]];
                [db executeUpdate:sql];
            }
        }
    }
    [rs close];
    [db close];
    
    return cnt;
}

-(NSMutableString*)survey_export{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //出力するデータを抽出
    //Survey
    NSString*   sql = [NSString stringWithFormat :@"SELECT * from Survey order by sur_id;"];
    
    FMResultSet*    rs = [db executeQuery:sql];
    
    mSur = [[NSMutableArray alloc] init];
    int max = 0;
    while( [rs next] )
    {
        Survey *survey = [[Survey alloc] init];
        survey.sur_id = [rs stringForColumn:@"sur_id"];
        survey.sur_name = [rs stringForColumn:@"sur_name"];
        survey.sur_division = [rs stringForColumn:@"sur_division"];
        [mSur addObject:survey];
        max = max + 1;
    }
    
    [rs close];
    [db close];
    
    //結果を一列にまとめ文字列をすべてつなげる
    NSMutableString *all = [NSMutableString stringWithCapacity: 0];
    NSString* line0 =[[NSString alloc] initWithFormat:@"sur_id,sur_name,sur_division\n"];
    [all appendFormat:@"%@", line0];
    for(int i = 0;i < max; i++){
        Survey *survey = mSur[i];
        NSString* line =[[NSString alloc] initWithFormat:@"%@,%@,%@\n",survey.sur_id,survey.sur_name,survey.sur_division];
        [all appendFormat:@"%@", line];
        
    }
    return all;
}
-(NSMutableString*)question_export{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //出力するデータを抽出
    //Survey
    NSString*   sql = [NSString stringWithFormat :@"SELECT * from Question order by q_id;"];
    
    FMResultSet*    rs = [db executeQuery:sql];
    
    mQ = [[NSMutableArray alloc] init];
    int max = 0;
    while( [rs next] )
    {
        Question *question = [[Question alloc] init];
        question.q_id = [rs stringForColumn:@"q_id"];
        question.q_name = [rs stringForColumn:@"q_name"];
        [mQ addObject:question];
        max = max + 1;
    }
    
    [rs close];
    [db close];
    
    //結果を一列にまとめ文字列をすべてつなげる
    NSMutableString *all = [NSMutableString stringWithCapacity: 0];
    NSString* line0 =[[NSString alloc] initWithFormat:@"q_id,q_name\n"];
    [all appendFormat:@"%@", line0];
    for(int i = 0;i < max; i++){
        Question* question = mQ[i];
        NSString* line =[[NSString alloc] initWithFormat:@"%@,%@\n",question.q_id,question.q_name];
        [all appendFormat:@"%@", line];
        
    }
    return all;
}
-(NSMutableString*)question_d_export{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //出力するデータを抽出
    //Survey
    NSString*   sql = [NSString stringWithFormat :@"SELECT * from QuestionDetail order by sur_id,q_id,qd_id;"];
    
    FMResultSet*    rs = [db executeQuery:sql];
    
    mQD = [[NSMutableArray alloc] init];
    int max = 0;
    while( [rs next] )
    {
        Question *questiond = [[Question alloc] init];
        questiond.sur_id = [rs stringForColumn:@"sur_id"];
        questiond.q_id = [rs stringForColumn:@"q_id"];
        questiond.qd_id = [rs stringForColumn:@"qd_id"];
        questiond.qd_name = [rs stringForColumn:@"qd_name"];
        questiond.cho_kubun = [rs stringForColumn:@"cho_kubun"];
        questiond.cho_id = [rs stringForColumn:@"cho_id"];
        [mQD addObject:questiond];
        max = max + 1;
    }
    
    [rs close];
    [db close];
    
    //結果を一列にまとめ文字列をすべてつなげる
    NSMutableString *all = [NSMutableString stringWithCapacity: 0];
    NSString* line0 =[[NSString alloc] initWithFormat:@"sur_id,q_id,qd_id,qd_name,cho_kubun,cho_id\n"];
    [all appendFormat:@"%@", line0];
    for(int i = 0;i < max; i++){
        Question* questiond = mQD[i];
        NSString* line =[[NSString alloc] initWithFormat:@"%@,%@,%@,%@,%@,%@\n",questiond.sur_id,questiond.q_id,questiond.qd_id,questiond.qd_name,questiond.cho_kubun,questiond.cho_id];
        [all appendFormat:@"%@", line];
        
    }
    return all;
}
-(NSMutableString*)choice_export{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //出力するデータを抽出
    //Survey
    NSString*   sql = [NSString stringWithFormat :@"SELECT * from Choice order by cho_id;"];
    
    FMResultSet*    rs = [db executeQuery:sql];
    
    mCho = [[NSMutableArray alloc] init];
    int max = 0;
    while( [rs next] )
    {
        Choice *cho = [[Choice alloc] init];
        cho.cho_id = [rs stringForColumn:@"cho_id"];
        cho.choice1 = [rs stringForColumn:@"choice1"];
        cho.choice2 = [rs stringForColumn:@"choice2"];
        cho.choice3 = [rs stringForColumn:@"choice3"];
        cho.choice4 = [rs stringForColumn:@"choice4"];
        cho.choice5 = [rs stringForColumn:@"choice5"];
        cho.choice6 = [rs stringForColumn:@"choice6"];
        [mCho addObject:cho];
        max = max + 1;
    }
    
    [rs close];
    [db close];
    
    //結果を一列にまとめ文字列をすべてつなげる
    NSMutableString *all = [NSMutableString stringWithCapacity: 0];
    NSString* line0 =[[NSString alloc] initWithFormat:@"cho_id,choice1,choice2,choice3,choice4,choice5,choice6\n"];
    [all appendFormat:@"%@", line0];
    for(int i = 0;i < max; i++){
        Choice* cho = mCho[i];
        NSString* line =[[NSString alloc] initWithFormat:@"%@,%@,%@,%@,%@,%@,%@\n",cho.cho_id,cho.choice1,cho.choice2,cho.choice3,cho.choice4,cho.choice5,cho.choice6];
        [all appendFormat:@"%@", line];
        
    }
    
    return all;
}
-(NSMutableString*)enterprise_export{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //出力するデータを抽出
    //Survey
    NSString*   sql = [NSString stringWithFormat :@"SELECT * from Enterprise order by e_id;"];
    
    FMResultSet*    rs = [db executeQuery:sql];
    
    mEn = [[NSMutableArray alloc] init];
    int max = 0;
    while( [rs next] )
    {
        Enterprise *enter = [[Enterprise alloc] init];
        enter.e_id = [rs stringForColumn:@"e_id"];
        enter.e_name = [rs stringForColumn:@"e_name"];
        enter.division = [rs stringForColumn:@"division"];
        [mEn addObject:enter];
        max = max + 1;
    }
    
    [rs close];
    [db close];
    
    //結果を一列にまとめ文字列をすべてつなげる
    NSMutableString *all = [NSMutableString stringWithCapacity: 0];
    NSString* line0 =[[NSString alloc] initWithFormat:@"e_id,e_name,division\n"];
    [all appendFormat:@"%@", line0];
    for(int i = 0;i < max; i++){
        Enterprise* enter = mEn[i];
        NSString* line =[[NSString alloc] initWithFormat:@"%@,%@,%@\n",enter.e_id,enter.e_name,enter.division];
        [all appendFormat:@"%@", line];
        
    }
    return all;
}
-(NSMutableString*)section_export{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //出力するデータを抽出
    //Survey
    NSString*   sql = [NSString stringWithFormat :@"SELECT * from Section order by e_id,sec_id;"];
    
    FMResultSet*    rs = [db executeQuery:sql];
    
    mEn = [[NSMutableArray alloc] init];
    int max = 0;
    while( [rs next] )
    {
        Enterprise *enter = [[Enterprise alloc] init];
        enter.e_id = [rs stringForColumn:@"e_id"];
        enter.sec_id = [rs stringForColumn:@"sec_id"];
        enter.sec_name = [rs stringForColumn:@"sec_name"];
        [mEn addObject:enter];
        max = max + 1;
    }
    
    [rs close];
    [db close];
    
    //結果を一列にまとめ文字列をすべてつなげる
    NSMutableString *all = [NSMutableString stringWithCapacity: 0];
    NSString* line0 =[[NSString alloc] initWithFormat:@"e_id,sec_id,sec_name\n"];
    [all appendFormat:@"%@", line0];
    for(int i = 0;i < max; i++){
        Enterprise* enter = mEn[i];
        NSString* line =[[NSString alloc] initWithFormat:@"%@,%@,%@\n",enter.e_id,enter.sec_id,enter.sec_name];
        [all appendFormat:@"%@", line];
        
    }
    return all;
}
-(NSMutableString*)answer_export{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //出力するデータを抽出
    //Survey
    NSString*   sql = [NSString stringWithFormat :@"SELECT * from Answer order by e_id,sec_id,sur_id,q_id,qd_id;"];
    
    FMResultSet*    rs = [db executeQuery:sql];
    
    mAns = [[NSMutableArray alloc] init];
    int max = 0;
    while( [rs next] )
    {
        Answer *answer = [[Answer alloc] init];
        answer.e_id = [rs stringForColumn:@"e_id"];
        answer.sec_id = [rs stringForColumn:@"sec_id"];
        answer.sur_id = [rs stringForColumn:@"sur_id"];
        answer.q_id = [rs stringForColumn:@"q_id"];
        answer.qd_id = [rs stringForColumn:@"qd_id"];
        answer.ans_date = [rs stringForColumn:@"ans_date"];
        answer.answerer = [rs stringForColumn:@"answerer"];
        answer.charge = [rs stringForColumn:@"charge"];
        answer.ans_cho = [rs stringForColumn:@"ans_cho"];
        answer.ans_str = [rs stringForColumn:@"ans_str"];
        answer.memo = [rs stringForColumn:@"memo"];
        [mAns addObject:answer];
        max = max + 1;
    }
    
    [rs close];
    [db close];
    
    //結果を一列にまとめ文字列をすべてつなげる
    NSMutableString *all = [NSMutableString stringWithCapacity: 0];
    NSString* line0 =[[NSString alloc] initWithFormat:@"e_id,sec_id,sur_id,q_id,qd_id,ans_date,answerer,charge,ans_cho,ans_str,memo\n"];
    [all appendFormat:@"%@", line0];
    for(int i = 0;i < max; i++){
        Answer* answer = mAns[i];
        NSString* line =[[NSString alloc] initWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",answer.e_id,answer.sec_id,answer.sur_id,answer.q_id,answer.qd_id,answer.ans_date,answer.answerer,answer.charge,answer.ans_cho,answer.ans_str,answer.memo];
        [all appendFormat:@"%@", line];
        
    }
    return all;
}
-(NSMutableString*)comment_export{
    //DB処理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"arm.db"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"arm.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    //出力するデータを抽出
    //Survey
    NSString*   sql = [NSString stringWithFormat :@"SELECT * from Comment order by sur_id,q_id,qd_id,e_id;"];
    
    FMResultSet*    rs = [db executeQuery:sql];
    
    mCom = [[NSMutableArray alloc] init];
    int max = 0;
    while( [rs next] )
    {
        Comments *comments = [[Comments alloc] init];
        comments.sur_id = [rs stringForColumn:@"sur_id"];
        comments.q_id = [rs stringForColumn:@"q_id"];
        comments.qd_id = [rs stringForColumn:@"qd_id"];
        comments.e_id = [rs stringForColumn:@"e_id"];
        comments.comment = [rs stringForColumn:@"comment"];
        [mCom addObject:comments];
        max = max + 1;
    }
    
    [rs close];
    [db close];
    
    //結果を一列にまとめ文字列をすべてつなげる
    NSMutableString *all = [NSMutableString stringWithCapacity: 0];
    NSString* line0 =[[NSString alloc] initWithFormat:@"sur_id,q_id,qd_id,e_id,comment\n"];
    [all appendFormat:@"%@", line0];
    for(int i = 0;i < max; i++){
        Comments *comments = mCom[i];
        NSString* line =[[NSString alloc] initWithFormat:@"%@,%@,%@,%@,%@\n",comments.sur_id,comments.q_id,comments.qd_id,comments.e_id,comments.comment];
        [all appendFormat:@"%@", line];
    }
    return all;
}
@end
