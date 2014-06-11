//
//  EndViewController.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "EndViewController.h"
#import "MainViewController.h"

@interface EndViewController ()

@end

@implementation EndViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainmenu:(id)sender {
    //メニュー画面へ遷移
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self presentViewController:mainViewController animated:YES completion:nil];
}
@end
