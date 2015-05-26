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
    IBOutlet UIButton *btnBack;
    IBOutlet UITextField *txtEmailID;
    IBOutlet UITextField *txtOldPwd;
    IBOutlet UITextField *txtNewPwd;
    IBOutlet UIButton *btnUpdate;
}
@end

@implementation changePassword

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    lblHeader.font = lableHeader;
    lblHeader.textColor = [UIColor whiteColor];
    
    UIImageView *img1= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img1.image = [UIImage imageNamed:@"Password.png"];
    txtOldPwd.font = lableHeader;
    [txtOldPwd addSubview:img1];
    txtOldPwd.leftView = paddinglogintext;
    txtOldPwd.leftViewMode = UITextFieldViewModeAlways;
    txtOldPwd.placeholder = @"Enter old password";
    
    UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img2.image = [UIImage imageNamed:@"Password.png"];
    txtNewPwd.font = lableHeader;
    [txtNewPwd addSubview:img2];
    txtNewPwd.leftView = paddinglogintext;
    txtNewPwd.leftViewMode = UITextFieldViewModeAlways;
    txtNewPwd.placeholder = @"Enter new password";
    
    UIImageView *img3= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img3.image = [UIImage imageNamed:@"Password.png"];
    txtConfirmPwd.font = lableHeader;
    [txtConfirmPwd addSubview:img3];
    txtConfirmPwd.leftView = paddinglogintext;
    txtConfirmPwd.leftViewMode = UITextFieldViewModeAlways;
    txtConfirmPwd.placeholder = @"Confirm new password";
}

#pragma mark - textField Delegate
-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    if(textField == txtOldPwd){
        [txtNewPwd becomeFirstResponder];
    }
    else if (textField == txtNewPwd){
        [textField resignFirstResponder];
    }
    return  YES;
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
