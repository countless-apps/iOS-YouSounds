//
//  SWTableViewCell.h
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "SWCellScrollView.h"
#import "SWLongPressGestureRecognizer.h"
#import "SWUtilityButtonTapGestureRecognizer.h"
#import "NSMutableArray+SWUtilityButtons.h"

@class SWTableViewCell;

typedef NS_ENUM(NSInteger, SWCellState)
{
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight,
};

@protocol SWTableViewCellDelegate <NSObject>

@optional
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state;
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell;
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state;
- (void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell;

@end

@interface SWTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *leftUtilityButtons;
@property (nonatomic, copy) NSArray *rightUtilityButtons;

@property (nonatomic, weak) id <SWTableViewCellDelegate> delegate;

- (void)setRightUtilityButtons:(NSArray *)rightUtilityButtons WithButtonWidth:(CGFloat) width;
- (void)setLeftUtilityButtons:(NSArray *)leftUtilityButtons WithButtonWidth:(CGFloat) width;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;
- (void)showLeftUtilityButtonsAnimated:(BOOL)animated;
- (void)showRightUtilityButtonsAnimated:(BOOL)animated;
- (BOOL)isUtilityButtonsHidden;

//Game Notofications Objects
@property (weak, nonatomic) IBOutlet UILabel *lblHint;
@property (weak, nonatomic) IBOutlet UIImageView *cellImg;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommon;
@property (weak, nonatomic) IBOutlet UILabel *lblSame;
@property (weak, nonatomic) IBOutlet UILabel *lblGuess;

//Hint View Controller objects
@property (weak, nonatomic) IBOutlet UILabel *HintTrackName;
@property (weak, nonatomic) IBOutlet UILabel *HintArtistName;
@property (weak, nonatomic) IBOutlet UILabel *HintlblDuration;
@property (weak, nonatomic) IBOutlet UILabel *HintlblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *HintIView;
@property (weak, nonatomic) IBOutlet UIImageView *HintPriceImg;
@property (weak, nonatomic) IBOutlet UIImageView *HintCellCorner;

//Accept Friend Request
@property (weak, nonatomic) IBOutlet UILabel *lblFname;
@property (weak, nonatomic) IBOutlet UILabel *lblSentRequestName;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnDenite;
@property (weak, nonatomic) IBOutlet UIImageView *RequestCellImg;

//MyFriendList Objects
@property (weak, nonatomic) IBOutlet UILabel *lblFriendNm;
@property (weak, nonatomic) IBOutlet UIImageView *imgFriend;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalTrack;



@end
