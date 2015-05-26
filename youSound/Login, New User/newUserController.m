//
//  newUserController.m
//  youSound
//
//  Created by Akash on 5/30/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "newUserController.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import "CommonMethods.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"
#import "TermsandCondition.h"
#import "PrivacyPolicy.h"

@interface newUserController ()
{
    NSURL *urlFetchKey, *urlRegisterUser;
    NSMutableDictionary *dictEditData;
    NSMutableData *reqData;
    UIDatePicker *pickerView ;
    UIImagePickerController * picker;
    UIImage *imgbtnImage ;
    UIActionSheet *menu;
    UIImageView *imgRight;
    NSData *data1;
    
    IBOutlet UIButton *btnTC;
    IBOutlet UIButton *btnPrivacy;
    IBOutlet UIButton *btnImageView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *LeftNavigationBtn;
    IBOutlet UITextField *txtEmailID;
    IBOutlet UILabel *lblPrivacy;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtFullname;
    IBOutlet UITextField *txtBirthDate;
    IBOutlet UIButton *signUpBtn;
    IBOutlet UIDatePicker *dtPicker;
    IBOutlet UITextField *txtConfirmPWD;
}
@end

@implementation newUserController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Terms & Conditions"];
    NSMutableAttributedString *Privacytxt = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy"];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    [Privacytxt addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [Privacytxt length])];
    if (!IS_DEVICE_iPHONE_5)
    {
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        scrollView.scrollEnabled = true;
        lblPrivacy.frame = CGRectMake(17, 405, 281, 32);
        btnTC.frame = CGRectMake(80, 413, 120, 32);
        btnPrivacy.frame = CGRectMake(195, 413, 120, 32);
        signUpBtn.frame = CGRectMake(17, 445, 286, 30);
    }
    [btnTC setAttributedTitle: titleString forState:UIControlStateNormal];
    btnTC.titleLabel.textColor = privacyPolivy;
    btnTC.titleLabel.font =lblPrivacyPolicy;

    [btnPrivacy setAttributedTitle:Privacytxt forState:UIControlStateNormal];
    btnPrivacy.titleLabel.tintColor =privacyPolivy;
    btnPrivacy.titleLabel.font =lblPrivacyPolicy;
    
    lblPrivacy.font = lblPrivacyPolicy;
    lblPrivacy.textColor = [UIColor whiteColor];

    btnImageView.backgroundColor = [UIColor whiteColor];
    [btnImageView setBackgroundImage:[UIImage imageNamed:@"Blank Image.png"] forState:UIControlStateNormal];
    btnImageView.imageView.accessibilityIdentifier = @"Blank Image.png";
    btnImageView.layer.masksToBounds = YES;
    btnImageView.layer.cornerRadius = 43;
    btnImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    btnImageView.layer.borderWidth = 3.0;
    
    UIImage *temp = [UIImage imageNamed:@"Blank Image.png"];
    data1 = UIImagePNGRepresentation([CommonMethods scaleAndRotateImage:temp]);
    txtEmailID.leftView = paddinglogintext;
    UIImageView *img= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img.image = [UIImage imageNamed:@"Email ID.png" ];
    txtEmailID.font = lableHeader;
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
    
    UIImageView *img4= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img4.image = [UIImage imageNamed:@"Password.png"];
    txtConfirmPWD.secureTextEntry=YES;
    txtConfirmPWD.font = lableHeader;
    [txtConfirmPWD addSubview:img4];
    txtConfirmPWD.leftView = paddinglogintext;
    txtConfirmPWD.leftViewMode = UITextFieldViewModeAlways;
    txtConfirmPWD.placeholder = @"••••••••••";
    
    txtFullname.leftView = paddinglogintext;
    UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img2.image = [UIImage imageNamed:@"Full Name.png" ];
    txtFullname.font = lableHeader;
    [txtFullname addSubview:img2];
    txtFullname.leftViewMode = UITextFieldViewModeAlways;
    txtFullname.placeholder = @"Full Name";
    
    txtBirthDate.leftView = paddinglogintext;
    UIImageView *img3= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    imgRight= [[UIImageView alloc] initWithFrame:CGRectMake(250, 15, 20, 15)];
    imgRight.image = [UIImage imageNamed:@"DatePopup.png"];
    
    img3.image = [UIImage imageNamed:@"Birthday.png" ];
    [txtBirthDate addSubview:imgRight];
    txtBirthDate.font = lableHeader;
    [txtBirthDate addSubview:img3];
    txtBirthDate.leftViewMode = UITextFieldViewModeAlways;
    txtBirthDate.placeholder = @"Birth date";
}

