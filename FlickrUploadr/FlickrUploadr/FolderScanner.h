//
//  FolderScanner.h
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/27/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrUploadr.h"

@protocol UploaderDelegate <NSObject>

- (void)upload:(NSString *)fileName FromPath:(NSString *)fromPath ToSet:(NSString *)setName;

@end

@interface FileInstance : NSObject

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *path;
@property (nonatomic, assign) NSString *set;

@end




@interface FolderScanner : NSObject
{
    NSFileManager *mgr;
    NSDirectoryEnumerator *enumerator;
}
@property (nonatomic, strong) NSMutableArray *fileArray;

- (id)init;
- (id)initWithStartingDirectory:(NSString *)start;
- (NSString *)current;
- (NSUInteger)buildFileList;
- (void)startUploadingTo:(NSObject<UploaderDelegate> *)uploader;


@end
