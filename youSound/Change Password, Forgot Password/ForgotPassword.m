//
//  ForgotPassword.m
//  youSound
//
//  Created by Akash on 6/17/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "ForgotPassword.h"
#import "Global.h"
#import "ServerCalls.h"
#import "CommonMethods.h"
#import "NSObject+SBJson.h"
#import "SVProgressHUD.h"

@interface ForgotPassword (){
    NSURL *urlstr,*urlFetchKey,*urlforgotpwd;
    NSMutableData *reqData;
    NSMutableDictionary *dictEditData;
    
    IBOutlet UILabel *lblHeader;
    IBOutlet UITextField *txtEmailID;
    IBOutlet UIButton *LeftNavigationBtn;
    IBOutlet UIButton *btnUpdate;
}
@end

@implementation ForgotPassword

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.view.frame andColors: BGCOLORS];
    
    txtEmailID.leftViewMode = UITextFieldViewModeAlways;
    txtEmailID.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Email ID.png"]];
}

#pragma mark - UpdatePassword WS
-(void)updateUser{
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictEditData];
    
    //prepare url
    urlforgotpwd = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/forgotpassword"]];
    
    //ws call
    [[ServerCalls sharedObject] executeRequest:urlforgotpwd withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"ERROR!!");
            DisplayAlert((NSString *)[error localizedDescription]);
            [SVProgressHUD dismiss];
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                NSString *strMessage = [responseData valueForKeyPath:@"MESSAGE"];
                ShowAlertWithTitle(@"Error", strMessage, @"Retry");
                txtEmailID.text = nil;
                [txtEmailID becomeFirstResponder];
            }
        }
        [SVProgressHUD dismiss];
    }];

}

#pragma mark - Alerview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101){
        
    }
}

#pragma mark - TextField Delegate
-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ForgotPWD ButtonClick
- (IBAction)btnUpdate_Click:(id)sender {
    NSDictionary *dictData = nil;
    dictData = [NSDictionary dictionaryWithObjects:@[txtEmailID.text] forKeys:@[@"vEmail"]];
    //ToCheck Field Is Valid ?
    if ([CommonMethods isValidTextFieldData:dictData])
    {
        dictEditData = [NSMutableDictionary dictionaryWithObjects:@[txtEmailID.text] forKeys:@[@"vEmail"]];
        [self updateUser];
    }
}

#pragma mark - Navigation Button
- (IBAction)LeftNavigationBtn_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
