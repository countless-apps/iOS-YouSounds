//
//  SlideMenuView.m
//  AudioPlayer
//
//  Created by Akash on 5/27/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "SlideMenuView.h"
#import "MFSideMenu.h"
#import "PlayList.h"
#import "MyFriendsList.h"
#import "NotificationController.h"
#import "InviteFriendsController.h"
#import "Global.h"
#import "ServerCalls.h"
#import "CommonMethods.h"
#import "NSObject+SBJson.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "FriendProfile.h"
#import "editUserDetails.h"
#import "UIImageView+AFNetworking.h"
#import "SWTableViewCell.h"
#import "BrowseListController.h"
#import "SettingController.h"
#import "LoginController.h"
#import "MZDownloadManagerViewController.h"

@interface SlideMenuView ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    NSMutableArray *tblList,*imgList ;
    NSMutableData *reqData;
    NSURL *urllogoutUser;
    NSString *ProfileName,*imgurl;
    
    IBOutlet UIImageView *profileImgView;
    IBOutlet UIButton *BtnimageView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *labelName;
}
@end

@implementation SlideMenuView

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    profileImgView.backgroundColor = [UIColor whiteColor];
    profileImgView.layer.masksToBounds = YES;
    profileImgView.layer.cornerRadius = 70.0;
    profileImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImgView.layer.borderWidth = 3.0f;
    
    labelName.font = lableHeader;
    labelName.textAlignment = NSTextAlignmentCenter;
    labelName.textColor = [UIColor whiteColor];
    
    scrollView.contentSize = CGSizeMake(285, 650);
    if (IS_DEVICE_iPHONE_5)
    {
        scrollView.scrollEnabled = NO;
    }
    else
    {
        scrollView.scrollEnabled = YES;
    }
    tableview.opaque = NO;
    tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    tableview.backgroundColor = [UIColor clearColor];
    
    tblList = [[NSMutableArray alloc]initWithObjects:
               @"Home",
               @"Playlist",
               @"Friends",
               @"Downloads",
               @"Settings",
               @"Invite friends",
               @"Logout", nil];
    imgList = [[NSMutableArray alloc] initWithObjects:
               @"Home.png",
               @"PlayList.png",
               @"Friends.png",
               @"Download.png",
               @"Settings.png",
               @"FriendProfile.png",
               @"Logout.png", nil];
}
-(void)viewWillAppear:(BOOL)animated{
    imgurl = [[NSUserDefaults standardUserDefaults] valueForKey:@"imgURL"];
    ProfileName = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    [profileImgView setImageWithURL:[NSURL URLWithString:imgurl]placeholderImage:[UIImage imageNamed:@"Blank Image.png"]];
    labelName.text = ProfileName;
}
#pragma mark - TableView Delegate
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
    }
    cell.tag = indexPath.row;
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(10/255.0) alpha:0.1];
    
    cell.selectedBackgroundView = selectionColor;
    
    UIImageView *accessoryImg = [[UIImageView alloc] initWithFrame:CGRectMake(260, 20, 12, 12)];
    accessoryImg.image = [UIImage imageNamed:@"Cell Accesory.png"];
    [cell.contentView addSubview:accessoryImg];
    
    tableview.contentInset = UIEdgeInsetsMake(0, -15, 0, 0);
    tableview.separatorColor = [UIColor whiteColor];
    
    UIImageView *cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 22, 22)];
    cellImg.image = [UIImage imageNamed:[imgList objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:cellImg];
    
    UILabel *lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 120, 30)];
    lblDetail.font = lableHeader;
    lblDetail.textColor = [UIColor whiteColor];
    lblDetail.text = [tblList objectAtIndex:indexPath.row];
    [cell.contentView addSubview:lblDetail];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row == 0) {
       
        if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"BrowseListController"])
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        else
        {
            BrowseListController *listAll = [[BrowseListController alloc] initWithNibName:@"BrowseListController" bundle:nil];
            self.menuContainerViewController.centerViewController = listAll;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }else if (indexPath.row == 1){
                
          if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"PlayList"])
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        else
        {
            PlayList *playlist  = [[PlayList alloc] initWithNibName:@"PlayList" bundle:nil];
            self.menuContainerViewController.centerViewController = playlist;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
    else if (indexPath.row == 2){
        
        if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"MyFriendsList"])
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        else
        {
            MyFriendsList *friendList  = [[MyFriendsList alloc] initWithNibName:@"MyFriendsList" bundle:nil];
            self.menuContainerViewController.centerViewController = friendList;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
    else if (indexPath.row == 3){
        if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"MZDownloadManagerViewController"])
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        else
        {
            self.menuContainerViewController.centerViewController = appDelegate.objDownloadVC;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
    else if (indexPath.row == 4){
        
        if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"SettingController"])
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        else
        {
            SettingController *settingControl  = [[SettingController alloc] initWithNibName:@"SettingController" bundle:nil];
            self.menuContainerViewController.centerViewController = settingControl;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
    else if (indexPath.row == 5){
        
        if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"InviteFriendsController"])
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        else
        {
            InviteFriendsController *invite  = [[InviteFriendsController alloc] initWithNibName:@"InviteFriendsController" bundle:nil];
            self.menuContainerViewController.centerViewController = invite;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
    else if (indexPath.row == 6){
       
        [self logout];
    }
}
#pragma mark - Logout Web Service
-(void)logout
{
    [player pause];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Login"];
    
    NSString *userID= [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SaveData"] valueForKey:@"iUserID"];
    
    NSDictionary *dictdata = nil;
    dictdata = [NSDictionary dictionaryWithObjects:@[userID] forKeys:@[@"iUserID"]];
    
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictdata];
    
    //prepare url
    urllogoutUser = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/logout/index/format/json"]];
    
    //ws call
    [[ServerCalls sharedObject] executeRequest:urllogoutUser withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
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
            {}
            else
            {}
        }
        [SVProgressHUD dismiss];
    }];
    LoginController *login = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    
    UINavigationController *navigation = ((AppDelegate*)[[UIApplication sharedApplication]delegate]).navigation;
    navigation = [[UINavigationController alloc] initWithRootViewController:login];
    ((AppDelegate*)[[UIApplication sharedApplication]delegate]).window.rootViewController = navigation;
    
    navigation.view.alpha = 0.0;
    ((AppDelegate*)[[UIApplication sharedApplication]delegate]).window.rootViewController = navigation;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         navigation.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}
- (IBAction)btnImage_Click:(id)sender {
    editUserDetails *edit = [[editUserDetails alloc] initWithNibName:@"editUserDetails" bundle:nil];
    [self.navigationController presentViewController:edit animated:YES completion:nil];
}
@end
