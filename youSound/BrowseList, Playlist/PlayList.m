//
//  PlayList.m
//  youSound
//
//  Created by Akash on 6/2/14.
//  Copyright (c) 2014 Akash. All rights reserved.

#import "Global.h"
#import "PlayList.h"
#import "MFSideMenu.h"
#import "SlideMenuView.h"
#import "MFSideMenuContainerViewController.h"
#import "ServerCalls.h"
#import "CommonMethods.h"
#import "NSObject+SBJson.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "GAViewController.h"
#import "AppDelegate.h"
#import "MZUtility.h"

@interface PlayList ()
{
    NSMutableArray *isLikeArr,*musicTrack;
    UIImageView *lineBar,*lineBar1,*lineBar2,*lineBar3,*lineBar4;
    UILabel *trackName,*byArtist,*timerLbl,*priceLbl;
    BOOL shouldLoadMore,IsInTravel,IsFromWS,isFromKingdom,isFromPalace,isFromTravel,isFromInnerCourt;
    UIImageView *cellImg;
    NSMutableArray *getAllData;
    NSMutableDictionary  *dictData;
    NSMutableData *reqData;
    NSURL *urlFetchtrack,*urlFetchSearchResults,*urlFavourite;
    NSNumber  *isLike,*arr_Size;
    UIActivityIndicatorView *spinner;
    IBOutlet UIButton *btnBadge;
    __weak IBOutlet UIButton *btnDownload;
    NSFileManager *fileManger;
    GAViewController *audioPlayer;
}
@end

@implementation PlayList


