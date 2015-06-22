//
//  PrivacyPolicy.m
//  youSound
//
//  Created by Akash on 8/12/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "PrivacyPolicy.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"

@interface PrivacyPolicy ()
{
    IBOutlet UIButton *btnLeftNavigation;
    IBOutlet UILabel *lblHeader;
    IBOutlet UIWebView *webView;
    NSURL *urlPrivacy;
}
@end

@implementation PrivacyPolicy

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.view.frame andColors:BGCOLORS];    
    [self fetchData];
}
-(void)fetchData
{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    urlPrivacy = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/privacy/format/json"]];
    
    [[ServerCalls sharedObject] executeRequest:urlPrivacy withData:nil method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success){
                NSString *htmlString =
               [NSString stringWithFormat:@"<div style='text-align:justify; font-size:12px;font-family:Arial;color:#ffffff;'>%@", [responseData valueForKey:@"data"]];
                [webView loadHTMLString:htmlString baseURL:nil];
            }
            else
            {
                NSString *strMessage = [responseData valueForKeyPath:@"MESSAGE"];
                ShowAlertWithTitle(@"Error", strMessage, @"Retry");
                
            }
        }
        [SVProgressHUD dismiss];
    }];
}
- (IBAction)btnLeftNavigation_Click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
