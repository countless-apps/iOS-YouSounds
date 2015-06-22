//
//  MyFriendsList.m
//  youSound
//
//  Created by Akash on 6/3/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "MyFriendsList.h"
#import "MFSideMenu.h"
#import "SlideMenuView.h"
#import "MFSideMenuContainerViewController.h"
#import "FriendProfile.h"
#import "SVProgressHUD.h"
#import "ServerCalls.h"
#import "UIImageView+AFNetworking.h"
#import "Global.h"
#import "NSObject+SBJson.h"
#import "SWTableViewCell.h"
#import "NotificationController.h"
#import "AppDelegate.h"

@interface MyFriendsList ()<SWTableViewCellDelegate>
{
    NSMutableArray *arrFilteredDashboard,*dictFriendData;
    UILabel *friendName,*trackslbl;
    NSURL *urlFriendData;
    
    BOOL isFiltered;
    
    IBOutlet UIButton *btnBadge;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *lblHeader;
    IBOutlet UITableView *tableview;
    IBOutlet UIButton *RightNavigationBtn;
    IBOutlet UIButton *LeftNavigationBtn;
    IBOutlet UITextField *txtSearch;
}
@end

@implementation MyFriendsList

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
       //self.scrollView.contentSize = CGSizeMake(250, 530);
    if (!IS_DEVICE_iPHONE_5)
    {
        [tableview setContentInset:UIEdgeInsetsMake(0, 0, 85, 0)];
        
    }
    lblHeader.font = lableHeader;
    lblHeader.textColor = [UIColor whiteColor];
    [self fetchFriendData];
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", DictGetBadge ] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBadge1:)
                                                 name:@"getBadge" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate getBadge1];
    double delayInSeconds = 1.0;//Second of delay
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if(DictGetBadge == NULL || [DictGetBadge isEqual:@"0"]){
            btnBadge.hidden = true;
        }else{
            btnBadge.hidden = false;
            [btnBadge setTitle:[NSString stringWithFormat:@"%@", DictGetBadge] forState:UIControlStateNormal];
        }
    });
}
-(void)getBadge1:(NSNotification *)dict1
{
    NSDictionary *userInfo = dict1.userInfo;
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", userInfo] forState:UIControlStateNormal];
}

#pragma mark - fetchGameData WS
-(void)fetchFriendData
{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    urlFriendData = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/get_friend_list/format/json"]];
    
    [[ServerCalls sharedObject] executeRequest:urlFriendData withData:nil method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success){
                   dictFriendData = [responseData valueForKey:@"data"];
            }
            else
            {
              /* NSString *strMessage = [responseData valueForKeyPath:@"MESSAGE"];
                    ShowAlertWithTitle(@"Error", strMessage, @"Retry");*/
            }
            [tableview reloadData];
        }
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView ||
        [arrFilteredDashboard count] > 0)
    {
        return arrFilteredDashboard.count;
    }
    else
    {
        return dictFriendData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.leftUtilityButtons = [self leftButtons];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyFriendListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
        //cell.leftUtilityButtons = [self leftButtons];
        cell.HintCellCorner.hidden = true;
        
        cell.imgFriend.layer.masksToBounds = YES;
        cell.imgFriend.layer.cornerRadius = 25.0;
        cell.imgFriend.backgroundColor = [UIColor whiteColor];
        cell.imgFriend.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.imgFriend.layer.borderWidth = 2.0;
        
        cell.lblFriendNm.font = semiLightFont16;
        cell.lblFriendNm.textColor = DarkColor;
        cell.lblTotalTrack.font = subtitleSemiLightFont;
        cell.lblTotalTrack.textColor =LiteColor;
    }
    if (tableView == self.searchDisplayController.searchResultsTableView ||
        [arrFilteredDashboard count] > 0)
    {
         cell.lblFriendNm.text = [[arrFilteredDashboard objectAtIndex:indexPath.row] valueForKey:@"vFirstname"];
         cell.lblTotalTrack.text = [@"Tracks "stringByAppendingString:[[arrFilteredDashboard objectAtIndex:indexPath.row] valueForKey:@"total_purchased_track"]];
        if([[[arrFilteredDashboard objectAtIndex:indexPath.row] valueForKey:@"compressthumb"]  isEqual: @""])
        {
            cell.imgFriend.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blank Image.png"]];
        }
        else
        {
            [cell.imgFriend setImageWithURL:[NSURL URLWithString:[[arrFilteredDashboard objectAtIndex:indexPath.row] valueForKey:@"compressthumb"]]placeholderImage:[UIImage imageNamed:@"Blank Image.png"]];
        }
    }
    else
    {
        cell.lblFriendNm.text = [[dictFriendData objectAtIndex:indexPath.row] valueForKey:@"vFirstname"];
        cell.lblTotalTrack.text = [@"Tracks "stringByAppendingString:[[dictFriendData objectAtIndex:indexPath.row] valueForKey:@"total_purchased_track"]];
        if([[[dictFriendData objectAtIndex:indexPath.row] valueForKey:@"compressthumb"]  isEqual: @""])
        {
             cell.imgFriend.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blank Image.png"]];
        }else
        {
            [cell.imgFriend setImageWithURL:[NSURL URLWithString:[[dictFriendData objectAtIndex:indexPath.row] valueForKey:@"compressthumb"]]placeholderImage:[UIImage imageNamed:@"Blank Image.png"]];
        }
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IsFromMyFlist = YES;
    [[NSUserDefaults standardUserDefaults] setValue:[[dictFriendData objectAtIndex:indexPath.row] valueForKey:@"iFriendID"] forKeyPath:@"FriendID"];
    FriendProfile *friednprofile = [[FriendProfile alloc] initWithNibName:@"FriendProfile" bundle:nil];
    
    [self.navigationController pushViewController:friednprofile animated:YES];
}

#pragma mark - Navigation Buttons
- (IBAction)LeftNavigationBtn_Click:(id)sender {
    [txtSearch resignFirstResponder];
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
#pragma mark - Swipe Cell
- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]] icon:[UIImage imageNamed:@"Remove Friend.png"]];
    return leftUtilityButtons;
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

#pragma mark - Textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)txtSearchEdit:(UITextField *)textField {
    
    NSString *text = textField.text;
    if (textField == txtSearch)
    {
        if(text.length == 0)
        {
            arrFilteredDashboard = nil;
            [tableview reloadData];
        }
        else
        {
            arrFilteredDashboard = [[NSMutableArray alloc] init];
            [self fetchSearchResult:text];
        }
    }
    
}
-(void)fetchSearchResult:(NSString *)strText
{
     NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"vFirstname contains[c] %@", strText];
    //arrFilteredDashboard = [[dictFriendData filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    arrFilteredDashboard = [NSMutableArray arrayWithArray:[dictFriendData filteredArrayUsingPredicate:resultPredicate]];;
    
    if(arrFilteredDashboard.count>0)
    {
        [tableview reloadData];
    }else
    {
        NSLog(@"No data");
    }
}
@end
