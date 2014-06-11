//
//  GridTableV.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDatabase.h"
#import "GridTableV.h"
#import "GridColumn.h"
#import "User.h"
#import "Question.h"


@interface GridTableV () <UITableViewDataSource, UITableViewDelegate> {
}
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UIView *headerView;

@end

@implementation GridTableV
@synthesize sqldata;
@synthesize cols;
@synthesize cols2;
@synthesize qd_name;
@synthesize qd_id;
@synthesize sur_id;
@synthesize record;
@synthesize q_id;
@synthesize q_name;
@synthesize e_id;
@synthesize omidashi_wid;
@synthesize komidashi_ans_wid;
@synthesize komidashi_memo_wid;
@synthesize heightmax;
@synthesize height_cell;
@synthesize columnsuu;
@synthesize omidashi_i;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
		UITableView *tableView = [[UITableView alloc] init];
		self.tableView = tableView;
		tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		tableView.delegate = self;
		tableView.dataSource = self;
		
		UIView *headerView = [[UIView alloc] init];
		self.headerView = headerView;
    }
    return self;
}

/**
 * 参照カウンタが0になってクラスのインスタンスが解放される直前に実行される。
 *初期化メソッドやセッターメソッドで確保したオブジェクトの所有権は、ここでまとめて解放する処理。
 **/
- (void) dealloc {
	self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self data];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = q_name;

    [self column];
    [self width];
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UIView *headerView = [[UIView alloc] init];
    self.headerView = headerView;
    
    [self grid];
	
	self.view.backgroundColor = [UIColor whiteColor];
    
	[self makeHeaderView];
	
	CGRect tableFrame = CGRectMake(0,self.headerView.frame.size.height,self.view.bounds.size.width,self.view.bounds.size.height-108);
    tableFrame.origin.y += 65;
	self.tableView.frame = tableFrame;
	[self.view addSubview:self.tableView];
	
	// セパレータ for tableView
	UIView *bgView = [[UIView alloc] initWithFrame:self.tableView.frame];
	bgView.backgroundColor = [UIColor whiteColor];
	self.tableView.backgroundView = bgView;
	
	for (int i = 0; i < [self.cols count]; i++) {
		float right = [self leftPositionOfColomnNumber:i+1];
		
		UIView *tableSeparator = [[UIView alloc] initWithFrame:CGRectMake(right,0,1,self.tableView.bounds.size.height)];
		tableSeparator.backgroundColor = [UIColor lightGrayColor];
		[self.tableView.backgroundView addSubview:tableSeparator];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)width{
    float int1 = 879;float int2 = 439;float int3 = 293;
    float int4 = 219.75;float int5 = 175.8;
    NSMutableArray *width = [[NSMutableArray alloc] init];
    [width addObject:[NSNumber numberWithFloat:int1]];
    [width addObject:[NSNumber numberWithFloat:int2]];
    [width addObject:[NSNumber numberWithFloat:int3]];
    [width addObject:[NSNumber numberWithFloat:int4]];
    [width addObject:[NSNumber numberWithFloat:int5]];
    float answer1 = 263.7;float answer2 = 131.85;float answer3 = 87.9;
    float answer4 = 65.925;float answer5 = 52.74;
    NSMutableArray *width1 = [[NSMutableArray alloc] init];
    [width1 addObject:[NSNumber numberWithFloat:answer1]];
    [width1 addObject:[NSNumber numberWithFloat:answer2]];
    [width1 addObject:[NSNumber numberWithFloat:answer3]];
    [width1 addObject:[NSNumber numberWithFloat:answer4]];
    [width1 addObject:[NSNumber numberWithFloat:answer5]];
    float memo1 = 615.3;float memo2 = 307.65;float memo3 = 205.1;
    float memo4 = 153.825;float memo5 = 123.06;
    NSMutableArray *width2 = [[NSMutableArray alloc] init];
    [width2 addObject:[NSNumber numberWithFloat:memo1]];
    [width2 addObject:[NSNumber numberWithFloat:memo2]];
    [width2 addObject:[NSNumber numberWithFloat:memo3]];
    [width2 addObject:[NSNumber numberWithFloat:memo4]];
    [width2 addObject:[NSNumber numberWithFloat:memo5]];
    omidashi_i = 0;
    if([qd_id count]-columnsuu >=3){
        omidashi_i = 3;
    }else if([qd_id count]-columnsuu == 2){
        omidashi_i = 2;
    }else if([qd_id count]-columnsuu == 1){
        omidashi_i = 1;
    }
    omidashi_wid = [[width objectAtIndex:omidashi_i-1] floatValue];
    komidashi_ans_wid = [[width1 objectAtIndex:omidashi_i-1] floatValue];
    komidashi_memo_wid = [[width2 objectAtIndex:omidashi_i-1] floatValue];
}

