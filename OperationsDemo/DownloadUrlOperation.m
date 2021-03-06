//
//  DownloadUrlOperation.m
//  OperationsDemo
//
//  Created by Ankit Gupta on 6/6/11.
//  Copyright 2011 Pulse News. All rights reserved.
//

#import "DownloadUrlOperation.h"

@implementation DownloadUrlOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

@synthesize error = error_, data = data_;
@synthesize connectionURL = connectionURL_;
#pragma mark -
#pragma mark Initialization & Memory Management

- (id)initWithURL:(NSURL *)url
{
    if( (self = [super init]) ) {
        self.connectionURL = [url copy];
    }
    return self;
}

- (void)dealloc
{
    if( self.sessionTask ) {
        [self.sessionTask cancel];
    }
    
    
    
}

#pragma mark -
#pragma mark Start & Utility Methods

// This method is just for convenience. It cancels the URL connection if it
// still exists and finishes up the operation.
- (void)done {
    if (self.sessionTask) {
        [self.sessionTask cancel];
        self.sessionTask = nil;
    }
    
    // Alert anyone that we are finished
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.executing = NO;
    self.finished  = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}
-(void)canceled {
	// Code for being cancelled
    self.error = [[NSError alloc] initWithDomain:@"DownloadUrlOperation"
                                            code:123
                                        userInfo:nil];
	
    [self done];
	
}
- (void)start
{
    // Ensure that the operation should exute
    if( self.finished || [self isCancelled] ) { [self done]; return; }
    
    // From this point on, the operation is officially executing--remember, isExecuting
    // needs to be KVO compliant!
    [self willChangeValueForKey:@"isExecuting"];
    self.executing = YES;
    [self didChangeValueForKey:@"isExecuting"];

    self.data = [NSMutableData data];
    
    // Create the session -- this could have been done in init, but we delayed
    // until no in case the operation was never enqueued or was cancelled before starting
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                         delegate:self
                                                    delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:connectionURL_ cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0]];
    [sessionTask resume];

}


#pragma mark -
#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self handleErrorCase:error];
    }
    else {
        [self handleSessionSuccess];
    }
}


#pragma mark - session failure

// The session failed
- (void)handleErrorCase:(NSError*)error
{
    // Check if the operation has been cancelled
    if([self isCancelled]) {
        [self canceled];
		return;
    }
	else {
		self.data = nil;
		self.error = error;
		[self done];
	}
}


#pragma mark - NSURLSessionDataDelegate

// The session received more data
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    // Check if the operation has been cancelled
    if([self isCancelled]) {
        [self canceled];
		return;
    }
    
    [self.data appendData:data];
}

#pragma mark - session success

- (void)handleSessionSuccess {
    // Check if the operation has been cancelled
    if([self isCancelled]) {
        [self canceled];
		return;
    }
	else {
		[self done];
	}
}

@end
