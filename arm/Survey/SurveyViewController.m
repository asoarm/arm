//
//  SurveyViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "SurveyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"
#import "Question.h"
#import "Choice.h"
#import "UIButton+BGColor.h"
#import "SurveyViewStringController.h"
#import "EndViewController.h"
#import "Answer.h"
#import "SendClass.h"
#import "SVProgressHUD.h"

@interface SurveyViewController ()

@end

@implementation SurveyViewController
@synthesize survey;
@synthesize enterprise;
@synthesize charge;
@synthesize answerer;
@synthesize questions;
@synthesize mQD;
@synthesize mAnswer;
@synthesize i;
@synthesize max;
@synthesize memo;
@synthesize choice1btn;
@synthesize choice2btn;
@synthesize choice3btn;
@synthesize choice4btn;
@synthesize choice5btn;
@synthesize choice6btn;
@synthesize selectcho; //選んだ選択肢
@synthesize cho; //クラスChoice cho
@synthesize back;
@synthesize flg1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //textview設定
    //重要
    memo.delegate = self;
    memo.layer.borderWidth = 1.0;
    memo.layer.borderColor = [UIColor grayColor].CGColor;
    memo.scrollEnabled = NO;
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    
    
    [self color:choice1btn];
    [self color:choice2btn];
    [self color:choice3btn];
    [self color:choice4btn];
    [self color:choice5btn];
    [self color:choice6btn];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //DBOpen
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
    //最初だけの処理
    if(i == 0)
    {
        //質問を全て配列に格納する
        NSString*   sql = [ NSString stringWithFormat : @"SELECT * FROM Question,QuestionDetail WHERE Question.q_id = QuestionDetail.q_id and sur_id = \"%@\" order by q_id,qd_id;",survey.sur_id];
        FMResultSet*    rs = [db executeQuery:sql];
        mQD = [[NSMutableArray alloc] init];
        
        while( [rs next] )
        {
            
            Question *QD = [[Question alloc] init];
            QD.sur_id = [rs stringForColumn:@"sur_id"];
            QD.q_id = [rs stringForColumn:@"q_id"];
            QD.q_name = [rs stringForColumn:@"q_name"];
            QD.qd_id = [rs stringForColumn:@"qd_id"];
            QD.qd_name = [rs stringForColumn:@"qd_name"];
            QD.cho_division = [rs stringForColumn:@"cho_division"];
            QD.cho_id = [rs stringForColumn:@"cho_id"];
            [mQD addObject:QD];
            
        }

        [rs close];
        
        //設問の個数を設定
        max = [mQD count];
        
    }
    //i番目のオブジェクトを選ぶ
    questions = [mQD objectAtIndex:i];
    
    //label変更
    _Question.text = questions.q_name;
    _QD.text = questions.qd_name;
    
    //選択肢抽出
    NSString*   sql = [ NSString stringWithFormat : @"SELECT * FROM Choice WHERE cho_id = \"%@\";", questions.cho_id];
    
    FMResultSet*    rs = [db executeQuery:sql];
    cho = [[Choice alloc] init];
    while( [rs next] ){
        cho.choice1 = [rs stringForColumn:@"choice1"];
        cho.choice2 = [rs stringForColumn:@"choice2"];
        cho.choice3 = [rs stringForColumn:@"choice3"];
        cho.choice4 = [rs stringForColumn:@"choice4"];
        cho.choice5 = [rs stringForColumn:@"choice5"];
        cho.choice6 = [rs stringForColumn:@"choice6"];
    }
    
    [rs close];
    [db close];
    
    //ボタンのラベル設定
    [choice1btn setTitle:cho.choice1 forState:UIControlStateNormal];
    [choice2btn setTitle:cho.choice2 forState:UIControlStateNormal];
    [choice3btn setTitle:cho.choice3 forState:UIControlStateNormal];
    [choice4btn setTitle:cho.choice4 forState:UIControlStateNormal];
    [choice5btn setTitle:cho.choice5 forState:UIControlStateNormal];
    [choice6btn setTitle:cho.choice6 forState:UIControlStateNormal];
    //ページ数設定
    _page.text = [NSString stringWithFormat:@"%d/%d",i + 1,max];
    if(!(i == 0)){
    [back setTitle:@"戻る" forState:UIControlStateNormal];
    }
    [self selectbtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // キーボードを閉じる
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
    
}