@synthesize LeftNavigationBtn,lblHeader,tableview,scrollView1,kingdomBtn,palacebtn,innerCourtbtn,Travel;

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    IsBuySong = false;
    isFromKingdom = true;
    IsFromBrowseList = false;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    // self.scrollView.contentSize = CGSizeMake(250, 550);
    if (!IS_DEVICE_iPHONE_5)
    {
        [tableview setContentInset:UIEdgeInsetsMake(0, 0, 85, 0)];
    }
    
    lblHeader.font = lableHeader;
    lblHeader.textColor = [UIColor whiteColor];
    
    self.scrollView1.contentSize = CGSizeMake(810, 35);
    self.scrollView1.scrollEnabled = YES;
    
    //Kingdom Button
    kingdomBtn.titleLabel.font = semiLightFontsize14;
    [kingdomBtn setTitleColor:SemiBlueColor forState:UIControlStateNormal];
    [scrollView1 addSubview:kingdomBtn];
    UIImageView *kingdomBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(1, 8, 20, 20)];
    kingdomBtnImg.backgroundColor = [UIColor whiteColor];
    kingdomBtnImg.image =[UIImage imageNamed:@"Kingdom.png"];
    lineBar = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 31, 82, 4)];
    lineBar.image = [UIImage imageNamed:@"Selected Button"];
    [kingdomBtn addSubview:lineBar];
    [kingdomBtn addSubview:kingdomBtnImg];
    
    //Palace Button
    palacebtn.titleLabel.font =  semiLightFontsize14;
    [palacebtn setTitleColor: SemiBlueColor forState:UIControlStateNormal];
    [scrollView1 addSubview:palacebtn];
    UIImageView *palaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 8, 20, 20)];
    palaceImg.backgroundColor = [UIColor whiteColor];
    palaceImg.image =[UIImage imageNamed:@"Palace.png"];
    lineBar1 = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 31, 73, 4)];
    lineBar1.image = [UIImage imageNamed:@"Selected Button"];
    
    [palacebtn addSubview:lineBar1];
    [palacebtn addSubview:palaceImg];
    
    //innerCourt Button
    innerCourtbtn.titleLabel.font =  semiLightFontsize14;
    [innerCourtbtn setTitleColor:SemiBlueColor forState:UIControlStateNormal];
    [scrollView1 addSubview:innerCourtbtn];
    UIImageView *innerCourtImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 8, 20, 20)];
    innerCourtImg.backgroundColor = [UIColor whiteColor];
    innerCourtImg.image =[UIImage imageNamed:@"Inner Court.png"];
    lineBar2 = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 31, 104, 4)];
    lineBar2.image = [UIImage imageNamed:@"Selected Button"];
    [innerCourtbtn addSubview:lineBar2];
    [innerCourtbtn addSubview:innerCourtImg];
    
    //Travel Button
    Travel.titleLabel.font =  semiLightFontsize14;
    [Travel setTitleColor:SemiBlueColor forState:UIControlStateNormal];
    [scrollView1 addSubview:Travel];
    UIImageView *travelImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 8, 20, 20)];
    travelImg.backgroundColor = [UIColor whiteColor];
    travelImg.image =[UIImage imageNamed:@"Travel.png"];
    lineBar3 = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 31, 182, 4)];
    lineBar3.image = [UIImage imageNamed:@"Selected Button"];
    [Travel addSubview:lineBar3];
    [Travel addSubview:travelImg];
    
    //Download Button
    btnDownload.titleLabel.font =  semiLightFontsize14;
    [btnDownload setTitleColor:SemiBlueColor forState:UIControlStateNormal];
    [scrollView1 addSubview:Travel];
    UIImageView *imgDownload = [[UIImageView alloc] initWithFrame:CGRectMake(2, 8, 20, 20)];
    imgDownload.backgroundColor = [UIColor whiteColor];
    imgDownload.image =[UIImage imageNamed:@"Download_menu.png"];
    lineBar4 = [[UIImageView alloc] initWithFrame:CGRectMake(-2, 31, 122, 4)];
    lineBar4.image = [UIImage imageNamed:@"Selected Button.png"];
    [btnDownload addSubview:lineBar4];
    [btnDownload addSubview:imgDownload];
    
    lineBar.hidden=false;
    lineBar1.hidden =YES;
    lineBar2.hidden =YES;
    lineBar3.hidden =YES;
    lineBar4.hidden = YES;
    
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", DictGetBadge] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBadge1:)
                                                 name:@"getBadge" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate getBadge1];
    
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
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    self.pageNo = 1;
    shouldLoadMore = YES;
    [self fetchDictData:self.pageNo playLstcharacter:@"k"];
}
-(void)getBadge1:(NSNotification *)dict1
{
    NSDictionary *userInfo = dict1.userInfo;
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", userInfo] forState:UIControlStateNormal];
}
#pragma mark - fetchDictData
-(void)fetchDictData:(int)pageNo playLstcharacter:(NSString *)chartxt{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    dictData = nil;
    NSString *pageIndex = [NSString stringWithFormat:@"%d",pageNo];
    dictData = [NSMutableDictionary dictionaryWithObjects:@[chartxt,pageIndex] forKeys:@[@"vType",@"page"]];
    [self fetchAllTracks:pageNo];
}

#pragma mark - Fetch All Track WS
-(void)fetchAllTracks:(int)page
{
    //[SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    IsFromWS = true;
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictData];
    if(IsInTravel == YES)
    {
        reqData = nil;
        urlFetchtrack = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/get_travel_data/format/json"]];
    }
    else
    {
        urlFetchtrack = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/playlist/index/format/json"]];
    }
    [[ServerCalls sharedObject] executeRequest:urlFetchtrack withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
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
                [[NSUserDefaults standardUserDefaults] setValue:[responseData valueForKey:@"data"] forKey:@"iUserID"];
                arr_Size = [responseData valueForKey:@"array_size"];
                
                if(page == 1)
                {
                    getAllData=[[NSMutableArray alloc]init];
                    getAllData = [responseData valueForKey:@"data"];
                }
                else
                {
                    if(isFromKingdom || isFromInnerCourt || isFromPalace || isFromTravel)
                    {
                        [getAllData addObjectsFromArray:[responseData valueForKey:@"data"]];
                    }
                }
                [tableview reloadData];
                [DictBrowselist setValue:getAllData forKeyPath:@"getAllDataDict"];
            }
            else{
                getAllData = nil;
                [tableview reloadData];
            }
        }
        [SVProgressHUD dismiss];
        [spinner stopAnimating];
    }];
}

