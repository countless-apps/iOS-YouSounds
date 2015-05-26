//
//  ServerCalls.h
//  FSA
//
//  Created by iMacViral on 7/5/13.
//  Copyright (c) 2013 INDUSA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataRequest.h"

@interface ServerCalls : NSObject {    
    
    // Add properties for customization you want to make.
}

// This method will create and return the Singleton object of its Class type
// User will be using this method to have access to methods of this class.
// Implementation of it, is pretty self explanatory
+ (ServerCalls*)sharedObject;

// All the webservice calls to be implemeted in the project, will uses the following method.
- (RequestInterface *)executeRequest:(NSURL *)requestURL
                            withData:(NSData *)requestBody
                              method:(NSString *)requestMethod
                     completionBlock:(void(^)(NSData *data, NSError *error))completionBlock;

@end
