//
//  CommentVC.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionDetail.h"
#import "Enterprise.h"
#import "Choice.h"

@interface CommentVC : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *pcVC_cn;
    NSMutableArray *cho_flg;
    QuestionDetail *questiondetail;
    Enterprise *enterprise;
    int choice1;
    int choice2;
    int choice3;
    int choice4;
    int choice5;
    int choice6;
    NSString *choice1_name;
    NSString *choice2_name;
    NSString *choice3_name;
    NSString *choice4_name;
    NSString *choice5_name;
    NSString *choice6_name;
    UIScrollView *myScrollView;
}
@property (weak, nonatomic) IBOutlet UILabel *qd;
@property(nonatomic,retain)QuestionDetail *questiondetail;
@property (weak, nonatomic) IBOutlet UILabel *commentlabel;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UIButton *done;
@property (weak, nonatomic) IBOutlet UIButton *reset;
@property (nonatomic,retain) NSMutableArray *cho_flg;
@property (nonatomic,retain) Enterprise *enterprise;
@property (nonatomic,retain) Choice *choice;
@property (nonatomic,assign) int choice1;
@property (nonatomic,assign) int choice2;
@property (nonatomic,assign) int choice3;
@property (nonatomic,assign) int choice4;
@property (nonatomic,assign) int choice5;
@property (nonatomic,assign) int choice6;
@property (nonatomic,retain) NSString *choice1_name;
@property (nonatomic,retain) NSString *choice2_name;
@property (nonatomic,retain) NSString *choice3_name;
@property (nonatomic,retain) NSString *choice4_name;
@property (nonatomic,retain) NSString *choice5_name;
@property (nonatomic,retain) NSString *choice6_name;
@property (nonatomic,retain) NSString *comment_value;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
- (IBAction)done:(id)sender;
- (IBAction)reset:(id)sender;

@end
