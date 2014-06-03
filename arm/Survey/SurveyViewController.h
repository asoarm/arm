//
//  SurveyViewController.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "Enterprise.h"
#import "Question.h"
#import "Choice.h"

@interface SurveyViewController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    Survey *survey;
    Enterprise *enterprise;
    NSString *charge;
    NSString *answerer;
    NSMutableArray *mQD;
    NSMutableArray *mAnswer;
    Choice *cho;
    Question *questions;
    int i;
    int max;
    bool flg1;
}

@property (nonatomic,retain) Survey *survey;
@property (nonatomic,retain) Enterprise *enterprise;
@property (nonatomic,retain) Choice *cho;
@property (nonatomic,retain) NSString *charge;
@property (nonatomic,retain) NSString *answerer;
@property (weak, nonatomic) IBOutlet UITextView *memo;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Question;
@property (weak, nonatomic) IBOutlet UILabel *QD;
@property (weak, nonatomic) IBOutlet UILabel *page;
@property (nonatomic,retain) Question *questions;
@property (nonatomic,retain) NSMutableArray *mQD;
@property (nonatomic,retain) NSMutableArray *mAnswer;
@property (nonatomic,assign) int i;
@property (nonatomic,assign) int max;
@property (nonatomic,retain) NSString *selectcho;
@property (nonatomic,assign) bool flg1;


//button
@property (weak, nonatomic) IBOutlet UIButton *choice1btn;
@property (weak, nonatomic) IBOutlet UIButton *choice2btn;
@property (weak, nonatomic) IBOutlet UIButton *choice3btn;
@property (weak, nonatomic) IBOutlet UIButton *choice4btn;
@property (weak, nonatomic) IBOutlet UIButton *choice5btn;
@property (weak, nonatomic) IBOutlet UIButton *choice6btn;
@property (weak, nonatomic) IBOutlet UIButton *back;
- (IBAction)pushchoice1:(id)sender;
- (IBAction)pushchoice2:(id)sender;
- (IBAction)pushchoice3:(id)sender;
- (IBAction)pushchoice4:(id)sender;
- (IBAction)pushchoice5:(id)sender;
- (IBAction)pushchoice6:(id)sender;
- (IBAction)back:(id)sender;

@end
