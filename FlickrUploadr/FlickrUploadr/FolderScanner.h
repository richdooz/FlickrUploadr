//
//  FolderScanner.h
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/27/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrUploadr.h"
#import "FUFileSet.h"

@protocol UploaderDelegate <NSObject>

- (void)upload:(NSString *)fileName FromPath:(NSString *)fromPath ToSet:(NSString *)setName;

@end



@interface FolderScanner : NSObject

@property (weak)  NSDirectoryEnumerator *enumerator;
@property (nonatomic, strong) FUFileSet *fileSet;

- (id)init;
- (id)initWithStartingDirectory:(NSString *)start;
- (id)initWithEnumerator:(NSDirectoryEnumerator *)enumerator;

- (NSUInteger)buildFileList;

- (void)startUploadingTo:(NSObject<UploaderDelegate> *)uploader;

//- (NSString *)getNameFromFile:(NSString *)file;
//- (NSString *)getPathFromFile:(NSString *)file;
//- (NSString *)getSetNameFromFile:(NSString *)file;



@end
