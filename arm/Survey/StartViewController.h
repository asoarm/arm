//
//  StartViewController.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "Enterprise.h"

@interface StartViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    Survey *survey;
    Enterprise *enterprise;
        NSMutableArray *mQD;
}

- (IBAction)start:(id)sender;
@property (nonatomic,retain) Survey *survey;
@property (nonatomic,retain) Enterprise *enterprise;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (nonatomic,retain) NSMutableArray *mQD;
@end
