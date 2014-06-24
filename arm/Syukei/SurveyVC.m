//
//  SurveyVC.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "SurveyVC.h"
#import "FMDatabase.h"
#import "mgVC.h"

@interface SurveyVC ()

@end

@implementation SurveyVC
@synthesize enterprise;

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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"アンケート一覧";
    
    [self selectSurvey];
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //セクション数
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //行数
    return [mSurvey count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //配列から値を習得し、セルのラベルに設定
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    Survey *survey = [mSurvey objectAtIndex:indexPath.row];
    cell.textLabel.text = survey.sur_name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexpath
{
    //セルの大きさ
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //セルをタップした処理
    mgVC *mgvc = [self.storyboard instantiateViewControllerWithIdentifier:@"mg"];
    mgvc.survey= [mSurvey objectAtIndex:indexPath.row];
    mgvc.enterprise = enterprise;
    [self.navigationController pushViewController: mgvc animated:YES];
}
-(void)selectSurvey{
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
    
    FMResultSet*    rs = [db executeQuery:@"select S.sur_id,S.sur_name from Answer A,Survey S where A.sur_id = S.sur_id and A.e_id = ? group by S.sur_id;",enterprise.e_id ];
    //mSurveyは企業に実施したアンケート情報（アンケートID,アンケート名）を入れる
    mSurvey= [[NSMutableArray alloc] init];
    while( [rs next] )
    {
        Survey * answer = [[Survey alloc] init];
        answer.sur_id = [rs stringForColumn:@"sur_id"];
        answer.sur_name = [rs stringForColumn:@"sur_name"];
        [mSurvey addObject:answer];
    }
    
    [rs close];
    [db close];

}

@end
