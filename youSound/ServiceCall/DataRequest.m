    //
//  DataRequest.m
//  FSA
//
//  Created by iMacViral on 7/5/13.
//  Copyright (c) 2013 INDUSA. All rights reserved.
//

#define kDefultTimeOut 120.0f

#import "DataRequest.h"
#import "Global.h"
@implementation DataRequest

@synthesize data;
@synthesize connection;

// Method implementation -- See header file for its parameter details.
- (id)initWithURL:(NSURL *)url 
		  timeout:(NSTimeInterval)requestTimeout
	   httpMethod:(NSString *)requestMethod
		 httpBody:(NSData *)requestBody
completionHandler:(void (^)(NSData *, NSError *))aCompletionBlock {

	self = [super init];
	if (self) {// checking for its validity - not null
        
        // allocation (and eventually retaining by copy) memory to completionblock
		completionBlock = [aCompletionBlock copy];
        
        // Allocating memory to data property
		data = [NSMutableData data];
		
        // preparing request for execution
		NSMutableURLRequest* mutableReq = [[NSMutableURLRequest alloc] initWithURL:url];
		[mutableReq addValue:@"utf-8" forHTTPHeaderField:@"charset"];
        
       // NSLog(@"ssad: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"X-API-KEY"]);
        
        [mutableReq addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"X-API-KEY"] forHTTPHeaderField:@"X-API-KEY"];
        
        for (int i = 0; i < [[[[NSUserDefaults standardUserDefaults] objectForKey:@"headerdict"] allKeys] count]; i++)
        {
            NSString *strKey = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"headerdict"] allKeys] objectAtIndex:i];
            NSString *strValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"headerdict"] valueForKey:strKey];
            [mutableReq addValue:strValue forHTTPHeaderField:strKey];
        }
        
        // Setting up timeout interval for the request
		mutableReq.timeoutInterval = requestTimeout;
		
		if (requestMethod) {
            // will be effective, only if, method parameter has something except nil
			mutableReq.HTTPMethod = requestMethod;
		}
		
		if (requestBody) {
            // will be effective, only if, bodyData parameter has something except nil
			mutableReq.HTTPBody = requestBody;
		}
        
        if ([requestMethod isEqualToString:@"POST"])
        {
            NSString *Boundary = [NSString stringWithFormat:@"%@",@"0xKhTmLbOuNdArY"];
            
            NSString  *contentType= [NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary];
            
            [mutableReq addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
        }
		
        // Seeting up the connection using the request
		connection = [NSURLConnection connectionWithRequest:mutableReq delegate:self];
	}
	
    // returning its value.
	return self;	
}

// Method will was declared into the interface is actually playing roll here. (See RequestInterface.h for detail)
- (void)cancel {
	
    // Calling its superclass' same method
    [super cancel];
	
    // Voiding block and connection & making them ready for fresh request
	completionBlock = nil;
	[connection cancel];
	connection = nil;
}

// Short hand method - avoiding many parameters from the main init method
// For user of this class, this method will likely to be used for most of the time
// This method hides additional complexity from its users
- (id)initWithURL:(NSURL *)url 
completionHandler:(void (^)(NSData *, NSError *))aCompletionBlock {
    
    // Eventually calling the main init method
	return [self initWithURL:url timeout:kDefultTimeOut httpMethod:nil httpBody:nil completionHandler:aCompletionBlock];
}

#pragma mark - NSURLConnectionDelegate

// This method will be called once for a request, when responce starts.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
    if (PRINT)
    {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        int responseStatusCode = [httpResponse statusCode];
        NSLog(@"Status Code :: %d", responseStatusCode);
    }
}

// This method will be called once or more per request, depending upon the size of the response.
- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)receivedData {
    
    // After didReceiveResponse - This will be the method which will give us data (in chunks, if large data)
    [data appendData:receivedData];
}

// This method will be invoked when the response gathering ends by didReceiveData(above) methods
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    
    // As connection's work is finished, we shall make it free, by pointing it to nil (for next execution, this make things clear)
	connection = nil;
	
	if([data length]) {
        
        // Checking data for its meningfulness.
         completionBlock(data, nil);
	}
	else { // Will be executed when no data is there

        // completion block with nil parameters.
		completionBlock(nil, nil);
		completionBlock = nil;		
	}
}

// Following method will get called in case of error occurance.
- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
    
    // completion block will get called, with error as parameter - data will be nil, as it should be.
    completionBlock(nil, error);
	
    // making the connection and completion block ready for next execution.
	completionBlock = nil;
	connection = nil;
}

@end
