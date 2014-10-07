//
//  SendClass.m
//  JsonTest
//
//  Created by masato on 2014/06/25.
//  Copyright (c) 2014年 abcc. All rights reserved.
//

#import "SendClass.h"
#import "Answer.h"
@implementation SendClass

-(NSString*)sendAnswerData:(NSData *)data{
    NSLog(@"%s", __func__);
    
    NSError *error = nil;
    //変換
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:
                          data
                          options:kNilOptions
                          error:&error];
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error){
        
        NSLog(@"%@", [error localizedDescription]);
        
    }else{
        
        NSString *stringJSON = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
        NSLog(@"stringJSON = %@", stringJSON);
        
        NSString *URLString = @"http://asoarm.chobi.net/getanswer.php";
        NSURL *URL = [NSURL URLWithString:URLString];
        
        NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        
        mutableURLRequest.HTTPMethod = @"POST";
        [mutableURLRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mutableURLRequest setHTTPBody:dataJSON];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:mutableURLRequest returningResponse:&response error:&error];
        if (error) {
            // error処理
            if (error.code == 256 || error.code == -1009) {
                return @"NetworkError";
            }
            return @"Error";
        }
    }
    return @"Success";
}
-(NSString*)sendAnswer:(FMDatabase*)db{
    //Answerを全てSELECT
    NSString*   sql = @"SELECT * FROM Temporary;";
    FMResultSet*    rs = [db executeQuery:sql];
    //配列の初期化
    NSMutableArray *mar = [[NSMutableArray alloc] init];
    int  num = 0;
    while( [rs next] )
    {
        // ディクショナリに要素を追加する
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        //Answerクラスのインスタンスを生成
        Answer * answer = [[Answer alloc] init];
        //インスタンスに値をセット
        answer.sur_id = [rs stringForColumn:@"sur_id"];
        answer.q_id = [rs stringForColumn:@"q_id"];
        answer.qd_id = [rs stringForColumn:@"qd_id"];
        answer.e_id = [rs stringForColumn:@"e_id"];
        answer.sec_id = [rs stringForColumn:@"sec_id"];
        answer.ans_date = [rs stringForColumn:@"ans_date"];
        answer.answerer = [rs stringForColumn:@"answerer"];
        answer.charge = [rs stringForColumn:@"charge"];
        answer.ans_cho = [rs stringForColumn:@"ans_cho"];
        answer.ans_str = [rs stringForColumn:@"ans_str"];
        answer.memo = [rs stringForColumn:@"memo"];
        //Dictionaryへ要素をセット
        [mdic setObject:answer.sur_id forKey:@"sur_id"];
        [mdic setObject:answer.q_id forKey:@"q_id"];
        [mdic setObject:answer.qd_id forKey:@"qd_id"];
        [mdic setObject:answer.e_id forKey:@"e_id"];
        [mdic setObject:answer.sec_id forKey:@"sec_id"];
        [mdic setObject:answer.ans_date forKey:@"ans_date"];
        [mdic setObject:answer.answerer forKey:@"answerer"];
        [mdic setObject:answer.charge forKey:@"charge"];
        [mdic setObject:answer.ans_cho forKey:@"ans_cho"];
        [mdic setObject:answer.ans_str forKey:@"ans_str"];
        [mdic setObject:answer.memo forKey:@"memo"];
        //DictionaryをJson形式のStringへ変換
        NSError *error = nil;
        NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *stringJSON = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
        //配列にデータを挿入
        [mar addObject:stringJSON];
        //データの数を数える
        num = num + 1;
    }
    NSString *all;
    int i = 0;
    while (i < num) {
        if(i == 0){
            all = [NSString stringWithFormat:@"[%@",mar[i]];
        }else{
            all = [NSString stringWithFormat:@"%@,%@",all,mar[i]];
        }
        i = i + 1;
    }
    all = [NSString stringWithFormat:@"%@]",all];
    NSLog(@"%@",all);
    NSData *data = [all dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [self sendAnswerData:data];
    
    return str;
}
-(NSString*)sendCommentData:(NSData *)data{
    
    NSLog(@"%s", __func__);
    
    NSError *error = nil;
    //変換
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:
                          data
                          options:kNilOptions
                          error:&error];
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error){
        
        NSLog(@"%@", [error localizedDescription]);
        
    }else{
        
        NSString *stringJSON = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
        NSLog(@"stringJSON = %@", stringJSON);
        
        NSString *URLString = @"http://asoarm.chobi.net/getcomment.php";
        NSURL *URL = [NSURL URLWithString:URLString];
        
        NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        
        mutableURLRequest.HTTPMethod = @"POST";
        [mutableURLRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mutableURLRequest setHTTPBody:dataJSON];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:mutableURLRequest returningResponse:&response error:&error];
        if (error) {
            // error処理
            if (error.code == 256 || error.code == -1009) {
                return @"NetworkError";
            }
            return @"Error";
        }
    }
    return @"Success";
}
-(NSString*)sendComment:(NSString*)sur_id and :(NSString*)q_id and
                  :(NSString*)qd_id and :(NSString*)e_id and :(NSString*)comment{
    //配列の初期化
    NSMutableArray *mar = [[NSMutableArray alloc] init];
    
    // ディクショナリに要素を追加する
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];

    //Dictionaryへ要素をセット
    [mdic setObject:sur_id forKey:@"sur_id"];
    [mdic setObject:q_id forKey:@"q_id"];
    [mdic setObject:qd_id forKey:@"qd_id"];
    [mdic setObject:e_id forKey:@"e_id"];
    [mdic setObject:comment forKey:@"comment"];
    //DictionaryをJson形式のStringへ変換
    NSError *error = nil;
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *stringJSON = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    //配列にデータを挿入
    [mar addObject:stringJSON];
    
    int i = 0;
    
    NSString *all = [NSString stringWithFormat:@"[%@",mar[i]];

    all = [NSString stringWithFormat:@"%@]",all];
    NSLog(@"%@",all);
    NSData *data = [all dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString* str = [self sendCommentData:data];
    
    return str;
}
- (NSString*)sendEnterpriseData:(NSData *)data{
    NSLog(@"%s", __func__);
    
    NSError *error = nil;
    //変換
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:
                          data
                          options:kNilOptions
                          error:&error];
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error){
        
        NSLog(@"%@", [error localizedDescription]);
        
    }else{
        
        NSString *stringJSON = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
        NSLog(@"stringJSON = %@", stringJSON);
        
        NSString *URLString = @"http://asoarm.chobi.net/getenterprise.php";
        NSURL *URL = [NSURL URLWithString:URLString];
        
        NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        
        mutableURLRequest.HTTPMethod = @"POST";
        [mutableURLRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mutableURLRequest setHTTPBody:dataJSON];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:mutableURLRequest returningResponse:&response error:&error];
        if (error) {
            // error処理
            if (error.code == 256 || error.code == -1009) {
                return @"NetworkError";
            }
            return @"Error";
        }
    }
    return @"Success";
}
- (NSString*)sendEnterprise:(NSString*)e_id and :(NSString*)e_name and :(NSString*)division{
    //配列の初期化
    NSMutableArray *mar = [[NSMutableArray alloc] init];
    
    // ディクショナリに要素を追加する
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    
    //Dictionaryへ要素をセット
    [mdic setObject:e_id forKey:@"e_id"];
    [mdic setObject:e_name forKey:@"e_name"];
    [mdic setObject:division forKey:@"division"];
    //DictionaryをJson形式のStringへ変換
    NSError *error = nil;
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *stringJSON = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    //配列にデータを挿入
    [mar addObject:stringJSON];
    
    int i = 0;
    
    NSString *all = [NSString stringWithFormat:@"[%@",mar[i]];
    
    all = [NSString stringWithFormat:@"%@]",all];
    NSLog(@"%@",all);
    NSData *data = [all dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [self sendEnterpriseData:data];
    
    return str;
    
}
- (NSString*)sendSectionData:(NSData *)data{
    NSLog(@"%s", __func__);
    
    NSError *error = nil;
    //変換
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:
                          data
                          options:kNilOptions
                          error:&error];
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error){
        
        NSLog(@"%@", [error localizedDescription]);
        
    }else{
        
        NSString *stringJSON = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
        NSLog(@"stringJSON = %@", stringJSON);
        
        NSString *URLString = @"http://asoarm.chobi.net/getsection.php";
        NSURL *URL = [NSURL URLWithString:URLString];
        
        NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        
        mutableURLRequest.HTTPMethod = @"POST";
        [mutableURLRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mutableURLRequest setHTTPBody:dataJSON];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:mutableURLRequest returningResponse:&response error:&error];
        if (error) {
            // error処理
            if (error.code == 256 || error.code == -1009) {
                return @"NetworkError";
            }
            return @"Error";
        }
    }
    return @"Success";
}
- (NSString*)sendSection:(NSString*)e_id and :(NSString*)sec_id and :(NSString*)sec_name{
    //配列の初期化
    NSMutableArray *mar = [[NSMutableArray alloc] init];
    
    // ディクショナリに要素を追加する
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    
    //Dictionaryへ要素をセット
    [mdic setObject:e_id forKey:@"e_id"];
    [mdic setObject:sec_id forKey:@"sec_id"];
    [mdic setObject:sec_name forKey:@"sec_name"];
    //DictionaryをJson形式のStringへ変換
    NSError *error = nil;
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *stringJSON = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    //配列にデータを挿入
    [mar addObject:stringJSON];
    
    int i = 0;
    
    NSString *all = [NSString stringWithFormat:@"[%@",mar[i]];
    
    all = [NSString stringWithFormat:@"%@]",all];
    NSLog(@"%@",all);
    NSData *data = [all dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* str = [self sendSectionData:data];
    
    return str;
}
@end