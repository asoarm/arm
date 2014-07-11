//
//  PrivateEnterpriseViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "PrivateEnterpriseViewController.h"
#import "FMDatabase.h"
#import "DivisionViewController.h"
#import "Enterprise.h"
#import "SurveyVC.h"
#import "ImportTable.h"

@interface PrivateEnterpriseViewController ()

@end

@implementation PrivateEnterpriseViewController

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //団体区分が民間の団体をDBから取り出す処理
    self.title = @"団体一覧";
    [self selectEnterprise];
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // セクション数
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //行数
    return [mEnterprise count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //配列から値を習得し、セルのラベルに設定
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    Enterprise *enterprise = [mEnterprise objectAtIndex:indexPath.row];
    cell.textLabel.text = enterprise.e_name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexpath
{
    //セルの大きさ
    return 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Enterprise *enterprise = [mEnterprise objectAtIndex:indexPath.row];
    
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
    NSString *sql = @"DELETE from Answer;";
    [db executeUpdate:sql];
    
    ImportTable *importtable = [ImportTable alloc];
    
    [importtable importAnswer:db and:enterprise.e_id];
    
    [db close];
    
    //セルをタップした処理
    SurveyVC *surveyvc = [self.storyboard instantiateViewControllerWithIdentifier:@"surveyV"];
    surveyvc.title = @"民間アンケート";
    surveyvc.enterprise= enterprise;
    [self.navigationController pushViewController:surveyvc  animated:YES];
}

-(void)selectEnterprise{
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
    
    NSString*   sql = @"SELECT * FROM Enterprise WHERE division = \"民間\";";
    FMResultSet*    rs = [db executeQuery:sql];
    mEnterprise= [[NSMutableArray alloc] init];
    while( [rs next] )
    {
        Enterprise * enterprise = [[Enterprise alloc] init];
        enterprise.division = [rs stringForColumn:@"division"];
        enterprise.e_id = [rs stringForColumn:@"e_id"];
        enterprise.e_name = [rs stringForColumn:@"e_name"];
        [mEnterprise addObject:enterprise];
    }
    
    [rs close];
    [db close];

}

- (IBAction)back:(id)sender {
    //バックボタンの処理
    DivisionViewController *divisionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SyukeiDivisionView"];
    [self presentViewController:divisionViewController animated:YES completion:nil];
}
@end
