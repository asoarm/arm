//
//  InExVC.h
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InExVC : UIViewController
{
    NSMutableArray *mAns;
    NSMutableArray *mSur;
    NSMutableArray *mQ;
    NSMutableArray *mQD;
    NSMutableArray *mCho;
    NSMutableArray *mEn;
    NSMutableArray *mCom;
}
@property (nonatomic,retain) NSMutableArray *mAns;
@property (nonatomic,retain) NSMutableArray *mSur;
@property (nonatomic,retain) NSMutableArray *mQ;
@property (nonatomic,retain) NSMutableArray *mQD;
@property (nonatomic,retain) NSMutableArray *mCho;
@property (nonatomic,retain) NSMutableArray *mEn;
@property (nonatomic,retain) NSMutableArray *mCom;
-(NSMutableString*)survey_export;
-(NSMutableString*)question_export;
-(NSMutableString*)question_d_export;
-(NSMutableString*)choice_export;
-(NSMutableString*)enterprise_export;
-(NSMutableString*)section_export;
-(NSMutableString*)comment_export;
-(NSMutableString*)answer_export;
-(int)survey_import:(NSString *)filestext;
-(int)question_import:(NSString *)filestext;
-(int)question_d_import:(NSString *)filestext;
-(int)choice_import:(NSString *)filestext;
-(int)enterprise_import:(NSString *)filestext;
-(int)section_import:(NSString *)filestext;
-(int)comment_import:(NSString *)filestext;
-(int)answer_import:(NSString *)filestext;
@end
