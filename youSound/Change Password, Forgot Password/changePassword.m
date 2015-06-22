//
//  changePassword.m
//  youSound
//
//  Created by Akash on 6/18/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "changePassword.h"
#import "Global.h"
#import "ServerCalls.h"
#import "CommonMethods.h"
#import "NSObject+SBJson.h"
#import "SVProgressHUD.h"
#import "LoginController.h"

@interface changePassword ()
{
    NSDictionary *dictData;
    NSMutableData *reqData;
    NSURL *urlpwdreset;
    
    __weak IBOutlet UITextField *txtConfirmPwd;
    IBOutlet UILabel *lblHeader;
    IBOutlet UITextField *txtOldPwd;
    IBOutlet UITextField *txtNewPwd;
}
@end

@implementation changePassword

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.view.frame andColors: BGCOLORS];
    
    
    
    txtOldPwd.leftViewMode = UITextFieldViewModeAlways;
    txtOldPwd.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Password.png"]];
    
    txtNewPwd.leftViewMode = UITextFieldViewModeAlways;
    txtNewPwd.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Password.png"]];
    
    txtConfirmPwd.leftViewMode = UITextFieldViewModeAlways;
    txtConfirmPwd.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Password.png"]];
}


#pragma  mark - UpdatePassword WS
-(void)updatePwd{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
  
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictData];
    
    //prepare url
    urlpwdreset = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/changepassword/format/json"]];
    
    //ws call
    [[ServerCalls sharedObject] executeRequest:urlpwdreset withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
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
            }
        }
        [SVProgressHUD dismiss];
    }];

}
#pragma mark - Buttons CLick Events
- (IBAction)btnUpdate_Click:(id)sender {
    if([txtConfirmPwd.text isEqualToString: txtNewPwd.text]){
        dictData = nil;
        
        NSDictionary *tempData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SaveData"];
        NSString *userID= [tempData valueForKey:@"iUserID"];
        NSLog(@"%@",userID);
        
        dictData = [NSDictionary dictionaryWithObjects:@[txtOldPwd.text, txtNewPwd.text] forKeys:@[@"vOldPassword",@"vPassword"]];
        [self updatePwd];
    }else{
        AlertWithTitle(@"YouSounds", @"New password and confirm password must be same.", @"Cancel");
        
    }
}
- (IBAction)btnBack_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
