//
//  SelectEnterpriseViewController.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"

@interface SelectEnterpriseViewController : UITableViewController
{
    Survey *survey;
    NSMutableArray *mEnterprise;
}

@property (nonatomic,retain) Survey *survey;

@end
