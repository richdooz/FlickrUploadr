//
//  FolderScanner.m
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/27/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import "FUFileSet.h"
#import "FolderScanner.h"
#import <Foundation/NSString.h>
#import <Foundation/NSCharacterSet.h>



@implementation FolderScanner

- (id)init
{
    self = [super init];

    self.enumerator = [[[NSFileManager alloc] init] enumeratorAtPath:@"."];
    self.fileSet = [[FUFileSet alloc] init];
    
    return self;
}

- (id)initWithStartingDirectory:(NSString *)start
{
    self = [super init];
    
    self.enumerator = [[[NSFileManager alloc] init] enumeratorAtPath:start];
    self.fileSet = [[FUFileSet alloc] init];
    
    return self;
}

- (id)initWithEnumerator:(NSDirectoryEnumerator *)enumerator;
{
    self = [super init];
    
    self.enumerator = enumerator;
    self.fileSet = [[FUFileSet alloc] init];
    
    return self;
}

- (NSUInteger)buildFileList
{
    NSString *file;
    while ((file = [self.enumerator nextObject])) {
        if([file hasPrefix:@"2"]) {
            FUFileInstance *fileInstance = [[FUFileInstance alloc] initWithFile:file];
            NSDictionary *attrs = [self.enumerator fileAttributes];
            
            if([[attrs objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
                NSLog(@"Folder \"%@\"\n", file);
            } else {
                NSLog(@"File \"%@\"\n", file);
                [self.fileSet add:fileInstance];
            }
        }
    }
    NSLog(@"Done building file list.\n");
    return [self.fileSet count];
}

- (void)startUploadingTo:(NSObject<UploaderDelegate> *)uploader
{
//    [self.fileArray enumerateObjectsUsingBlock:^(FileInstance *obj, NSUInteger idx, BOOL *stop) {
//        
//        [uploader upload:[obj name] FromPath:[obj path] ToSet:[obj set]];
//    }];
}




@end
