//
//  GridTableV.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef void(^RowRenderer)(UITableViewCell *cell, int rowIndex);

@interface GridTableV : UIViewController
@property(nonatomic, retain) NSString *sur_id;
@property(nonatomic, retain) NSString *e_id;
@property(nonatomic, retain) NSMutableArray *rows;
@property(nonatomic, retain) NSMutableArray *cols;
@property(nonatomic, retain) NSMutableArray *cols2;
@property(nonatomic, retain) NSMutableArray *sqldata;
@property int omidashi_i;
@property int datak;
//行全体の加工
@property(nonatomic, assign) RowRenderer rowRenderer;
@property(nonatomic, retain) NSMutableArray *qd_name;
@property(nonatomic, retain) NSMutableArray *qd_id;
@property(nonatomic, retain) NSMutableArray *record;
@property(nonatomic, retain) NSString *q_id;
@property(nonatomic, retain) NSString *q_name;
@property float omidashi_wid;
@property float komidashi_ans_wid;
@property float komidashi_memo_wid;
@property int heightmax;
@property NSMutableArray *height_cell;
@end
