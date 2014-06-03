//
//  ViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "Enterprise.h"
#import "AdministrationMasterTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize txt2;
@synthesize txt3;
@synthesize division;

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
    //delegate設定
    NSLog(@"11111111%@",division);
    [txt2 setDelegate:self];
    [txt3 setDelegate:self];
    
    //tap
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
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
    [self.txt2 resignFirstResponder];
    [self.txt3 resignFirstResponder];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.singleTap) {
        
        // キーボード表示中のみ有効
        if (self.txt2.isFirstResponder ||self.txt3.isFirstResponder) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}
- (IBAction)done:(id)sender {
    

    //NULL判定
    if([txt2.text isEqual:[NSNull null]] || [txt3.text isEqual:[NSNull null]]){
    }
    else{
        if (!([txt2.text isEqualToString:@""]) && !([txt3.text isEqualToString:@""])){
        
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
            
            
            //初めて登録する場合
            NSString* sqlfirst = @"select * from Enterprise;";
            FMResultSet* rsfirst = [db executeQuery:sqlfirst];
            NSString *strfirst;
            while( [rsfirst next] )
            {
                strfirst = [rsfirst stringForColumn:@"e_id"];
            }
            if(strfirst == nil || [strfirst isEqual:@""])
            {
                NSString* sql2 = [NSString stringWithFormat:@"INSERT INTO Enterprise VALUES(\"E10001\",\"%@\",\"%@\");",txt2.text,division];
                [db executeUpdate:sql2];
            }else
            {
                //同じ名前の会社がない場合
                NSString* sqlname = [NSString stringWithFormat:@"select * from Enterprise where e_name = \"%@\";",txt2.text];
                FMResultSet* rsname = [db executeQuery:sqlname];
                NSString *strname;
                while( [rsname next] )
                {
                    strname = [rsname stringForColumn:@"e_id"];
                }
                [rsname close];
                
                if (strname == nil || [strname isEqual:@""]) {
                    NSString*   sql = @"select * from Enterprise order by e_id;";
                    
                    FMResultSet* rs = [db executeQuery:sql];
                    
                    NSString *str;
                    
                    while( [rs next] )
                    {
                        str = [rs stringForColumn:@"e_id"];
                    }
                    
                    [rs close];
                    //文字列置換　Eを取り除く
                    NSString *result = [str stringByReplacingOccurrencesOfString:@"E" withString:@""];
                    
                    int i = [result intValue];
                    
                    i = i + 1;
                    
                    NSString* sql2 = [NSString stringWithFormat:@"INSERT INTO Enterprise VALUES(\"E%d\",\"%@\",\"%@\");",i,txt2.text,division];
                    
                    [db executeUpdate:sql2];
                }
            }
            
            
            //入力した会社名のe_idをセレクト
            NSString*   sql5 = [NSString stringWithFormat:@"select * from Enterprise where e_name = \"%@\";",txt2.text];
            FMResultSet* rs3 = [db executeQuery:sql5];
            NSString *e_id;
            while( [rs3 next] )
            {
                e_id = [rs3 stringForColumn:@"e_id"];
            }
            [rs3 close];
            
            //指定したe_idでsectionをセレクト
            NSString*   sql3 = [NSString stringWithFormat:@"select * from Section where e_id = \"%@\" order by e_id,sec_id;",e_id];
            
            FMResultSet* rs2 = [db executeQuery:sql3];
            
            NSString *str2;
            while( [rs2 next] )
            {
                str2 = [rs2 stringForColumn:@"sec_id"];
            }
            
            [rs2 close];
            
            
            if(!([str2 isEqual:@""]) && !(str2 == nil)){
                //既に課コードが入っていた場合
                NSString* sqlsec = [NSString stringWithFormat:@"SELECT * FROM Section WHERE e_id = \"%@\" and sec_name = \"%@\";",e_id,txt3.text];
                FMResultSet* rssec = [db executeQuery:sqlsec];
                NSString *strsec;
                while( [rssec next] )
                {
                    strsec = [rssec stringForColumn:@"sec_id"];
                }
                if(([strsec isEqual:@""]) || (strsec == nil))
                {
                    //同じ課名がない場合
                    //文字列置換　SECを取り除く
                    NSString *resultS = [str2 stringByReplacingOccurrencesOfString:@"SEC" withString:@""];
            
                    int iS = [resultS intValue];
            
                    iS = iS + 1;
            
                    NSString* sql4 = [NSString stringWithFormat:@"INSERT INTO Section VALUES(\"%@\",\"SEC%d\",\"%@\");",e_id,iS,txt3.text];
            
                    [db executeUpdate:sql4];
                }
            }else{
                //入っていなかった場合
                NSString* sql4 = [NSString stringWithFormat:@"INSERT INTO Section VALUES(\"%@\",\"SEC101\",\"%@\");",e_id,txt3.text];
                
                [db executeUpdate:sql4];
            }
            [db close];
            [self.navigationController popViewControllerAnimated:YES];
            //元の画面に戻る
        }else{
            NSString *body = @"選択・入力してください";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    
    }
}

//追加1
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
    NSTimeInterval animationDuration =
    [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    
    NSInteger adjustDelta =200;

    if(self.txt2.isFirstResponder){
        adjustDelta = 0;
    }
    if (showKeyboard)
        frame.origin.y -= adjustDelta;
    else
        frame.origin.y += adjustDelta;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

@end
