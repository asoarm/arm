//
//  SelectSectionViewController.m
//  arm
//
//  Created by Owner on 2013/12/30.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "SelectSectionViewController.h"
#import "Enterprise.h"
#import "FMDatabase.h"
#import "MainViewController.h"
#import "StartViewController.h"
#import "Survey.h"
#import "Enterprise.h"
#import "ImportTable.h"
#import "SVProgressHUD.h"

@interface SelectSectionViewController ()

@end

@implementation SelectSectionViewController
@synthesize survey;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //タイトルをセット
    self.title = @"課一覧";
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
    //選択した団体の課を選択
    NSString*   sql = [NSString stringWithFormat : @"SELECT * FROM Section WHERE e_id = \"%@\";",enterprise.e_id];
    FMResultSet*    rs = [db executeQuery:sql];
    //配列の初期化
    mEnterprise= [[NSMutableArray alloc] init];
    while( [rs next] )
    {
        //Enterpriseクラスのインスタンス生成
        Enterprise *enter = [[Enterprise alloc] init];
        //インスタンスに値をセット
        enter.division = enterprise.division;
        enter.e_id = enterprise.e_id;
        enter.e_name = enterprise.e_name;
        enter.sec_id = [rs stringForColumn:@"sec_id"];
        enter.sec_name = [rs stringForColumn:@"sec_name"];
        //配列にインスタンスを挿入
        [mEnterprise addObject:enter];
    }
    
    //Temporaryテーブル初期化
    NSString *dltsql = @"DELETE from Temporary;";
    [db executeUpdate:dltsql];
    
    //DB終了
    [rs close];
    [db close];
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
    return [mEnterprise count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //セルをセット
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    Enterprise *Enter = [mEnterprise objectAtIndex:indexPath.row];
    cell.textLabel.text = Enter.sec_name;
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
    enterprise = [mEnterprise objectAtIndex:indexPath.row];
    
    //現在日付を取得
    NSDate *nowdate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *datemoji = [formatter stringFromDate:nowdate];
    
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

    //くるくる表示
    [SVProgressHUD showWithMaskType: SVProgressHUDMaskTypeBlack];
    
    //日付が同じ回答がサーバーにある場合Temporaryテーブルへ入れる
    ImportTable *importtable = [ImportTable alloc];
    NSString* setflg1 = [importtable importTemporary:db and:survey.sur_id and:enterprise.e_id and:enterprise.sec_id and:datemoji];
    
    //DB終了
    [db close];

    //くるくる非表示
    [SVProgressHUD dismiss];
    
    if([setflg1 isEqualToString:@"NetworkError"]){
        UIAlertView *alertView =
        [[UIAlertView alloc]
         initWithTitle:@"ネットワークエラーが発生しました" message:@"ネットワークに接続できません\nネットワークの接続を確認して再試行してください" delegate:self
         cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [alertView show];
        
        return;
    }
    
    if([setflg1 isEqualToString:@"Error"]){
        UIAlertView *alertView =
        [[UIAlertView alloc]
         initWithTitle:@"エラーが発生しました" message:@"原因不明のエラー" delegate:self
         cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [alertView show];
        
        return;
    }
    
    //Start画面へ遷移
    StartViewController *startViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Start"];
    startViewController.enterprise = [mEnterprise objectAtIndex:indexPath.row];
    startViewController.survey = survey;
    [self.navigationController pushViewController:startViewController animated:YES];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            break;
        case 1:
            break;
    }
}
@end
