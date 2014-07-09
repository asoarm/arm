//
//  ImportTable.m
//  JsonTest
//
//  Created by masato on 2014/06/24.
//  Copyright (c) 2014年 abcc. All rights reserved.
//

#import "ImportTable.h"


@implementation ImportTable
-(void)importSurvey:(FMDatabase*) db{
    //Surveyテーブルをimportする
    NSURL *jsonUrl = [NSURL URLWithString:@"http://asoarm.chobi.net/data/survey.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for( NSDictionary * json in jsonResponse )
    {
        NSString* sur_id = [json objectForKey:@"sur_id"];
        NSString* sur_name = [json objectForKey:@"sur_name"];
        NSString* sur_division = [json objectForKey:@"sur_division"];
        NSString*   sql = [ NSString stringWithFormat :@"insert into Survey values (\"%@\",\"%@\",\"%@\");",sur_id,sur_name,sur_division];
        [db executeUpdate:sql];
    }
    
}
-(void)importQuestion:(FMDatabase *)db{
    //Questionテーブルをimportする
    NSURL *jsonUrl = [NSURL URLWithString:@"http://asoarm.chobi.net/data/question.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for( NSDictionary * json in jsonResponse )
    {
        NSString* q_id = [json objectForKey:@"q_id"];
        NSString* q_name = [json objectForKey:@"q_name"];
        NSString*   sql = [ NSString stringWithFormat :@"insert into Question values (\"%@\",\"%@\");",q_id,q_name];
        [db executeUpdate:sql];
    }
    
}
-(void)importQuestionDetail:(FMDatabase*) db{
    //QuestionDetailテーブルをimportする
    NSURL *jsonUrl = [NSURL URLWithString:@"http://asoarm.chobi.net/data/questiondetail.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for( NSDictionary * json in jsonResponse )
    {
        NSString* sur_id = [json objectForKey:@"sur_id"];
        NSString* q_id = [json objectForKey:@"q_id"];
        NSString* qd_id = [json objectForKey:@"qd_id"];
        NSString* qd_name = [json objectForKey:@"qd_name"];
        NSString* cho_division = [json objectForKey:@"cho_division"];
        NSString* cho_id = [json objectForKey:@"cho_id"];
        NSString*   sql = [ NSString stringWithFormat :@"insert into QuestionDetail values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",sur_id,q_id,qd_id,qd_name,cho_division,cho_id];
        [db executeUpdate:sql];
    }
}
-(void)importChoice:(FMDatabase*) db{
    //Choiceテーブルをimportする
    NSURL *jsonUrl = [NSURL URLWithString:@"http://asoarm.chobi.net/data/choice.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for( NSDictionary * json in jsonResponse )
    {
        NSString* cho_id = [json objectForKey:@"cho_id"];
        NSString* choice1 = [json objectForKey:@"choice1"];
        NSString* choice2 = [json objectForKey:@"choice2"];
        NSString* choice3 = [json objectForKey:@"choice3"];
        NSString* choice4 = [json objectForKey:@"choice4"];
        NSString* choice5 = [json objectForKey:@"choice5"];
        NSString* choice6 = [json objectForKey:@"choice6"];
        NSString*   sql = [ NSString stringWithFormat :@"insert into Choice values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",cho_id,choice1,choice2,choice3,choice4,choice5,choice6];
        [db executeUpdate:sql];
    }
}
-(void)importEnterprise:(FMDatabase*) db{
    //Enterpriseテーブルをimportする
    NSURL *jsonUrl = [NSURL URLWithString:@"http://asoarm.chobi.net/data/enterprise.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for( NSDictionary * json in jsonResponse )
    {
        NSString* e_id = [json objectForKey:@"e_id"];
        NSString* e_name = [json objectForKey:@"e_name"];
        NSString* division = [json objectForKey:@"division"];
        NSString*   sql = [ NSString stringWithFormat :@"insert into Enterprise values (\"%@\",\"%@\",\"%@\");",e_id,e_name,division];
        [db executeUpdate:sql];
    }
}
-(void)importSection:(FMDatabase*) db{
    //Sectionテーブルをimportする
    NSURL *jsonUrl = [NSURL URLWithString:@"http://asoarm.chobi.net/data/section.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for( NSDictionary * json in jsonResponse )
    {
        NSString* e_id = [json objectForKey:@"e_id"];
        NSString* sec_id = [json objectForKey:@"sec_id"];
        NSString* sec_name = [json objectForKey:@"sec_name"];
        NSString*   sql = [ NSString stringWithFormat :@"insert into Section values (\"%@\",\"%@\",\"%@\");",e_id,sec_id,sec_name];
        [db executeUpdate:sql];
    }
}
-(void)importComment:(FMDatabase*) db{
    //Commentテーブルをimportする
    NSURL *jsonUrl = [NSURL URLWithString:@"http://asoarm.chobi.net/data/comment.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for( NSDictionary * json in jsonResponse )
    {
        NSString* sur_id = [json objectForKey:@"sur_id"];
        NSString* q_id = [json objectForKey:@"q_id"];
        NSString* qd_id = [json objectForKey:@"qd_id"];
        NSString* e_id = [json objectForKey:@"e_id"];
        NSString* comment = [json objectForKey:@"comment"];
        NSString*   sql = [ NSString stringWithFormat :@"insert into Comment values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",sur_id,q_id,qd_id,e_id,comment];
        [db executeUpdate:sql];
    }
}
-(void)importAnswer:(FMDatabase*) db{
    //Answerテーブルをimportする
    NSURL *jsonUrl = [NSURL URLWithString:@"http://asoarm.chobi.net/data/answer.php"];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl options:kNilOptions error:&error];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    for( NSDictionary * json in jsonResponse )
    {
        NSString* sur_id = [json objectForKey:@"sur_id"];
        NSString* q_id = [json objectForKey:@"q_id"];
        NSString* qd_id = [json objectForKey:@"qd_id"];
        NSString* e_id = [json objectForKey:@"e_id"];
        NSString* sec_id = [json objectForKey:@"sec_id"];
        NSString* ans_date = [json objectForKey:@"ans_date"];
        NSString* answerer = [json objectForKey:@"answerer"];
        NSString* charge = [json objectForKey:@"charge"];
        NSString* ans_cho = [json objectForKey:@"ans_cho"];
        NSString* ans_str = [json objectForKey:@"ans_str"];
        NSString* memo = [json objectForKey:@"memo"];
        NSString*   sql = [ NSString stringWithFormat :@"insert into Answer values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",sur_id,q_id,qd_id,e_id,sec_id,ans_date,answerer,charge,ans_cho,ans_str,memo];
        [db executeUpdate:sql];
    }
}
-(void)importTemporary:(FMDatabase*) db and :(NSString*)sur_id and :(NSString*)e_id and
                      :(NSString*)sec_id and :(NSString*)ans_date{
    //配列の初期化
    NSMutableArray *mar = [[NSMutableArray alloc] init];
    
    // ディクショナリに要素を追加する
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    
    //Dictionaryへ要素をセット
    [mdic setObject:sur_id forKey:@"sur_id"];
    [mdic setObject:e_id forKey:@"e_id"];
    [mdic setObject:sec_id forKey:@"sec_id"];
    [mdic setObject:ans_date forKey:@"ans_date"];
    //DictionaryをJson形式のStringへ変換
    NSError *error = nil;
    NSData *tempodata = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *stringJSON = [[NSString alloc] initWithData:tempodata encoding:NSUTF8StringEncoding];
    //配列にデータを挿入
    [mar addObject:stringJSON];
    
    NSString *all = [NSString stringWithFormat:@"[%@",mar[0]];
    
    all = [NSString stringWithFormat:@"%@]",all];
    NSLog(@"%@",all);
    NSData *data = [all dataUsingEncoding:NSUTF8StringEncoding];
    
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
        
        NSString *URLString = @"http://asoarm.chobi.net/data/temporary.php";
        NSURL *URL = [NSURL URLWithString:URLString];
        
        NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        
        mutableURLRequest.HTTPMethod = @"POST";
        [mutableURLRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mutableURLRequest setHTTPBody:dataJSON];
     
        //Temporaryテーブルにimportする
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:mutableURLRequest returningResponse:nil error:nil];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        for( NSDictionary * json in jsonResponse )
        {
            NSString* sur_id = [json objectForKey:@"sur_id"];
            NSString* q_id = [json objectForKey:@"q_id"];
            NSString* qd_id = [json objectForKey:@"qd_id"];
            NSString* e_id = [json objectForKey:@"e_id"];
            NSString* sec_id = [json objectForKey:@"sec_id"];
            NSString* ans_date = [json objectForKey:@"ans_date"];
            NSString* answerer = [json objectForKey:@"answerer"];
            NSString* charge = [json objectForKey:@"charge"];
            NSString* ans_cho = [json objectForKey:@"ans_cho"];
            NSString* ans_str = [json objectForKey:@"ans_str"];
            NSString* memo = [json objectForKey:@"memo"];
            NSString*   sql = [ NSString stringWithFormat :@"insert into Temporary values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",sur_id,q_id,qd_id,e_id,sec_id,ans_date,answerer,charge,ans_cho,ans_str,memo];
            [db executeUpdate:sql];
        }

    }
}
@end

@implementation UIAlertView (NSError)
-(id)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        self.title = [error localizedDescription];
        self.message = [[NSArray arrayWithObjects:[error localizedFailureReason], [error localizedRecoverySuggestion], nil] componentsJoinedByString:@"\n"];
        NSArray* optionTitles = [error localizedRecoveryOptions];
        for (NSString *title in optionTitles) {
            [self addButtonWithTitle:title];
        }
    }
    return self;
}
@end
