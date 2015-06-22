//
//  newUserController.m
//  youSound
//
//  Created by Akash on 5/30/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

#import "newUserController.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import "CommonMethods.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"
#import "TermsandCondition.h"
#import "PrivacyPolicy.h"

@interface newUserController ()  <TTTAttributedLabelDelegate>
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
    
    
    
    
    IBOutlet UIButton *btnImageView;
}


@property (weak, nonatomic) IBOutlet UIView *navBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagePickerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLogoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLogoBottom;


@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *birthdate;

@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, strong) NSDate *selectedDate;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *termsText;


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
    [self setupViews];
    
    self.selectedDate = [NSDate date];
    
    data1 = UIImagePNGRepresentation([CommonMethods scaleAndRotateImage:[UIImage imageNamed:@"Blank Image.png"]]);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    btnImageView.layer.cornerRadius = btnImageView.frame.size.width/2;
}


#pragma mark - txtDateClick
- (IBAction)txtDateClick:(id)sender {

    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1900];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];

}


- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    
    self.birthdate.text = [df stringFromDate:self.selectedDate];
}


#pragma mark - Left Navigation
- (IBAction)LeftNavigationBtn_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Register user
- (IBAction)signUpBtn_Click:(id)sender {
    NSDictionary *dict = nil;
    dict = [NSDictionary dictionaryWithObjects:@[self.fullName.text, self.password.text,self.emailAddress.text] forKeys:@[@"vFirstname", @"vPassword",@"vEmail"]];
    //ToCheck Field Is Valid ?
   if ([CommonMethods isValidTextFieldData:dict])
    {
        dictEditData = [NSMutableDictionary dictionaryWithObjects:@[self.fullName.text,@" ",self.emailAddress.text, self.password.text,data1, self.birthdate.text,@"IOS",[[NSUserDefaults standardUserDefaults] valueForKey:@"TokenKey"],@"0"] forKeys:@[@"vFirstname",@"vLastname",@"vEmail", @"vPassword",@"vImage",@"dDob",@"ePlatform",@"vDeviceToken",@"vFbID"]];
        
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
    self.birthdate.text = nil;
    self.emailAddress.text = nil;
    self.fullName.text = nil;
    self.password.text =nil;
    [btnImageView setBackgroundImage:[UIImage imageNamed:@"Blank Image.png"] forState:UIControlStateNormal];
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





-(void) setupViews{
    
    if(IS_IPHONE_4_OR_LESS){
        self.logoHeight.constant = 50;
        self.imagePickerHeight.constant = 64;
        self.verticalLogoTop.constant = 2;
        self.verticalLogoBottom.constant = 2;
    }
    else if(IS_IPHONE_5){
        self.logoHeight.constant = 73;
        self.imagePickerHeight.constant = 80;
    }
    
    
    btnImageView.backgroundColor = [UIColor whiteColor];
    [btnImageView setBackgroundImage:[UIImage imageNamed:@"Blank Image.png"] forState:UIControlStateNormal];
    btnImageView.imageView.accessibilityIdentifier = @"Blank Image.png";
    btnImageView.layer.masksToBounds = YES;
    btnImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    btnImageView.layer.borderWidth = 3.0;
    
    
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.view.frame andColors: BGCOLORS];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navBar
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:20]];
    
    
    self.emailAddress.leftViewMode = UITextFieldViewModeAlways;
    self.emailAddress.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Email ID.png"]];
    
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Password.png"]];
    
    self.fullName.leftViewMode = UITextFieldViewModeAlways;
    self.fullName.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Full Name.png"]];
    
    self.birthdate.leftViewMode = UITextFieldViewModeAlways;
    self.birthdate.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Birthday.png"]];
    
    self.termsText.lineBreakMode = NSLineBreakByWordWrapping;
    self.termsText.numberOfLines = 0;
    self.termsText.delegate = self;
    
    //By registering, You automatically agree to youSounds's Terms & Conditions and Privacy Policy
    
    [self.termsText setText:self.termsText.text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange termsRange = [[mutableAttributedString string] rangeOfString:@"Terms & Conditions" options:NSCaseInsensitiveSearch];
        NSRange privacyRange = [[mutableAttributedString string] rangeOfString:@"Privacy Policy" options:NSCaseInsensitiveSearch];
        
        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:12];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:termsRange];
            
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:privacyRange];
            CFRelease(font);
        }
        
        return mutableAttributedString;
    }];
    
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"terms"]];
    [self.termsText addLinkToURL:url1 withRange: [self.termsText.text rangeOfString:@"Terms & Conditions"]];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"privacy"]];
    [self.termsText addLinkToURL:url2 withRange: [self.termsText.text rangeOfString:@"Privacy Policy"]];
    
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    
    if([url.absoluteString isEqualToString:@"terms"]){
        TermsandCondition *terms = [[TermsandCondition alloc] initWithNibName:@"TermsandCondition" bundle:nil];
        [self.navigationController presentViewController:terms animated:YES completion:nil];
    }
    else if([url.absoluteString isEqualToString:@"privacy"]){
        PrivacyPolicy *privacy = [[PrivacyPolicy alloc] initWithNibName:@"PrivacyPolicy" bundle:nil];
        [self.navigationController presentViewController:privacy animated:YES completion:nil];
    }
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didLongPressLinkWithURL:(__unused NSURL *)url atPoint:(__unused CGPoint)point {
}
@end
