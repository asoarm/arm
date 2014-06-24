//
//  StartViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "StartViewController.h"
#import "SurveyViewController.h"
#import "Enterprise.h"
#import "FMDatabase.h"
#import "SurveyViewStringController.h"
#import "Question.h"

@interface StartViewController ()

@end

@implementation StartViewController
@synthesize survey;
@synthesize enterprise;
@synthesize txt1;
@synthesize txt2;
@synthesize mQD;

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
    
    [txt1 setDelegate:self];
    [txt2 setDelegate:self];
    
    //tap
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    
    //DB接続処理
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
    //質問形式を区別するために区分を持ってくる
    NSString*   sql = [ NSString stringWithFormat : @"SELECT * FROM Question,QuestionDetail WHERE Question.q_id = QuestionDetail.q_id and sur_id = \"%@\" order by q_id,qd_id;",survey.sur_id];
    
    FMResultSet*    rs = [db executeQuery:sql];
    //配列を初期化
    mQD = [[NSMutableArray alloc] init];
        
    while( [rs next] )
        {
            //Questionクラスのインスタンスを生成
            Question *QD = [[Question alloc] init];
            //インスタンスに属性をセット
            QD.cho_division = [rs stringForColumn:@"cho_division"];
            //配列にインスタンスを挿入
            [mQD addObject:QD];
        }
    //DB終了
    [rs close];
    [db close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    // キーボードを閉じる
    [theTextField resignFirstResponder];
    
    return YES;
}

-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.txt1 resignFirstResponder];
    [self.txt2 resignFirstResponder];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        
        // キーボード表示中のみ有効
        if (self.txt1.isFirstResponder || self.txt2.isFirstResponder) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (IBAction)start:(id)sender {
    //入力されている場合のみ処理が実行される
    if(!([txt1.text isEqual:@""]) && !([txt2.text isEqual:@""])){

        Question *qd = [mQD objectAtIndex:0];
        
        //質問形式に応じた画面へ遷移する
        if([qd.cho_division isEqual: @"cho"]){
            SurveyViewController *surveyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyView"];
            surveyViewController.enterprise = enterprise;
            surveyViewController.survey = survey;
            surveyViewController.charge = txt1.text;
            surveyViewController.answerer = txt2.text;
            [self presentViewController:surveyViewController animated:YES completion:nil];
        }else if ([qd.cho_division isEqual:@"str"]){
            SurveyViewStringController *surveyViewStringController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveyViewString"];
            surveyViewStringController.enterprise = enterprise;
            surveyViewStringController.survey = survey;
            surveyViewStringController.charge = txt1.text;
            surveyViewStringController.answerer = txt2.text;
            [self presentViewController:surveyViewStringController animated:YES completion:nil];
        }
        
    }else{
        NSString *body = @"入力してください";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
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
    NSTimeInterval animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    CGRect txt1f = self.txt1.frame;
    CGRect txt2f = self.txt2.frame;
    CGRect label1f = self.label1.frame;
    CGRect label2f = self.label2.frame;
    
    NSInteger origin = 0;
    NSInteger origin1 =0;
    
    if(self.txt1.isFirstResponder){
        origin = 0;
    }
    if(self.txt2.isFirstResponder){
        origin = 200;
        origin1 = 500;
    }
    if (showKeyboard){
        txt1f.origin.y -= origin1;
        txt2f.origin.y -= origin;
        label1f.origin.y -= origin1;
        label2f.origin.y -= origin;
    }else{
        txt1f.origin.y += origin1;
        txt2f.origin.y += origin;
        label1f.origin.y += origin1;
        label2f.origin.y += origin;
    }
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    self.txt1.frame = txt1f;
    self.txt2.frame = txt2f;
    self.label1.frame = label1f;
    self.label2.frame = label2f;
    [UIView commitAnimations];
}
@end
