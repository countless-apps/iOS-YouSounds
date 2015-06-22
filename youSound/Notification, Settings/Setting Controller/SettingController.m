//
//  SettingController.m
//  youSound
//
//  Created by Akash on 6/3/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "SettingController.h"
#import "MFSideMenu.h"
#import "SlideMenuView.h"
#import "MFSideMenuContainerViewController.h"
#import "NotificationController.h"
#import "changePassword.h"
#import "HowToUse.h"
#import "TermsandCondition.h"
#import "PrivacyPolicy.h"
#import "SWTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "Global.h"

@interface SettingController ()<SWTableViewCellDelegate,MFMailComposeViewControllerDelegate>
{
    NSMutableArray *tblList,*imgList;
    IBOutlet UIButton *btnBadge;
    IBOutlet UITableView *tableview;
    IBOutlet UIButton *RightNavigationBtn;
    IBOutlet UIButton *LeftNavigationBtn;
    IBOutlet UILabel *lblHeader;
}
@end

@implementation SettingController

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect newFrame = self.view.frame;
    newFrame.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.view.frame = newFrame;
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.view.frame andColors: BGCOLORS];
    
    
    tableview.opaque = NO;
    tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    tableview.backgroundColor = [UIColor clearColor];
    tblList = [[NSMutableArray alloc] initWithObjects:
               @"Change Password",
               @"Rate Us",
               @"Send us Feedback",
               @"How to Use This App",
               @"Terms & Conditions",
               @"Privacy Policy",@"Game Notifocation",nil];
    imgList = [[NSMutableArray alloc] initWithObjects:
               @"Key.png",
               @"Rate US.png",
               @"feedback.png",
               @"How to use this App.png",
               @"Tearms@condition.png",
               @"lock.png",@"notification-icon.png", nil];
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", DictGetBadge ] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBadge1:)
                                                 name:@"getBadge" object:nil];
   IsFromSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsSwitch"];
    
    
}
-(void)getBadge1:(NSNotification *)dict1
{
    NSDictionary *userInfo = dict1.userInfo;
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", userInfo] forState:UIControlStateNormal];
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate getBadge1];
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", DictGetBadge] forState:UIControlStateNormal];
    IsFromSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsSwitch"];
    double delayInSeconds = 1.0;//Second of delay
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        
        if(DictGetBadge == NULL || [DictGetBadge isEqual:@"0"])
        {
            btnBadge.hidden = true;
        }
        else
        {
            btnBadge.hidden = false;
            [btnBadge setTitle:[NSString stringWithFormat:@"%@", DictGetBadge] forState:UIControlStateNormal];
        }
    });
}

#pragma mark - TableView Delegate Methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tblList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        if(indexPath.row == 6){
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
           // IsFromSwitch= true;
           // if(![[NSUserDefaults standardUserDefaults] boolForKey:@"IsSwitch"])
            if(IsFromSwitch == false)
            {
                [switchView setOn:YES animated:NO];
            }
            
            cell.accessoryView = switchView;
            
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//            switchView.tintColor = [UIColor redColor];
//            switchView.onTintColor = [UIColor greenColor];
        }
    }
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(10/255.0) alpha:0.1];
    
    cell.selectedBackgroundView = selectionColor;
    
    tableview.contentInset = UIEdgeInsetsMake(0, -15, 0, 0);
    tableview.separatorColor = [UIColor whiteColor];
    
    UIImageView *cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 22, 22)];
    cellImg.image = [UIImage imageNamed:[imgList objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:cellImg];
    
    UILabel *lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 30)];
    lblDetail.text = [tblList objectAtIndex:indexPath.row];
    lblDetail.font = lableHeader;
    lblDetail.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:lblDetail];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        changePassword *changePwd = [[changePassword alloc] initWithNibName:@"changePassword" bundle:nil];
        [self.navigationController presentViewController:changePwd animated:YES completion:nil];
    }
    else if (indexPath.row == 1)
    {
        UIAlertView *alertRateUs = [[UIAlertView alloc]initWithTitle:@"Rate YouSounds" message:@"If YouSounds useful for you, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!" delegate:self cancelButtonTitle:@"No, Thanks" otherButtonTitles:@"Rate It Now",@"Remind Me Later", nil];
        alertRateUs.tag = 301;
        [alertRateUs show];
    }
    else if(indexPath.row == 2)
    {
        [self setupEmail];
    }
    else if(indexPath.row == 3)
    {
        HowToUse *UseApp= [[HowToUse alloc] initWithNibName:@"HowToUse" bundle:nil];
        [self.navigationController presentViewController:UseApp animated:YES completion:nil];
    }
    else if(indexPath.row == 4)
    {
        TermsandCondition *Terms= [[TermsandCondition alloc] initWithNibName:@"TermsandCondition" bundle:nil];
        [self.navigationController presentViewController:Terms animated:YES completion:nil];
    }
    else if(indexPath.row == 5)
    {
        PrivacyPolicy *Policy= [[PrivacyPolicy alloc] initWithNibName:@"PrivacyPolicy" bundle:nil];
        [self.navigationController presentViewController:Policy animated:YES completion:nil];
    }
}

#pragma mark - Switch Method
- (void) switchChanged:(UISwitch *)sender
{
   // NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    if(sender.on)
    {
          IsFromSwitch = false;
    }
    else
    {
          IsFromSwitch = true;
    }
    [[NSUserDefaults standardUserDefaults] setBool:IsFromSwitch  forKey:@"IsSwitch"];
}
#pragma mark - AlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 301)
    {
        if (buttonIndex == 1)
        {
            [self OpenRateUsPage];
        }
        else
        {
            return;
        }
    }
}
#pragma mark - OpenRateUsPage
-(void)OpenRateUsPage
{
    NSURL *UrlRateUS = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? RateiOS7AppStoreURLFormat: RateiOSAppStoreURLFormat, APP_ID]];
    [[UIApplication sharedApplication] openURL:UrlRateUS];
}

#pragma mark - setupEmail
-(void) setupEmail{
    
    NSString *messageBody;
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@yousounds.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail]) {
        mc.mailComposeDelegate = self;
        [mc setSubject:@"Test mail"];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        [self presentViewController:mc animated:YES completion:NULL];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    UIAlertView *alert;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc] initWithTitle:@"Draft Saved" message:@"Composed Mail is saved in draft." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultSent:
            alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Mail sent successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Sorry! Failed to send." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigations
- (IBAction)LeftNavigationBtn_Click:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
- (IBAction)RightNavigationBtn_Click:(id)sender {
    NotificationController *notify = [[NotificationController alloc] initWithNibName:@"NotificationController" bundle:nil];
    
    SlideMenuView *leftSlideMenu = [[SlideMenuView alloc] initWithNibName:@"SlideMenuView" bundle:nil];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:notify
                                                    leftMenuViewController:leftSlideMenu
                                                    rightMenuViewController:nil];
    
    [self.navigationController pushViewController:container animated:YES];
}
@end
