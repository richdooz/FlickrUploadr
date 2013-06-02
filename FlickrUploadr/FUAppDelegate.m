//
//  FUAppDelegate.m
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/29/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import "FUAppDelegate.h"
#import "FolderScanner.h"
#import "SampleAPIKey.h"

@implementation FUAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures/flickr"];
    
    flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
    
    flickrRequest.delegate = self;
    
    self.scanner = [[FolderScanner alloc] initWithStartingDirectory:path];
    
    [self registerUrlScheme];
    [self authFromWeb];
    
    NSLog(@"Current=%@\n", [self.scanner current]);
    
    //[scanner startUploadingTo:app];
    
    NSLog(@"Finished Launching.");
    [self.statusLabel setStringValue:@"Starting..."];
    [self.statusLabel display];
}

- (void)registerUrlScheme
{
    NSLog(@"Registering getUrl handler");
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}
- (void)authFromWeb
{
    
    NSURL *url = [[NSURL alloc] initWithString:@"flickruploadr://callback"];
    [flickrRequest fetchOAuthRequestTokenWithCallbackURL:url];
    
    
    NSLog(@"Launched Flickr auth URL %@\n", [url absoluteString]);
    [self.statusLabel setStringValue:@"Starting Flickr auth..."];
    [self.statusLabel display];
}


- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSURL *callbackURL = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    NSLog(@"Callback URL: %@", [callbackURL absoluteString]);
    
    NSString *requestToken= nil;
    NSString *verifier = nil;
    
    BOOL result = OFExtractOAuthCallback(callbackURL, [NSURL URLWithString:@"flickruploadr://callback"], &requestToken, &verifier);
    if (!result) {
        NSLog(@"Invalid callback URL");
    }
    
    [flickrRequest fetchOAuthAccessTokenWithRequestToken:requestToken verifier:verifier];
    [self.statusLabel setStringValue:@"Got user response..."];
    [self.statusLabel display];

    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    [flickrContext setOAuthToken:inRequestToken];
    [flickrContext setOAuthTokenSecret:inSecret];
    
    NSLog(@"Got Request token, waiting for user authorization...\n");
    NSURL *url = [flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    
    BOOL result = [[NSWorkspace sharedWorkspace] openURL:url];
    
    NSLog(@"openURL result=%d", result);
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID
{
    [flickrContext setOAuthToken:inAccessToken];
    [flickrContext setOAuthTokenSecret:inSecret];
    
    NSLog(@"User authorization successful!  Got Access token!\n");
    [self.statusLabel setStringValue:@"Authorized"];
    [self.statusLabel display];
    
    [NSThread detachNewThreadSelector:@selector(startWorker) toTarget:self withObject:nil];
}

- (void)startWorker
{
    self.totalCount = [self.scanner buildFileList];
    
    NSString *str = [NSString stringWithFormat:@"Uploading %lu files...", (unsigned long)self.totalCount];
    
    [self.statusLabel setStringValue:str];
    [self.statusLabel display];
    
    [self.scanner startUploadingTo:self];
    
}

- (void)scrollToBottom
{
    NSPoint     pt;
    id          scrollView;
    id          clipView;
    
    pt.x = 0;
    pt.y = 100000000000.0;
    
    scrollView = [self.activity enclosingScrollView];
    clipView = [scrollView contentView];
    
    pt = [clipView constrainScrollPoint:pt];
    [clipView scrollToPoint:pt];
    [scrollView reflectScrolledClipView:clipView];
}

- (void)upload:(NSString *)fileName FromPath:(NSString *)fromPath ToSet:(NSString *)setName
{
    
    
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"file:%@ path:%@ set:%@\n", fileName, fromPath, setName]];
    
    [[self.activity textStorage] performSelectorOnMainThread:@selector(appendAttributedString:) withObject:attrString waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:self waitUntilDone:YES];
    
    
    NSLog(@"File=%@ Path=%@ Set=%@\n", fileName, fromPath, setName);

}

@end
