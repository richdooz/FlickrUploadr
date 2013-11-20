//
//  FUFlickr.m
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/29/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//


#import "Flickr.h"
#import "FolderScanner.h"
#import "SampleAPIKey.h"


/*
 init
 registerUrlScheme => getUrl:withReplyEvent:
 authFromWeb
 
 
 
 */

@implementation FUFlickr

-(id) init
{
    self = [super init];
    self.context = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY
                                                 sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
    request = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.context];
    request.delegate = self;
    return self;
}

- (void)authWithKnownToken
{
    [self.context setOAuthToken:@"72157633799659695-18fa2dbedef388a3"];
    [self.context setOAuthTokenSecret:@"b6e62b4e58a1e88e"];
}

- (void)authFromWeb
{
    NSURL *url = [[NSURL alloc] initWithString:@"flickruploadr://callback"];
    NSLog(@"Launching Flickr auth URL %@\n", [url absoluteString]);
    [request fetchOAuthRequestTokenWithCallbackURL:url];
}

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSString *requestToken= nil;
    NSString *verifier = nil;
    
    NSURL *callbackURL = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    NSLog(@"Callback URL: %@", [callbackURL absoluteString]);
    
    BOOL result = OFExtractOAuthCallback(callbackURL,
                                         [NSURL URLWithString:@"flickruploadr://callback"],
                                         &requestToken, &verifier);
    if (!result) {
        NSLog(@"Invalid callback URL");
    } else {
        [request fetchOAuthAccessTokenWithRequestToken:requestToken verifier:verifier];
        self.status = [self.status initWithString:[[NSString alloc]initWithFormat:@"Got user response..."] ];
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
didObtainOAuthRequestToken:(NSString *)inRequestToken
                  secret:(NSString *)inSecret
{
    [self.context setOAuthToken:inRequestToken];
    [self.context setOAuthTokenSecret:inSecret];
    
    NSLog(@"Got Request token, waiting for user authorization...\n");
    NSURL *url = [self.context userAuthorizationURLWithRequestToken:inRequestToken
                                                requestedPermission:OFFlickrWritePermission];
    
    BOOL result = [[NSWorkspace sharedWorkspace] openURL:url];
    
    NSLog(@"openURL result=%d", result);
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
didObtainOAuthAccessToken:(NSString *)inAccessToken
                  secret:(NSString *)inSecret
            userFullName:(NSString *)inFullName
                userName:(NSString *)inUserName
                userNSID:(NSString *)inNSID
{
    [self.context setOAuthToken:inAccessToken];
    [self.context setOAuthTokenSecret:inSecret];
    
    NSLog(@"User authorization successful!  Got Access token!\n");
    NSLog(@"Access Token: %@", inAccessToken);
    NSLog(@"Secret: %@", inSecret);
    
    self.status = [self.status initWithString:[[NSString alloc] initWithFormat:@"Authorized"]];
    
//    [NSThread detachNewThreadSelector:@selector(startWorker) toTarget:self withObject:nil];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
        didFailWithError:(NSError *)inError
{
    NSLog(@"Error detected...\n");
//    [self.statusLabel setStringValue:@"Error detected...."];
    
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:
                                       [NSString stringWithFormat:@"%@\n", [inError localizedDescription]]];

    self.status = attrString;

    //    [[self.activity textStorage] performSelectorOnMainThread:@selector(appendAttributedString:)
//                                                  withObject:attrString waitUntilDone:YES];
//    [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:self waitUntilDone:YES];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
 didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"Successful");
//    [self.waitForUploadComplete lock];
//    [self.waitForUploadComplete signal];
//    [self.waitForUploadComplete unlock];
}

- (void)testCode
{
//    bool result = [request ]
}

@end

