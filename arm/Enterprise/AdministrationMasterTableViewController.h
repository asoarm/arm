//
//  MasterTableViewController.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdministrationMasterTableViewController : UITableViewController
{
    NSMutableArray *mEnterprise;
    NSString *division;
}
- (IBAction)back:(id)sender;

@end
