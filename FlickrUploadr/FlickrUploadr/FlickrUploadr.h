//
//  FlickrUploadr.h
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/27/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectiveFlickr/ObjectiveFlickr.h"

@interface FlickrUploadr : NSObject <NSApplicationDelegate, OFFlickrAPIRequestDelegate>
{

    OFFlickrAPIContext *flickrContext;
    OFFlickrAPIRequest *flickrRequest;
}
        

- (bool)upload:(NSString *)fileName FromPath:(NSString *)path ToSet:(NSString *)setName;
- (void)registerUrlScheme;
- (void)authFromWeb;
- (void)authFromDesktop;


- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent;
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret;
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID;
@end
