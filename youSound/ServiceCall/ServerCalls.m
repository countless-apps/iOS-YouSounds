//
//  ServerCalls.m
//  FSA
//
//  Created by iMacViral on 7/5/13.
//  Copyright (c) 2013 INDUSA. All rights reserved.
//

#import "ServerCalls.h"
#import "Global.h"
@implementation ServerCalls

#pragma mark - Initialization

// singleton instance of ServerCalls -- This eliminates the local object for the request to be created everytime
+ (ServerCalls *)sharedObject
{
    // Static variable of type ServerCalls -- Declaration
    static ServerCalls* globalServerCalls = nil;
    
    // GCD despatch queue -- Alternate would be simple Alloc - Init with IF not nil check
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalServerCalls = [[ServerCalls alloc] init]; // Allocating and initializing object
    });
    
    // Returning singleton object
    return globalServerCalls;
}

// Init method for ServerCalls
- (id)init
{
    self = [super init];
    if (self) {
        // Init Code Goes Here.
    }
    return self;
}

// Main method implemented for the interface
- (RequestInterface *)executeRequest:(NSURL *)requestURL
    withData:(NSData *)requestBody
    method:(NSString *)requestMethod
    completionBlock:(void(^)(NSData *data, NSError *error))completionBlock
{
    DataRequest *request = [[DataRequest alloc] initWithURL:requestURL timeout:kDefultTimeOut httpMethod:requestMethod
    httpBody:requestBody completionHandler:completionBlock];
    return (RequestInterface *)request;
}
@end