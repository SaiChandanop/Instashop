//
//  GroupDiskManager.m
//  Calendar
//
//  Created by Jay Canty on 4/19/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "GroupDiskManager.h"

@interface GroupDiskManager()

- (NSString *) getFolderPath;
- (NSString *) pathForDataFile;

@end

@implementation GroupDiskManager

static GroupDiskManager *theManager;


+(GroupDiskManager *)sharedManager
{
    if (theManager == nil)
        theManager = [[GroupDiskManager alloc] init];
    
    return theManager;
}

- (GroupDiskManager *) init
{
    self = [super init];
    return self;
}

-(NSString *)getFolderPath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSArray *userPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [userPath objectAtIndex:0];
	
	NSString *folder = [documentsDirectory stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO)
	{
		[fileManager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:nil];
	}	
        
	return folder;
}

- (NSString *) pathForDataFile
{
    NSString *folder = [self getFolderPath];
	NSString *fileName = @"CalData.dat";
    
	return [folder stringByAppendingPathComponent: fileName];    
}

- (void) saveDataToDiskWithObject:(id)object withKey:(NSString *)key
{
	NSString * path = [self pathForDataFile];
	
	NSMutableDictionary *rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path]; 	
	if (rootObject == nil)
		rootObject = [NSMutableDictionary dictionary];
	
	[rootObject setValue:object forKey:key];
	[NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}

- (id) loadDataFromDiskWithKey:(NSString *)key
{
    
	NSString     * path        = [self pathForDataFile];
	NSDictionary * rootObject;
    
	rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path]; 
    if (rootObject)   
        return [rootObject objectForKey:key];
    
    else return  nil;
}

- (BOOL) deleteFile:(NSString *) fileNameToDelete error:(NSError **)err
{
    NSString * path = [self pathForDataFile];
	
	NSMutableDictionary *rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	if (rootObject == nil)
		rootObject = [NSMutableDictionary dictionary];
	

	[rootObject removeObjectForKey:fileNameToDelete];

	return [NSKeyedArchiver archiveRootObject: rootObject toFile: path];

}
                         


@end
