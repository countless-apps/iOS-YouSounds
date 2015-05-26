//
//  RequestInterface.m
//  FSA
//
//  Created by iMacViral on 7/5/13.
//  Copyright (c) 2013 INDUSA. All rights reserved.
//

// Header inclusion
#import "RequestInterface.h"

@implementation RequestInterface

- (void)cancel {
    
    // abstract -- This method will be implemented in the class which conforms to this interface.
}

- (void)dealloc {
    
	[self cancel]; // Quite self explanatory
}

@end
