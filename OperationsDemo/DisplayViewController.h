//
//  DisplayViewController.h
//  OperationsDemo
//
//  Created by Ankit Gupta on 6/6/11.
//  Copyright 2011 Pulse News. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DisplayViewController : UIViewController {
    
    UIActivityIndicatorView *loadingIndicator;
    UITextView *textView;
    
    NSData *data;
    NSString *sourceTitle;
}

@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(nonatomic, strong) IBOutlet UITextView *textView;
@property(nonatomic, strong) NSData *data;
@property(nonatomic, strong) NSString *sourceTitle;

@end
