//
//  FolderScanner.m
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/27/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import "FolderScanner.h"

@implementation FileInstance



@end

@implementation FolderScanner

- (id)init
{
    self = [super init];
    mgr = [[NSFileManager alloc] init];
    enumerator = [mgr enumeratorAtPath:@"."];
    self.fileArray = [[NSMutableArray alloc] init];
    
    return self;
}

- (id)initWithStartingDirectory:(NSString *)start
{
    self = [super init];
    mgr = [[NSFileManager alloc] init];
    enumerator = [mgr enumeratorAtPath:start];
    self.fileArray = [[NSMutableArray alloc] init];
    
    return self;
}

- (NSString *)current
{
    return [mgr currentDirectoryPath];
}

- (NSUInteger)buildFileList
{
    NSString *file;
    while ((file = [enumerator nextObject])) {
        if([file hasPrefix:@"2"]) {
            FileInstance *fileInstance = [[FileInstance alloc] init];
            NSDictionary *attrs = [enumerator fileAttributes];
            
            if([[attrs objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
                NSLog(@"Folder \"%@\"\n", file);
            }
            else {
                fileInstance.name = [file lastPathComponent];
                fileInstance.path = [file stringByDeletingLastPathComponent];
                fileInstance.set = [[file stringByDeletingLastPathComponent] stringByReplacingOccurrencesOfString:@"/" withString:@" "];
                [self.fileArray addObject:fileInstance];
            }
        }
    }
    return [self.fileArray count];
}

- (void)startUploadingTo:(NSObject<UploaderDelegate> *)uploader
{
    [self.fileArray enumerateObjectsUsingBlock:^(FileInstance *obj, NSUInteger idx, BOOL *stop) {
        
        [uploader upload:[obj name] FromPath:[obj path] ToSet:[obj set]];
    }];
}


@end
