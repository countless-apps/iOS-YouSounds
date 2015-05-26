//
//  BrowseListController.m
//  youSound
//
//  Created by Akash on 5/31/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "BrowseListController.h"
#import "MFSideMenu.h"
#import "SlideMenuView.h"
#import "MFSideMenuContainerViewController.h"
#import "PlayList.h"
#import "ServerCalls.h"
#import "CommonMethods.h"
#import "NSObject+SBJson.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "GAViewController.h"
#import "Global.h"
#import "InviteFriendsController.h"
#import "RageIAPHelper.h"
#import "AppDelegate.h"
#import "BrowseListCell.h"
#import "OurServiceObject.h"
#import <Social/Social.h>

@interface BrowseListController () <UIActionSheetDelegate>
{
    NSMutableArray *musicTrack,*musicID,*isLikeArr,*leftUtilityButtons, *getData,*checkedArray,*arrFilteredDashboard, *sharingItems;;
    NSMutableDictionary  *dictData,*dictData1;
    NSMutableData *reqData;
    NSURL *urlFetchtrack,*urlFetchSearchResults,*urlFavourite;
    NSString *text, *productIdenity, *productTitle,*productPrice,*anOffer,*priceTag, *errorMsg, *userName, *strTrackName;
    NSNumber *arr_Size,*isLike;
    UIActivityIndicatorView *spinner;
    NSArray *_products, *availableServices;
    SWTableViewCell *cell;
    UIButton *btnSelectTrack;
    NSUInteger SelectedIndex;
    IBOutlet UIButton *btnBadge;
    BOOL isFiltered,shouldLoadMore, isFavourite, isAnOffer;
    
    IBOutlet UIButton * bringUpComposeViewButton;
}
@end

@implementation BrowseListController

@synthesize txtSearch,lblHeader,tableview,LeftNavigationBtn,RightNavigationBtn;

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bringUpComposeViewButton.layer.cornerRadius = 7.0;
    
    IsBuySong = true;
    IsFromBrowseList= true;
    isAnOffer = true;
    IsInAppBrowse = true;
    IsInAppHint = false;
    IsInAppMusic = false;
    
    DictBrowselist = [[NSMutableDictionary alloc]init];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    lblHeader.font = lableHeader;
    lblHeader.textColor = [UIColor whiteColor];
    
    if (!IS_DEVICE_iPHONE_5)
    {
        [tableview setContentInset:UIEdgeInsetsMake(0, 0, 85, 0)];
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBadge1:)
                                                 name:@"getBadge" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    sharingItems = [[NSMutableArray alloc] init];
}

-(void)getBadge1:(NSNotification *)dict1
{
    NSDictionary *userInfo = dict1.userInfo;
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", userInfo] forState:UIControlStateNormal];
}

- (void)reload {
    _products = nil;
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = nil;
            _products = products;
            //             for (SKProduct * skProduct in products) {
            //                [PriceInapp addObject:skProduct.price];
            //             }
        }
    }];
}
#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [self reload];
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
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
    checkedArray = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    shouldLoadMore = YES;
    [self fetchDictData:self.pageNo];
}
#pragma mark - Shareing FB
-(void)shareViaFB:(NSString*)text1 appLink:(NSString*)link {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *shareSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch(result){
                 case SLComposeViewControllerResultCancelled:
                 default:
                 {
                     NSLog(@"Cancelled.....");
                     
                 }
                     break;
                 case SLComposeViewControllerResultDone:
                 {
                     NSLog(@"Posted....");
                 }
                     break;
             }
         }];
        
        [shareSheet setInitialText:text1];
        [shareSheet addURL:[NSURL URLWithString:link]];
        [self presentViewController:shareSheet animated:YES completion:nil];
    }else{
        DisplayAlert(@"Please add facebook account from settings");
    }
}