-(BOOL) grid{
    //GridColumnオブジェクト=列情報を定義
	NSMutableArray *cols1 = [[NSMutableArray alloc] init];
    [cols1 addObject:[[GridColumn alloc] initWithPropertyName:@"no" headerText:@"NO." width:45]];
    [cols1 addObject:[[GridColumn alloc] initWithPropertyName:@"sec_name" headerText:@"      所属課" width:100]];
    for (int i = 0; i < [qd_id count]; i++) {
        [cols1 addObject:[[GridColumn alloc] initWithPropertyName:@"" headerText:[qd_name objectAtIndex:i] width:omidashi_wid]];
    }
    NSMutableArray *cols3 = [[NSMutableArray alloc] init];
    [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"no" headerText:@"" width:45]];
	[cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"sec_name" headerText:@"" width:100]];
    [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"answer1" headerText:@"回答" width:komidashi_ans_wid]];
    [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"memo1" headerText:@"インタビューメモ" width:komidashi_memo_wid]];
    if([qd_id count] > 1){
        [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"answer2" headerText:@"回答" width:komidashi_ans_wid]];
        [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"memo2" headerText:@"インタビューメモ" width:komidashi_memo_wid]];
        if([qd_id count] > 2){
            [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"answer3" headerText:@"回答" width:komidashi_ans_wid]];
            [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"memo3" headerText:@"インタビューメモ" width:komidashi_memo_wid]];
            if([qd_id count] > 3){
                [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"answer4" headerText:@"回答" width:komidashi_ans_wid]];
                [cols3 addObject:[[GridColumn alloc] initWithPropertyName:@"memo4" headerText:@"インタビューメモ" width:komidashi_memo_wid]];
                            }
        }
    }

	cols = cols1;
    cols2 = cols3;
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *row = [sqldata objectAtIndex:indexPath.row];
    heightmax = 50;
	for (int i = 0; i < [self.cols2 count]; i++) {
		GridColumn *col = [self.cols2 objectAtIndex:i];
        NSObject *val = [row performSelector:NSSelectorFromString(col.propertyName)];
		
		float left = [self leftPositionOfColomnNumber1:i];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left+10,5,col.width-10,0)];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:14];
		label.textColor = [UIColor darkGrayColor];
        label.numberOfLines  = 0;
		
		if (col.textRenderer != nil) {
			label.text = col.textRenderer(val);
		} else {
			label.text = [NSString stringWithFormat:@"%@", val];
            if ( [label.text isEqualToString:@"<null>"]){
                label.text = @"----";
            }
		}
		
		if (col.labelRenderer != nil) {
			col.labelRenderer(label, val);
		}
        [label sizeToFit];
        int height = label.frame.size.height;
        
        if(heightmax < height){
            heightmax = height;
        }

	}
    if(indexPath.row == 0){
        height_cell = [[NSMutableArray alloc] init];
    }
    [height_cell addObject:[NSNumber numberWithFloat:heightmax+5]];

    return [[height_cell objectAtIndex:indexPath.row] floatValue];
}

