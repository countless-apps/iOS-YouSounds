//
//  CommonMethods.h
//  FSA
//
//  Created by iMacViral on 7/5/13.
//  Copyright (c) 2013 INDUSA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonMethods : NSObject

+(CommonMethods *) sharedObj;

+ (BOOL) isValidTextFieldData :(NSDictionary *)dicValues;
+ (BOOL)isNonEmptyString :(NSString *)strstring;
+ (BOOL)isProperEmail:(NSString*)email;

+ (UIButton *)customizeLeftBarButton :(UIImage *)image;
+ (UIButton *)customizeLeftBarButtonNewStyle :(UIImage *)image;
+ (UIButton *)customizeRightBarButton :(UIImage *)image withText:(NSString *)str andLength :(int)len andFontSize:(int)size;
+ (UIButton *)customizeRightBarButtonNewStyle :(UIImage *)image withText:(NSString *)str andLength :(int)len andFontSize:(int)size;
+ (UIImage *)setBackgroundImage;
+ (void)customizeNavigationbar :(UINavigationBar *)navBar;
+ (void)customizeNavigationbarWithLogo :(UINavigationBar *)navBar;
+(void)customPushAnimation : (UINavigationController *)navigationController;
+(void)customPopAnimation : (UINavigationController *)navigationController;
+(BOOL)isImageNotNull : (UIImage *)image;
+ (void)customizeSearchBar;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;

+(NSMutableData *)preparePostData :(NSDictionary *)dictData;

+(NSString *)convertText:(NSString *)strText fromFormat:(NSString *)strFromformat toFormat:(NSString *)strToFormat;
+(NSDate *)convertToDate:(NSString *)strText fromFormat:(NSString *)strFromformat;
+(NSString *)convertDate:(NSDate *)dtText inFormat:(NSString *)strFromformat toTextInFormat:(NSString *)strToFormat;

+(void)animateBtnLR :(UIButton *)btn1 label:(UILabel *)lbl1 BtnRL:(UIButton *)btn2 label:(UILabel *)lbl2;
+(void)animateButton :(UIButton *)sender;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
