//
//  QuestionVC.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "QuestionVC.h"
#import "FMDatabase.h"
#import "PieChartsViewController.h"

@interface QuestionVC ()

@end

@implementation QuestionVC
@synthesize questiondetail;
@synthesize enterprise;
@synthesize survey;
@synthesize choice1;
@synthesize choice2;
@synthesize choice3;
@synthesize choice4;
@synthesize choice5;
@synthesize choice6;
@synthesize cho_flg;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"質問一覧";
    
    choice1 = 0;
    choice2 = 0;
    choice3 = 0;
    choice4 = 0;
    choice5 = 0;
    choice6 = 0;
    [self selectQuestionDetail];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //セクション数
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //行数
    return [mQD count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //配列から値を習得し、セルのラベルに設定
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    QuestionDetail *qd = [mQD objectAtIndex:indexPath.row];
    cell.textLabel.text = qd.qd_name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexpath{
    //セルの大きさ
    return 100;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //セルをタップした処理
    questiondetail = [mQD objectAtIndex:indexPath.row];
    [self cho];

    PieChartsViewController *pcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Display"];
    pcVC.questiondetail = questiondetail;
    pcVC.enterprise = enterprise;
    pcVC.choice1 = choice1;
    pcVC.choice2 = choice2;
    pcVC.choice3 = choice3;
    pcVC.choice4 = choice4;
    pcVC.choice5 = choice5;
    pcVC.choice6 = choice6;
    pcVC.cho_flg = cho_flg;
    [self.navigationController pushViewController:pcVC animated:YES];
}

-(void)selectQuestionDetail{
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
    
    FMResultSet*    rs = [db executeQuery:@"select * from QuestionDetail where sur_id = ? and cho_kubun = \"cho\" order by q_id,qd_id;",survey.sur_id];
    
    FMResultSet*    qc = [db executeQuery:@"select count(q_id) as q_count from Question;"];
    //mQDは選んだアンケートの質問情報を入れる
    //mq_countは設問数が入れる
    mQD= [[NSMutableArray alloc] init];
    mq_count  = [[NSMutableArray alloc] init];
    while( [rs next] )
    {
        QuestionDetail *qd  = [[QuestionDetail alloc] init];
        qd.sur_id = [rs stringForColumn:@"sur_id"];
        qd.q_id = [rs stringForColumn:@"q_id"];
        qd.qd_id = [rs stringForColumn:@"qd_id"];
        qd.qd_name = [rs stringForColumn:@"qd_name"];
        qd.cho_kubun = [rs stringForColumn:@"cho_kubun"];
        qd.cho_id = [rs stringForColumn:@"cho_id"];
        [mQD addObject:qd];
    }while ([qc next]){
        q_count *QC = [[q_count alloc] init];
        QC.q_cnt = [[qc stringForColumn:@"q_count"] intValue];
        [mq_count addObject:QC];
    }
    [qc close];
    [rs close];
    
    
    [db close];

}

-(void)cho{
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
    cho_flg = [[NSMutableArray alloc] init];
    FMResultSet* rs = [db executeQuery: @"select * from QuestionDetail q,Choice c where q.sur_id = ? and q.q_id = ? and q.qd_id = ? and q.cho_id = c.cho_id;",survey.sur_id,questiondetail.q_id,questiondetail.qd_id];
    while( [rs next] )
    {
        NSString *choice1_name = @"";
        NSString *choice2_name = @"";
        NSString *choice3_name = @"";
        NSString *choice4_name = @"";
        NSString *choice5_name = @"";
        NSString *choice6_name = @"";
        if(!([rs stringForColumn:@"choice1"] == nil)){
        choice1_name = [rs stringForColumn:@"choice1"];
        }
        if(!([rs stringForColumn:@"choice2"] == nil)){
        choice2_name =[rs stringForColumn:@"choice2"];
        }
        if (!([rs stringForColumn:@"choice3"] == nil)){
        choice3_name = [rs stringForColumn:@"choice3"];
        }
        if(!([rs stringForColumn:@"choice4"] == nil)){
        choice4_name = [rs stringForColumn:@"choice4"];
        }
        if(!([rs stringForColumn:@"choice5"] == nil)){
        choice5_name = [rs stringForColumn:@"choice5"];
        }
        if(!([rs stringForColumn:@"choice6"] == nil)){
        choice6_name = [rs stringForColumn:@"choice6"];
        }
        [cho_flg addObject:choice1_name];
        [cho_flg addObject:choice2_name];
        [cho_flg addObject:choice3_name];
        [cho_flg addObject:choice4_name];
        [cho_flg addObject:choice5_name];
        [cho_flg addObject:choice6_name];
    }
    [rs close];
    
    FMResultSet*  rschoice1 = [db executeQuery:@"select count(ans_cho)as count from Answer where sur_id = ? and e_id = ? and q_id = ? and qd_id = ? and ans_cho = ? group by ans_cho;",survey.sur_id,enterprise.e_id,questiondetail.q_id,questiondetail.qd_id,cho_flg[0]];
    while( [rschoice1 next] )
    {
        NSString *choice1_count = [rschoice1 stringForColumn:@"count"];
        choice1= [choice1_count intValue];
    }
    [rschoice1 close];
    
    FMResultSet*  rschoice2 = [db executeQuery:@"select count(ans_cho)as count from Answer where sur_id = ? and e_id = ? and q_id = ? and qd_id = ? and ans_cho = ? group by ans_cho;",survey.sur_id,enterprise.e_id,questiondetail.q_id,questiondetail.qd_id,cho_flg[1]];
    while( [rschoice2 next] )
    {
        NSString *choice2_count = [rschoice2 stringForColumn:@"count"];
        choice2= [choice2_count intValue];
    }
    [rschoice2 close];
    
    FMResultSet*  rschoice3 = [db executeQuery:@"select count(ans_cho)as count from Answer where sur_id = ? and e_id = ? and q_id = ? and qd_id = ? and ans_cho = ? group by ans_cho;",survey.sur_id,enterprise.e_id,questiondetail.q_id,questiondetail.qd_id,cho_flg[2]];
    while( [rschoice3 next] )
    {
        NSString *choice3_count = [rschoice3 stringForColumn:@"count"];
        choice3= [choice3_count intValue];
    }
    [rschoice3 close];
    
    FMResultSet*  rschoice4 = [db executeQuery:@"select count(ans_cho)as count from Answer where sur_id = ? and e_id = ? and q_id = ? and qd_id = ? and ans_cho = ? group by ans_cho;",survey.sur_id,enterprise.e_id,questiondetail.q_id,questiondetail.qd_id,cho_flg[3]];
    while( [rschoice4 next] )
    {
        NSString *choice4_count = [rschoice4 stringForColumn:@"count"];
        choice4= [choice4_count intValue];
    }
    [rschoice4 close];
    
    FMResultSet*  rschoice5 = [db executeQuery:@"select count(ans_cho)as count from Answer where sur_id = ? and e_id = ? and q_id = ? and qd_id = ? and ans_cho = ? group by ans_cho;",survey.sur_id,enterprise.e_id,questiondetail.q_id,questiondetail.qd_id,cho_flg[4]];
    while( [rschoice5 next] )
    {
        NSString *choice5_count = [rschoice5 stringForColumn:@"count"];
        choice5= [choice5_count intValue];
    }
    [rschoice5 close];
    
    FMResultSet*  rschoice6 = [db executeQuery:@"select count(ans_cho)as count from Answer where sur_id = ? and e_id = ? and q_id = ? and qd_id = ? and ans_cho = ? group by ans_cho;",survey.sur_id,enterprise.e_id,questiondetail.q_id,questiondetail.qd_id,cho_flg[5]];
    while( [rschoice6 next] )
    {
        NSString *choice6_count = [rschoice6 stringForColumn:@"count"];
        choice6= [choice6_count intValue];
    }
    [rschoice6 close];
    
    [db close];
}

@end
