//
//  FriendProfile.m
//  youSound
//
//  Created by Akash on 6/3/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "Global.h"
#import "FriendProfile.h"
#import "SlideMenuView.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "MyFriendsList.h"
#import "ServerCalls.h"
#import "CommonMethods.h"
#import "NSObject+SBJson.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "SWTableViewCell.h"
#import "GAViewController.h"

@interface FriendProfile()<SWTableViewCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIActivityIndicatorView *spinner;
    UIView *activityView;
    NSMutableArray *songsList,*userDataArr,*musicTrack,*isLikeArr;
    UILabel *trackName,*byArtist,*timerLbl,*priceLbl;
    NSMutableData *reqData;
    NSURL *urllastPurchase,*urlSendRequest;
    UIButton *btnTag;
    UIImagePickerController *picker;
    NSData *data1;
    UIImage *imgbtnImage ;
    NSString *imgurl ,*ProfileName,*struserID;
    NSMutableDictionary *dictEditData;
    IBOutlet UISegmentedControl *segamentControll;
    IBOutlet UILabel *lblHeader;
    IBOutlet UITextView *txtView;
    IBOutlet UILabel *birthlbl;
    IBOutlet UILabel *Name;
    IBOutlet UIButton *addBtn;
    IBOutlet UITableView *tableview;
    IBOutlet UIButton *BtnimageView;
    IBOutlet UIButton *LeftNavigationBtn;
    IBOutlet UIButton *RightNavigationBtn;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *profileImgView;
        NSNumber *isLike;
}
@end

