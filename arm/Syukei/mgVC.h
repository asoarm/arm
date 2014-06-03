//
//  mgVC.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

/*--マトリクス図、グラフ選択画面--*/

#import <UIKit/UIKit.h>
#import "Enterprise.h"
#import "Survey.h"

@interface mgVC : UIViewController
{
    Survey *survey;
    Enterprise *enterprise;
}
@property (nonatomic,retain) Survey *survey;
@property (nonatomic,retain) Enterprise *enterprise;

-(IBAction)graph:(id)sender;
-(IBAction)grid:(id)sender;
@end