#pragma mark - Shareing Twitter
-(void)shareViaTwitter:(NSString*)text1 appLink:(NSString*)link {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *shareSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch(result){
                 case SLComposeViewControllerResultCancelled:
                 default:
                 {
                     NSLog(@"Cancelled.....");
                     
                 }
                     break;
                 case SLComposeViewControllerResultDone:
                 {
                     NSLog(@"Posted....");
                 }
                     break;
             }
         }];
        
        [shareSheet setInitialText:text1];
        [shareSheet addURL:[NSURL URLWithString:link]];
        [self presentViewController:shareSheet animated:YES completion:nil];
    }else{
        DisplayAlert(@"Please add twitter accounts from settings");
    }
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self shareViaFB:[[userName stringByAppendingString:@" is listening "]stringByAppendingString:[strTrackName stringByAppendingString:@" YouSounds Online music store."]] appLink:@"www.yousounds.com"];
    }else if(buttonIndex == 1){
        [self shareViaTwitter:[[userName stringByAppendingString:@" is listening "]stringByAppendingString:[strTrackName stringByAppendingString:@" YouSounds Online music store."]] appLink:@"www.yousounds.com"];
    }
}

#pragma mark - ProductPurched Notification
- (void)productPurchased:(NSNotification *)notification {
    if(IsInAppBrowse){
        [[ServerCalls sharedObject] executeRequest:urlFavourite withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error){
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
                    ShowAlertWithTitle(@"Congratulation",@"you have purchased the Song Successfully. Now, you can go to Playlist screen to play purchased songs.",@"Ok");
                    [self viewWillAppear:YES];
                    [checkedArray removeAllObjects];
                    [tableview reloadData];
                }
            }
        }];
    }
}
#pragma mark - fetchDictData
-(void)fetchDictData:(int)pageNo{
    NSDictionary *tempData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SaveData"];
    NSString *userID= [tempData valueForKey:@"iUserID"];
    userName= [tempData valueForKey:@"vFirstname"];
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
    dictData = nil;
    NSString *pageIndex = [NSString stringWithFormat:@"%d",pageNo];
    if(isFiltered == NO){
        dictData = [NSMutableDictionary dictionaryWithObjects:@[@" ",userID,pageIndex] forKeys:@[@"searchkeyword",@"iUserID",@"page"]];
        [self fetchAllTracks:pageNo];
    }else{
        dictData = [NSMutableDictionary dictionaryWithObjects:@[text,userID,pageIndex] forKeys:@[@"searchkeyword",@"iUserID",@"page"]];
        [self fetchAllTracks:pageNo];
    }
}

