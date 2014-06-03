//
//  User.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//NSStringクラス＝文字列を扱うクラス
//nonatomic＝インスタンスの同時実行を防ぐ
//retain＝関連づけられている変数のカウントを１プラスする
@property(nonatomic, retain) NSString *no;
@property(nonatomic, retain) NSString *no1;
@property(nonatomic, retain) NSString *sec_name;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *answer1;
@property(nonatomic, retain) NSString *memo1;
@property(nonatomic, retain) NSString *answer2;
@property(nonatomic, retain) NSString *memo2;
@property(nonatomic, retain) NSString *answer3;
@property(nonatomic, retain) NSString *memo3;
@property(nonatomic, retain) NSString *answer4;
@property(nonatomic, retain) NSString *memo4;
@property(nonatomic, retain) NSString *answer5;
@property(nonatomic, retain) NSString *memo5;

//id型＝どんなクラスのインスタンスも入れることができる、型を意識しなくてよい
//すべてid型で指定している
-(id) initWithNo:(NSString*)no sec_name:(NSString*)sec_name answer1:(NSString*)answer1 memo1:(NSString*)memo1;

-(id) initWithNo:(NSString*)no sec_name:(NSString*)sec_name answer1:(NSString*)answer1 memo1:(NSString*)memo1 answer2:(NSString*)answer2 memo2:(NSString*)memo2;

-(id) initWithNo:(NSString*)no sec_name:(NSString*)sec_name answer1:(NSString*)answer1 memo1:(NSString*)memo1 answer2:(NSString*)answer2 memo2:(NSString*)memo2 answer3:(NSString*)answer3 memo3:(NSString*)memo3;

@end
