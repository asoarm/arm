//
//  MasterTableViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "AdministrationMasterTableViewController.h"
#import "Enterprise.h"
#import "FMDatabase.h"
#import "SectionViewController.h"
#import "MainViewController.h"

@interface AdministrationMasterTableViewController ()

@end

@implementation AdministrationMasterTableViewController

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
    division = @"行政";
    [self button];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self.navigationItem setHidesBackButton:YES];
    //戻るボタン非表示
    self.title = @"団体一覧";
    
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
    
    //課格納
    NSString*   sql = @"SELECT * FROM Enterprise WHERE division = \"行政\";";
    FMResultSet*    rs = [db executeQuery:sql];
    mEnterprise = [[NSMutableArray alloc] init];
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
    return [mEnterprise count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    //詳細へ遷移
    SectionViewController *sectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sectionViewController"];
    sectionViewController.enterprise= [mEnterprise objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:sectionViewController animated:YES];
}
- (void)button{
    UIBarButtonItem* view_btn = [[UIBarButtonItem alloc]
                                    initWithTitle:@"登録"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(registration)];
    self.navigationItem.rightBarButtonItems = @[view_btn];
}
-(void)registration{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"団体名を入力して下さい"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"登録", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            //NULL判定
            if (!([[alertView textFieldAtIndex:0].text isEqualToString:@""])){
                //DB設定
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
                
                // NSUserDefaultsからデータを読み込む
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  // 取得
                int i = [defaults integerForKey:@"KEY_I"];  // KEY_Iの内容をint型として取得
                
                //同じ名前の会社がない場合
                NSString* sqlname = [NSString stringWithFormat:@"select * from Enterprise where e_name = \"%@\";",[alertView textFieldAtIndex:0].text];
                FMResultSet* rsname = [db executeQuery:sqlname];
                NSString *strname;
                while( [rsname next] )
                {
                    strname = [rsname stringForColumn:@"e_id"];
                }
                [rsname close];
                
                if (strname == nil || [strname isEqual:@""]) {
                    
                    NSString* sql2 = [NSString stringWithFormat:@"INSERT INTO Enterprise VALUES(\"E%d\",\"%@\",\"%@\");",i,[alertView textFieldAtIndex:0].text,division];
                    
                    [db executeUpdate:sql2];
                    
                    i = i + 1;
                    
                    // NSUserDefaultsに保存する
                    [defaults setInteger:i forKey:@"KEY_I"];
                    // 設定を保存
                    [defaults synchronize];
                }else{
                    NSString *body = @"その団体名はすでに登録済みです";
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];

                }
                [self viewWillAppear:YES];
            }else{
                NSString *body = @"団体名を入力してください";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        default:
            break;
    }
}
- (IBAction)back:(id)sender {
    MainViewController *divisionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterpriseDivisionView"];
    [self presentViewController:divisionViewController animated:YES completion:nil];
}
@end
