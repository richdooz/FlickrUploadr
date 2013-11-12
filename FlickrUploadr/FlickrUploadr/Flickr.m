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

@implementation FUFlickr

-(id) init
{
    self = [super init];
    
    flickrContext = [[OFFlickrAPIContext alloc]
                     initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY
                     sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
    flickrRequest = [[OFFlickrAPIRequest alloc]
                     initWithAPIContext:flickrContext];
    
    flickrRequest.delegate = self;

    [flickrContext setOAuthToken:@"72157633799659695-18fa2dbedef388a3"];
    [flickrContext setOAuthTokenSecret:@"b6e62b4e58a1e88e"];

    return self;
}

@end
