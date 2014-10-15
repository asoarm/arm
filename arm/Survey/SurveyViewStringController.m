//
//  SurveyViewStringController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "SurveyViewStringController.h"
#import "SurveyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"
#import "Question.h"
#import "EndViewController.h"
#import "Answer.h"
#import "SendClass.h"
#import "SVProgressHUD.h"

@interface SurveyViewStringController ()
@property (assign,nonatomic) BOOL flg;
@end

@implementation SurveyViewStringController
@synthesize survey;
@synthesize enterprise;
@synthesize charge;
@synthesize answerer;
@synthesize questions;
@synthesize mQD;
@synthesize i;
@synthesize max;
@synthesize answer_str;
@synthesize back;
@synthesize memo;
@synthesize flg1;
@synthesize mAnswer;

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
    answer_str.delegate = self;
    answer_str.layer.borderWidth = 1.0;
    answer_str.layer.borderColor = [UIColor grayColor].CGColor;
    answer_str.scrollEnabled = NO;
    
    memo.delegate = self;
    memo.layer.borderWidth = 1.0;
    memo.layer.borderColor = [UIColor grayColor].CGColor;
    memo.scrollEnabled = NO;
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    

    
    
}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    _flg = YES;
	
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
        
        //Temporaryのデータを空にする
        NSString*   delete = @"DELETE FROM Temporary";
        [db executeUpdate:delete];
    }
    //i番目のオブジェクトを選ぶ
    questions = [mQD objectAtIndex:i];
    
    //label変更
    _Question.text = questions.q_name;
    _QD.text = questions.qd_name;
    _page.text = [NSString stringWithFormat:@"%d/%d",i + 1,max];
    [db close];
    
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
    
    [self.answer_str resignFirstResponder];
    
    [self.memo resignFirstResponder];
    
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        
        // キーボード表示中のみ有効
        if (self.answer_str.isFirstResponder || self.memo.isFirstResponder) {
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
    
    //入力されていて次の質問がある場合の処理
    if(i < max-1 && !([answer_str.text isEqual:@""]) && !(answer_str.text == nil))
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
        
        NSString*   sql = [ NSString stringWithFormat : @"INSERT OR REPLACE INTO Temporary VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"%@\",\"%@\");", questions.sur_id,questions.q_id,questions.qd_id,enterprise.e_id,enterprise.sec_id,datemoji,answerer,charge,answer_str.text,memo.text];
        
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
        //入力されていて次の質問がない場合の処理
    }else if(i == max-1 && !([answer_str.text isEqual:@""]) && !(answer_str.text == nil)){
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
        
        NSString*   sql = [ NSString stringWithFormat : @"INSERT OR REPLACE INTO Temporary VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"%@\",\"%@\");", questions.sur_id,questions.q_id,questions.qd_id,enterprise.e_id,enterprise.sec_id,datemoji,answerer,charge,answer_str.text,memo.text];
        
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
    }else if(_flg){
        //入力されていない場合の処理
        NSString *body = @"入力してください";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)back:(id)sender {
    _flg = NO;
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
    }
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
    CGRect ansf = self.answer_str.frame;
    CGRect memof = self.memo.frame;
    
    NSInteger adjustDelta =UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetHeight(keyboardRect) : CGRectGetWidth(keyboardRect);
    NSInteger ansI = 700;
    if(self.answer_str.isFirstResponder){
        adjustDelta = 0;
        ansI = 0;
    }
    
    if (showKeyboard){
        memof.origin.y -= adjustDelta;
        ansf.origin.y  -= ansI;
    }
    else{
        memof.origin.y += adjustDelta;
        ansf.origin.y  += ansI;
    }
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.memo.frame = memof;
    self.answer_str.frame = ansf;
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
    
    NSString*   sql = [ NSString stringWithFormat : @"select ans_str,memo from Temporary where sur_id = \"%@\" and q_id = \"%@\" and qd_id = \"%@\" and e_id = \"%@\" and sec_id = \"%@\" and ans_date = \"%@\";",survey.sur_id,questions.q_id,questions.qd_id,enterprise.e_id,enterprise.sec_id,datemoji];
    FMResultSet*    rs = [db executeQuery:sql];
    while( [rs next] )
    {
        Answer * answer = [[Answer alloc] init];
        answer.ans_str= [rs stringForColumn:@"ans_str"];
        answer.memo = [rs stringForColumn:@"memo"];
        answer_str.text = answer.ans_str;
        memo.text = answer.memo;
        [mAnswer addObject:answer];
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