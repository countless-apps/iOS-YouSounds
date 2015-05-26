//
//  BrowseListCell.m
//  YouSounds
//
//  Created by Akash on 11/20/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import "BrowseListCell.h"
@interface BrowseListCell ()<SWTableViewCellDelegate>
{
    NSMutableArray *leftUtilityButtons;
}
@end
@implementation BrowseListCell
@synthesize btnAccept,btnSelectTrack;
-(id)initWithOwner:(id)Owner
{
    if (self=[super init])
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BrowseListCell" owner:self options:nil];
        self = [nib objectAtIndex:0];
//        self.delegate = self;
//        self.leftUtilityButtons = [self leftButtons];
//        btnSelectTrack.layer.cornerRadius = 5.0;
        btnSelectTrack.layer.borderColor = [UIColor whiteColor].CGColor;
        btnSelectTrack.layer.borderWidth = 2.0;
    }
    return self;
}
#pragma mark - Swipe Cell Delegates
- (NSArray *)leftButtons
{
    leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]] icon:[UIImage imageNamed:@"Share Btn.png"]];
    
   /* [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]]icon:[UIImage imageNamed:@"Heart_Liked.png"]];*/
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]]icon:[UIImage imageNamed:@"heart2.png"]];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"Swipe Btn BG.png" ]]icon:[UIImage imageNamed:@"buy-icon.png"]];
    
    return leftUtilityButtons;
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}
@end
