//
//  InviteFriendsController.m
//  youSound
//
//  Created by Akash on 6/4/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "InviteFriendsController.h"
#import "MFSideMenu.h"
#import "SlideMenuView.h"
#import "NotificationController.h"
#import "MFSideMenuContainerViewController.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import "ServerCalls.h"
#import "NSObject+SBJson.h"
#import "CommonMethods.h"
#import "AppDelegate.h"
#import "SWTableViewCell.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>


@interface InviteFriendsController ()<SWTableViewCellDelegate>
{
    NSMutableArray *checkedArray, *contactList,*arrFilteredDashboard;
    UILabel *friendName,*friendPhone;
    UIImageView *cellImg;
    NSURL *urlSendEmail;
    NSData *reqData;
    NSString *strSendMail;
    
    BOOL temp;
    
    IBOutlet UIButton *btnBadge;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *tableview;
    IBOutlet UIButton *RightNavigationBtn;
    IBOutlet UIButton *LeftNavigationBtn;
    IBOutlet UISearchBar *mSearchBar;
    IBOutlet UITextField *txtSearch;
    IBOutlet UILabel *lblHeader;
    IBOutlet UIButton *btnDone;
    IBOutlet UIButton *btnAll;
}
@end

@implementation InviteFriendsController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    
    self.view.frame = CGRectMake(0, 0, 320, 568);
    if (IS_DEVICE_iPHONE_5)
    {
        [tableview setShowsVerticalScrollIndicator:NO];
    }
    else
    {
        [tableview setShowsVerticalScrollIndicator:NO];
        tableview.frame = CGRectMake(0, 130, 322, 320);
        btnAll.frame = CGRectMake(20, 452, 53, 25);
        btnDone.frame = CGRectMake(240, 452, 62, 25);
        [tableview setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    }
    lblHeader.font = lableHeader;
    lblHeader.textColor = [UIColor whiteColor];
    temp = NO;
    checkedArray = [[NSMutableArray alloc] init];
    contactList=[[NSMutableArray alloc] init];
    tableview.allowsMultipleSelectionDuringEditing = YES;
    
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", DictGetBadge ] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBadge1:)
                                                 name:@"getBadge" object:nil];
    
}

