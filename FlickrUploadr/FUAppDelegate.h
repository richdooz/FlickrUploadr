//
//  FUAppDelegate.h
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/29/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FolderScanner.h"
#import "ObjectiveFlickr/ObjectiveFlickr.h"

@interface FUAppDelegate : NSObject <NSApplicationDelegate, OFFlickrAPIRequestDelegate, UploaderDelegate>
{
    
    OFFlickrAPIContext *flickrContext;
    OFFlickrAPIRequest *flickrRequest;
}
@property (weak) IBOutlet NSTextField *statusLabel;
@property (strong) FolderScanner *scanner;
@property (strong) NSThread *worker;
@property (nonatomic, assign) NSUInteger totalCount;

- (void)upload:(NSString *)fileName FromPath:(NSString *)path ToSet:(NSString *)setName;
- (void)registerUrlScheme;
- (void)authFromWeb;


- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent;
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret;
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID;

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *activity;

@end
