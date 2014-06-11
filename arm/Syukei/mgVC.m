//
//  mgVC.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "mgVC.h"
#import "QuestionVC.h"
#import "GridQuestionVC.h"
@interface mgVC ()

@end

@implementation mgVC
@synthesize survey;
@synthesize enterprise;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//グラフ化ボタンをタップした処理
-(IBAction)graph:(id)sender{
    QuestionVC *question = [self.storyboard instantiateViewControllerWithIdentifier:@"QVC"];
    question.survey = survey;
    question.enterprise = enterprise;
    [self.navigationController pushViewController:question animated:YES];
}

//マトリクスボタンをタップした処理
-(IBAction)grid:(id)sender{
    GridQuestionVC *grid = [self.storyboard instantiateViewControllerWithIdentifier:@"GridQuestion"];
    grid.sur_id = survey.sur_id;
    grid.e_id = enterprise.e_id;
    [self.navigationController pushViewController:grid animated:YES];
}
@end
