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
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures/flickr_test"];
    
    flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
    
    flickrRequest.delegate = self;
    
    self.scanner = [[FolderScanner alloc] initWithStartingDirectory:path];

    
    [flickrContext setOAuthToken:@"72157633799659695-18fa2dbedef388a3"];
    [flickrContext setOAuthTokenSecret:@"b6e62b4e58a1e88e"];
    [self.statusLabel setStringValue:@"Authorized"];
    [self.statusLabel display];
    [NSThread detachNewThreadSelector:@selector(startWorker) toTarget:self withObject:nil];

    //[self registerUrlScheme];
    //[self authFromWeb];
    
    NSLog(@"Current=%@\n", [self.scanner current]);
    
    //[scanner startUploadingTo:app];
    
    NSLog(@"Finished Launching.");
    [self.statusLabel setStringValue:@"Starting..."];
    [self.statusLabel display];
    
    [self.progress setMinValue:0.0];
    [self.progress setMaxValue:0.0];
    [self.progress setDoubleValue:0.0];
    
    self.totalCount = 0;
    self.currentCount = 0;
    
    self.waitForStart = [[NSCondition alloc] init];
    self.waitForUploadComplete = [[NSCondition alloc] init];
}

- (void)registerUrlScheme
{
    NSLog(@"Registering getUrl handler");
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}
- (void)authFromWeb
{
    NSURL *url = [[NSURL alloc] initWithString:@"flickruploadr://callback"];

    NSLog(@"Launching Flickr auth URL %@\n", [url absoluteString]);
    [self.statusLabel setStringValue:@"Starting Flickr auth..."];
    [self.statusLabel display];
    
    [flickrRequest fetchOAuthRequestTokenWithCallbackURL:url];
}

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSString *requestToken= nil;
    NSString *verifier = nil;
    
    NSURL *callbackURL = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    NSLog(@"Callback URL: %@", [callbackURL absoluteString]);
    
    BOOL result = OFExtractOAuthCallback(callbackURL, [NSURL URLWithString:@"flickruploadr://callback"], &requestToken, &verifier);
    if (!result) {
        NSLog(@"Invalid callback URL");
    } else {
        [flickrRequest fetchOAuthAccessTokenWithRequestToken:requestToken verifier:verifier];
        [self.statusLabel setStringValue:@"Got user response..."];
        [self.statusLabel display];
    }
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
    NSLog(@"Access Token: %@", inAccessToken);
    NSLog(@"Secret: %@", inSecret);
    
    [self.statusLabel setStringValue:@"Authorized"];
    [self.statusLabel display];
    
    [NSThread detachNewThreadSelector:@selector(startWorker) toTarget:self withObject:nil];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    [self.statusLabel setStringValue:@"Error detected...."];
    
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", [inError localizedDescription]]];
    [[self.activity textStorage] performSelectorOnMainThread:@selector(appendAttributedString:) withObject:attrString waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:self waitUntilDone:YES];

}

- (void)startWorker
{
    self.totalCount = [self.scanner buildFileList];
    
    NSString *str = [NSString stringWithFormat:@"Uploading %lu files...", (unsigned long)self.totalCount];
    [self.statusLabel setStringValue:str];
    [self.statusLabel display];
    [self.progress setMaxValue:self.totalCount];
    [self.startButton setEnabled:YES];

    NSLog(@"Waiting for start...");
    [self.waitForStart lock];
    [self.waitForStart wait];
    [self.waitForStart unlock];
    NSLog(@"Got start signal.");

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
    self.currentCount++;
    
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"file:%@ path:%@ set:%@\n", fileName, fromPath, setName]];
    [[self.activity textStorage] performSelectorOnMainThread:@selector(appendAttributedString:) withObject:attrString waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:self waitUntilDone:YES];

    [self.statusLabel setStringValue:[NSString stringWithFormat:@"Uploading %lu of %lu files...", (unsigned long)self.currentCount, (unsigned long)self.totalCount]];
    [self.progress setDoubleValue:self.currentCount];
    
    NSString *ext = [fileName pathExtension];
    NSString *mimeType = @"";

    NSString *fullPath = [fromPath stringByAppendingFormat:@"/%@", fileName];
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:fullPath];

    if([ext isCaseInsensitiveLike:@"jpg"]) {
        mimeType = @"image/jpeg";
    }
    else if([ext isCaseInsensitiveLike:@"png"]) {
        mimeType = @"image/png";
    }
    

    bool result = [flickrRequest uploadImageStream:inputStream suggestedFilename:fileName MIMEType:mimeType arguments:@{}];
    NSLog(@"Sent request result=%d FullPath=%@ Set=%@ mimeType=%@\n", result, fullPath, setName, mimeType);
    [self.waitForUploadComplete lock];
    [self.waitForUploadComplete wait];
    [self.waitForUploadComplete unlock];
    NSLog(@"Sent request result=%d FullPath=%@ Set=%@ mimeType=%@\n", result, fullPath, setName, mimeType);

}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
    NSLog(@"Upload successful... inSentBytes:%lu inTotalBytes:%lu", inSentBytes, inTotalBytes);
    [self.waitForUploadComplete lock];
    [self.waitForUploadComplete signal];
    [self.waitForUploadComplete unlock];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"Successful");
}

- (IBAction)start:(id)sender {
    NSLog(@"Signalling start...");
    [self.waitForStart lock];
    [self.waitForStart signal];
    [sender setEnabled:NO];
    [self.waitForStart unlock];
}
@end
