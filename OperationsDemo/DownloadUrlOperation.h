//
//  DownloadUrlOperation.h
//  OperationsDemo
//
//  Created by Ankit Gupta on 6/6/11.
//  Copyright 2011 Pulse News. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadUrlOperation : NSOperation <NSURLSessionTaskDelegate, NSURLSessionDataDelegate> {
    // In concurrent operations, we have to manage the operation's state
}


@property (atomic, assign, getter=isExecuting) BOOL executing;
@property (atomic, assign, getter=isFinished) BOOL finished;

@property (nonatomic, strong) NSError* error;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURL *connectionURL;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;

- (id)initWithURL:(NSURL*)url;

@end
