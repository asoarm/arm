//
//  SectionViewController.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enterprise.h"

@interface SectionViewController : UITableViewController
{
    Enterprise *enterprise;
    NSMutableArray *mSec;
}
@property (nonatomic,retain) Enterprise *enterprise;

@end