#pragma mark-  TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txtEmailID){
        [txtPassword becomeFirstResponder];
    }
    else if (textField == txtPassword){
        [txtFullname becomeFirstResponder];
    }
    else if (textField == txtFullname){
        [self txtDateClick:nil];
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - txtDateClick
- (IBAction)txtDateClick:(id)sender {
    [txtBirthDate resignFirstResponder];
    [txtEmailID resignFirstResponder];
    [txtFullname resignFirstResponder];
    [txtPassword resignFirstResponder];
    if (IS_DEVICE_iPHONE_5)
    {
        [scrollView setContentOffset:CGPointMake(0,145) animated:YES];
    }
    else
    {
        [scrollView setContentOffset:CGPointMake(0,225) animated:YES];
    }
    double delayInSeconds = 0.2;//Second of delay
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        menu = [[UIActionSheet alloc] initWithTitle:@" "
        delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil
        otherButtonTitles:nil];
        
        // Add the picker
        pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        pickerView.datePickerMode = UIDatePickerModeDate;
        [menu addSubview:pickerView];
        [menu showInView:self.view];
        [menu setBounds:CGRectMake(0,0,320, 300)];
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -20, 320, 44)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [menu addSubview:pickerToolbar];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
        [barItems addObject:doneBtn];
        [pickerToolbar setItems:barItems animated:YES];
    });
}

#pragma mark - Picker Done CLick
-(void)pickerDone{
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    txtBirthDate.text = [dateFormat stringFromDate:pickerView.date];
    [menu dismissWithClickedButtonIndex:0 animated:TRUE];
    [self.view endEditing:YES];
    [txtBirthDate resignFirstResponder];
}

#pragma mark - Left Navigation
- (IBAction)LeftNavigationBtn_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Register user
- (IBAction)signUpBtn_Click:(id)sender {
    NSDictionary *dict = nil;
    dict = [NSDictionary dictionaryWithObjects:@[txtFullname.text, txtPassword.text,txtEmailID.text] forKeys:@[@"vFirstname", @"vPassword",@"vEmail"]];
    //ToCheck Field Is Valid ?
   if ([CommonMethods isValidTextFieldData:dict])
    {
        dictEditData = [NSMutableDictionary dictionaryWithObjects:@[txtFullname.text,@" ",txtEmailID.text, txtPassword.text,data1, txtBirthDate.text,@"IOS",[[NSUserDefaults standardUserDefaults] valueForKey:@"TokenKey"],@"0"] forKeys:@[@"vFirstname",@"vLastname",@"vEmail", @"vPassword",@"vImage",@"dDob",@"ePlatform",@"vDeviceToken",@"vFbID"]];
        
         //dictEditData = [NSMutableDictionary dictionaryWithObjects:@[txtFullname.text,@" ",txtEmailID.text, txtPassword.text,data1, txtBirthDate.text,@"IOS",@"sf",@"0"] forKeys:@[@"vFirstname",@"vLastname",@"vEmail", @"vPassword",@"vImage",@"dDob",@"ePlatform",@"vDeviceToken",@"vFbID"]];
        
        [self registerUser];
    }
}

#pragma mark - Register User WS
-(void)registerUser
{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    
    //prepare post data
    reqData = [NSMutableData data];
  
    reqData = [CommonMethods preparePostData:dictEditData];
    
    //prepare url
    urlRegisterUser = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/index"]];
    
    
    //ws call
    [[ServerCalls sharedObject] executeRequest:urlRegisterUser withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success){
                [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"iUserID"] forKey:@"iUserID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSDictionary *dictdata=[[NSDictionary alloc]initWithObjects:@[@"accesstoken"] forKeys:@[@"vMac"]];
                [[NSUserDefaults standardUserDefaults] setObject:dictdata forKey:@"accesstoken"];
                [self.navigationController popViewControllerAnimated:YES];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTripMatcher message:@"please check your email to validate your account." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];\
                [alert show];\
                alert.tag=103;
                [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:4];
               
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
-(void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101){
        [self clearAlltext];
    }
    if(alertView.tag == 102){
        [self clearAlltext];
    }
}

#pragma mark - Clear All Field
-(void)clearAlltext{
    txtBirthDate.text = nil;
    txtEmailID.text = nil;
    txtFullname.text = nil;
    txtPassword.text =nil;
    [btnImageView setBackgroundImage:[UIImage imageNamed:@"Blank Image.png"] forState:UIControlStateNormal];
    [txtEmailID becomeFirstResponder];
}

#pragma mark - Image Pick
- (IBAction)btnImageView_Click:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Gallery", @"Camera",nil];
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(popup.tag == 101)
    {
        if(buttonIndex == 0){
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }
        else if(buttonIndex == 1)
        {
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self pickerDone];
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - ImagePickerController Delegates
- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker1 dismissViewControllerAnimated:YES completion:nil];
    imgbtnImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imgbtnImage = [self imageWithImage:imgbtnImage scaledToSize:CGSizeMake(180, 180)];
    [btnImageView setBackgroundImage:imgbtnImage forState:UIControlStateNormal];
    data1 = UIImagePNGRepresentation([CommonMethods scaleAndRotateImage:imgbtnImage]);
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (IBAction)btnTC_Click:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 61)
    {
        TermsandCondition *terms = [[TermsandCondition alloc] initWithNibName:@"TermsandCondition" bundle:nil];
        [self.navigationController presentViewController:terms animated:YES completion:nil];
    }
    else
    {
        PrivacyPolicy *privacy = [[PrivacyPolicy alloc] initWithNibName:@"PrivacyPolicy" bundle:nil];
        [self.navigationController presentViewController:privacy animated:YES completion:nil];
    }
}
@end
