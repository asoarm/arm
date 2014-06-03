//
//  GridColumn.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString*(^TextRenderer)(NSObject*);
typedef void(^LabelRenderer)(UILabel*, NSObject*);

@interface GridColumn : NSObject

@property(nonatomic, retain) NSString *propertyName;
@property(nonatomic, retain) NSString *headerText;
@property(nonatomic, assign) float width;
//表示する文字列自体の加工
@property(nonatomic, assign) TextRenderer textRenderer;
//文字列の見た目の加工
@property(nonatomic, assign) LabelRenderer labelRenderer;

-(id) initWithPropertyName:(NSString*)propertyName headerText:(NSString*)headerText width:(float)width;

@end