-(void)getBadge1:(NSNotification *)dict1
{
    NSDictionary *userInfo = dict1.userInfo;
    [btnBadge setTitle:[NSString stringWithFormat:@"%@", userInfo] forState:UIControlStateNormal];
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
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    __block BOOL accessGranted;
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else {
        accessGranted = YES;
    }
    if(accessGranted){
        for (int i = 0; i < CFArrayGetCount(people); i++) {
            ABRecordRef person = CFArrayGetValueAtIndex(people, i);
            ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
            for (int j=0; j < ABMultiValueGetCount(emails); j++) {
                NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
                NSMutableDictionary *dOfPerson=[[NSMutableDictionary alloc] init];
                
                if (!email) {
                }
                else{
                    //For FirstName
                    NSString *firstName;
                    firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                    if(firstName == NULL){
                        [dOfPerson setObject:@"No Name" forKey:@"name"];
                    }else{
                        
                        [dOfPerson setObject:firstName forKey:@"name"];
                    }
                    //For Contact Image
                    NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
                    UIImage  *img = [UIImage imageWithData:imgData];
                    if(img == NULL){
                        [dOfPerson setObject:[UIImage imageNamed:@"Blank Image.png"] forKey:@"imgData"];
                    }else{
                        [dOfPerson setObject:img forKey:@"imgData"];
                    }
                    [dOfPerson setObject:email forKey:@"emailID"];
                }
                
                if(email){
                    [contactList addObject:dOfPerson];
                }
            }
        }
        CFRelease(addressBook);
        CFRelease(people);
    }
    else{
        DisplayAlert(@"Deny Access");
    }
    
    [tableview reloadData];
    [SVProgressHUD dismiss];
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
        return contactList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        friendName = [[UILabel alloc] initWithFrame:CGRectMake(80, 6, 200, 30)];
        friendName.font = semiLightFont16;
        friendName.tag = 20;
        friendName.textColor = DarkColor;
        [cell.contentView addSubview:friendName];
        
        friendPhone = [[UILabel alloc] initWithFrame:CGRectMake(80, 27, 200, 30)];
        friendPhone.font = subtitleSemiLightFont;
        friendPhone.tag = 21;
        friendPhone.textColor = DarkColor;
        [cell.contentView addSubview:friendPhone];
        
        cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
        cellImg.layer.masksToBounds = YES;
        cellImg.layer.cornerRadius = 25;
        cellImg.layer.borderColor = (RoundCorner).CGColor;
        cellImg.layer.borderWidth = 2.0f;
        cellImg.tag = 101;
        [cell.contentView addSubview:cellImg];
    }
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    tableview.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Cell_separator.png"]];
    
    if (tableView == self.searchDisplayController.searchResultsTableView ||
        [arrFilteredDashboard count] > 0)
    {
        ((UILabel *)[cell.contentView viewWithTag:20]).text = [[arrFilteredDashboard objectAtIndex:indexPath.row]valueForKey:@"name"];
        ((UILabel *)[cell.contentView viewWithTag:21]).text = [[arrFilteredDashboard objectAtIndex:indexPath.row] valueForKey:@"emailID"];
        [((UIImageView *)[cell.contentView viewWithTag:101]) setImage:[[arrFilteredDashboard objectAtIndex:indexPath.row]valueForKeyPath:@"imgData"]];
        
        if(temp == YES){
            [checkedArray addObject:[arrFilteredDashboard objectAtIndex:indexPath.row]];
            cell.accessoryView = [[ UIImageView alloc ]
                                  initWithImage:[UIImage imageNamed:@"Checked.png"]];
        }
        else{
            if([checkedArray containsObject:arrFilteredDashboard[indexPath.row]]){
                cell.accessoryView = [[ UIImageView alloc ]
                                      initWithImage:[UIImage imageNamed:@"Checked.png"]];
            }
            else{
                cell.accessoryView = [[ UIImageView alloc ]
                                      initWithImage:[UIImage imageNamed:@"unchecked1.png"]];
            }
        }
    }else{
        ((UILabel *)[cell.contentView viewWithTag:20]).text = [[contactList objectAtIndex:indexPath.row] valueForKey:@"name"];
        ((UILabel *)[cell.contentView viewWithTag:21]).text = [[contactList objectAtIndex:indexPath.row] valueForKey:@"emailID"];
        [((UIImageView *)[cell.contentView viewWithTag:101]) setImage:[[contactList objectAtIndex:indexPath.row] valueForKeyPath:@"imgData"]];
        //CONTACT LISt
        if(temp == YES){
            [checkedArray addObject:[contactList objectAtIndex:indexPath.row]];
            cell.accessoryView = [[UIImageView alloc]
                                  initWithImage:[UIImage imageNamed:@"Checked.png" ]];
        }
        else{
            if([checkedArray containsObject:contactList[indexPath.row]]){
                cell.accessoryView = [[UIImageView alloc]
                                      initWithImage:[UIImage imageNamed:@"Checked.png" ]];
            }
            else{
                cell.accessoryView = [[UIImageView alloc]
                                      initWithImage:[UIImage imageNamed:@"unchecked1.png" ]];
            }
        }
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
    {
        //  cell.accessoryType = UITableViewCellAccessoryNone;
        if( tableView == self.searchDisplayController.searchResultsTableView ||arrFilteredDashboard.count>0 ){
            
            if([checkedArray containsObject:arrFilteredDashboard[indexPath.row]]){
                
                [checkedArray removeObject:arrFilteredDashboard[indexPath.row]];
                cell.accessoryView = [[ UIImageView alloc ]
                                      initWithImage:[UIImage imageNamed:@"unchecked1.png" ]];
            }else{
                [checkedArray addObject:[arrFilteredDashboard[indexPath.row] copy]];
                cell.accessoryView = [[ UIImageView alloc ]
                                      initWithImage:[UIImage imageNamed:@"Checked.png" ]];
            }
        }else{
            
            if([checkedArray containsObject:contactList[indexPath.row]]){
                
                [checkedArray removeObject:contactList[indexPath.row]];
                cell.accessoryView = [[ UIImageView alloc ]
                                      initWithImage:[UIImage imageNamed:@"unchecked1.png" ]];
            }else{
                [checkedArray addObject:[contactList[indexPath.row] copy]];
                cell.accessoryView = [[ UIImageView alloc ]
                                      initWithImage:[UIImage imageNamed:@"Checked.png" ]];
            }
            
        }
        
    }
}
#pragma mark- Navigation Buttons
- (IBAction)RightNavigationBtn_Click:(id)sender {
    NotificationController *notify = [[NotificationController alloc] initWithNibName:@"NotificationController" bundle:nil];
    
    SlideMenuView *leftSlideMenu = [[SlideMenuView alloc] initWithNibName:@"SlideMenuView" bundle:nil];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:notify
                                                    leftMenuViewController:leftSlideMenu
                                                    rightMenuViewController:nil];
    
    [self.navigationController pushViewController:container animated:YES];
    
}
- (IBAction)LeftNavigationBtn_Click:(id)sender {
    [txtSearch resignFirstResponder];
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
#pragma mark - Buttons Click
- (IBAction)btnAll_Click:(id)sender {
    if(temp==YES){
        temp = NO;
        [tableview reloadData];
        [checkedArray removeAllObjects];
    }else{
        temp = YES;
        [tableview reloadData];
    }
}
- (IBAction)btnDone_Click:(id)sender {
    if(checkedArray.count > 0){
        NSMutableString *large_CSV_String = [[NSMutableString alloc] init];
        for(NSString *aKey in [checkedArray valueForKey:@"emailID"]){
            [large_CSV_String appendFormat:@",%@",aKey];
        }
        strSendMail = [large_CSV_String substringFromIndex:1];
        [self sendEmail];
    }
}

#pragma mark - sendEmail
-(void)sendEmail{
    
    NSDictionary *dictdata = nil;
    
    dictdata = [NSMutableDictionary dictionaryWithObjects:@[strSendMail] forKeys:@[@"emails"]];
    
    [SVProgressHUD showWithStatus:kPleaseWait maskType:SVProgressHUDMaskTypeGradient];
    
    reqData = [NSMutableData data];
    reqData = [CommonMethods preparePostData:dictdata];
    
    urlSendEmail = [NSURL URLWithString:[URLBase stringByAppendingString:@"ws/user/email_invite/format/json"]];
    
    [[ServerCalls sharedObject] executeRequest:urlSendEmail withData:reqData method:kPOST completionBlock:^(NSData *data, NSError *error) {
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTripMatcher message:@"Invitaion Sent Successfully" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                alert.tag=103;
                [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
            }
        }
        [SVProgressHUD dismiss];
    }];
    
}
-(void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", strText];
    arrFilteredDashboard = [NSMutableArray arrayWithArray:[contactList filteredArrayUsingPredicate:resultPredicate]];
    
    if(arrFilteredDashboard.count>0){
        [tableview reloadData];
    }else{
        NSLog(@"No data");
    }
}

@end
