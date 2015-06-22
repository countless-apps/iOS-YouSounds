//
//  BrowseListController.h
//  youSound
//
//  Created by Akash on 5/31/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "NotificationController.h"
#import "Global.h"

@interface BrowseListController : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate >
{
     IBOutlet  SWTableViewCell *CellBrowse;
}
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *RightNavigationBtn;
@property (weak, nonatomic) IBOutlet UIButton *LeftNavigationBtn;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) int pageNo;

@end
