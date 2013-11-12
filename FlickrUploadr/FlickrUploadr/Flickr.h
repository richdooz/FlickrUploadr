//
//  FUFlickr.h
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/29/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FolderScanner.h"
#import "ObjectiveFlickr/ObjectiveFlickr.h"

@interface FUFlickr : NSObject <NSApplicationDelegate, OFFlickrAPIRequestDelegate>
{
    
    OFFlickrAPIContext *flickrContext;
    OFFlickrAPIRequest *flickrRequest;
}

-(id) init;


@end

