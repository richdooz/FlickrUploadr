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
    OFFlickrAPIRequest *request;
}

@property (strong) OFFlickrAPIContext *context;
@property (strong) NSAttributedString *status;
@property BOOL result;

- (id)init;
- (void)authFromWeb;
- (void)authWithKnownToken;
- (void)testCode;

@end


@interface FUFileUpload : NSObject

@end