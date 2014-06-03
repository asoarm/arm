//
//  Comment.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "Comment.h"
#import "ViewSquare.h"
#import "PieChartsView.h"
#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"

@interface Comment ()
@end

@implementation Comment
@synthesize questiondetail;
@synthesize enterprise;
@synthesize choice1;
@synthesize choice2;
@synthesize choice3;
@synthesize choice4;
@synthesize choice5;
@synthesize choice6;
@synthesize choice1_name;
@synthesize choice2_name;
@synthesize choice3_name;
@synthesize choice4_name;
@synthesize choice5_name;
@synthesize choice6_name;
@synthesize comment;
@synthesize comment_value;
@synthesize cho_flg;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    //textview設定
    [super viewDidLoad];
    
    // スクロールビューを作成します。
    [self.view addSubview:_done];
    [self.view addSubview:_reset];
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 721)];
    [self.view addSubview:myScrollView];
    comment.frame = CGRectMake(130,500, 780, 211);
    [myScrollView addSubview:comment];
    _commentlabel.frame = CGRectMake(100,470,143,36);
    [myScrollView addSubview:_commentlabel];
    _qd.frame = CGRectMake(_qd.frame.origin.x, _qd.frame.origin.y-40, _qd.frame.size.width, _qd.frame.size.height);
    [myScrollView addSubview:_qd];
    
    [self setcho_name];
    
    //-(void)showpieを実行
    [self showpie];
    //-(void)labelを実行
    [self label];
    
    [self comment_show];
    
    comment.delegate = self;
    comment.scrollEnabled = NO;
    
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

- (BOOL) textViewShouldReturn:(UITextView *)theTextView
{
    // キーボードを閉じる
    [theTextView resignFirstResponder];
    
    return YES;
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
    //シングルタップされたらresignFirstResponderでキーボードを閉じる
    [self.comment resignFirstResponder];
}

- (void)setcho_name
{
    //適切な選択肢を取り出す処理
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
    FMResultSet*    rs = [db executeQuery:@"select * from Choice where cho_id = ? ;",questiondetail.cho_id];
    while( [rs next] )
    {
        choice1_name = [rs stringForColumn:@"choice1"];
        choice2_name = [rs stringForColumn:@"choice2"];
        choice3_name = [rs stringForColumn:@"choice3"];
        choice4_name = [rs stringForColumn:@"choice4"];
        choice5_name = [rs stringForColumn:@"choice5"];
        choice6_name = [rs stringForColumn:@"choice6"];
    }
    [rs close];
    
    
    [db close];
}


