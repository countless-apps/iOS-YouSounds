//
//  BrowseListCell.h
//  YouSounds
//
//  Created by Akash on 11/20/14.
//  Copyright (c) 2014 Akash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface BrowseListCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *HintTrackName;
@property (weak, nonatomic) IBOutlet UILabel *HintArtistName;
@property (weak, nonatomic) IBOutlet UILabel *HintlblDuration;
@property (weak, nonatomic) IBOutlet UILabel *HintlblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *HintIView;
@property (weak, nonatomic) IBOutlet UIImageView *HintPriceImg;
@property (weak, nonatomic) IBOutlet UIImageView *HintCellCorner;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectTrack;

-(id)initWithOwner:(id)Owner;

@end
