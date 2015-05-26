//
//  LoginController.m
//  youSound
//
//  Created by Akash on 5/30/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "LoginController.h"
#import "newUserController.h"
#import "BrowseListController.h"
#import "SlideMenuView.h"
#import "MFSideMenuContainerViewController.h"
#import "Global.h"
#import "ServerCalls.h"
#import "CommonMethods.h"
#import "NSObject+SBJson.h"
#import "SVProgressHUD.h"
#import "changePassword.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface LoginController ()
{
    NSURL *urlstr,*urlFetchKey,*urlloginUser;
    NSMutableDictionary *dictEditData;
    NSMutableData *reqData;
    UIButton *btn;
}

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@end

@implementation LoginController
@synthesize txtEmailID,txtPassword,btnFacebook,btnLogin,btnNewUser,lbliUserID,lblmusicID,

accountStore = _accountStore ,
facebookAccount = _facebookAccount;

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *myString = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
    if([myString  isEqual: @"1"]){
        [self displayView];
    }
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden=YES;
    
    // find the font family
  /*-  for (NSString* family in [UIFont familyNames])
     {
     NSLog(@"Font Family:%@ *******", family);
     
     for (NSString* name in [UIFont fontNamesForFamilyName: family])
     {
     NSLog(@"  %@", name);
     }
     }*/
    
    //Padding Spaces in to begining of cell
    UIImageView *img= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img.image = [UIImage imageNamed:@"Email ID.png" ];
    txtEmailID.font = lableHeader;
    txtEmailID.leftView = paddinglogintext;
    [txtEmailID addSubview:img];
    txtEmailID.leftViewMode = UITextFieldViewModeAlways;
    txtEmailID.placeholder = @"E-Mail address";
    
    UIImageView *img1= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img1.image = [UIImage imageNamed:@"Password.png"];
    txtPassword.secureTextEntry=YES;
    txtPassword.font = lableHeader;
    [txtPassword addSubview:img1];
    txtPassword.leftView = paddinglogintext;
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
    txtPassword.placeholder = @"••••••••••";
}

#pragma mark - TextField Delegate
-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    if(textField == txtEmailID)
    {
        [txtPassword becomeFirstResponder];
    }
    else if (textField == txtPassword)
    {
        [textField resignFirstResponder];
    }
    return  YES;
}

#pragma mark - New User Buttons Click Events
- (IBAction)btnNewUser_Click:(id)sender
{
    newUserController *newUser = [[newUserController alloc]initWithNibName:@"newUserController" bundle:nil];
    [self.navigationController pushViewController:newUser animated:YES];
}

#pragma mark - ForgotPWD Buttons Click Events
- (IBAction)btnForgotPwdClick:(id)sender
{
    ForgotPassword *forgotPWD = [[ForgotPassword alloc] init];
    [self.navigationController presentViewController:forgotPWD animated:YES completion:nil];
}

#pragma mark - Login
- (IBAction)btnLogin_Click:(id)sender {
    [txtPassword resignFirstResponder];
    btn = (UIButton *)sender;
    NSDictionary *dictData = nil;
    
    dictData = [NSDictionary dictionaryWithObjects:@[txtEmailID.text, txtPassword.text, @"IOS", [[NSUserDefaults standardUserDefaults] valueForKey:@"TokenKey"]] forKeys:@[@"vEmail",@"vPassword",@"ePlatform",@"vDeviceToken"]];
    //dictData = [NSDictionary dictionaryWithObjects:@[txtEmailID.text, txtPassword.text, @"IOS", @"sf"] forKeys:@[@"vEmail",@"vPassword",@"ePlatform",@"vDeviceToken"]];
    
    //ToCheck Field Is Valid ?
    if ([CommonMethods isValidTextFieldData:dictData])
    {
        dictEditData = [NSMutableDictionary dictionaryWithObjects:@[txtEmailID.text, txtPassword.text, @"IOS",[[NSUserDefaults standardUserDefaults] valueForKey:@"TokenKey"]] forKeys:@[@"vEmail", @"vPassword",@"ePlatform",@"vDeviceToken"]];
        //dictEditData = [NSMutableDictionary dictionaryWithObjects:@[txtEmailID.text, txtPassword.text, @"IOS",@"sf"] forKeys:@[@"vEmail", @"vPassword",@"ePlatform",@"vDeviceToken"]];
        
        [self loginUser:btn.tag];
    }
}