- (int) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [sqldata count];
}
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellId = [NSString stringWithFormat:@"GridViewCell:%d", indexPath.section];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
		UITableViewCellStyle style = UITableViewCellStyleDefault;
		cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:cellId];
        
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	// 前回のビューを削除
	for (UIView *view in cell.contentView.subviews) {
		[view removeFromSuperview];
	}
	if (self.rowRenderer != nil) {
		self.rowRenderer(cell, indexPath.row);
	}
	
	NSObject *row = [sqldata objectAtIndex:indexPath.row];
	for (int i = 0; i < [self.cols2 count]; i++) {
		GridColumn *col = [self.cols2 objectAtIndex:i];
        NSObject *val = [row performSelector:NSSelectorFromString(col.propertyName)];
		
		float left = [self leftPositionOfColomnNumber1:i];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left+10,5,col.width-10,0)];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:14];
		label.textColor = [UIColor darkGrayColor];
        label.numberOfLines  = 0;
		
		if (col.textRenderer != nil) {
			label.text = col.textRenderer(val);
		} else {
			label.text = [NSString stringWithFormat:@"%@", val];
            if ( [label.text isEqualToString:@"<null>"]){
                 label.text = @"----";
            }
		}
		if (col.labelRenderer != nil) {
			col.labelRenderer(label, val);
		}
        [label sizeToFit];

		[cell.contentView addSubview:label];
		
		// セパレータ
		float right = [self leftPositionOfColomnNumber1:i+1];
		UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(right,0,1,[[height_cell objectAtIndex:indexPath.row] floatValue])];
		separator.backgroundColor = [UIColor lightGrayColor];
		[cell.contentView addSubview:separator];
	}
    return cell;
}

- (void) makeHeaderView {
    int maxsize1 = 0;
    int maxsize2 = 0;
	self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.headerView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    //ヘッダー領域
	CGRect headerFrame = CGRectMake(0,0,self.view.bounds.size.width,70);
    headerFrame.origin.y += 65;
	self.headerView.frame = headerFrame;
	[self.view addSubview:self.headerView];
	int j = columnsuu;
    if([qd_id count]-j >=3){
        omidashi_i = 3;
    }else if([qd_id count]-j == 2){
        omidashi_i = 2;
    }else if([qd_id count]-j == 1){
        omidashi_i = 1;
    }

	for (int i = 0; i < omidashi_i+2; i++) {
        
        GridColumn *col = [[GridColumn alloc]init];
        if(i < 2){
		 col = [self.cols objectAtIndex:i];
		}else{
         col = [self.cols objectAtIndex:j+2];
            j = j + 1;
        }
		// 列ヘッダラベル (ソートボタン)
		float left = [self leftPositionOfColomnNumber:i];
        UILabel *oomidashi = [[UILabel alloc] initWithFrame:CGRectMake(left+5,4,0,0)];
		oomidashi.backgroundColor = [UIColor clearColor];
        oomidashi.font = [UIFont systemFontOfSize:14];
        oomidashi.textColor = [UIColor darkGrayColor];
        if (col.headerText != nil) {
            oomidashi.text = col.headerText;
        } else {
			
        }
        oomidashi.numberOfLines  = 0;
        oomidashi.frame          = CGRectMake(left + 5,4,omidashi_wid-5,10);
        [oomidashi sizeToFit];
        int size= oomidashi.frame.size.height;
        if(size > maxsize1){
            maxsize1 = size;
        }
        [self.headerView addSubview:oomidashi];
		
		// セパレータ
		float right = [self leftPositionOfColomnNumber:i+1];
		UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(right,0,1,self.headerView.bounds.size.height)];
		separator.backgroundColor = [UIColor lightGrayColor];
		[self.headerView addSubview:separator];
	}
	
	// 下線を引く
	UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0,maxsize1+3,self.headerView.bounds.size.width,1)];
	bottomBorder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	bottomBorder.backgroundColor = [UIColor lightGrayColor];
	[self.headerView addSubview:bottomBorder];
    
        for (int i = 0; i < [self.cols2 count]; i++) {
            GridColumn *col = [self.cols2 objectAtIndex:i];
            float left = [self leftPositionOfColomnNumber1:i];
            left =  left ;
            UILabel *komidashi = [[UILabel alloc] initWithFrame:CGRectMake(left+5,maxsize1+8,0,20)];
            komidashi.backgroundColor = [UIColor clearColor];
            komidashi.font = [UIFont systemFontOfSize:14];
            komidashi.textColor = [UIColor darkGrayColor];
            if (col.headerText != nil) {
                komidashi.text = col.headerText;
            } else {
			
            }
		    komidashi.numberOfLines  = 0;
            komidashi.frame          = CGRectMake(left + 5,maxsize1+7,140,10);
            [komidashi sizeToFit];
            int size= komidashi.frame.size.height;
            if(size > maxsize2){
                maxsize2 = size;
            }
            [komidashi sizeToFit];
            // セパレータ
            float right = [self leftPositionOfColomnNumber1:i+1];
            right = right;
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(right,maxsize1+maxsize2+7,1,self.headerView.bounds.size.height)];
            separator.backgroundColor = [UIColor lightGrayColor];
        }
    // オリジナルの枠を取得
    CGRect original = self.headerView.frame;
    
    // 枠の高さを半分に
    CGRect new = CGRectMake(original.origin.x,
                            original.origin.y,
                            original.size.width,
                            maxsize1+maxsize2+8);
    
    // 新しい枠をセットする
    self.headerView.frame = new;
    for (int i = 0; i < [self.cols2 count]; i++) {
        GridColumn *col = [self.cols2 objectAtIndex:i];
        float left = [self leftPositionOfColomnNumber1:i];
        left =  left ;
        UILabel *komidashi = [[UILabel alloc] initWithFrame:CGRectMake(left+5,maxsize1+8,0,20)];
        komidashi.backgroundColor = [UIColor clearColor];
        komidashi.font = [UIFont systemFontOfSize:14];
        komidashi.textColor = [UIColor darkGrayColor];
        if (col.headerText != nil) {
            komidashi.text = col.headerText;
        } else {
			
        }
        komidashi.numberOfLines  = 0;
        komidashi.frame          = CGRectMake(left + 5,maxsize1+7,140,10);
        int size= komidashi.frame.size.height;
        if(size > maxsize2){
            maxsize2 = size;
        }
        [komidashi sizeToFit];
        [self.headerView addSubview:komidashi];
        // セパレータ
        float right = [self leftPositionOfColomnNumber1:i+1];
        right = right;
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(right,maxsize1+3,1,self.headerView.bounds.size.height)];
        separator.backgroundColor = [UIColor lightGrayColor];
        [self.headerView addSubview:separator];
    }
    // 下線を引く
	UIView *bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0,maxsize1+maxsize2+7,self.headerView.bounds.size.width,1)];
	bottomBorder1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	bottomBorder1.backgroundColor = [UIColor lightGrayColor];
	[self.headerView addSubview:bottomBorder1];
}

