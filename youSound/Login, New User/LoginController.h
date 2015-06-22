//
//  LoginController.h
//  youSound
//
//  Created by Akash on 5/30/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgotPassword.h"
#import "AppDelegate.h"

@interface LoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtEmailID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNewUser;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPwd;
@property (retain, nonatomic) NSString *lbliUserID;
@property (retain, nonatomic) NSString *lblmusicID;

@end