#pragma mark - Login User WS
-(void)loginUser:(int)btn1
{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictEditData];
    if(btn1 == 1){
        // Login
        urlloginUser = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/login/index/format/json"]];
    }
    else{
        // FB with Login
        urlloginUser = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/index"]];
    }
    
    //ws call
    [[ServerCalls sharedObject] executeRequest:urlloginUser withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
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
                [[NSUserDefaults standardUserDefaults] setValue:[responseData valueForKey:@"data"] forKey:@"SaveData"];
                NSDictionary *dictdata=[[NSDictionary alloc]initWithObjects:@[[[responseData valueForKey:@"data"] valueForKey:@"vHmac"], [[responseData valueForKey:@"data"] valueForKey:@"iUserID"]] forKeys:@[@"accesstoken", @"iUserID"]];
                
                if(btn1 == 1){
                    [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"vImage"]forKey:@"imgURL"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"vFirstname"]forKey:@"userName"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"dDob"] forKey:@"userBirthDate"];
                }
                [[NSUserDefaults standardUserDefaults] setObject:dictdata forKey:@"headerdict"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] boolForKey:@"Login"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Login"];
                
                if([[[responseData valueForKey:@"data"] valueForKey:@"temp_change_password"]  isEqual: @"1"]){
                    changePassword *cPWd = [[changePassword alloc] initWithNibName:@"changePassword" bundle:nil];
                    [self.navigationController presentViewController:cPWd animated:YES completion:nil];
                }else{
                    [self displayView];
                }
            }
            else
            {
                if(btn1 == 1){
                    NSString *strMessage = [responseData valueForKeyPath:@"MESSAGE"];
                    ShowAlertWithTitle(@"Log in failed", strMessage, @"Retry");
                }
                else{
                    [[NSUserDefaults standardUserDefaults] setValue:[responseData valueForKey:@"data"] forKey:@"SaveData"];
                    NSDictionary *dictdata=[[NSDictionary alloc]initWithObjects:@[[[responseData valueForKey:@"data"] valueForKey:@"vHmac"], [[responseData valueForKey:@"data"] valueForKey:@"iUserID"]] forKeys:@[@"accesstoken", @"iUserID"]];
                    
                    if(btn1 == 1){
                        [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"vImage"]forKey:@"imgURL"];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"vFirstname"]forKey:@"userName"];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"dDob"] forKey:@"userBirthDate"];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dictdata forKey:@"headerdict"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSUserDefaults standardUserDefaults] boolForKey:@"Login"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Login"];
                    
                    [self displayView];
                }
            }
        }
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Fb Register
- (IBAction)btnFb_Click:(id)sender {
    [txtEmailID resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    btn = (UIButton *)sender;
    
    if(!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSArray *fbAccounts =[[NSArray alloc]init];
    fbAccounts= [_accountStore accountsWithAccountType:facebookTypeAccount];
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] ) {
        
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"There is no facebook account set in setting. please go to settings > Facebook and setup your Facebook account." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alt show];
        return;
    }
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    NSArray *permissions = [NSArray arrayWithObjects:@"email",@"user_birthday", nil];
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"609370442503573", ACFacebookAppIdKey,permissions , ACFacebookPermissionsKey,nil];
    
    [_accountStore requestAccessToAccountsWithType:facebookTypeAccount  options:options
                                        completion:^(BOOL granted, NSError *error)
     {
         if(granted)
         {
             NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
             _facebookAccount = [accounts lastObject];
             
             [_accountStore renewCredentialsForAccount:_facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                 //we don't actually need to inspect renewResult or error.
                 if (error)
                 {
                     NSLog(@"ERROR:%@",error);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [SVProgressHUD dismiss];
                     });
                 }
             }];
             NSLog(@"Success");
             [self FB_Detail:btn.tag];
         }
         else
         {
             NSLog(@"User IS Denied Permission");
             NSLog(@"Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
             });
         }
     }];
    
}
-(void)FB_Detail:(int)btn1
{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET URL:meurl   parameters:nil];
    merequest.account = _facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         NSDictionary *user = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
         
         if (user!=nil)
         {   NSString *str;
             dictEditData = nil;
             if([user objectForKey:@"birthday"] == nil){
                 str = @" ";
             }
             else{
                 str = [user objectForKey:@"birthday"];
             }
             dictEditData = [NSMutableDictionary dictionaryWithObjects:@[
                    [user objectForKey:@"first_name"],
                    [user objectForKey:@"last_name"],
                     @" ",
                     @" ",
                    str,
                    @"IOS",
                    [[NSUserDefaults standardUserDefaults] valueForKey:@"TokenKey"],
                    [user objectForKey:@"id"]]
                    forKeys:
                     @[@"vFirstname",
                       @"vLastname",
                       @"vEmail",
                       @"vPassword",
                       @"dDob",
                       @"ePlatform",
                       @"vDeviceToken",
                       @"vFbID",]];
             
             NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectForKey:@"id"]];
             
             [[NSUserDefaults standardUserDefaults] setValue:userImageURL forKey:@"imgURL"];
             [[NSUserDefaults standardUserDefaults] setValue:[user objectForKey:@"first_name"] forKey:@"userName"];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self loginUser:btn1];
             });
         }
         else
         {
             NSLog(@"No User detail Found from facebook");
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
             });
         }
     }];
}
#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101){
        txtEmailID.text = nil;
        txtPassword.text = nil;
        [txtEmailID becomeFirstResponder];
    }
    if(alertView.tag == 103){
        switch (buttonIndex) {
            case 0:
            {
                [self displayView];
            }
                break;
            case 1:{
                
                changePassword *cPWd = [[changePassword alloc] initWithNibName:@"changePassword" bundle:nil];
                [self.navigationController presentViewController:cPWd animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
        
    }
}

#pragma  mark - DisplayView
-(void) displayView
{
    [SVProgressHUD dismiss];
    BrowseListController *listAllsong = [[BrowseListController alloc] initWithNibName:@"BrowseListController" bundle:nil];
    
    SlideMenuView *leftSlideMenu = [[SlideMenuView alloc] initWithNibName:@"SlideMenuView" bundle:nil];
    
    MFSideMenuContainerViewController *container =
    [MFSideMenuContainerViewController containerWithCenterViewController:listAllsong
                                                  leftMenuViewController:leftSlideMenu
                                                 rightMenuViewController:nil];
    
    
    UINavigationController *navigation = ((AppDelegate*)[[UIApplication sharedApplication]delegate]).navigation;
    navigation = [[UINavigationController alloc] initWithRootViewController:container];
    
    navigation.view.alpha = 0.0;
    ((AppDelegate*)[[UIApplication sharedApplication]delegate]).window.rootViewController = navigation;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         navigation.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    navigation.navigationBarHidden=YES;
}
@end
