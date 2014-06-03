//
//  SurveyViewStringController.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "Enterprise.h"
#import "Question.h"

@interface SurveyViewStringController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    Survey *survey;
    Enterprise *enterprise;
    NSString *charge;
    NSString *answerer;
    NSMutableArray *mQD;
    NSMutableArray *mAnswer;
    Question *questions;
    int i;
    int max;
    bool flg1;
}

@property (nonatomic,retain) Survey *survey;
@property (nonatomic,retain) Enterprise *enterprise;
@property (nonatomic,retain) NSString *charge;
@property (nonatomic,retain) NSString *answerer;
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
@property (nonatomic,assign) bool flg1;
@property (weak, nonatomic) IBOutlet UITextView *answer_str;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UITextView *memo;
- (IBAction)back:(id)sender;

@end
