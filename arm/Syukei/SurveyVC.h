//
//  SurveyVC.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

/*--実施したアンケート一覧--*/

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "Enterprise.h"

@interface SurveyVC : UITableViewController
{
    NSMutableArray *mSurvey;
    Enterprise *enterprise;
}

@property (nonatomic,retain) Enterprise *enterprise;
@end
