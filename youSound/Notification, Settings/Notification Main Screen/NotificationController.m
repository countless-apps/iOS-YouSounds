//
//  NotificationController.m
//  youSound
//
//  Created by Akash on 6/3/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "Global.h"
#import "NotificationController.h"
#import "MFSideMenu.h"
#import "SlideMenuView.h"
#import "MFSideMenuContainerViewController.h"
#import "CommonMethods.h"
#import "SVProgressHUD.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"
#import "UIImageView+AFNetworking.h"
#import "HintViewController.h"
#import "SWTableViewCell.h"

@interface NotificationController ()<SWTableViewCellDelegate>
{
    NSMutableArray *dictGameData;
    NotificationController *notify;
    UIButton *btn,*accpetBtn,*DeclineBtn;
    NSMutableDictionary *dictEditdata;
    UILabel *friendName,*friendName1,*commonlbl,*samelbl,*rightSong,*hintlbl,*requestDescriptionlbl;
    UIImageView *clockImg,*cellImg;
    NSURL *urlGameData;
    NSMutableData *reqData;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *lblHeader;
    IBOutlet UITableView *tableview;
    IBOutlet UIButton *RightNavigationBtn;
    IBOutlet UIButton *LeftNavigationBtn;
    IBOutlet UISegmentedControl *segamentControll;
    BOOL temp;
    NSString *strTem;
}
@end

@implementation NotificationController

