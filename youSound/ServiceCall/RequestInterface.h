//
//  RequestInterface.h
//  FSA
//
//  Created by iMacViral on 7/5/13.
//  Copyright (c) 2013 INDUSA. All rights reserved.
//

/*
 This is the header file for the RequestInterface.
 
 User of this file may add any usefule methods to be implemeted, as and when required.
 Those method will be implemented by DataRequset Class, to make the method functioning.
 
 Example method: - (void)cancel -- This method will be implemented by DataRequest Class
 */
#import <Foundation/Foundation.h>

@interface RequestInterface : NSObject

// calls cancel on the underlying NSURLConnection
// NOTE: if a completion block is associated with the request, it will not be called after you call this function
- (void)cancel;

@end