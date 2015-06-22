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

@end
