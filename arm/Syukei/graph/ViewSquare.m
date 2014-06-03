//
//  ViewSquare.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "ViewSquare.h"

@implementation ViewSquare

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.frame = CGRectMake(0,0,1024,748);
    
    if (self) {
        // 背景を透明に設定
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
    
}


- (void)drawRect:(CGRect)rect
{
    //四角の枠を表示
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGRect r1 = CGRectMake(500.0, 210.0, 455.0, 250.0);
    CGContextAddRect(context, r1);
    CGContextStrokePath(context);
}


@end
