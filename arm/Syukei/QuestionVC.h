//
//  QuestionVC.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

/*--グラフ化する質問一覧--*/

#import <UIKit/UIKit.h>
#import "QuestionDetail.h"
#import "Enterprise.h"
#import "Survey.h"

@interface QuestionVC : UITableViewController
{
    NSMutableArray *mQD;
    NSMutableArray *mq_count;
    NSMutableArray *y_count;
    NSMutableArray *cho_flg;
    Survey *survey;
    Enterprise *enterprise;
    QuestionDetail *questiondetail;
    int choice1;
    int choice2;
    int choice3;
    int choice4;
    int choice5;
    int choice6;
}
@property (nonatomic,retain) Survey *survey;
@property (nonatomic,retain) QuestionDetail *questiondetail;
@property (nonatomic,retain) Enterprise *enterprise;
@property (nonatomic,assign) int choice1;
@property (nonatomic,assign) int choice2;
@property (nonatomic,assign) int choice3;
@property (nonatomic,assign) int choice4;
@property (nonatomic,assign) int choice5;
@property (nonatomic,assign) int choice6;
@property (nonatomic,retain) NSMutableArray *cho_flg;
@end
