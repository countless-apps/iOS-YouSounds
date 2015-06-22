//
//  LeftMenuCell.m
//  YouSounds
//
//  Created by rjcristy on 6/4/15.
//  Copyright (c) 2015 rjcristy. All rights reserved.
//

#import "LeftMenuCell.h"

@implementation LeftMenuCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
