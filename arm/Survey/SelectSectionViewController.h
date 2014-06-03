//
//  SelectSectionViewController.h
//  arm
//
//  Created by Owner on 2013/12/30.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "Enterprise.h"
@interface SelectSectionViewController : UITableViewController
{
    Survey *survey;
    Enterprise *enterprise;
    NSMutableArray *mEnterprise;
}
@property (nonatomic,retain) Survey *survey;
@property (nonatomic,retain) Enterprise *enterprise;
@end
