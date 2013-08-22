//
//  FlickrUploadr.m
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/27/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import "FlickrUploadr.h"
#import "FolderScanner.h"
#import "SampleAPIKey.h"

@implementation FlickrUploadr

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures/flickr"];

    flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
    
    flickrRequest.delegate = self;

    FolderScanner *scanner = [[FolderScanner alloc] initWithStartingDirectory:path];
    
    [self registerUrlScheme];
    [self authFromWeb];
    
    NSLog(@"Current=%@\n", [scanner current]);
    
    //[scanner startUploadingTo:app];
    
    NSLog(@"Finished Launching.");
}

- (bool)upload:(NSString *)fileName FromPath:(NSString *)path ToSet:(NSString *)setName
{
    NSLog(@"File=%@ Path=%@ Set=%@\n", fileName, path, setName);
    

    return TRUE;
}
- (void)registerUrlScheme
{
    NSLog(@"Registering getUrl handler");
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}
- (void)authFromWeb
{

    NSURL *url = [[NSURL alloc] initWithString:@"flickruploadr://com.duszczak.FlickrUploadr"];
    [flickrRequest fetchOAuthRequestTokenWithCallbackURL:url];
    
    
    NSLog(@"Launched Flickr auth URL %@\n", [url absoluteString]);
}

- (void)authFromDesktop
{
//    
//    [flickrRequest fetchOAuthAccessTokenWithRequestToken:<#(NSString *)#> verifier:<#(NSString *)#>]
//    NSDictionary *dict = [[NSDictionary alloc] init];
//    [flickrRequest callAPIMethodWithGET:@"flickr.auth.getFrob" arguments:dict];
    
}

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSURL *callbackURL = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    NSLog(@"Callback URL: %@", [callbackURL absoluteString]);
    
    NSString *requestToken= nil;
    NSString *verifier = nil;
    
    BOOL result = OFExtractOAuthCallback(callbackURL, [NSURL URLWithString:@"flickruploadr://com.duszczak.FlickrUploadr"], &requestToken, &verifier);
    if (!result) {
        NSLog(@"Invalid callback URL");
    }
    
    [flickrRequest fetchOAuthAccessTokenWithRequestToken:requestToken verifier:verifier];
    
    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    [flickrContext setOAuthToken:inRequestToken];
    [flickrContext setOAuthTokenSecret:inSecret];

    NSLog(@"Got Request token, waiting for user authorization...\n");
    NSURL *url = [flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];

    [[NSWorkspace sharedWorkspace] openURL:url];
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID
{
    [flickrContext setOAuthToken:inAccessToken];
    [flickrContext setOAuthTokenSecret:inSecret];
    
    NSLog(@"User authorization successful!  Got Access token!\n");
}

@end



