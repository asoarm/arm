//
//  UIButton+BGColor.h
//  Prototype
//
//  Created by masato on 2013/09/28.
//  Copyright (c) 2013年 ntt(kari). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BGColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundColorString:(NSString *)colorStr forState:(UIControlState)state;

@end