// 列の左端の座標を取得
- (float) leftPositionOfColomnNumber:(int)colNumber {
	float x = 0;
	for (int i = 0; i < [self.cols count]; i++) {
		//TODO: width:-1で可変幅列
		GridColumn *col = [self.cols objectAtIndex:i];
		
		if (i == colNumber) {
			return x;
		}
        
		x += col.width;
	}
	// その他の場合は、length+1として受け付ける
	return x;
}

- (float) leftPositionOfColomnNumber1:(int)colNumber {
	float x = 0;
	for (int i = 0; i < [self.cols2 count]; i++) {
		//TODO: width:-1で可変幅列
		GridColumn *col = [self.cols2 objectAtIndex:i];
		
		if (i == colNumber) {
			return x;
		}
        
		x += col.width;
	}
	// その他の場合は、length+1として受け付ける
	return x;
}

-(void) column{
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
    FMResultSet*    rs = [db executeQuery:@"select qd_name,qd_id from QuestionDetail where q_id = ?;",q_id];
    NSMutableArray *qd_name1 = [[NSMutableArray alloc] init];
    NSMutableArray *qd_id1 = [[NSMutableArray alloc] init];
    while( [rs next] )
    {
        NSString *name = [[NSString alloc] init];
        name = [rs stringForColumn:@"qd_name"];
        [qd_name1 addObject:name];
        NSString *qd = [[NSString alloc] init];
        qd = [rs stringForColumn:@"qd_id"];
        [qd_id1 addObject:qd];
    }
    qd_name = qd_name1;
    qd_id = qd_id1;

    [rs close];
    
    
    [db close];

}

