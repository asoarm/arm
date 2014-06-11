//
//  DivisionViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "DivisionViewController.h"
#import "FMDatabase.h"

@interface DivisionViewController ()

@end

@implementation DivisionViewController

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
    //ナビゲーションバー非表示
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	// Do any additional setup after loading the view.
    
    [self temporary];
}

- (void)viewWillAppear:(BOOL)animated
{
    //ナビゲーションバー非表示
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu:(id)sender {
    //メニュー画面へ遷移する
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)temporary{
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
    //Temporaryのデータを空にする
    NSString*   delete = @"DELETE FROM Temporary";
    [db executeUpdate:delete];
    [db close];
}
@end