#pragma mark - Fetch All Track WS
-(void)fetchAllTracks:(int)page{
    /*if(shouldLoadMore == YES){
     [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
     }*/
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictData];
    urlFetchtrack = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/searchlist/format/json"]];
    
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
                arr_Size = [responseData valueForKey:@"count_total_records"];
                if(isAnOffer){
                    anOffer = [responseData valueForKey:@"offer_type"];
                    priceTag = [responseData valueForKey:@"track_price"];
                    if ([anOffer  isEqual: @"2"]){
                        DisplayAlert(@"congrats we have special discount of 25% on each track! You can select any two tracks to purchase.");
                    }
                    else if ([anOffer  isEqual: @"1"]){
                        DisplayAlert(@"congrats we have special discount of 50% on each track! You can select any three tracks to purchase.");
                    }
                    isAnOffer = false;
                }
                if(!isFiltered){
                    if(page == 1){
                        getData = [[NSMutableArray alloc]init];
                        for (NSDictionary *d in [responseData valueForKey:@"data"])
                        {
                            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:d];
                            [mdict setValue:@"NO" forKey:@"ISSELECTED"];
                            [getData addObject:mdict];
                        }
                        [DictBrowselist setValue:getData forKeyPath:@"getAllDataDict"];
                    }
                    else{
                        for (NSDictionary *d in [responseData valueForKey:@"data"])
                        {
                            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:d];
                            [mdict setValue:@"NO" forKey:@"ISSELECTED"];
                            [getData addObject:mdict];
                        }
                        //[getData addObjectsFromArray:[responseData valueForKey:@"data"]];
                    }
                }
                else{
                    if(page == 1){
                        arrFilteredDashboard=[[NSMutableArray alloc]init];
                        for (NSDictionary *d in [responseData valueForKey:@"data"])
                        {
                            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:d];
                            [mdict setValue:@"NO" forKey:@"ISSELECTED"];
                            [arrFilteredDashboard addObject:mdict];
                        }
                        [DictBrowselist setValue:arrFilteredDashboard forKeyPath:@"getAllDataDict"];
                    }
                    else{
                        for (NSDictionary *d in [responseData valueForKey:@"data"])
                        {
                            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:d];
                            [mdict setValue:@"NO" forKey:@"ISSELECTED"];
                            [arrFilteredDashboard addObject:mdict];
                        }
                        //[arrFilteredDashboard addObjectsFromArray:[responseData valueForKey:@"data"]];
                    }
                }
                [tableview reloadData];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [spinner stopAnimating];
        });
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
    }else{
        return getData.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView ||
        [arrFilteredDashboard count] > 0)
    {
        isLike = [[arrFilteredDashboard objectAtIndex:indexPath.row]valueForKey:@"islike"];
        isLikeArr = [arrFilteredDashboard valueForKey:@"islike"];
        musicID = [arrFilteredDashboard valueForKey:@"iMusicID"];
        musicTrack = [arrFilteredDashboard valueForKey:@"samplemusic"];
    }else{
        isLike = [[getData objectAtIndex:indexPath.row]valueForKey:@"islike"];
        isLikeArr = [getData valueForKey:@"islike"];
        musicID = [getData valueForKey:@"iMusicID"];
        musicTrack = [getData valueForKey:@"samplemusic"];
    }
    
    static NSString *cellIdentifier = @"Cell";
    
    cell = (SWTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    static int kCheck = -10;
    if(cell == nil)
    {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:@"BrowseListCell" owner:self options:Nil];
        cell = [nib objectAtIndex:0];
        
        cell.delegate = self;
        cell.leftUtilityButtons = [self leftButtons];
        
        btnSelectTrack = [[UIButton alloc] initWithFrame:CGRectMake(14, 4, 45, 45)];
        [btnSelectTrack addTarget:self action:@selector(MultipleSelectionTrack:) forControlEvents:UIControlEventTouchUpInside];
        [btnSelectTrack setTag:kCheck];
        [btnSelectTrack setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateSelected];
        [btnSelectTrack setImage:nil forState:UIControlStateNormal];
        [cell.contentView addSubview:btnSelectTrack];
        btnSelectTrack.layer.masksToBounds = YES;
        btnSelectTrack.layer.cornerRadius = 5.0;
        btnSelectTrack.layer.borderColor = [UIColor whiteColor].CGColor;
        btnSelectTrack.layer.borderWidth = 2.0;
    }
    else
    {
        cell.delegate = self;
        btnSelectTrack = (UIButton *)[cell.contentView viewWithTag:kCheck];
        cell.leftUtilityButtons = [self leftButtons];
    }
    
    cell.tag = indexPath.row;
