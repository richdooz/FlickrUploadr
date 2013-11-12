//
//  FUFileSet.h
//  FlickrUploadr
//
//  Created by Richard Duszczak on 11/7/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FUInfoDirector : NSObject

+(NSString *)getNameFromFile:(NSString *)file;
+(NSString *)getPathFromFile:(NSString *)file;
+(NSString *)getSetNameFromFile:(NSString *)file;

@end

@interface FUFileInstance : NSObject

// Do we want to store any other file information?  File type? Unique identifier? Size in bytes?
// Metadata? Image size?

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *path;
@property (nonatomic, assign) NSString *set;

-(id)initWithName:(NSString *)name Path:(NSString *)path Set:(NSString *)set;
-(id)initWithFile:(NSString *)file;

+(id)instanceWithFile:(NSString *)file;

@end



@interface FUFileSet : NSObject

-(void) add:(FUFileInstance *)file;
-(int) count;
@end
