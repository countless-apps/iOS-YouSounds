//
//  OSTextField.m
//  YouSounds
//
//  Created by rjcristy on 5/31/15.
//  Copyright (c) 2015 rjcristy. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "OSTextField.h"

@implementation OSTextField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self setLeftViewMode:UITextFieldViewModeUnlessEditing];
        
        self.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.clipsToBounds = YES;
        [self setLeftViewMode:UITextFieldViewModeUnlessEditing];
        
        self.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect) leftViewRectForBounds:(CGRect)bounds {
    
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}

@end