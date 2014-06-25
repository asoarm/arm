//
//  PieChartsViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "PieChartsViewController.h"
#import "CommentVC.h"
#import "ViewSquare.h"
#import "PieChartsView.h"
#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"

@interface PieChartsViewController ()
@end

@implementation PieChartsViewController
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
@synthesize comment_value;
@synthesize memo;
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
    [super viewDidLoad];

    //-(void)showpieを実行
    [self setcho_name];
    
    [self showpie];
    //-(void)labelを実行
    [self label];
    
    [self button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [self interviewmemo];
    
    [self comment_show];

}

- (void)setcho_name{
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


- (void)showpie{
    //円グラフを表示
    PieChartsView *pieChartsView = [[PieChartsView alloc] initWithFrame:self.view.bounds];
    pieChartsView.choice1 = choice1;
    pieChartsView.choice2 = choice2;
    pieChartsView.choice3 = choice3;
    pieChartsView.choice4 = choice4;
    pieChartsView.choice5 = choice5;
    pieChartsView.choice6 = choice6;
    [self.view addSubview:pieChartsView];
    [self.view sendSubviewToBack:pieChartsView];
    
    //四角系を表示
    ViewSquare *viewSquare =[[ViewSquare alloc] initWithFrame :self.view.bounds];
    [self.view addSubview:viewSquare];
    [self.view sendSubviewToBack:viewSquare];
    
    //commentlabelの角丸を設定
    _commentlabel.layer.cornerRadius = 10.0;
    
    //commentの枠線を設定
    comment.layer.borderWidth = 1.0;
    comment.layer.borderColor = [UIColor grayColor].CGColor;
    
    //interviewlabelの角丸を設定
    _interviewlabel.layer.cornerRadius = 10.0;
    
    //border2の枠線を設定
    _interview.layer.borderWidth = 1.0;
    _interview.layer.borderColor = [UIColor grayColor].CGColor;
    
}
- (void)label{
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
    [self.view addSubview:label1];
    }
    
    if(![cho_flg[1]isEqualToString:@""]) {
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(550,261,400,30)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.textColor = [UIColor redColor];
    label2.font = [UIFont fontWithName:@"AppleGothic" size:20];
    label2.text = [ NSString stringWithFormat : @"%@　%d％",choice2_name,cho2per];
    [self.view addSubview:label2];
    }
    
    if(![cho_flg[2]isEqualToString:@""]){
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(550,301,400,30)];
    label3.backgroundColor = [UIColor whiteColor];
    label3.textColor = [UIColor colorWithRed:0.133 green:0.545 blue:0.133 alpha:1.0];
    label3.font = [UIFont fontWithName:@"AppleGothic" size:20];
    label3.text = [ NSString stringWithFormat : @"%@　%d％",choice3_name, cho3per];
    [self.view addSubview:label3];
    }
    
    if(![cho_flg[3]isEqualToString:@""]) {
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(550,341,400,30)];
    label4.backgroundColor = [UIColor whiteColor];
    label4.textColor = [UIColor orangeColor];
    label4.font = [UIFont fontWithName:@"AppleGothic" size:20];
    label4.text = [ NSString stringWithFormat : @"%@　%d％",choice4_name, cho4per];
    [self.view addSubview:label4];
    }
    
    if(![cho_flg[4]isEqualToString:@""]) {
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(550,381,400,30)];
    label5.backgroundColor = [UIColor whiteColor];
    label5.textColor = [UIColor colorWithRed:0.118 green:0.565 blue:1.0 alpha:1.0];
    label5.font = [UIFont fontWithName:@"AppleGothic" size:20];
    label5.text = [ NSString stringWithFormat : @"%@　%d％",choice5_name, cho5per];
    [self.view addSubview:label5];
    }
    
    if(![cho_flg[5]isEqualToString:@""]) {
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(550,421,400,30)];
    label6.backgroundColor = [UIColor whiteColor];
    label6.textColor = [UIColor magentaColor];
    label6.font = [UIFont fontWithName:@"AppleGothic" size:20];
    label6.text = [ NSString stringWithFormat : @"%@ %d％",choice6_name, cho6per];
    [self.view addSubview:label6];
    }
}
- (void)interviewmemo
{
    //インタビューメモ表示処理
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
    
    FMResultSet*    sql1 = [db executeQuery:@"select memo from Answer where sur_id=? and q_id=? and qd_id=? and e_id=? and not memo=\"\";",questiondetail.sur_id,questiondetail.q_id,questiondetail.qd_id,enterprise.e_id];
    //interviewmemoはインタビューメモを表示するための変数
    NSString *interviewmemo = [[NSString alloc] init];
    int i = 0;
    while( [sql1 next] )
    {
        memo = [sql1 stringForColumn:@"memo"];
        if( memo == nil || ([memo isEqualToString:@""]) || [memo isEqual:[NSNull null]] ){
            //nullのときの処理
        }else{
            if(i==0){
                interviewmemo = memo;
            }else{
            interviewmemo = [NSString stringWithFormat:@"%@\n\n%@",interviewmemo,memo];
            }
        }
        i += 1;
    }
    [sql1 close];
    
    _interview.text = interviewmemo;
    
    [db close];
    
}

- (void)comment_show
{
    //コメント表示処理
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
    FMResultSet*    sql2 = [db executeQuery:@"select comment from Comment where sur_id=? and q_id=? and qd_id=? and e_id=?;",questiondetail.sur_id,questiondetail.q_id,questiondetail.qd_id,enterprise.e_id];
    while( [sql2 next] )
    {
        comment_value = [sql2 stringForColumn:@"comment"];
    }
    [sql2 close];
    comment.text = comment_value;
    
    [db close];
    
}

- (void)button{
    //コメントボタンの処理
    UIBarButtonItem* comment_btn = [[UIBarButtonItem alloc]
                               initWithTitle:@"コメント入力"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(cmt)];
    self.navigationItem.rightBarButtonItems = @[comment_btn];
}
-(void)cmt{
    //コメントボタンをタップした処理
    CommentVC *cmt = [self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
    cmt.enterprise = enterprise;
    cmt.questiondetail = questiondetail;
    cmt.enterprise = enterprise;
    cmt.choice1 = choice1;
    cmt.choice2 = choice2;
    cmt.choice3 = choice3;
    cmt.choice4 = choice4;
    cmt.choice5 = choice5;
    cmt.choice6 = choice6;
    cmt.cho_flg = cho_flg;
    [self.navigationController pushViewController: cmt animated:YES];
}
@end
