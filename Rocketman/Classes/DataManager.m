//
//  DataManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "DataManager.h"

// For singleton
static DataManager *_dataManager = nil;

@implementation DataManager

#pragma mark - Object Lifecycle

+ (DataManager *) dataManager
{
	if (!_dataManager)
		_dataManager = [[self alloc] init];
	
	return _dataManager;
}

+ (id) alloc
{
	NSAssert(_dataManager == nil, @"Attempted to allocate a second instance of a Game State Manager singleton.");
	return [super alloc];
}

+ (void) purgeDataManager
{
	[_dataManager release];
	_dataManager = nil;
}

- (id) init
{
	if ((self = [super init])) {
        
        levelData_ = nil;
        numLevels_ = 0;
        
	}
	return self;
}

- (void) dealloc
{		
    [levelData_ release];
    levelData_ = nil;
    
	[super dealloc];
}

#pragma mark - Data Manipulation

- (void) loadLevelData
{
    NSUInteger levelNum = 1;
    while (true) {
        NSString *dataFilename = [NSString stringWithFormat:@"Level%d_data", levelNum];
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:dataFilename ofType:@"plist"];
        
        // If path doesn't exist, stop searching
        if (!dataPath) {
            break;
        }
        
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:dataPath];        
        [levelData_ addObject:data];
        levelNum++;
    }
}

- (NSArray *) getLevelNames
{
    NSMutableArray *levelNames = [NSMutableArray arrayWithCapacity:[levelData_ count]];
    for (NSDictionary *level in levelData_) {
        [levelNames addObject:[level objectForKey:@"Level Name"]]; 
    }
    return levelNames;    
}

- (NSArray *) getLevelDescs
{
    NSMutableArray *levelDescs = [NSMutableArray arrayWithCapacity:[levelData_ count]];
    for (NSDictionary *level in levelData_) {
        [levelDescs addObject:[level objectForKey:@"Level Desc"]]; 
    }
    return levelDescs;
}

- (NSString *) getLevelBackground:(NSUInteger)levelNum
{
    NSDictionary *data = [levelData_ objectAtIndex:levelNum];
    return [data objectForKey:@"Background File"];
}

- (NSString *) getLevelGround:(NSUInteger)levelNum
{
    NSDictionary *data = [levelData_ objectAtIndex:levelNum];
    return [data objectForKey:@"Ground File"];
}

- (NSString *) getLevelParallax:(NSUInteger)levelNum
{
    NSDictionary *data = [levelData_ objectAtIndex:levelNum];
    return [data objectForKey:@"Parallax File"];
}

@end
