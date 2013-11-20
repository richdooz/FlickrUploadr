//
//  FUAuthTest.m
//  FlickrUploadr
//
//  Created by Richard Duszczak on 11/17/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Flickr.h"

@interface FUAuthTest : XCTestCase

@end

@implementation FUAuthTest
{
    FUFlickr *mut;
}
- (void)setUp
{
    [super setUp];
    mut = [[FUFlickr alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAuthFromWeb
{
    [mut authFromWeb];
//    XCTAssertEqual([mut status], @"", <#format...#>)
}

@end
