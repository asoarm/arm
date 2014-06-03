//
//  PieChartsView.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartsView : UIView {
    int choice1;
    int choice2;
    int choice3;
    int choice4;
    int choice5;
    int choice6;
}

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic,assign) int choice1;
@property (nonatomic,assign) int choice2;
@property (nonatomic,assign) int choice3;
@property (nonatomic,assign) int choice4;
@property (nonatomic,assign) int choice5;
@property (nonatomic,assign) int choice6;
@end