//
//  DataRequest.h
//  FSA
//
//  Created by iMacViral on 7/5/13.
//  Copyright (c) 2013 INDUSA. All rights reserved.
//

// Header inclusion for conforming to the Interface
#import "RequestInterface.h"

@interface DataRequest : RequestInterface < NSURLConnectionDelegate, NSURLConnectionDataDelegate > {
    
    // The block serves the purpose to the class, ehich makes the rquest.
    // This block will be invoked from the class itself, but the functionlity will, actually be implemented into the class, which makes the request.
    void(^completionBlock)(NSData *response, NSError *error);
}

// This Property will hold the data returned as response to web request.
// This property eliminates the need for locally declaring the instance for the class, which makes request.
@property (nonatomic, retain) NSMutableData *data;

// This is the connection object, which will hold the attributes for the HTTPConnection Request
@property (nonatomic, retain) NSURLConnection *connection;

// Main method which will be called every time the user makes HTTP Request.
- (id)initWithURL:(NSURL *)url                                      // URL for the rquest
		  timeout:(NSTimeInterval)requestTimeout                    // time out parameter for the request
	   httpMethod:(NSString *)requestMethod                         // specifies the HTTP request method
		 httpBody:(NSData *)requestBody                             // this will contain the body for request (mostly will be used, when posting data to web service)
completionHandler:(void (^)(NSData *, NSError *))aCompletionBlock;  // this will get into the implementation, and will get invoked from the method.

// This method will eventually call the Above method.
- (id)initWithURL:(NSURL *)url                                      // URL for the rquest
completionHandler:(void (^)(NSData *, NSError *))aCompletionBlock;  // this will get into the implementation, and will get invoked from the method.

@end