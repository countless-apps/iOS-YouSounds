//
//  AppDelegate.h
//  youSound
//
//  Created by Akash on 5/30/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"
#import "MZDownloadManagerViewController.h"

#import <ChameleonFramework/Chameleon.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BGCOLORS @[ UIColorFromRGB(0x23c3cc), UIColorFromRGB(0x3fb7ef)]

#define BGCOLORS1 @[ UIColorFromRGB(0x23c3cc), UIColorFromRGB(0x3fb7ef)]

#define BGCOLORS2 @[ UIColorFromRGB(0x3fb7ef),UIColorFromRGB(0x3fb7ef), UIColorFromRGB(0xffffff)]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain ,nonatomic) NSString *Key;
@property (retain,nonatomic) UINavigationController *navigation;
@property BOOL YesNo;
@property (copy) void (^backgroundSessionCompletionHandler)();
@property (nonatomic, strong) MZDownloadManagerViewController *objDownloadVC;

-(void)fetchKey;
-(void)getBadge1;

@end