#pragma mark - TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return getAllData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(IsFromWS == true){
        musicTrack = [getAllData valueForKey:@"vMusic"];
        isLike = [[getAllData objectAtIndex:indexPath.row]valueForKey:@"islike"];
        isLikeArr = [getAllData valueForKey:@"islike"];
        //cell.leftUtilityButtons = [self leftButtons];
    }
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HintViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
        // cell.leftUtilityButtons = [self leftButtons];
        cell.HintCellCorner.hidden = true;
        cell.HintlblPrice.hidden = true;
        cell.HintPriceImg.hidden = true;
    }
    CellDetails;
    if(IsFromWS == true){
        cell.HintIView.layer.cornerRadius = 5.0f;
        cell.HintIView.layer.borderWidth = 2.0;
        cell.HintIView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.HintIView.layer.masksToBounds = YES;
        cell.HintTrackName.text = [[getAllData objectAtIndex:indexPath.row] valueForKey:@"vMusicname"];
        cell.HintArtistName.text =[[getAllData objectAtIndex:indexPath.row] valueForKey:@"artistname"];
        cell.HintlblDuration.text =[[getAllData objectAtIndex:indexPath.row] valueForKey:@"vLength"];
        if([[[getAllData objectAtIndex:indexPath.row] valueForKey:@"bigthumbmusic"]  isEqual: @""]){
            [cell.HintIView setImageWithURL:[NSURL URLWithString:[[getAllData objectAtIndex:indexPath.row] valueForKey:@"albumimage"]]placeholderImage:[UIImage imageNamed:@"play-button.png"]];
        }else{
            [cell.HintIView setImageWithURL:[NSURL URLWithString:[[getAllData objectAtIndex:indexPath.row] valueForKey:@"bigthumbmusic"]]placeholderImage:[UIImage imageNamed:@"play-button.png"]];
        }
    }else{
        cell.HintTrackName.text = [[getAllData objectAtIndex:indexPath.row] stringByDeletingPathExtension];
        [cell.HintIView setImage:[UIImage imageNamed:@"play-button.png"]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Track;
     if(IsFromWS == true)
     {
        IsFromPlaylist = true;
        IsOffline=false;
        [DictBrowselist setValue:[[getAllData objectAtIndex:indexPath.row]valueForKey:@"bigthumbmusic"] forKey:@"userTrackImg"];
        [DictBrowselist setValue:[[getAllData objectAtIndex:indexPath.row]valueForKey:@"compressthumbmusic"] forKey:@"userTrackImgBig"];
        [DictBrowselist setValue:[[getAllData objectAtIndex:indexPath.row]valueForKey:@"vMusicname"] forKey:@"userTrackName"];
        [DictBrowselist setValue:[[getAllData objectAtIndex:indexPath.row]  valueForKey:@"artistname"] forKey:@"userArtistName"];
        
        [DictBrowselist setValue:isLikeArr forKey:@"userisLike"];
        isLike = [[getAllData objectAtIndex:indexPath.row]valueForKey:@"islike"];
        
        Track = [musicTrack objectAtIndex:indexPath.row];
        [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
        
        audioPlayer = [[GAViewController alloc]initWithSoundFiles:musicTrack atPath:Track andSelectedIndex:indexPath.row andisLike:isLike];
        //   [self.navigationController pushViewController:audioPlayer animated:YES];
    }
    else
    {
        
        /*NSURL *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         NSURL *getTrackPath = [directory URLByAppendingPathComponent:[getAllData objectAtIndex:indexPath.row]];
         
         //NSArray *arr= [self findFiles:@"mp3"];*/
        IsOffline=true;
        //IsFromPlaylist = true;
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *documentsDirectory = [pathArray objectAtIndex:0];
        Track = [documentsDirectory stringByAppendingPathComponent:[getAllData objectAtIndex:indexPath.row]];
        NSArray *arr = [documentsDirectory stringsByAppendingPaths:getAllData];
        [getAllData removeAllObjects];
        [getAllData addObjectsFromArray:arr];
        audioPlayer = [[GAViewController alloc]initWithSoundFiles:getAllData atPath:Track andSelectedIndex:indexPath.row andisLike:isLike];
    }
    [self.navigationController pushViewController:audioPlayer animated:YES];
}

#pragma mark - Swipe Cell Delegate
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
#pragma mark - Download Button Click
- (IBAction)btnDownload_Click:(id)sender {
    lineBar.hidden=YES;
    lineBar1.hidden =YES;
    lineBar2.hidden =YES;
    lineBar3.hidden =YES;
    lineBar4.hidden =false;
    IsFromWS = false;
    fileManger = [NSFileManager defaultManager];
    
    NSError *error;
    getAllData = [[fileManger contentsOfDirectoryAtPath:fileDest error:&error] mutableCopy];
    
    if([getAllData containsObject:@".DS_Store"])
        [getAllData removeObject:@".DS_Store"];
    [tableview reloadData];
}

#pragma mark - Kingdom Button Click
- (IBAction)kingdomBtn_Click:(id)sender {
    getAllData = nil;
    isFromKingdom = true;
    isFromPalace = false;
    isFromInnerCourt=false;
    isFromTravel = false;
    [self fetchDictData:1 playLstcharacter:@"k"];
    lineBar.hidden=false;
    lineBar1.hidden =YES;
    lineBar2.hidden =YES;
    lineBar3.hidden =YES;
    lineBar4.hidden =YES;
}

#pragma mark - Palace Button Click
- (IBAction)palacebtn_Click:(id)sender {
    getAllData = nil;
    isFromKingdom = false;
    isFromPalace = true;
    isFromInnerCourt=false;
    isFromTravel = false;
    [self fetchDictData:1 playLstcharacter:@"p"];
    lineBar.hidden=YES;
    lineBar1.hidden =false;
    lineBar2.hidden =YES;
    lineBar3.hidden =YES;
    lineBar4.hidden =YES;
}

#pragma mark - InnerCourt Button Click
- (IBAction)innerCourtbtn_Click:(id)sender {
    isFromKingdom = false;
    isFromInnerCourt=true;
    isFromTravel = false;
    isFromPalace = false;
    [self fetchDictData:1 playLstcharacter:@"i"];
    lineBar.hidden=YES;
    lineBar1.hidden =YES;
    lineBar2.hidden =false;
    lineBar3.hidden =YES;
    lineBar4.hidden =YES;
}

#pragma mark - Travel Button Click
- (IBAction)Travel_Click:(id)sender {
    isFromKingdom = false;
    isFromPalace =false;
    isFromInnerCourt=false;
    isFromTravel = true;

    IsInTravel = YES;
    [self fetchDictData:1 playLstcharacter:@"t"];
    lineBar.hidden=YES;
    lineBar1.hidden =YES;
    lineBar2.hidden =YES;
    lineBar3.hidden =false;
    lineBar4.hidden =YES;
}

#pragma mark - Navigation Buttons
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

#pragma  mark - ScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.tag != 101)
    {
        if ([arr_Size intValue] > getAllData.count )
        {
            ++self.pageNo;
            [spinner startAnimating];
            tableview.tableFooterView = spinner;
            shouldLoadMore = NO;
            if (isFromKingdom) {
                [self fetchDictData:self.pageNo playLstcharacter:@"k"];
            }else if(isFromPalace){
                [self fetchDictData:self.pageNo playLstcharacter:@"p"];
            }else if(isFromInnerCourt){
                [self fetchDictData:self.pageNo playLstcharacter:@"i"];
            }else if(isFromTravel){
                [self fetchDictData:self.pageNo playLstcharacter:@"t"];
            }
        }
    }
}
@end