#pragma  mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!IsFromSwitch)
    {
        segamentControll.selectedSegmentIndex = 0;
        segamentControll.hidden = false;
        lblHeader.font = lableHeader;
        lblHeader.textColor = [UIColor whiteColor];
    }else
    {
         segamentControll.hidden = true;
        segamentControll.selectedSegmentIndex = 1;
        lblHeader.text = @"Friend's Request";
        lblHeader.font = lableHeader;
        lblHeader.textColor = [UIColor whiteColor];
    }
    scrollView.contentSize = CGSizeMake(250, 530);
    if (!IS_DEVICE_iPHONE_5)
    {
        [tableview setContentInset:UIEdgeInsetsMake(0, 0, 85, 0)];
    }
    temp = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [self fetchGameData];
}
#pragma mark - fetchGameData WS
-(void)fetchGameData
{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    dictGameData = nil;
    if(segamentControll.selectedSegmentIndex == 0){
        urlGameData = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/game/format/json"]];
    }
    
    else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        urlGameData = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/get_friend_request/format/json"]];
    }
    
    
    [[ServerCalls sharedObject] executeRequest:urlGameData withData:nil method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success){
                dictGameData =[responseData valueForKey:@"data"];
            }
            [tableview reloadData];
        }
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(segamentControll.selectedSegmentIndex == 1){
        return 55.0f;
    }else{
        return 90.0f;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(segamentControll.selectedSegmentIndex == 0){
        return [dictGameData count];
    }else{
        return [dictGameData count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    strTem = [[dictGameData objectAtIndex:indexPath.row] valueForKey:@"iUserID"];
    
    NSArray *nib;
    if(segamentControll.selectedSegmentIndex == 0){
        nib = [[NSBundle mainBundle] loadNibNamed:@"gameNotification" owner:self options:nil];
    }
    else{
        nib = [[NSBundle mainBundle] loadNibNamed:@"AcceptRequest" owner:self options:nil];
    }
    cell = [nib objectAtIndex:0];
    cell.delegate = self;
    
    if(segamentControll.selectedSegmentIndex == 0){
        cell.cellImg.layer.masksToBounds = YES;
        cell.cellImg.layer.cornerRadius = 29.0f;
        cell.cellImg.layer.borderWidth = 2.0f;
        cell.cellImg.layer.borderColor = [UIColor whiteColor].CGColor;
        
        cell.lblName.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
        cell.lblName.textColor = DarkColor;
        cell.lblCommon.font = CommonText;
        cell.lblCommon.textColor = DarkColor;
        cell.lblSame.font = CommonText;
        cell.lblSame.textColor = LiteColor;
        cell.lblGuess.font = CommonText;
        cell.lblGuess.textColor = LiteColor;
        cell.lblHint.font = lblPrivacyPolicy;
        
        cell.lblName.text = [[dictGameData objectAtIndex:indexPath.row] valueForKey:@"name"];
        //cell.lblCommon.text =[[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"name"] stringByAppendingString:@" and you have 80% music in common."];
        cell.lblSame.text =[[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"name"] stringByAppendingString:@" and you have the same taste in music."];
        cell.lblGuess.text = [[@"Guess the right song to know more about " stringByAppendingString:[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"name"]] stringByAppendingString:@" !!!"];
        cell.lblHint.text = [[dictGameData objectAtIndex:indexPath.row] valueForKey:@"hint"];
        
        cell.cellImg.backgroundColor = [UIColor whiteColor];
        if([[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"image"]  isEqual: @""]){
            cell.cellImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blank Image.png"]];
        }else{
            [cell.cellImg setImageWithURL:[NSURL URLWithString:[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"image"]]placeholderImage:[UIImage imageNamed:@"Blank Image.png"]];
        }
    }else{
        cell.lblName.font = semiLightFont16;
        cell.lblName.textColor = DarkColor;
        cell.lblSentRequestName.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
        cell.lblSentRequestName.textColor = LiteColor;
        
        cell.lblFname.text = [[dictGameData objectAtIndex:indexPath.row] valueForKey:@"vFirstname"];
        cell.lblSentRequestName.text = [[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"vFirstname"]stringByAppendingString:@" has send you Friend Request"];
        
        cell.RequestCellImg.layer.masksToBounds = YES;
        cell.RequestCellImg.layer.cornerRadius = 23.0f;
        cell.RequestCellImg.layer.borderWidth = 2.0f;
        cell.RequestCellImg.backgroundColor = [UIColor whiteColor];
        cell.RequestCellImg.layer.borderColor = [UIColor whiteColor].CGColor;
        
        if([[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"compressthumb"]  isEqual: @""]){
            cell.RequestCellImg.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Blank Image.png"]];
        }else{
            [cell.RequestCellImg setImageWithURL:[NSURL URLWithString:[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"compressthumb"]]placeholderImage:[UIImage imageNamed:@"Blank Image.png"]];
        }
        [cell.btnAccept addTarget:self action:@selector(RequestAccept:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnAccept.tag = 301;
        [cell.btnDenite addTarget:self action:@selector(RequestAccept:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDenite.tag = 302;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(segamentControll.selectedSegmentIndex == 0){
        // [[NSUserDefaults standardUserDefaults] setValue:[dictGameData objectAtIndex:indexPath.row]  forKeyPath:@"userProfileData"];
        [[NSUserDefaults standardUserDefaults] setValue:[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"iMusicID"] forKey:@"MusciID"];
        [[NSUserDefaults standardUserDefaults]  setValue:[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"iUserID"] forKey:@"FriendUserID"];
        [[NSUserDefaults standardUserDefaults]  setValue:[[dictGameData objectAtIndex:indexPath.row] valueForKey:@"album_id_new"] forKey:@"AlbumID"];
        
        HintViewController *hView = [[HintViewController alloc] initWithNibName:@"HintViewController" bundle:nil];
        [self.navigationController pushViewController:hView animated:YES];
    }
}
-(void)RequestAccept:(UIButton *)sender{
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    dictGameData = nil;
    reqData = [[NSMutableData alloc] init];
    dictEditdata = [NSMutableDictionary dictionaryWithObjects:@[strTem] forKeys:@[@"iFriendID"]];
    reqData = [CommonMethods preparePostData:dictEditdata];
    if(sender.tag == 301){
         urlGameData = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/acceptrequest/format/json"]];
    }else{
         urlGameData = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/decline_friend_request/format/json"]];
    }
    
    [[ServerCalls sharedObject] executeRequest:urlGameData withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            [self fetchGameData];
        }
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - navigations Button
- (IBAction)LeftNavigationBtn_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Swipe Cell
- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]] icon:[UIImage imageNamed:@"Delete.png"]];
    return leftUtilityButtons;
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}
- (IBAction)segamentControll_Click:(id)sender {
    if(segamentControll.selectedSegmentIndex == 0){
        lblHeader.text = @"Notification";
        [self fetchGameData];
    }
    else{
        lblHeader.text = @"Friend's Request";
        [self fetchGameData];
    }
}
@end
