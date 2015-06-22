//
//  editUserDetails.m
//  youSound
//
//  Created by Akash on 7/12/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "editUserDetails.h"
#import "NotificationController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "SlideMenuView.h"
#import "CommonMethods.h"
#import "SVProgressHUD.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"
#import "UIImageView+AFNetworking.h"
#import "Global.h"

@interface editUserDetails ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UIImagePickerController *picker;
    UIImage *imgbtnImage;
    NSData *data1;
    UIImageView *imgRight, *temp1;
    UIDatePicker *pickerView;
    UIActionSheet *menu;
    NSString *imgurl ;
    NSMutableData *reqData;
    NSURL *urllastPurchase;
   
    BOOL temp;
    
    IBOutlet UIImageView *profileImgView;
    IBOutlet UILabel *lblHeader;
    IBOutlet UIButton *btnBack;
    IBOutlet UITextField *txtEmailID;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtFullname;
    IBOutlet UITextField *txtBirthDate;
    IBOutlet UIButton *updateBtn;
    IBOutlet UIButton *btnImage;
    IBOutlet UIScrollView *scrollView;
    
}
@end

@implementation editUserDetails

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];

    [scrollView addGestureRecognizer:singleTap];
   
    NSDictionary *tempData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SaveData"];
   
    txtEmailID.leftView = paddinglogintext;
    UIImageView *img= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img.image = [UIImage imageNamed:@"Email ID.png" ];
    txtEmailID.font = lableHeader;
    [txtEmailID addSubview:img];
    txtEmailID.leftViewMode = UITextFieldViewModeAlways;
    txtEmailID.enabled = NO;
    txtEmailID.alpha = 0.7;
    txtEmailID.text = [tempData valueForKey:@"vEmail"];
    if([txtEmailID.text  isEqualToString: @" "]){
        txtEmailID.text = @"Facebook Login";
    }
   
    txtFullname.leftView = paddinglogintext;
    txtFullname.text = @"";
    UIImageView *img2= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    img2.image = [UIImage imageNamed:@"Full Name.png" ];
    txtFullname.font = lableHeader;
    [txtFullname addSubview:img2];
    txtFullname.leftViewMode = UITextFieldViewModeAlways;
    txtFullname.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    
    txtBirthDate.leftView = paddinglogintext;
    UIImageView *img3= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    imgRight= [[UIImageView alloc] initWithFrame:CGRectMake(250, 15, 20, 15)];
    imgRight.image = [UIImage imageNamed:@"DatePopup.png"];
    img3.image = [UIImage imageNamed:@"Birthday.png" ];
    [txtBirthDate addSubview:imgRight];
    txtBirthDate.font = lableHeader;
    [txtBirthDate addSubview:img3];
    txtBirthDate.leftViewMode = UITextFieldViewModeAlways;
  
    
    lblHeader.font = lableHeader;
    lblHeader.textColor = [UIColor whiteColor];
   
    temp = false;
   
    imgurl = [[NSUserDefaults standardUserDefaults] valueForKey:@"imgURL"];
    profileImgView.layer.masksToBounds = YES;
    profileImgView.layer.cornerRadius = 60;
    profileImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImgView.layer.borderWidth = 3.0f;
    profileImgView.backgroundColor = [UIColor whiteColor];
    [profileImgView setImageWithURL:[NSURL URLWithString:imgurl]];
}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [txtFullname resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
}
-(void) viewDidAppear:(BOOL)animated{
    NSString* dateString = [[NSUserDefaults standardUserDefaults] valueForKey:@"userBirthDate"];
    NSDateFormatter* firstDateFormatter = [[NSDateFormatter alloc] init] ;
    [firstDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [firstDateFormatter dateFromString:dateString];
    [firstDateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringDte = [firstDateFormatter stringFromDate:date];
    txtBirthDate.text = stringDte;
    if(temp){
        profileImgView.image = imgbtnImage ;
    }else{
        [profileImgView setImageWithURL:[NSURL URLWithString:imgurl]];
        data1 = UIImagePNGRepresentation([CommonMethods scaleAndRotateImage:profileImgView.image]);
    }
    [SVProgressHUD dismiss];
}
#pragma mark-  TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtFullname){
        [self txtDateClick:nil];
    }
    [textField resignFirstResponder];
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self pickerDone];
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - txtDateClick
- (IBAction)txtDateClick:(id)sender {
    [txtBirthDate resignFirstResponder];
    [txtFullname resignFirstResponder];
    [txtPassword resignFirstResponder];
    BOOL isDeviceiPhone5 = ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height>=568.0f));
    if (isDeviceiPhone5)
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
-(void)pickerDone{
    [txtBirthDate resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    txtBirthDate.text = [dateFormat stringFromDate:pickerView.date];
    [menu dismissWithClickedButtonIndex:0 animated:TRUE];
}

#pragma mark - Navigation Buttons
- (IBAction)btnBack_Click:(id)sender {
   // [txtFullname resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Update Button
- (IBAction)updateBtn_Click:(id)sender{
    [txtFullname resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    [self updateWS];
}
#pragma mark - updateWS
-(void)updateWS{

    NSDictionary *dictdata = nil;
   // NSDictionary *tempData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SaveData"];
   
    //data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]];
    dictdata = [NSMutableDictionary dictionaryWithObjects:@[txtFullname.text,@" ",txtEmailID.text, data1, txtBirthDate.text,@"IOS",@"DFSD"] forKeys:@[@"vFirstname",@"vLastname",@"vEmail",@"vImage",@"dDob",@"ePlatform",@"vDeviceToken"]];
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictdata];
    
    urllastPurchase = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/edit/format/json"]];
    
    [[ServerCalls sharedObject] executeRequest:urllastPurchase withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
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
                temp1 = [[UIImageView alloc] init];
                NSURL *imgURL = [NSURL URLWithString:[[responseData valueForKey:@"data"] valueForKey:@"vImage"]];
                [temp1 setImageWithURL:imgURL];
                
                [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"vImage"]forKey:@"imgURL"];
          
                [[NSUserDefaults standardUserDefaults] setValue:txtFullname.text forKey:@"userName"];
                
                [[NSUserDefaults standardUserDefaults] setValue:[[responseData valueForKey:@"data"] valueForKey:@"dDob"] forKey:@"userBirthDate"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTripMatcher message:@"Profile update successfully" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];\
                [alert show];\
                alert.tag=103;
                [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3.5];
            }else
            {
            }
        }
        [SVProgressHUD dismiss];
    }];

}
-(void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
}
#pragma mark - Button Image
- (IBAction)btnImage_Click:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Gallery", @"Camera",nil];
    actionSheet.tag = 101;
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(popup.tag == 101){
        if(buttonIndex == 0){
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];
        }else if(buttonIndex == 1){
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

#pragma mark - ImagePickerController Delegates
- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    temp = true;
    [picker1 dismissViewControllerAnimated:YES completion:nil];
    imgbtnImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imgbtnImage = [self imageWithImage:imgbtnImage scaledToSize:CGSizeMake(100 , 100)];
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

@end