//    [btnSelectTrack setTitle:[NSString stringWithFormat:@"%d",(int)indexPath.row+200] forState:UIControlStateDisabled];
    [btnSelectTrack setTitle:[NSString stringWithFormat:@"%d",(int)indexPath.row+200] forState:UIControlStateDisabled];
    
    CellDetails;
    cell.HintIView.layer.cornerRadius = 5.0f;
    cell.HintIView.layer.borderWidth = 2.0;
    cell.HintIView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.HintIView.layer.masksToBounds    = YES;
    
    if (tableView == self.searchDisplayController.searchResultsTableView ||
        [arrFilteredDashboard count] > 0)
    {
        NSMutableDictionary *mdict = [arrFilteredDashboard objectAtIndex:indexPath.row];
        
        if([checkedArray containsObject:[musicID objectAtIndex:indexPath.row]]){
            [mdict setValue:@"YES" forKey:@"ISSELECTED"];
        }
        
        if ([[mdict valueForKey:@"ISSELECTED"] isEqualToString:@"YES"])
        {
            btnSelectTrack.backgroundColor = [UIColor blackColor];
            btnSelectTrack.selected = true;
            btnSelectTrack.alpha = 0.7;
        }else{
            btnSelectTrack.backgroundColor = [UIColor clearColor];
            btnSelectTrack.selected = false;
        }
        
        cell.HintTrackName.text =  [mdict valueForKey:@"vMusicname"];
        cell.HintArtistName.text =[mdict valueForKey:@"artistname"];
        cell.HintlblDuration.text =[mdict valueForKey:@"vLength"];
        cell.HintlblPrice.text = priceTag;
        
        if([[mdict valueForKey:@"bigthumbmusic"]  isEqual: @""]){
            [cell.HintIView setImageWithURL:[NSURL URLWithString:[mdict valueForKey:@"albumimage"]]
                           placeholderImage:[UIImage imageNamed:@"play-button.png"]];
        }else{
            [cell.HintIView setImageWithURL:[NSURL URLWithString:[mdict valueForKey:@"bigthumbmusic"]] placeholderImage:[UIImage imageNamed:@"play-button.png"]];
        }
    }
    else{
        NSMutableDictionary *mdict = [getData objectAtIndex:indexPath.row];
        
        if([checkedArray containsObject:[musicID objectAtIndex:indexPath.row]]){
            [mdict setValue:@"YES" forKey:@"ISSELECTED"];
        }
        if ([[mdict valueForKey:@"ISSELECTED"] isEqualToString:@"YES"])
        {
            btnSelectTrack.backgroundColor = [UIColor blackColor];
            btnSelectTrack.selected = true;
            btnSelectTrack.alpha = 0.7;
        }else{
            btnSelectTrack.backgroundColor = [UIColor clearColor];
            btnSelectTrack.selected = false;
        }
        
        cell.HintTrackName.text = [mdict valueForKey:@"vMusicname"];
        cell.HintArtistName.text =[mdict valueForKey:@"artistname"];
        cell.HintlblDuration.text =[mdict valueForKey:@"vLength"];
        cell.HintlblPrice.text = priceTag;
        if([[mdict valueForKey:@"bigthumbmusic"]  isEqual: @""]){
            [cell.HintIView setImageWithURL:[NSURL URLWithString:[mdict valueForKey:@"albumimage"]] placeholderImage:[UIImage imageNamed:@"play-button.png"]];
        }else{
            [cell.HintIView setImageWithURL:[NSURL URLWithString:[mdict valueForKey:@"bigthumbmusic"]] placeholderImage:[UIImage imageNamed:@"play-button.png"]];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [txtSearch resignFirstResponder];
    IsFromPlaylist = false;
    IsOffline=false;
    if (tableView == self.searchDisplayController.searchResultsTableView ||
        [arrFilteredDashboard count] > 0)
    {
        [DictBrowselist setValue:[[arrFilteredDashboard objectAtIndex:indexPath.row]valueForKey:@"bigthumbmusic"] forKey:@"userTrackImg"];
        [DictBrowselist setValue:[[arrFilteredDashboard objectAtIndex:indexPath.row]valueForKey:@"compressthumbmusic"] forKey:@"userTrackImgBig"];
        [DictBrowselist setValue:[[arrFilteredDashboard objectAtIndex:indexPath.row]valueForKey:@"vMusicname"] forKey:@"userTrackName"];
        [DictBrowselist setValue:[[arrFilteredDashboard objectAtIndex:indexPath.row]  valueForKey:@"artistname"] forKey:@"userArtistName"];
        [DictBrowselist setValue:isLikeArr forKey:@"userisLike"];
        isLike = [[arrFilteredDashboard objectAtIndex:indexPath.row]valueForKey:@"islike"];
    }else{
        [DictBrowselist setValue:[[getData objectAtIndex:indexPath.row]valueForKey:@"bigthumbmusic"] forKey:@"userTrackImg"];
        [DictBrowselist setValue:[[getData objectAtIndex:indexPath.row]valueForKey:@"compressthumbmusic"] forKey:@"userTrackImgBig"];
        [DictBrowselist setValue:[[getData objectAtIndex:indexPath.row]valueForKey:@"vMusicname"] forKey:@"userTrackName"];
        [DictBrowselist setValue:[[getData objectAtIndex:indexPath.row]  valueForKey:@"artistname"] forKey:@"userArtistName"];
        [DictBrowselist setValue:isLikeArr forKey:@"userisLike"];
        isLike = [[getData objectAtIndex:indexPath.row]valueForKey:@"islike"];
    }
    NSString *track = [musicTrack objectAtIndex:indexPath.row];
    // [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    //Music Player
    GAViewController *audioPlayer = [[GAViewController alloc]initWithSoundFiles:musicTrack atPath:track andSelectedIndex:(int)indexPath.row andisLike:isLike];
    
    [self.navigationController pushViewController:audioPlayer animated:YES];
}
#pragma mark - Multiple Track Selection
-(void)MultipleSelectionTrack:(UIButton *)sender
{
    int tag = [[sender titleForState:UIControlStateDisabled] intValue]-200;
    NSString *strBtnText = [musicID objectAtIndex:tag] ;
    
    NSMutableDictionary *mdict;
    if(!isFiltered){
        mdict = [getData objectAtIndex:tag];
    }else{
        mdict = [arrFilteredDashboard objectAtIndex:tag];
    }
    
    if ([anOffer  isEqual: @"0"])
    {
        DisplayAlert(@"Offer not avilable !");
        return;
    }
    else if ([anOffer  isEqual: @"1"])
    {
        if(checkedArray.count == 2)
        {
            if (sender.selected)
            {
                [checkedArray removeObject:strBtnText];
                sender.backgroundColor = [UIColor clearColor];
                [mdict setValue:@"NO" forKey:@"ISSELECTED"];
                sender.selected = false;
            }
            if(checkedArray.count == 2){
                DisplayAlert(@"You can't select more than 2 songs to purchase");
                return;
            }
            return;
        }
    }
    else if ([anOffer  isEqual: @"2"])
    {
        if(checkedArray.count == 3)
        {
            if (sender.selected)
            {
                [checkedArray removeObject:strBtnText];
                sender.backgroundColor = [UIColor clearColor];
                [mdict setValue:@"NO" forKey:@"ISSELECTED"];
                sender.selected = false;
            }
            if(checkedArray.count == 3){
                DisplayAlert(@"You can't select more than 3 songs to purchase");
                return;
            }
            return;
        }
    }
   
    if (sender.selected)
    {
        [checkedArray removeObject:strBtnText];
        sender.backgroundColor = [UIColor clearColor];
        sender.selected = false;
        [mdict setValue:@"NO" forKey:@"ISSELECTED"];
    }
    else
    {
        [checkedArray addObject:[musicID objectAtIndex:tag]];
        sender.selected = true;
        sender.backgroundColor = [UIColor blackColor];
        sender.alpha = 0.7;
        [mdict setValue:@"YES" forKey:@"ISSELECTED"];
    }
    [tableview reloadData];
}

#pragma mark - Swipe Cell Delegates
- (NSArray *)leftButtons
{
    leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]] icon:[UIImage imageNamed:@"Share Btn.png"]];
    //Add to Favourite
    if([isLike  isEqual: @"1"]){
        [leftUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]]icon:[UIImage imageNamed:@"Heart_Liked.png"]];
        isFavourite = false;
    }
    else{
        [leftUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]]icon:[UIImage imageNamed:@"heart2.png"]];
        isFavourite = true;
    }
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]]icon:[UIImage imageNamed:@"Purchase.png"]];
    return leftUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell1 didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            if(isFiltered){
                NSMutableDictionary *mdict = [arrFilteredDashboard objectAtIndex:cell1.tag];
                strTrackName =  [mdict valueForKey:@"vMusicname"];
            }else {
                NSMutableDictionary *mdict = [getData objectAtIndex:cell1.tag];
                
                strTrackName =  [mdict valueForKey:@"vMusicname"];
            }
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Social Sharing" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Facebook", @"Twitter",nil];
            [actionSheet showInView:self.view];
            break;
        }
        case 1:
        {
            [self addFavouriteCell:cell1 withIndex:(int)index];
            break;
        }
        case 2:
        {
            [self addFavouriteCell:cell1 withIndex:(int)index];
            break;
        }
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

