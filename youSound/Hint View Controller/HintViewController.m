//
//  HintViewController.m
//  youSound
//
//  Created by Akash on 8/1/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "HintViewController.h"
#import "SWTableViewCell.h"
#import "SVProgressHUD.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"
#import "Global.h"
#import "CommonMethods.h"
#import "UIImageView+AFNetworking.h"
#import "RageIAPHelper.h"
#import "FriendProfile.h"

@interface HintViewController () <SWTableViewCellDelegate>
{
    NSMutableArray *_products,*dictHintData,*musicID;
    NSURL *urlHintData;
    NSMutableData *reqData;
    NSString *productPrice,*userID;
    NSMutableDictionary *dictEditData;
    UIRefreshControl *refreshControl;
    IBOutlet UIButton *btnLeftNavigation;
    IBOutlet UILabel *lblHeader;
    IBOutlet UITableView *tableview;
}
@end

@implementation HintViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IsInAppBrowse = false;
    IsInAppHint = true;
    IsInAppMusic = true;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self reload];
    [refreshControl beginRefreshing];
    

    lblHeader.font = lableHeader;
    lblHeader.textColor = [UIColor whiteColor];
    [self fetchHintData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchasedi:) name:IAPHelperProductPurchasedNotification object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
   
}
- (void)reload {
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        //PriceInapp = [[NSMutableArray alloc] init] ;
        if (success) {
            _products = nil;
            _products = [products mutableCopy];
            
            /*for (SKProduct * skProduct in products) {
                [PriceInapp addObject:skProduct.price];
                NSLog(@"%@",PriceInapp);
            }*/
        }
        [refreshControl endRefreshing];
    }];
}
- (void)productPurchasedi:(NSNotification *)notification {
    
    if(IsInAppHint){
    [[ServerCalls sharedObject] executeRequest:urlHintData withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error){
        if (error)
        {
            NSLog(@"ERROR!!@@");
            DisplayAlert((NSString *)[error localizedDescription]);
            [SVProgressHUD dismiss];
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success)
            {
                NSLog(@"%@",responseData);
                NSLog(@"Dict data id : %@ NSusermusci id : %@",[dictEditData valueForKey:@"iMusicID"], [[NSUserDefaults standardUserDefaults] valueForKey:@"MusciID"]);
                             
                if([[dictEditData valueForKey:@"iMusicID"]  isEqual: [[NSUserDefaults standardUserDefaults] valueForKey:@"MusciID"]]){
                    NSString *strFriendID = [[NSUserDefaults standardUserDefaults] valueForKey:@"FriendUserID"];
                    NSLog(@"%@",strFriendID);
                    [[NSUserDefaults standardUserDefaults] setValue:strFriendID forKeyPath:@"FriendID"];
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FriendID"]);
                    AlertWithTitle(@"YouSounds",@"congratulations you guessed it right, you can now send a friend request to this friend",nil);
                    FriendProfile *fProfile = [[FriendProfile alloc] initWithNibName:@"FriendProfile" bundle:nil];
                    [self.navigationController pushViewController:fProfile animated:YES];
                }else{
                    DisplayAlert(@"You guess wrong music, please try again.");
                }
                [tableview reloadData];
            }
        }
        [SVProgressHUD dismiss];
    
    }];
    }
}

#pragma mark - fetchGameData WS
-(void)fetchHintData
{
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    dictEditData = [NSMutableDictionary dictionaryWithObjects:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"AlbumID"]] forKeys:@[@"iMusicID"]];
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictEditData];
    
    urlHintData = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/admin/knowmore/format/json"]];
    
    [[ServerCalls sharedObject] executeRequest:urlHintData withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else if (data)
        {
            NSDictionary *responseData = [data JSONValue];
            BOOL Success = [[responseData valueForKey:@"SUCCESS"] boolValue];
            if (Success){
                dictHintData =[responseData valueForKey:@"data"];
            }
            else
            {
                /*NSString *strMessage = [responseData valueForKeyPath:@"MESSAGE"];
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
    return dictHintData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    musicID = [dictHintData valueForKey:@"iMusicID"];
  
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HintViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
        cell.leftUtilityButtons = [self leftButtons];
    }

    cell.HintIView.layer.cornerRadius     = 5.0f;
    cell.HintIView.layer.borderWidth = 2.0;
    cell.HintIView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.HintIView.layer.masksToBounds    = YES;
    
    cell.HintTrackName.font = semiLightFont16;
    cell.HintTrackName.textColor = DarkColor;
    cell.HintArtistName.font = subtitleSemiLightFont;
    cell.HintArtistName.textColor = LiteColor;
    cell.HintlblPrice.font = subtitleSemiLightFont;
    cell.HintlblPrice.textColor = LiteColor;
    cell.HintlblDuration.font = subtitleSemiLightFont;
    cell.HintlblDuration.textColor = LiteColor;
    
    cell.HintTrackName.text = [[dictHintData objectAtIndex:indexPath.row] valueForKey:@"vMusicname"];
    cell.HintArtistName.text =[[dictHintData objectAtIndex:indexPath.row] valueForKey:@"artistname"];
    cell.HintlblDuration.text =[[dictHintData objectAtIndex:indexPath.row] valueForKey:@"vLength"];
    cell.HintlblPrice.text = [[dictHintData objectAtIndex:indexPath.row] valueForKey:@"trackprice"];
    //cell.HintlblPrice.text =

    if([[[dictHintData objectAtIndex:indexPath.row] valueForKey:@"bigthumbmusic"]  isEqual: @""]){
        cell.HintIView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"play-button.png"]];
    }else{
        [cell.HintIView setImageWithURL:[NSURL URLWithString:[[dictHintData objectAtIndex:indexPath.row] valueForKey:@"bigthumbmusic"]]placeholderImage:[UIImage imageNamed:@"play-button.png"]];
    }
    return cell;
}
#pragma mark - Swipe Cell
- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]] icon:[UIImage imageNamed:@"Purchase.png"]];
    return leftUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell1 didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
            
        case 0:{
            NSLog(@"Case 0");
            [self addFavouriteCell:cell1 withIndex:index];
            break;
        }
    }
}
#pragma mark - Add To Favourite
-(void)addFavouriteCell:(SWTableViewCell *)cell2 withIndex:(int)index {
    NSIndexPath *cellID = [[NSIndexPath alloc] init];
    cellID = [tableview indexPathForCell:cell2];
    NSString *Music =  musicID [cellID.row];
    NSLog(@"%@",Music);
    NSDictionary *tempData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SaveData"];
    userID = [tempData valueForKey:@"iUserID"];
    SKProduct  *product = (SKProduct *)[_products objectAtIndex:0];
   
    dictEditData = [NSMutableDictionary dictionaryWithObjects:@[Music,@"InApp",@"Purchase from IOS",@"1",userID,@"0.99"] forKeys:@[@"iMusicID",@"vType",@"tComment",@"from_game",@"other_userid",@"dAmount"]];
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictEditData];
    urlHintData = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/purchase/index/format/json"]];
    
    [[RageIAPHelper sharedInstance] buyProduct:product];
    
    NSLog(@"Price : %@",productPrice);
    NSLog(@"Product ID: %@",product.productIdentifier);
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}
#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 102){
         [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Button Navigations
- (IBAction)btnLeftNavigation_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
