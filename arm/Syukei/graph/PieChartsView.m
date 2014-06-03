//
//  PieChartsView.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "PieChartsView.h"

static inline float radians(double degrees) { return degrees * M_PI / 180.0; }

@implementation PieChartsView
@synthesize choice1;
@synthesize choice2;
@synthesize choice3;
@synthesize choice4;
@synthesize choice5;
@synthesize choice6;

- (id)initWithFrame:(CGRect)frame {
    
    self.frame = CGRectMake(0,0,1024,748);
    
    if ((self = [super initWithFrame:frame])) {
        // 背景を透明に設定
        self.backgroundColor = UIColor.clearColor;
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // 中心座標の取得
    CGFloat x = CGRectGetWidth(self.bounds) / 2.8;
    CGFloat y = CGRectGetHeight(self.bounds) / 3.1;
    
    // 半径
    CGFloat radius = 130.0;
    
    // 描画開始位置
    CGFloat start = -90.0;
	
    // 各項目の割合を取得
    CGFloat allItems = choice1 + choice2 + choice3 + choice4 + choice5 + choice6;
    
    CGFloat itemAFinish = choice1 * 360.0f / allItems;
    CGFloat itemBFinish = choice2 * 360.0f / allItems;
    CGFloat itemCFinish = choice3 * 360.0f / allItems;
    CGFloat itemDFinish = choice4 * 360.0f / allItems;
    CGFloat itemEFinish = choice5 * 360.0f / allItems;
    CGFloat itemFFinish = choice6 * 360.0f / allItems;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 円グラフの描画
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius,  radians(start), radians(start + itemAFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius,  radians(start + itemAFinish), radians(start + itemAFinish + itemBFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:0.133 green:0.545 blue:0.133 alpha:0.6] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius,  radians(start + itemAFinish + itemBFinish), radians(start + itemAFinish + itemBFinish + itemCFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius,  radians(start + itemAFinish + itemBFinish + itemCFinish), radians(start + itemAFinish + itemBFinish + itemCFinish + itemDFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:0.118 green:0.565 blue:1.0 alpha:1.0] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius,  radians(start + itemAFinish + itemBFinish + itemCFinish + itemDFinish), radians(start + itemAFinish + itemBFinish + itemCFinish + itemDFinish + itemEFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:1.0 green:0.4 blue:1.0 alpha:1.0] CGColor]));
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, radius,  radians(start + itemAFinish + itemBFinish + itemCFinish + itemDFinish + itemEFinish), radians(start + itemAFinish + itemBFinish + itemCFinish + itemDFinish + itemEFinish + itemFFinish), 0.0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end