#pragma mark - Navigation Buttons
- (IBAction)RightNavigationBtn_Click:(id)sender {
    [txtSearch resignFirstResponder];
    NotificationController *notify = [[NotificationController alloc] initWithNibName:@"NotificationController" bundle:nil];
    
    [self.navigationController pushViewController:notify animated:YES];
}
- (IBAction)LeftNavigationBtn_Click:(id)sender {
    [txtSearch resignFirstResponder];
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

#pragma mark - Textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SearchBox
- (IBAction)txtSearchEdit:(UITextField *)textField {
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    text = textField.text;
    if (textField == txtSearch)
    {
        if(textField.text.length == 0)
        {
            isFiltered = NO;
            [arrFilteredDashboard removeAllObjects];
            [self fetchDictData:1];
        }
        else
        {
            isFiltered = YES;
            [self fetchDictData:1];
        }
    }
}

#pragma mark - Add To Favourite
-(void)addFavouriteCell:(SWTableViewCell *)cell2 withIndex:(int)index {
    NSIndexPath *cellID = [[NSIndexPath alloc] init];
    cellID = [tableview indexPathForCell:cell2];
    NSString *Music = musicID [cellID.row];
    NSString *strSendMail;
    NSMutableString *large_CSV_String;
    dictData = nil;
    if(index == 1)
    {
        dictData = [NSMutableDictionary dictionaryWithObjects:@[Music] forKeys:@[@"iMusicID"]];
        [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
        reqData = [NSMutableData data];
        reqData = [CommonMethods preparePostData:dictData];
        urlFavourite = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/like/index/format/json"]];
    }
    else if (index == 2)
    {
        SKProduct *product;
        product = nil;
        if(checkedArray.count == 0)
        {
            product = (SKProduct *)[_products objectAtIndex:0];
            strSendMail = musicID [cellID.row];
            productPrice = @"0.99";
        }else
        {
            if([anOffer isEqual: @"0"] || [anOffer isEqual: @"1"])
            {
                product = (SKProduct *)[_products objectAtIndex:0];
                productPrice = @"0.99";
            }else if ([anOffer isEqual: @"2"])
            {
                product = (SKProduct *)[_products objectAtIndex:1];
                productPrice = @"1.99";
            }
            large_CSV_String = [[NSMutableString alloc] init];
            for(int i=0 ;i<checkedArray.count; i++)
            {
                NSString *tempMusic= [checkedArray objectAtIndex:i];
                [large_CSV_String appendFormat:@",%@",tempMusic];
            }
            strSendMail = [large_CSV_String substringFromIndex:1];
        }
        [[RageIAPHelper sharedInstance] buyProduct:product];
        
        dictData1 = [[NSMutableDictionary alloc] init];
        dictData1 = [NSMutableDictionary dictionaryWithObjects:@[strSendMail,@"InApp",@"Purchase from IOS",@"0",@"0",productPrice] forKeys:@[@"iMusicID",@"vType",@"tComment",@"from_game",@"other_userid",@"dAmount"]];
        [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
        reqData = [NSMutableData data];
        reqData = [CommonMethods preparePostData:dictData1];
        urlFavourite = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/purchase/index/format/json"]];
    }
    if(index == 1 || index == 3){
        [[ServerCalls sharedObject] executeRequest:urlFavourite withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
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
                    if(index == 1){
                        if(!isFiltered){
                            NSLog(@"LIKE : %@ CELL  :%@",[getData [cellID.row] valueForKey:@"islike"],cellID );
                            if([[getData [cellID.row] valueForKey:@"islike"]  isEqual: @"0"]){
                                [getData [cellID.row] setValue:@"1" forKey:@"islike"];
                            }else{
                                [getData [cellID.row] setValue:@"0" forKey:@"islike"];
                            }
                        }else{
                            if([[arrFilteredDashboard [cellID.row] valueForKey:@"islike"]  isEqual: @"0"]){
                                [arrFilteredDashboard [cellID.row] setValue:@"1" forKey:@"islike"];
                            }else{
                                [arrFilteredDashboard [cellID.row] setValue:@"0" forKey:@"islike"];
                            }
                        }
                        [tableview beginUpdates];
                        [tableview reloadRowsAtIndexPaths:@[cellID] withRowAnimation:UITableViewRowAnimationNone];
                        [tableview endUpdates];
                    }
                }
            }
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma  mark - ScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(isFiltered)
    {
        if ([arr_Size intValue] > arrFilteredDashboard.count)
        {
            ++self.pageNo;
            [spinner startAnimating];
            tableview.tableFooterView = spinner;
            shouldLoadMore = NO;
            [self fetchDictData:self.pageNo];
        }
    }else{
        if ([arr_Size intValue] > getData.count)
        {
            ++self.pageNo;
            [spinner startAnimating];
            tableview.tableFooterView = spinner;
            shouldLoadMore = NO;
            [self fetchDictData:self.pageNo];
        }
    }
}

@end
