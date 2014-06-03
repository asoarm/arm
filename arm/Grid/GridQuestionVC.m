//
//  GridQuestionVC.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "GridQuestionVC.h"
#import "FMDatabase.h"
#import "Question.h"
#import "GridTableV.h"

@interface GridQuestionVC ()

@end

@implementation GridQuestionVC
@synthesize sur_id;
@synthesize e_id;
@synthesize question;

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
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"質問一覧";
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
    
    FMResultSet*    rs = [db executeQuery:@"select distinct q.q_id ,q.q_name from QuestionDetail qd,Question q where qd.sur_id = ? and qd.q_id = q.q_id;",sur_id];
    
    question = [[NSMutableArray alloc] init];
    while( [rs next] )
    {
        Question *qd  = [[Question alloc] init];
        qd.q_id = [rs stringForColumn:@"q_id"];
        qd.q_name = [rs stringForColumn:@"q_name"];
        [question addObject:qd];
    }

    [rs close];
    
    
    [db close];
    
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [question count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    Question *text = [question objectAtIndex:indexPath.row];
    cell.textLabel.text = text.q_name;
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
    GridTableV *grid = [self.storyboard instantiateViewControllerWithIdentifier:@"Grid"];
    grid.sur_id = sur_id;
    grid.e_id = e_id;
    Question *que = [question objectAtIndex:indexPath.row];
    grid.q_id = que.q_id;
    grid.q_name = que.q_name;
    int k = 0;
    grid.datak = k;
    [self.navigationController pushViewController: grid animated:YES];
}
@end
