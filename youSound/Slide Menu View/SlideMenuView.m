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
#import "FriendProfile.h"
#import "editUserDetails.h"
#import "UIImageView+AFNetworking.h"
#import "BrowseListController.h"
#import "SettingController.h"
#import "LoginController.h"
#import "MZDownloadManagerViewController.h"

#import "LeftMenuCell.h"

@interface SlideMenuView ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{

    
    
    NSMutableData *reqData;
    NSURL *urllogoutUser;
    NSString *ProfileName,*imgurl;
    
    
    IBOutlet UIImageView *profileImgView;
    IBOutlet UIButton *BtnimageView;
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *labelName;
}

@property (strong, nonatomic) NSArray *mArray;
@end

@implementation SlideMenuView
static NSString *kCellIdentifier = @"CellIdentifier";

- (NSArray *)mArray
{
    
    if (!_mArray){
        _mArray = [[NSArray alloc] init];
        _mArray = @[
                    
                    @{ @"name"    : @"Home",
                       @"image"   : @"Home.png",
                       },
                    @{ @"name"    : @"Playlist",
                       @"image"   : @"PlayList.png",
                       },
                    @{ @"name"    : @"Friends",
                       @"image"   : @"Friends.png",
                       },
                    @{ @"name"    : @"Downloads",
                       @"image"   : @"Download.png",
                       },
                    @{ @"name"    : @"Settings",
                       @"image"   : @"Settings.png",
                       },
                    @{ @"name"    : @"Invite friends",
                       @"image"   : @"FriendProfile.png",
                       },
                    @{ @"name"    : @"Logout",
                       @"image"   : @"Logout.png",
                       }
                    
                    ];
    }
    return _mArray;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.view.frame andColors: BGCOLORS];
    
    
    profileImgView.backgroundColor = [UIColor whiteColor];
    profileImgView.layer.masksToBounds = YES;

    profileImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImgView.layer.borderWidth = 3.0f;
    
    tableview.allowsSelection = YES;
    
    [tableview registerNib:[UINib nibWithNibName:@"LeftMenuCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellIdentifier];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    
    tableview.rowHeight = UITableViewAutomaticDimension;
    tableview.estimatedRowHeight = 44.0;
    [tableview setShowsHorizontalScrollIndicator:NO];
    [tableview setShowsVerticalScrollIndicator:NO];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    profileImgView.layer.cornerRadius = profileImgView.frame.size.width/2;
    
    imgurl = [[NSUserDefaults standardUserDefaults] valueForKey:@"imgURL"];
    ProfileName = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    [profileImgView setImageWithURL:[NSURL URLWithString:imgurl]placeholderImage:[UIImage imageNamed:@"Blank Image.png"]];
    labelName.text = ProfileName;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(contentSizeCategoryChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

-(void)contentSizeCategoryChanged: (NSNotification *) notification {
    [tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArray.count;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftMenuCell *cell = (LeftMenuCell *)[tableview dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.mTitle.text = [self.mArray[indexPath.row] objectForKey:@"name"];
    
    UIImage *mImage = [UIImage imageNamed:[self.mArray[indexPath.row] objectForKey:@"image"]];
    
    [cell.mImage setImage:mImage];
    
    cell.mImage.contentMode = UIViewContentModeCenter;
    if (cell.mImage.bounds.size.width > mImage.size.width && cell.mImage.bounds.size.height > mImage.size.height) {
        cell.mImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = UIColorFromRGB(0x26bcd1);
    
    [cell setSelectedBackgroundView:bgColorView];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: //HOME
        {
            if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"BrowseListController"])
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            else
            {
                BrowseListController *listAll = [[BrowseListController alloc] initWithNibName:@"BrowseListController" bundle:nil];
                self.menuContainerViewController.centerViewController = listAll;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
            
        }
            break;
        case 1: //PLAYLIST
        {
            if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"PlayList"])
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            else
            {
                PlayList *playlist  = [[PlayList alloc] initWithNibName:@"PlayList" bundle:nil];
                self.menuContainerViewController.centerViewController = playlist;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
        }
            break;
        case 2: //FRIENDS
        {
            if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"MyFriendsList"])
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            else
            {
                MyFriendsList *friendList  = [[MyFriendsList alloc] initWithNibName:@"MyFriendsList" bundle:nil];
                self.menuContainerViewController.centerViewController = friendList;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
        }
            break;
        case 3:{//DOWNLOADS
            if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"MZDownloadManagerViewController"])
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            else
            {
                self.menuContainerViewController.centerViewController = appDelegate.objDownloadVC;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
        }
            break;
        case 4:{//SETTINGS
            if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"SettingController"])
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            else
            {
                SettingController *settingControl  = [[SettingController alloc] initWithNibName:@"SettingController" bundle:nil];
                self.menuContainerViewController.centerViewController = settingControl;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
        }
            break;
        case 5:{//Invite friends
            if([[self.menuContainerViewController.centerViewController nibName] isEqualToString:@"InviteFriendsController"])
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            else
            {
                InviteFriendsController *invite  = [[InviteFriendsController alloc] initWithNibName:@"InviteFriendsController" bundle:nil];
                self.menuContainerViewController.centerViewController = invite;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
        }
            break;
        case 6:{
            [self logout];
        }
        default:
            break;
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
