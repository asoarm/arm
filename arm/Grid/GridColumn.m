//
//  GridColumn.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "GridColumn.h"

@implementation GridColumn//implementationインスタンス変数の宣言。実装部で書く場合
//initWithPropertyName=PropertyNameを初期化
-(id) initWithPropertyName:(NSString*)propertyName headerText:(NSString*)headerText width:(float)width {
	self = [super init];
	if (self) {
		self.propertyName = propertyName;
		self.headerText = headerText;
		self.width = width;
	}
	return self;
}

@end
