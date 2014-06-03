//
//  SectionlViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "SectionViewController.h"
#import "FMDatabase.h"
#import "Section.h"

@interface SectionViewController ()

@end

@implementation SectionViewController
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
    self.title = @"課一覧";
    
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
    NSString*   sql = [ NSString stringWithFormat :@"SELECT * FROM Section Where e_id = \"%@\";",enterprise.e_id];
    FMResultSet*    rs = [db executeQuery:sql];
    mSec = [[NSMutableArray alloc] init];
    while( [rs next] )
    {
        Section *section = [[Section alloc] init];
        section.e_id = [rs stringForColumn:@"e_id"];
        section.sec_id = [rs stringForColumn:@"sec_id"];
        section.sec_name = [rs stringForColumn:@"sec_name"];
        [mSec addObject:section];
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
    return [mSec count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    Section *section = [mSec objectAtIndex:indexPath.row];
    cell.textLabel.text = section.sec_name;
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
- (void)button{
    UIBarButtonItem* view_btn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"登録"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(registration)];
    self.navigationItem.rightBarButtonItems = @[view_btn];
}
-(void)registration{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"課名を入力して下さい"
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
            if (!([[alertView textFieldAtIndex:0].text isEqualToString:@""])){
                NSLog(@"%@",[alertView textFieldAtIndex:0].text);
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
                //指定したe_idでsectionをセレクト
                NSString*   sql3 = [NSString stringWithFormat:@"select * from Section where e_id = \"%@\" order by e_id,sec_id;",enterprise.e_id];
                
                FMResultSet* rs2 = [db executeQuery:sql3];
                
                NSString *str2;
                while( [rs2 next] )
                {
                    str2 = [rs2 stringForColumn:@"sec_id"];
                }
                
                [rs2 close];
                
                
                if(!([str2 isEqual:@""]) && !(str2 == nil)){
                    //既に課コードが入っていた場合
                    NSString* sqlsec = [NSString stringWithFormat:@"SELECT * FROM Section WHERE e_id = \"%@\" and sec_name = \"%@\";",enterprise.e_id,[alertView textFieldAtIndex:0].text];
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
                        
                        NSString* sql4 = [NSString stringWithFormat:@"INSERT INTO Section VALUES(\"%@\",\"SEC%d\",\"%@\");",enterprise.e_id,iS,[alertView textFieldAtIndex:0].text];
                        
                        [db executeUpdate:sql4];
                    }else{
                        NSString *body = @"その課名はすでに登録済みです";
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                }else{
                    //入っていなかった場合
                    NSString* sql4 = [NSString stringWithFormat:@"INSERT INTO Section VALUES(\"%@\",\"SEC101\",\"%@\");",enterprise.e_id,[alertView textFieldAtIndex:0].text];
                    
                    [db executeUpdate:sql4];
                }
                
                [db close];
                
                [self viewWillAppear:YES];
                    
            }
            else{
                NSString *body = @"課名を入力してください";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:body delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            break;

         default:
            break;
    }
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

@end
