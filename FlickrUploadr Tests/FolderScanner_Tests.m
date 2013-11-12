//
//  FlickrUploadr_Tests.m
//  FlickrUploadr Tests
//
//  Created by Richard Duszczak on 10/25/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

#import "FUFileSet.h"
#import "FolderScanner.h"



@interface FolderScanner_Tests : XCTestCase <UploaderDelegate>

@property (strong) FolderScanner *mut;
@property (strong) FUFileSet *fileSet;

@end


@implementation FolderScanner_Tests

- (void)upload:(NSString *)fileName FromPath:(NSString *)path ToSet:(NSString *)setName
{
    NSLog(@"upload");
}

- (void)setUp
{
    [super setUp];

    self.mut = [[FolderScanner alloc] initWithEnumerator:[[[NSFileManager alloc] init] enumeratorAtPath:@"."]];
    self.fileSet = [[FUFileSet alloc] init];
}

- (void)tearDown
{
    self.mut = nil;
    self.fileSet = nil;
    [super tearDown];
}

- (void)testGetNameFromFile
{
    NSString *input = @"/Users/rich/path1/path2/path3/image.jpg";
    NSString *expected = @"image.jpg";
    NSString *result = [FUInfoDirector getNameFromFile:input];
    
    XCTAssert([expected isEqualToString:result], @"Expected:%@ Actual:%@", expected, result);
}

- (void)testGetPathFromFile
{
    NSString *input = @"/Users/rich/path1/path2/path3/image.jpg";
    NSString *expected = @"/Users/rich/path1/path2/path3";
    NSString *result = [FUInfoDirector getPathFromFile:input];
    
    XCTAssert([expected isEqualToString:result], @"Expected:%@ Actual:%@", expected, result);
}

- (void)testGetSetNameFromFile
{
    NSString *input = @"/Users/rich/path1/path2/path3/image.jpg";
    NSString *expected = @"Users rich path1 path2 path3";
    NSString *result = [FUInfoDirector getSetNameFromFile:input];
    
    XCTAssert([expected isEqualToString:result], @"Expected:%@ Actual:%@", expected, result);
}

- (void)testBuildFileSet
{
    [self.fileSet add:[FUFileInstance instanceWithFile:@"2009/birthday/karissa/img1.jpg"]];
    
    XCTAssert([self.fileSet count] == 1, @"Expected:%d\n", [self.fileSet count]);
}
@end
