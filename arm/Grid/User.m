//
//  User.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "User.h"

@implementation User

//表示する質問が一つの場合
-(id) initWithNo:(NSString*)no sec_name:(NSString*)sec_name answer1:(NSString*)answer1 memo1:(NSString*)memo1{
    self = [super init];
    if(self){
        self.no = no;
        self.sec_name = sec_name;
		self.answer1 = answer1;
		self.memo1 = memo1;
    }
    return self;
}

//表示する質問が二つの場合
-(id) initWithNo:(NSString *)no sec_name:(NSString *)sec_name answer1:(NSString *)answer1 memo1:(NSString *)memo1 answer2:(NSString *)answer2 memo2:(NSString *)memo2{
    self = [super init];
	if (self) {
        self.no = no;
        self.sec_name = sec_name;
		self.answer1 = answer1;
		self.memo1 = memo1;
        self.answer2 = answer2;
		self.memo2 = memo2;
	}
	return self;
}

//表示する質問が三つの場合
-(id) initWithNo:(NSString*)no sec_name:(NSString*)sec_name answer1:(NSString*)answer1 memo1:(NSString*)memo1 answer2:(NSString*)answer2 memo2:(NSString*)memo2 answer3:(NSString*)answer3 memo3:(NSString*)memo3{
	self = [super init];
	if (self) {
        self.no = no;
        self.sec_name = sec_name;
		self.answer1 = answer1;
		self.memo1 = memo1;
        self.answer2 = answer2;
		self.memo2 = memo2;
        self.answer3 = answer3;
		self.memo3 = memo3;
	}
	return self;
}

@end
