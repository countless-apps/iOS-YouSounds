//
//  PlayList.h
//  youSound
//
//  Created by Akash on 6/2/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "NotificationController.h"

@interface PlayList : UIViewController<SWTableViewCellDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *Travel;
@property (weak, nonatomic) IBOutlet UIButton *innerCourtbtn;
@property (weak, nonatomic) IBOutlet UIButton *palacebtn;
@property (weak, nonatomic) IBOutlet UIButton *kingdomBtn;
@property (weak, nonatomic) IBOutlet UIButton *LeftNavigationBtn;
@property (weak, nonatomic) IBOutlet UIButton *RightNavigationBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, readwrite) int pageNo;

@end