-(void)data{
    record = [[NSMutableArray alloc] init];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
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
    NSMutableArray *sec_id = [[NSMutableArray alloc] init];
    NSMutableArray *sec_name = [[NSMutableArray alloc] init];
    FMResultSet* sql1 = [db executeQuery:@"select sec_id,sec_name from Section where e_id = ?;",e_id];
    while( [sql1 next] )
    {
        NSString *sec = [[NSString alloc] init];
        NSString *name = [[NSString alloc] init];
        sec = [sql1 stringForColumn:@"sec_id"];
        name = [sql1 stringForColumn:@"sec_name"];
        [sec_id addObject:sec];
        [sec_name addObject:name];
    }
    
    [sql1 close];
    //課の数だけループする処理
    for(int j=0; j< [sec_id count];j++){
      NSMutableArray *qd_name1 = [[NSMutableArray alloc] init];
      [qd_name1 addObject:[NSNull null]];
        
        //配列に入っている質問の位置
        int i = columnsuu;
        
        //画面に表示する質問の数だけループする処理
        for(int k=0; k < 3;k++){
          if(columnsuu + k < [qd_id count]){
          [qd_name1 addObject:[NSNull null]];
          [qd_name1 addObject:[NSNull null]];
          NSString *kubun = [[NSString alloc] init];
              
          FMResultSet*    sql1 = [db executeQuery:@"select cho_kubun from QuestionDetail where sur_id = ? and q_id = ? and qd_id = ?;",sur_id,q_id,qd_id[columnsuu + k]];
          while( [sql1 next] )
          {
              NSString *sql2 = [[NSString alloc] init];
              sql2 = [sql1 stringForColumn:@"cho_kubun"];
              kubun = sql2;
          }
          [sql1 close];
          FMResultSet* rs;
          if([kubun isEqualToString:@"cho"]){
              rs = [db executeQuery:@"select a.ans_cho,s.sec_name,a.memo from Answer a,Section s where a.sur_id = ? and a.q_id = ? and a.e_id = ? and a.sec_id = s.sec_id and a.e_id = s.e_id and a.sec_id = ? and a.qd_id = ?;",sur_id,q_id,e_id,sec_id[j],qd_id[columnsuu + k]];
          }else if ([kubun isEqualToString:@"str"]){
              rs = [db executeQuery:@"select a.ans_str,s.sec_name,a.memo from Answer a,Section s where a.sur_id = ? and a.q_id = ? and a.e_id = ? and a.sec_id = s.sec_id and a.e_id = s.e_id and a.sec_id = ? and a.qd_id = ?;",sur_id,q_id,e_id,sec_id[j],qd_id[columnsuu + k]];
          }
          while( [rs next] )
          {
            if(k == 0){
              NSString *sec_name = [[NSString alloc] init];
              sec_name = [rs stringForColumn:@"sec_name"];
              [qd_name1 replaceObjectAtIndex:0 withObject:sec_name];
          }
            NSString *ans_cho = [[NSString alloc] init];
            if([kubun isEqualToString:@"cho"]){
              ans_cho = [rs stringForColumn:@"ans_cho"];
            }else if([kubun isEqualToString:@"str"]){
              ans_cho = [rs stringForColumn:@"ans_str"];
            }
            [qd_name1 replaceObjectAtIndex:k*2+1 withObject:ans_cho];
            NSString *memo = [[NSString alloc] init];
            memo = [rs stringForColumn:@"memo"];
            [qd_name1 replaceObjectAtIndex:k*2+2 withObject:memo];
          }
          [rs close];
          i = i +1;
        }
      }
    record = qd_name1;
    NSString* strJ = [NSString stringWithFormat : @"%d", j+1];
        if([record count] == 3){
            [rows addObject:[[User alloc] initWithNo:strJ sec_name:sec_name[j] answer1:record[1] memo1:record[2]]];
        }else if([record count] == 5){
    [rows addObject:[[User alloc] initWithNo:strJ sec_name:sec_name[j] answer1:record[1] memo1:record[2] answer2:record[3] memo2:record[4]]];
        }else if([record count] == 7){
            [rows addObject:[[User alloc] initWithNo:strJ sec_name:sec_name[j] answer1:record[1] memo1:record[2] answer2:record[3] memo2:record[4] answer3:record[5] memo3:record[6]]];
        }
        if(j == [sec_id count]-1 && i < [qd_id count]){
            [self button];
        }
    }
    sqldata = rows;
    [db close];
}

//ボタンの配置
- (void)button{
    UIBarButtonItem* comment_btn = [[UIBarButtonItem alloc]
                                    initWithTitle:@"次へ"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(btn_next)];
    self.navigationItem.rightBarButtonItems = @[comment_btn];
}

//ボタンの処理
-(void)btn_next{
    GridTableV *grid = [self.storyboard instantiateViewControllerWithIdentifier:@"Grid"];
    grid.sur_id = sur_id;
    grid.e_id = e_id;
    grid.q_id = q_id;
    grid.q_name = q_name;
    grid.columnsuu = columnsuu + 3;

    [self.navigationController pushViewController: grid animated:YES];
}
@end
