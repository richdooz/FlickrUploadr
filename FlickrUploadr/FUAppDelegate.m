//
//  FUAppDelegate.m
//  FlickrUploadr
//
//  Created by Richard Duszczak on 5/29/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import "FUAppDelegate.h"
#import "FolderScanner.h"
#import "SampleAPIKey.h"

@implementation FUAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures/flickr_test"];

    
    self.flickr = [[FUFlickr alloc] init];
    self.scanner = [[FolderScanner alloc] initWithStartingDirectory:path];
    
    [self.statusLabel setStringValue:@"Authorized"];
    [self.statusLabel display];
    [NSThread detachNewThreadSelector:@selector(startWorker) toTarget:self withObject:nil];

    [self registerUrlScheme];

    [self auth];
    [self.statusLabel setStringValue:@"Starting Flickr auth..."];
    [self.statusLabel display];
    
//    NSLog(@"Current=%@\n", [self.scanner current]);
    
    //[scanner startUploadingTo:app];
    
    NSLog(@"Finished Launching.");
    [self.statusLabel setStringValue:@"Starting..."];
    [self.statusLabel display];
    
    [self.progress setMinValue:0.0];
    [self.progress setMaxValue:0.0];
    [self.progress setDoubleValue:0.0];
    
    self.totalCount = 0;
    self.currentCount = 0;
    
    self.waitForStart = [[NSCondition alloc] init];
    self.waitForUploadComplete = [[NSCondition alloc] init];
}

- (void)registerUrlScheme
{
    NSLog(@"Registering getUrl handler");
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                       andSelector:@selector(getUrl:withReplyEvent:)
                                                     forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)auth
{
//    [self.flickr authWithKnownToken];
    [self.flickr authFromWeb];
}

- (void)startWorker
{
    self.totalCount = [self.scanner buildFileList];
    
    NSString *str = [NSString stringWithFormat:@"Uploading %lu files...",
                     (unsigned long)self.totalCount
                     ];
    [self.statusLabel setStringValue:str];
    [self.statusLabel display];
    [self.progress setMaxValue:self.totalCount];
    [self.startButton setEnabled:YES];

    NSLog(@"Waiting for start...");
    [self.waitForStart lock];
    [self.waitForStart wait];
    [self.waitForStart unlock];
    NSLog(@"Got start signal.");

    [self.scanner startUploadingTo:self];
    
}

- (void)scrollToBottom
{
    NSPoint     pt;
    id          scrollView;
    id          clipView;
    
    pt.x = 0;
    pt.y = 100000000000.0;
    
    scrollView = [self.activity enclosingScrollView];
    clipView = [scrollView contentView];
    
    pt = [clipView constrainScrollPoint:pt];
    [clipView scrollToPoint:pt];
    [scrollView reflectScrolledClipView:clipView];
}

- (void)upload:(NSString *)fileName FromPath:(NSString *)fromPath ToSet:(NSString *)setName
{
#if 0
    self.currentCount++;
    
    NSAttributedString * attrString =
    [[NSAttributedString alloc] initWithString:[NSString
                                                stringWithFormat:@"file:%@ path:%@ set:%@\n",
                                                fileName,
                                                fromPath,
                                                setName
                                                ]];
    [[self.activity textStorage] performSelectorOnMainThread:@selector(appendAttributedString:)
                                                  withObject:attrString waitUntilDone:YES
     ];
    [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:self waitUntilDone:YES];

    [self.statusLabel setStringValue:[NSString stringWithFormat:@"Uploading %lu of %lu files...",
                                      (unsigned long)self.currentCount,
                                      (unsigned long)self.totalCount
                                      ]];
    [self.progress setDoubleValue:self.currentCount];
    
    NSString *ext = [fileName pathExtension];
    NSString *mimeType = @"";

    NSString *fullPath = [fromPath stringByAppendingFormat:@"/%@", fileName];
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:fullPath];

    if([ext isCaseInsensitiveLike:@"jpg"]) {
        mimeType = @"image/jpeg";
    }
    else if([ext isCaseInsensitiveLike:@"png"]) {
        mimeType = @"image/png";
    }
    

    bool result = [flickrRequest uploadImageStream:inputStream
                                 suggestedFilename:fileName MIMEType:mimeType
                                         arguments:@{}
                   ];
    NSLog(@"Sent request result=%d FullPath=%@ Set=%@ mimeType=%@\n",
          result, fullPath, setName, mimeType
          );
//    [self.waitForUploadComplete lock];
//    [self.waitForUploadComplete wait];
//    [self.waitForUploadComplete unlock];
    NSLog(@"Sent request result=%d FullPath=%@ Set=%@ mimeType=%@\n",
          result, fullPath, setName, mimeType
          );

#endif
}


- (IBAction)start:(id)sender {
    NSLog(@"Signalling start...");
    [self.waitForStart lock];
    [self.waitForStart signal];
    [sender setEnabled:NO];
    [self.waitForStart unlock];
}
@end