-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [self.memo resignFirstResponder];
    
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        
        // キーボード表示中のみ有効
        if (self.memo.isFirstResponder) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (IBAction)next:(id)sender {
    [self pushNext];
}

- (void)pushNext{
    //選択肢が選ばれていて次の質問がある場合の処理
    if(i < max-1 && !([selectcho isEqual:@""]) && !(selectcho == nil))
    {
        //次の質問の番号へ
        i = i + 1;
        
        //現在日付を取得
        NSDate *nowdate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *datemoji = [formatter stringFromDate:nowdate];
        
        //回答を仮テーブルに保存
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
        
        NSString*   sql = [ NSString stringWithFormat : @"INSERT OR REPLACE INTO Temporary VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"%@\");", questions.sur_id,questions.q_id,questions.qd_id,enterprise.e_id,enterprise.sec_id,datemoji,answerer,charge,selectcho,memo.text];
        
        [db executeUpdate:sql];
        
        [db close];
        
        questions = [mQD objectAtIndex:i];
        
        //次のビューへ遷移する処理
        if([questions.cho_division isEqual: @"cho"]){
            SurveyViewController *surveyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyView"];
            surveyViewController.enterprise = enterprise;
            surveyViewController.survey = survey;
            surveyViewController.charge = charge;
            surveyViewController.answerer = answerer;
            surveyViewController.i = i;
            surveyViewController.mQD = mQD;
            surveyViewController.max = max;
            [self presentViewController:surveyViewController animated:YES completion:nil];
        }else if ([questions.cho_division isEqual:@"str"]){
            SurveyViewStringController *surveyViewStringController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyViewString"];
            surveyViewStringController.enterprise = enterprise;
            surveyViewStringController.survey = survey;
            surveyViewStringController.charge = charge;
            surveyViewStringController.answerer = answerer;
            surveyViewStringController.i = i;
            surveyViewStringController.mQD = mQD;
            surveyViewStringController.max = max;
            [self presentViewController:surveyViewStringController animated:YES completion:nil];
        }
        //選択肢が選ばれていて次の質問がない場合の処理
    }else if(i == max-1 && !([selectcho isEqual:@""]) && !(selectcho == nil)){
        //仮テーブルからAnswerテーブルへ
        
        //現在日付を取得
        NSDate *nowdate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *datemoji = [formatter stringFromDate:nowdate];
        
        //回答をDBに保存
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
        
        NSString*   sql = [ NSString stringWithFormat : @"INSERT OR REPLACE INTO Temporary VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"%@\");", questions.sur_id,questions.q_id,questions.qd_id,enterprise.e_id,enterprise.sec_id,datemoji,answerer,charge,selectcho,memo.text];
        
        [db executeUpdate:sql];
        
        //くるくる表示
        [SVProgressHUD showWithMaskType: SVProgressHUDMaskTypeBlack];
        
        //結果をサーバーに送信
        SendClass *sendclass = [SendClass alloc];
        NSString *setflg1 = [sendclass sendAnswer:db];
        
        //くるくる非表示
        [SVProgressHUD dismiss];
        
        [db close];
        
        //ネットワークエラー
        if([setflg1 isEqualToString:@"NetworkError"]){
            UIAlertView *alertView =
            [[UIAlertView alloc]
             initWithTitle:@"ネットワークエラーが発生しました" message:@"ネットワークに接続できません\nネットワークの接続を確認して再試行してください" delegate:self
             cancelButtonTitle:@"キャンセル" otherButtonTitles:@"再試行する", nil];
            [alertView show];
            
            return;
        }
        //その他のエラー
        if([setflg1 isEqualToString:@"Error"]){
            UIAlertView *alertView =
            [[UIAlertView alloc]
             initWithTitle:@"エラーが発生しました" message:@"原因不明のエラー" delegate:self
             cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
            [alertView show];
            
            return;
        }
        
        //画面遷移
        EndViewController *endViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EndView"];
        [self presentViewController:endViewController animated:YES completion:nil];
    }else{
        //選択肢が選ばれていない場合の処理
        NSString *body = @"選択してください";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)pushchoice1:(id)sender {
    //選択
    if(!([cho.choice1 isEqual: @""]) && !(cho.choice1 == nil)){
        [self selectchoice1];
    }
}
- (IBAction)pushchoice2:(id)sender {
    //選択
    if(!([cho.choice2 isEqual: @""]) && !(cho.choice2 == nil)){
        [self selectchoice2];
    }
}
- (IBAction)pushchoice3:(id)sender {
    //選択
    if(!([cho.choice3 isEqual: @""]) && !(cho.choice3 == nil)){
        [self selectchoice3];
    }
}
- (IBAction)pushchoice4:(id)sender {
    //選択
    if(!([cho.choice4 isEqual: @""]) && !(cho.choice4 == nil)){
        [self selectchoice4];
    }
}
- (IBAction)pushchoice5:(id)sender {
    //選択
    if(!([cho.choice5 isEqual: @""]) && !(cho.choice5 == nil)){
        [self selectchoice5];
    }
}
- (IBAction)pushchoice6:(id)sender {
    //選択
    if(!([cho.choice6 isEqual: @""]) && !(cho.choice6 == nil)){
        [self selectchoice6];
    }
}
-(void)selectchoice1{
    //選択したボタンの色を変更
    selectcho = cho.choice1;
    [choice1btn setBackgroundColorString:@"AFDFE4" forState:UIControlStateNormal];
    [choice2btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice3btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice4btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice5btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice6btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
}
-(void)selectchoice2{
    selectcho = cho.choice2;
    [choice1btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice2btn setBackgroundColorString:@"AFDFE4" forState:UIControlStateNormal];
    [choice3btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice4btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice5btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice6btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
}
-(void)selectchoice3{
    selectcho = cho.choice3;
    [choice1btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice2btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice3btn setBackgroundColorString:@"AFDFE4" forState:UIControlStateNormal];
    [choice4btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice5btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice6btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
}
-(void)selectchoice4{
    selectcho = cho.choice4;
    [choice1btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice2btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice3btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice4btn setBackgroundColorString:@"AFDFE4" forState:UIControlStateNormal];
    [choice5btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice6btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
}
-(void)selectchoice5{
    selectcho = cho.choice5;
    [choice1btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice2btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice3btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice4btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice5btn setBackgroundColorString:@"AFDFE4" forState:UIControlStateNormal];
    [choice6btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
}
-(void)selectchoice6{
    selectcho = cho.choice6;
    [choice1btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice2btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice3btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice4btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice5btn setBackgroundColorString:@"FFFFFF" forState:UIControlStateNormal];
    [choice6btn setBackgroundColorString:@"AFDFE4" forState:UIControlStateNormal];
}
- (IBAction)back:(id)sender {
    if(!(i == 0)){
        i = i - 1;
        questions = [mQD objectAtIndex:i];
        //前のビューへ遷移する処理
        if([questions.cho_division isEqual: @"cho"]){
            SurveyViewController *surveyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyView"];
            surveyViewController.enterprise = enterprise;
            surveyViewController.survey = survey;
            surveyViewController.charge = charge;
            surveyViewController.answerer = answerer;
            surveyViewController.i = i;
            surveyViewController.mQD = mQD;
            surveyViewController.max = max;
            surveyViewController.flg1= true;
            NSLog(@"%i",surveyViewController.flg1);
            [self presentViewController:surveyViewController animated:YES completion:nil];
        }else if ([questions.cho_division isEqual:@"str"]){
            SurveyViewStringController *surveyViewStringController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyViewString"];
            surveyViewStringController.enterprise = enterprise;
            surveyViewStringController.survey = survey;
            surveyViewStringController.charge = charge;
            surveyViewStringController.answerer = answerer;
            surveyViewStringController.i = i;
            surveyViewStringController.mQD = mQD;
            surveyViewStringController.max = max;
            surveyViewStringController.flg1= true;
            NSLog(@"%i",flg1);
            [self presentViewController:surveyViewStringController animated:YES completion:nil];
        }
    }
}

-(void)color:(UIButton*)button{
    // ボタン枠線の色
    [[button layer] setBorderColor:[[UIColor grayColor] CGColor]];
    // ボタン枠線の太さ
    [[button layer] setBorderWidth:0.7];
    //角丸
    [[button layer] setCornerRadius:7.5];
    [button setClipsToBounds:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self adjustViewForKeyboardReveal:YES notificationInfo:[aNotification userInfo]];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self adjustViewForKeyboardReveal:NO notificationInfo:[aNotification userInfo]];
}

- (void)adjustViewForKeyboardReveal:(BOOL)showKeyboard notificationInfo:(NSDictionary *)notificationInfo
{
    CGRect keyboardRect = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
    [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect memof = self.memo.frame;
    CGRect btn1f = self.choice1btn.frame;
    CGRect btn2f = self.choice2btn.frame;
    CGRect btn3f = self.choice3btn.frame;
    CGRect btn4f = self.choice4btn.frame;
    CGRect btn5f = self.choice5btn.frame;
    CGRect btn6f = self.choice6btn.frame;
    
    NSInteger adjustDelta =UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetHeight(keyboardRect) : CGRectGetWidth(keyboardRect);
    
    if (showKeyboard){
        memof.origin.y -= adjustDelta;
        btn1f.origin.y -= 600;
        btn2f.origin.y -= 600;
        btn3f.origin.y -= 600;
        btn4f.origin.y -= 600;
        btn5f.origin.y -= 600;
        btn6f.origin.y -= 600;
    }else{
        memof.origin.y += adjustDelta;
        btn1f.origin.y += 600;
        btn2f.origin.y += 600;
        btn3f.origin.y += 600;
        btn4f.origin.y += 600;
        btn5f.origin.y += 600;
        btn6f.origin.y += 600;
    }
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.memo.frame = memof;
    self.choice1btn.frame = btn1f;
    self.choice2btn.frame = btn2f;
    self.choice3btn.frame = btn3f;
    self.choice4btn.frame = btn4f;
    self.choice5btn.frame = btn5f;
    self.choice6btn.frame = btn6f;
    [UIView commitAnimations];
}
- (void)selectbtn{
    //DBOpen
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
    //現在日付を取得
    NSDate *nowdate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *datemoji = [formatter stringFromDate:nowdate];
    
    NSString*   sql = [ NSString stringWithFormat : @"select ans_cho,memo from Temporary where sur_id = \"%@\" and q_id = \"%@\" and qd_id = \"%@\" and e_id = \"%@\" and sec_id = \"%@\" and ans_date = \"%@\";",survey.sur_id,questions.q_id,questions.qd_id,enterprise.e_id,enterprise.sec_id,datemoji];
    FMResultSet*    rs = [db executeQuery:sql];
    while( [rs next] )
    {
        Answer * answer = [[Answer alloc] init];
        answer.ans_cho= [rs stringForColumn:@"ans_cho"];
        answer.memo = [rs stringForColumn:@"memo"];
        memo.text = answer.memo;
        [mAnswer addObject:answer];
        if([cho.choice1 isEqual: [NSString stringWithFormat:@"%@",answer.ans_cho]]){
            [self selectchoice1];
        }else if([cho.choice2 isEqual: [NSString stringWithFormat:@"%@",answer.ans_cho]]){
            [self selectchoice2];
        }else if([cho.choice3 isEqual: [NSString stringWithFormat:@"%@",answer.ans_cho]]){
            [self selectchoice3];
        }else if([cho.choice4 isEqual: [NSString stringWithFormat:@"%@",answer.ans_cho]]){
            [self selectchoice4];
        }else if([cho.choice5 isEqual: [NSString stringWithFormat:@"%@",answer.ans_cho]]){
            [self selectchoice5];
        }else if([cho.choice6 isEqual: [NSString stringWithFormat:@"%@",answer.ans_cho]]){
            [self selectchoice6];
        }
    }
    
    
    [rs close];
    [db close];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            [self pushNext];
            break;
    }
}
@end