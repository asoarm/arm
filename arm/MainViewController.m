//
//  AppDelegate.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "MainViewController.h"
#import "FMDatabase.h"
#import "NotesSettingsController.h"
#import <Dropbox/Dropbox.h>
#import "ImportTable.h"
#import "SVProgressHUD.h"
#import "EnterpriseDivisionViewController.h"
#import "DivisionViewController.h"
#import "SyukeiDivisionViewController.h"

@interface MainViewController (){
    NSString *strflg;
}
@property (nonatomic, retain) SettingsController *settingsController;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ナビゲーションバー非表示
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    // NSUserDefaultsの取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // KEY_BOOLの内容を取得し、BOOL型変数へ格納
    BOOL isBool = [defaults boolForKey:@"KEY_BOOL"];
    // isBoolがNOの場合、アラート表示
    if (!isBool) {
        //データベース作成・接続
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
        
        //テーブル作成
        NSString    *sql = @"CREATE TABLE Survey (sur_id TEXT,sur_name TEXT NOT NULL,sur_division TEXT NOT NULL,PRIMARY KEY(sur_id));";
        NSString    *sql2 = @"CREATE TABLE Question (q_id TEXT,q_name TEXT NOT NULL,PRIMARY KEY(q_id));";
        NSString    *sql3 = @"CREATE TABLE Enterprise (e_id TEXT, e_name TEXT NOT NULL, division TEXT NOT NULL, PRIMARY KEY(e_id));";
        NSString    *sql4 = @"CREATE TABLE Section(e_id TEXT,sec_id TEXT,sec_name TEXT NOT NULL, PRIMARY KEY(e_id,sec_id),FOREIGN KEY(e_id) REFERENCES Enterprise(e_id));";
        NSString    *sql5 = @"CREATE TABLE Choice (cho_id TEXT, choice1 TEXT NOT NULL, choice2 TEXT NOT NULL, choice3 TEXT, choice4 TEXT, choice5 TEXT, choice6 TEXT, PRIMARY KEY(cho_id));";
        
        NSString    *sql6 = @"CREATE TABLE QuestionDetail (sur_id TEXT, q_id TEXT, qd_id TEXT,qd_name TEXT NOT NULL, cho_division TEXT NOT NULL,cho_id TEXT,PRIMARY KEY(sur_id,q_id,qd_id) ,FOREIGN KEY(sur_id) REFERENCES Survey(sur_id),FOREIGN KEY(q_id) REFERENCES Question(q_id),FOREIGN KEY(cho_id) REFERENCES Choice(cho_id));";

        NSString    *sql7 = @"CREATE TABLE Answer (sur_id TEXT, q_id TEXT, qd_id TEXT,e_id TEXT,sec_id TEXT,ans_date NUMERIC,answerer TEXT NOT NULL,charge TEXT NOT NULL,ans_cho TEXT,ans_str TEXT,memo TEXT,PRIMARY KEY(sur_id,q_id,qd_id,e_id,sec_id,ans_date) ,FOREIGN KEY(sur_id) REFERENCES Survey(sur_id),FOREIGN KEY(q_id) REFERENCES Question(q_id),FOREIGN KEY(qd_id) REFERENCES QuestionDetail(qd_id),FOREIGN KEY(e_id) REFERENCES Enterprise(e_id),FOREIGN KEY(sec_id) REFERENCES Section(sec_id));";
        
        NSString    *sql8 = @"create table Comment (sur_id TEXT not null,q_id TEXT not null,qd_id TEXT not null,e_id TEXT not null,comment TEXT,primary key (sur_id,q_id,qd_id,e_id),foreign key (sur_id) references Survey (sur_id),foreign key (q_id) references Question (q_id),foreign key (qd_id) references QuestionDetail (sur_id),foreign key (e_id) references Enterprise (e_id));";
            
        NSString    *sql9 =@"CREATE TABLE Temporary (sur_id TEXT, q_id TEXT, qd_id TEXT,e_id TEXT,sec_id TEXT,ans_date NUMERIC,answerer TEXT NOT NULL,charge TEXT NOT NULL,ans_cho TEXT,ans_str TEXT,memo TEXT,PRIMARY KEY(sur_id,q_id,qd_id,e_id,sec_id,ans_date) ,FOREIGN KEY(sur_id) REFERENCES Survey(sur_id),FOREIGN KEY(q_id) REFERENCES Question(q_id),FOREIGN KEY(qd_id) REFERENCES QuestionDetail(qd_id),FOREIGN KEY(e_id) REFERENCES Enterprise(e_id),FOREIGN KEY(sec_id) REFERENCES Section(sec_id));";
            
        [db executeUpdate:sql];
        [db executeUpdate:sql2];
        [db executeUpdate:sql3];
        [db executeUpdate:sql4];
        [db executeUpdate:sql5];
        [db executeUpdate:sql6];
        [db executeUpdate:sql7];
        [db executeUpdate:sql8];
        [db executeUpdate:sql9];
        
        [db close];
        // KEY_BOOLにYESを設定
        [defaults setBool:YES forKey:@"KEY_BOOL"];
        // 設定を保存
        [defaults synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //ナビゲーションバー非表示
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //データベース作成・接続
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
    
    //テーブル初期化
    NSString    *sql = @"DELETE from Survey;";
    [db executeUpdate:sql];
    sql = @"DELETE from Question;";
    [db executeUpdate:sql];
    sql = @"DELETE from Enterprise;";
    [db executeUpdate:sql];
    sql = @"DELETE from Section;";
    [db executeUpdate:sql];
    sql = @"DELETE from Choice;";
    [db executeUpdate:sql];
    sql = @"DELETE from QuestionDetail;";
    [db executeUpdate:sql];
    sql = @"DELETE from Answer;";
    [db executeUpdate:sql];
    sql = @"DELETE from Comment;";
    [db executeUpdate:sql];
    sql = @"DELETE from Temporary;";
    [db executeUpdate:sql];
    
    [db close];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushSurvey:(id)sender {
    [self importSurvey];
}

- (IBAction)pushSyukei:(id)sender {
    [self importSyukei];
}

- (IBAction)pushEnterprise:(id)sender {
    [self importEnterprise];
}

- (IBAction)data:(id)sender
{
    //NotesSettingControllerクラスのインスタンスを生成
    _settingsController = [[NotesSettingsController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_settingsController];
    //_settingControllerへ画面遷移
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)showKurukuru{
    //くるくる表示
    [SVProgressHUD showWithMaskType: SVProgressHUDMaskTypeBlack];
}
-(void)dismissKurukuru{
    //くるくる非表示
    [SVProgressHUD dismiss];
}


-(void)importSurvey{
    strflg = @"Survey";
    
    [self showKurukuru];
    
    //データベース作成・接続
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
    
    //サーバーからデータを内部DBへ入れる
    ImportTable *importTable = [ImportTable alloc];
    NSString* setflg1 = [importTable importEnterprise:db];
    NSString* setflg2 = [importTable importSection:db];
    NSString* setflg3 = [importTable importSurvey:db];
    NSString* setflg4 = [importTable importQuestion:db];
    NSString* setflg5 = [importTable importChoice:db];
    NSString* setflg6 = [importTable importQuestionDetail:db];
    
    [db close];
    
    [self dismissKurukuru];
    
    if([setflg1 isEqualToString:@"NetworkError"] || [setflg2 isEqualToString:@"NetworkError"] || [setflg3 isEqualToString:@"NetworkError"] || [setflg4 isEqualToString:@"NetworkError"] || [setflg5 isEqualToString:@"NetworkError"] || [setflg6 isEqualToString:@"NetworkError"]){
        UIAlertView *alertView =
        [[UIAlertView alloc]
         initWithTitle:@"ネットワークエラーが発生しました" message:@"ネットワークに接続できません\nネットワークの接続を確認して再試行してください" delegate:self
         cancelButtonTitle:@"キャンセル" otherButtonTitles:@"再試行する", nil];
        [alertView show];
        
        return;
    }
    
    if([setflg1 isEqualToString:@"Error"] || [setflg2 isEqualToString:@"Error"] || [setflg3 isEqualToString:@"Error"] || [setflg4 isEqualToString:@"Error"] || [setflg5 isEqualToString:@"Error"] || [setflg6 isEqualToString:@"Error"]){
        UIAlertView *alertView =
        [[UIAlertView alloc]
         initWithTitle:@"エラーが発生しました" message:@"原因不明のエラー" delegate:self
         cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [alertView show];
        
        return;
    }
    
    //画面遷移
    DivisionViewController *enterpriseDivisionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DivisionView"];
    [self presentViewController:enterpriseDivisionViewController animated:YES completion:nil];
}

-(void)importSyukei{
    strflg = @"Syukei";
    
    [self showKurukuru];
    
    //データベース作成・接続
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
    
    //サーバーからデータを内部DBへ入れる
    ImportTable *importTable = [ImportTable alloc];
    
    NSString* setflg1 = [importTable importEnterprise:db];
    NSString* setflg2 = [importTable importSection:db];
    NSString* setflg3 = [importTable importSurvey:db];
    NSString* setflg4 = [importTable importQuestion:db];
    NSString* setflg5 = [importTable importChoice:db];
    NSString* setflg6 = [importTable importQuestionDetail:db];
    
    [db close];
    
    [self dismissKurukuru];
    
    if([setflg1 isEqualToString:@"NetworkError"] || [setflg2 isEqualToString:@"NetworkError"] || [setflg3 isEqualToString:@"NetworkError"] || [setflg4 isEqualToString:@"NetworkError"] || [setflg5 isEqualToString:@"NetworkError"] || [setflg6 isEqualToString:@"NetworkError"]){
        UIAlertView *alertView =
        [[UIAlertView alloc]
         initWithTitle:@"ネットワークエラーが発生しました" message:@"ネットワークに接続できません\nネットワークの接続を確認して再試行してください" delegate:self
         cancelButtonTitle:@"キャンセル" otherButtonTitles:@"再試行する", nil];
        [alertView show];
        
        return;
    }
    
    if([setflg1 isEqualToString:@"Error"] || [setflg2 isEqualToString:@"Error"] || [setflg3 isEqualToString:@"Error"] || [setflg4 isEqualToString:@"Error"] || [setflg5 isEqualToString:@"Error"] || [setflg6 isEqualToString:@"Error"]){
        UIAlertView *alertView =
        [[UIAlertView alloc]
         initWithTitle:@"エラーが発生しました" message:@"原因不明のエラー" delegate:self
         cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [alertView show];
        
        return;
    }
    
    //画面遷移
    SyukeiDivisionViewController *syukeiDivisionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SyukeiDivisionView"];
    [self presentViewController:syukeiDivisionViewController animated:YES completion:nil];
}

-(void)importEnterprise{
    strflg = @"Enterprise";
    
    [self showKurukuru];
    
    //データベース作成・接続
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
    
    //サーバーからデータを内部DBへ入れる
    ImportTable *importTable =[ImportTable alloc];
    NSString* setflg1 = [importTable importEnterprise:db];
    NSString* setflg2 = [importTable importSection:db];
    
    [db close];
    
    [self dismissKurukuru];
    
    if([setflg1 isEqualToString:@"NetworkError"] || [setflg2 isEqualToString:@"NetworkError"]){
        UIAlertView *alertView =
        [[UIAlertView alloc]
         initWithTitle:@"ネットワークエラーが発生しました" message:@"ネットワークに接続できません\nネットワークの接続を確認して再試行してください" delegate:self
         cancelButtonTitle:@"キャンセル" otherButtonTitles:@"再試行する", nil];
        [alertView show];
        
        return;
    }
    
    if([setflg1 isEqualToString:@"Error"] || [setflg2 isEqualToString:@"Error"]){
        UIAlertView *alertView =
        [[UIAlertView alloc]
         initWithTitle:@"エラーが発生しました" message:@"原因不明のエラー" delegate:self
         cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [alertView show];
        
        return;
    }
    
    //画面遷移
    EnterpriseDivisionViewController *enterpriseDivisionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterpriseDivisionView"];
    [self presentViewController:enterpriseDivisionViewController animated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            if([strflg  isEqual: @"Survey"]){
                [self importSurvey];
            }else if([strflg  isEqual: @"Syukei"]){
                [self importSyukei];
            }else if([strflg  isEqual: @"Enterprise"]){
                [self importEnterprise];
            }
            break;
    }
}
@end
