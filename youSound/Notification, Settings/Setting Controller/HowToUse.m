//
//  HowToUse.m
//  youSound
//
//  Created by Akash on 8/12/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "HowToUse.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"

@interface HowToUse ()
{
    IBOutlet UIButton *btnLeftNavigation;
    IBOutlet UILabel *lblHeader;
    IBOutlet UIWebView *webView;
    NSURL *urlHelpData;
}
@end

@implementation HowToUse

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblHeader.font = lableHeader;
    // Do any additional setup after loading the view from its nib.
    
    /*NSString *fullURL = [URLBase stringByAppendingString:@"ws/admin/help/format/json"];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];*/
    [self fetchData];
}
-(void)fetchData
{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    urlHelpData = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/help/format/json"]];
    
    [[ServerCalls sharedObject] executeRequest:urlHelpData withData:nil method:kPOST completionBlock:^(NSData *data, NSError *error) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnLeftNavigation_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
