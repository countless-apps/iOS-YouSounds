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
