//
//  ViewController.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSString *division;
}
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@property (nonatomic,retain) NSString *division;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
- (IBAction)done:(id)sender;

@end