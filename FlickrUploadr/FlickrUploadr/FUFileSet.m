//
//  FUFileSet.m
//  FlickrUploadr
//
//  Created by Richard Duszczak on 11/7/13.
//  Copyright (c) 2013 Richard Duszczak. All rights reserved.
//

#import "FUFileSet.h"

@implementation FUInfoDirector

+(NSString *)getNameFromFile:(NSString *)file
{
    return [file lastPathComponent];
}

+(NSString *)getPathFromFile:(NSString *)file
{
    return [file stringByDeletingLastPathComponent];
}

+(NSString *)getSetNameFromFile:(NSString *)file
{
    return [[[file stringByDeletingLastPathComponent] stringByReplacingOccurrencesOfString:@"/" withString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

}

@end

@implementation FUFileInstance

-(id) initWithName:(NSString *)name Path:(NSString *)path Set:(NSString *)set
{
    self = [super init];
    
    self.name = name;
    self.path = path;
    self.set = set;
    
    return self;
}

-(id) initWithFile:(NSString *)file
{
    self = [super init];
    
    self.name = [FUInfoDirector getNameFromFile:file];
    self.path = [FUInfoDirector getPathFromFile:file];
    self.set = [FUInfoDirector getSetNameFromFile:file];
    
    return self;
}

+(id) instanceWithFile:(NSString *)file
{
    return [[FUFileInstance alloc] initWithFile:file];
}

@end

@implementation FUFileSet
{
    NSMutableSet *set;
}


-(void) add:(FUFileInstance *)file
{
    
}

-(int) count
{
    return 0;
}
@end
