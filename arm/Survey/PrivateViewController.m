//
//  PrivateViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "PrivateViewController.h"
#import "FMDatabase.h"
#import "Survey.h"
#import "DivisionViewController.h"
#import "SelectEnterpriseViewController.h"

@interface PrivateViewController ()

@end

@implementation PrivateViewController

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
    
    //ナビゲーションバー表示
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self selectprivate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self selectprivate];
    
    //tableviewのデータを再読み込み
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //配列の数を返す
    return [mSurvey count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Cellをセットする
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //団体選択画面へ遷移
    SelectEnterpriseViewController *selectEnterpriseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectenterprise"];
    selectEnterpriseViewController.survey = [mSurvey objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:selectEnterpriseViewController animated:YES];
}

- (IBAction)back:(id)sender {
    //質問区分選択画面へ遷移
    DivisionViewController *divisionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DivisionView"];
    [self presentViewController:divisionViewController animated:YES completion:nil];
}

- (void)selectprivate{
    //タイトルをセット
    self.title = @"民間アンケート";
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
    
    //区分が民間のアンケートを選択
    NSString*   sql = @"SELECT * FROM Survey WHERE sur_division = \"民間\";";
    FMResultSet*    rs = [db executeQuery:sql];
    //配列の初期化
    mSurvey= [[NSMutableArray alloc] init];
    while( [rs next] )
    {
        //Surveyクラスのインスタンス生成
        Survey * survey = [[Survey alloc] init];
        //インスタンスに値をセット
        survey.sur_id = [rs stringForColumn:@"sur_id"];
        survey.sur_name = [rs stringForColumn:@"sur_name"];
        survey.sur_division = [rs stringForColumn:@"sur_division"];
        //配列にインスタンスを挿入
        [mSurvey addObject:survey];
    }
    
    //DB終了
    [rs close];
    [db close];
}
@end
