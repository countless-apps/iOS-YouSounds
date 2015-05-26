//
//  AppDelegate.m
//  youSound
//
//  Created by Akash on 5/30/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginController.h"
#import "SlideMenuView.h"
#import "SVProgressHUD.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"
#import "Global.h"
#import "NotificationController.h"

@implementation AppDelegate
{
    NSURL *urlFetchKey;
    NSString *myString;
}
@synthesize Key,navigation;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // set the public key in to Header
    appDelegate = [[UIApplication sharedApplication] delegate];
    [[NSUserDefaults standardUserDefaults] setValue:@"6d9f729b765aae27f45e5ef9150fa073f8a61b94" forKeyPath:@"X-API-KEY"];
    
    [NSThread sleepForTimeInterval:(2.0)];
   
    [self fetchKey];
    
    self.objDownloadVC = [[MZDownloadManagerViewController alloc] initWithNibName:@"MZDownloadManagerViewController" bundle:nil];
    
     myString = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
    
        LoginController *login = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
        navigation = [[UINavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = navigation;
   
    self.navigation.navigationBarHidden=YES;
    //************ Notification Register
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
         UIUserNotificationTypeBadge |
         UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound];
    }
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
   
    return YES;
}

// Fetch the Private Key
-(void)fetchKey
{
    urlFetchKey = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/key"]];
        
    [[ServerCalls sharedObject] executeRequest:urlFetchKey withData:nil method:KPUT completionBlock:^(NSData *data, NSError *error)
     {
         if (error)
         {
             NSLog(@"ERROR!!"); 
         }
         else if (data)
         {
             NSDictionary *responseData = [data JSONValue];
             BOOL Success = [[responseData valueForKey:@"status"] boolValue];
             if (Success)
             {
                 if([myString  isEqual: @"0"] || !myString)
                 {
                     [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"key"] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"X-API-KEY"];
                     [[NSUserDefaults standardUserDefaults] setObject:[responseData valueForKey:@"key"] forKey:@"KEY"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else{
                     NSDictionary *keyDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"KEY"];
                     [[NSUserDefaults standardUserDefaults] setObject:keyDict forKey:@"X-API-KEY"];
                 }
             }
             else
             {
                 NSLog(@"ERROR!!");
                [SVProgressHUD dismiss];
             }
         }
     }];
}

#pragma mark - APNS management
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"TokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
 
    token = nil;
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error %@",str);
    
    NSString  *udid = @"ABCD123456";
    
    [[NSUserDefaults standardUserDefaults]setObject:udid forKey:@"TokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    [self getBadge1];

}
-(void)getBadge1
{
    NSURL *urlGetCount = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/get_notification/format/json"]];
    [[ServerCalls sharedObject] executeRequest:urlGetCount withData:nil method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success)
            {
                DictGetBadge = [responseData valueForKey:@"COUNT"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getBadge" object:nil userInfo:DictGetBadge];
            }
            else
            {
                
            }
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Backgrounding Methods -
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
	self.backgroundSessionCompletionHandler = completionHandler;
}
@end
