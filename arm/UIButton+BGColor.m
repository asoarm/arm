//
//  UIButton+BGColor.m
//  Prototype
//
//  Created by masato on 2013/09/28.
//  Copyright (c) 2013年 ntt(kari). All rights reserved.
//

#import "UIButton+BGColor.h"


#import <QuartzCore/QuartzCore.h>
#import "UIColor_Expanded.h"

@implementation UIButton (BGColor)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    CGRect buttonSize = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *bgView = [[UIView alloc] initWithFrame:buttonSize];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = true;
    bgView.backgroundColor = color;
    UIGraphicsBeginImageContext(self.frame.size);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:screenImage forState:state];
}

- (void)setBackgroundColorString:(NSString *)colorStr forState:(UIControlState)state {
    UIColor *color = [UIColor colorWithHexString:colorStr];
    [self setBackgroundColor:color forState:state];
}

@end