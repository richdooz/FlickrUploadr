//
//  FUAppDelegate.h
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/29/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FolderScanner.h"
#import "Flickr.h"
#import "ObjectiveFlickr/ObjectiveFlickr.h"

@interface FUAppDelegate : NSObject <NSApplicationDelegate, UploaderDelegate>
{
    
//    OFFlickrAPIContext *flickrContext;
//    OFFlickrAPIRequest *flickrRequest;
}
@property (strong) FUFlickr *flickr;

@property (strong) FolderScanner *scanner;

@property (strong) NSThread *worker;

@property (nonatomic, assign) NSUInteger totalCount;
@property (nonatomic, assign) NSUInteger currentCount;

@property (weak) IBOutlet NSButtonCell *startButton;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *activity;
@property (weak) IBOutlet NSProgressIndicator *progress;

@property (strong) NSCondition *waitForStart;
@property (strong) NSCondition *waitForUploadComplete;

-(void)upload:(NSString *)fileName FromPath:(NSString *)path ToSet:(NSString *)setName;
-(void)registerUrlScheme;
-(void)auth;


//-(void)                      getUrl:(NSAppleEventDescriptor *)event
//                     withReplyEvent:(NSAppleEventDescriptor *)replyEvent;

-(IBAction)                   start:(id)sender;

@end