@implementation FriendProfile


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma  mark - viewDidLoad
- (void)viewDidLoad
{
    IsBuySong = false;
    IsFromBrowseList=true;
    addBtn.enabled = true;
    [super viewDidLoad];
    if(IsFromMyFlist == YES){
        addBtn.hidden = true;
    }
    else{
        addBtn.hidden = false;
    }
    lblHeader.font = lableHeader;
    lblHeader.textColor = [UIColor whiteColor];
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    
    scrollView.contentSize = CGSizeMake(250, 330);
    
    if (!IS_DEVICE_iPHONE_5)
    {
        [tableview setContentInset:UIEdgeInsetsMake(0, 0, 85, 0)];
        
    }
    segamentControll.selectedSegmentIndex = 0;
    
    [self segament_Click:segamentControll];
}
-(void)viewDidAppear:(BOOL)animated{
       
    profileImgView.layer.masksToBounds = YES;
    profileImgView.backgroundColor = [UIColor whiteColor];
    profileImgView.layer.cornerRadius = 60;
    profileImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImgView.layer.borderWidth = 3.0f;
    
    Name.font = lableHeader;
    Name.textAlignment = NSTextAlignmentCenter;
    Name.textColor = [UIColor whiteColor];
    
    birthlbl.font =lableHeader;
    birthlbl.textAlignment = NSTextAlignmentCenter;
    birthlbl.textColor = [UIColor whiteColor];
    
}
-(void)setupView{
    
    [profileImgView setImageWithURL:[NSURL URLWithString:[userDataArr valueForKey:@"vImage"]]];
    
    Name.text = [userDataArr valueForKey:@"vFirstname"];
    
    NSString* dateString = [userDataArr valueForKey:@"dDob"];
    NSDateFormatter* firstDateFormatter = [[NSDateFormatter alloc] init] ;
    [firstDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [firstDateFormatter dateFromString:dateString];
    [firstDateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringDte = [firstDateFormatter stringFromDate:date];
    birthlbl.text = stringDte;
    
}
#pragma mark - TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [songsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    isLike = [[songsList objectAtIndex:indexPath.row]valueForKey:@"islike"];
    isLikeArr = [songsList valueForKey:@"islike"];

    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HintViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
        //cell.leftUtilityButtons = [self leftButtons];
        cell.HintCellCorner.hidden = true;
        cell.HintlblPrice.hidden = true;
        cell.HintPriceImg.hidden = true;
    }
    CellDetails;
    cell.HintIView.layer.cornerRadius     = 5.0f;
    cell.HintIView.layer.borderWidth = 2.0;
    cell.HintIView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.HintIView.layer.masksToBounds    = YES;
    cell.HintTrackName.text = [[songsList objectAtIndex:indexPath.row] valueForKey:@"vMusicname"];
    cell.HintArtistName.text =[[songsList objectAtIndex:indexPath.row] valueForKey:@"artistname"];
    cell.HintlblDuration.text =[[songsList objectAtIndex:indexPath.row] valueForKey:@"vLength"];
    
    if([[[songsList objectAtIndex:indexPath.row] valueForKey:@"bigthumbmusic"]  isEqual: @""]){
        [cell.HintIView setImageWithURL:[NSURL URLWithString:[[songsList objectAtIndex:indexPath.row] valueForKey:@"albumimage"]]placeholderImage:[UIImage imageNamed:@"play-button.png"]];
    }else{
        [cell.HintIView setImageWithURL:[NSURL URLWithString:[[songsList objectAtIndex:indexPath.row] valueForKey:@"bigthumbmusic"]]placeholderImage:[UIImage imageNamed:@"play-button.png"]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IsFromPlaylist = false;
    IsOffline=false;
    [DictBrowselist setValue:[[songsList objectAtIndex:indexPath.row]valueForKey:@"bigthumbmusic"] forKey:@"userTrackImg"];
    [DictBrowselist setValue:[[songsList objectAtIndex:indexPath.row]valueForKey:@"compressthumbmusic"] forKey:@"userTrackImgBig"];
    [DictBrowselist setValue:[[songsList objectAtIndex:indexPath.row]valueForKey:@"vMusicname"] forKey:@"userTrackName"];
    [DictBrowselist setValue:[[songsList objectAtIndex:indexPath.row]  valueForKey:@"artistname"] forKey:@"userArtistName"];
    [DictBrowselist setValue:isLikeArr forKey:@"userisLike"];
    isLike = [[songsList objectAtIndex:indexPath.row]valueForKey:@"islike"];
    
    NSString *track = [musicTrack objectAtIndex:indexPath.row];
    // [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    //Music Player
    GAViewController *audioPlayer = [[GAViewController alloc]initWithSoundFiles:musicTrack atPath:track andSelectedIndex:indexPath.row andisLike:isLike];
    
    [self.navigationController pushViewController:audioPlayer animated:YES];
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

#pragma mark - Navigation Buttons

- (IBAction)leftbtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Services
- (IBAction)segament_Click:(id)sender {
    NSDictionary *dictdata = nil;
    userDataArr = [[NSMutableArray alloc] init];
    struserID= [[NSUserDefaults standardUserDefaults]valueForKey:@"FriendID"];
    dictdata = [NSDictionary dictionaryWithObjects:@[struserID] forKeys:@[@"iFriendID"]];
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictdata];
   
    urllastPurchase = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/last_purchase_fav/format/json"]];
   
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
                songsList = nil;
                if(segamentControll.selectedSegmentIndex == 0){
                    songsList = [[responseData valueForKey:@"data"] valueForKey:@"favourite_tracks_of_friend"];
                    
                    musicTrack = [songsList valueForKey:@"samplemusicfav"];
                }
                else{
                    songsList = [[responseData valueForKey:@"data"] valueForKey:@"last_purchase_tracks_of_friend"];
                    
                    musicTrack = [songsList valueForKey:@"samplemusicpur"];
                }
                [DictBrowselist setValue:songsList forKeyPath:@"getAllDataDict"];
                userDataArr= [[responseData valueForKey:@"data"] valueForKey:@"user_data"];
            }
            else
            {
                songsList = nil;
                [tableview reloadData];
            }
        }
        [self setupView];
        [tableview reloadData];
        [SVProgressHUD dismiss];
        [spinner stopAnimating];
    }];
}

#pragma mark - Button Add Friend Request
- (IBAction)btnAdd_Click:(id)sender {
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    dictEditData = [NSMutableDictionary dictionaryWithObjects:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"FriendUserID"]] forKeys:@[@"iFriendID"]];
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictEditData];
    
    urlSendRequest = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/sendrequest/format/json"]];
    
    [[ServerCalls sharedObject] executeRequest:urlSendRequest withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success){
                addBtn.enabled = false;
            }
            else
            {
                NSString *strMessage = [responseData valueForKeyPath:@"MESSAGE"];
                ShowAlertWithTitle(@"Request", strMessage, @"OK");
                addBtn.enabled = false;
            }
        }
        [SVProgressHUD dismiss];
    }];
}
@end