- (void)showpie
{
    //円グラフを表示
    PieChartsView *pieChartsView = [[PieChartsView alloc] initWithFrame:self.view.bounds];
    pieChartsView.choice1 = choice1;
    pieChartsView.choice2 = choice2;
    pieChartsView.choice3 = choice3;
    pieChartsView.choice4 = choice4;
    pieChartsView.choice5 = choice5;
    pieChartsView.choice6 = choice6;
    [myScrollView addSubview:pieChartsView];
    [myScrollView sendSubviewToBack:pieChartsView];

    
    //四角系を表示
    ViewSquare *viewSquare =[[ViewSquare alloc] initWithFrame :self.view.bounds];
    [myScrollView addSubview:viewSquare];
    [myScrollView sendSubviewToBack:viewSquare];
    
    //commentlabelの角丸を設定
    _commentlabel.layer.cornerRadius = 10.0;
    
    //commentの枠線を設定
    comment.layer.borderWidth = 1.0;
    comment.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)label
{
    //qd表示
    _qd.text = [ NSString stringWithFormat : @"%@", questiondetail.qd_name];
    //label表示
    double cho1 = choice1;
    double cho2 = choice2;
    double cho3 = choice3;
    double cho4 = choice4;
    double cho5 = choice5;
    double cho6 = choice6;
    
    double sum = cho1 + cho2 + cho3 + cho4 + cho5 + cho6;
    if(sum == 0){
        sum = 1;
    }

    int cho1per = round(cho1 * 100 / sum);
    int cho2per = round(cho2 * 100 / sum);
    int cho3per = round(cho3 * 100 / sum);
    int cho4per = round(cho4 * 100 / sum);
    int cho5per = round(cho5 * 100 / sum);
    int cho6per = round(cho6 * 100 / sum);

    if (![cho_flg[0]isEqualToString:@""]){
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(550,221,400,30)];
        label1.backgroundColor = [UIColor whiteColor];
        label1.textColor = [UIColor blueColor];
        label1.font = [UIFont fontWithName:@"AppleGothic" size:20];
        label1.text = [ NSString stringWithFormat : @"%@　%d％",choice1_name,cho1per];
        [myScrollView addSubview:label1];
    }
    
    if(![cho_flg[1]isEqualToString:@""]) {
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(550,261,400,30)];
        label2.backgroundColor = [UIColor whiteColor];
        label2.textColor = [UIColor redColor];
        label2.font = [UIFont fontWithName:@"AppleGothic" size:20];
        label2.text = [ NSString stringWithFormat : @"%@　%d％",choice2_name,cho2per];
        [myScrollView addSubview:label2];
    }
    
    if(![cho_flg[2]isEqualToString:@""]){
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(550,301,400,30)];
        label3.backgroundColor = [UIColor whiteColor];
        label3.textColor = [UIColor colorWithRed:0.133 green:0.545 blue:0.133 alpha:1.0];
        label3.font = [UIFont fontWithName:@"AppleGothic" size:20];
        label3.text = [ NSString stringWithFormat : @"%@　%d％",choice3_name, cho3per];
        [myScrollView addSubview:label3];
    }
    
    if(![cho_flg[3]isEqualToString:@""]) {
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(550,341,400,30)];
        label4.backgroundColor = [UIColor whiteColor];
        label4.textColor = [UIColor orangeColor];
        label4.font = [UIFont fontWithName:@"AppleGothic" size:20];
        label4.text = [ NSString stringWithFormat : @"%@　%d％",choice4_name, cho4per];
        [myScrollView addSubview:label4];
    }
    
    if(![cho_flg[4]isEqualToString:@""]) {
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(550,381,400,30)];
        label5.backgroundColor = [UIColor whiteColor];
        label5.textColor = [UIColor colorWithRed:0.118 green:0.565 blue:1.0 alpha:1.0];
        label5.font = [UIFont fontWithName:@"AppleGothic" size:20];
        label5.text = [ NSString stringWithFormat : @"%@　%d％",choice5_name, cho5per];
        [myScrollView addSubview:label5];
    }
    
    if(![cho_flg[5]isEqualToString:@""]) {
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(550,421,400,30)];
        label6.backgroundColor = [UIColor whiteColor];
        label6.textColor = [UIColor magentaColor];
        label6.font = [UIFont fontWithName:@"AppleGothic" size:20];
        label6.text = [ NSString stringWithFormat : @"%@ %d％",choice6_name, cho6per];
        [myScrollView addSubview:label6];
    }

}

-(void) comment_show{
    //コメント表示
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
    
        FMResultSet*    sql2 = [db executeQuery:@"select comment from Comment where sur_id=? and q_id=? and qd_id=? and e_id = ?;",questiondetail.sur_id,questiondetail.q_id,questiondetail.qd_id,enterprise.e_id];
        while( [sql2 next] )
        {
            comment_value = [sql2 stringForColumn:@"comment"];
        }
        [sql2 close];
        comment.text = comment_value;
            
        [db close];
}

- (IBAction)done:(id)sender {
    //コメント確定ボタン処理
    if([comment.text isEqual:[NSNull null]]){
    }
    else{
        if ( !([comment.text isEqualToString:@""])){
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
                
            NSString* sql2 = [NSString stringWithFormat:@"INSERT OR REPLACE INTO Comment VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",questiondetail.sur_id,questiondetail.q_id,questiondetail.qd_id,enterprise.e_id,comment.text];
                
                [db executeUpdate:sql2];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    //元の画面に戻る
}

- (IBAction)reset:(id) sender {
    //リセットボタンの処理
    comment.text = comment_value;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    // listen for keyboard hide/show notifications so we can properly adjust the table's height
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
    // キーボードの高さを習得
	CGRect keyboardRect = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
    [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger adjustDelta =
    UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetHeight(keyboardRect) : CGRectGetWidth(keyboardRect);
    //キーボードのアニメーションに対してviewをスクロールさせる
    if (showKeyboard){
        CGPoint scrollPoint = CGPointMake(0.0,adjustDelta);
        [myScrollView setContentOffset:scrollPoint animated:YES];
    }else{
          [myScrollView setContentOffset:CGPointZero animated:YES];
    }
    
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

@end
