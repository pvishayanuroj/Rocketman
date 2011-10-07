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

@synthesize spriteSheet = spriteSheet_;

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

- (void) animationLoader:(NSString *)unitListName spriteSheetName:(NSString *)spriteSheetName
{
	NSArray *unitAnimations;
	NSString *unitName;
	NSString *animationName;
	NSUInteger numFr;
	CGFloat delay;
	NSMutableArray *frames;
	CCAnimation *animation;
	
	// Load from the Units.plist file
	NSString *path = [[NSBundle mainBundle] pathForResource:unitListName ofType:@"plist"];
	NSArray *unit_array = [NSArray arrayWithContentsOfFile:path];	
	
	// Load the frames from the spritesheet into the shared cache
	CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
	path = [[NSBundle mainBundle] pathForResource:spriteSheetName ofType:@"plist"];
	[cache addSpriteFramesWithFile:path];
	
	// Load the spritesheet and add it to the game scene
	path = [[NSBundle mainBundle] pathForResource:spriteSheetName ofType:@"png"];
	spriteSheet_ = [CCSpriteBatchNode batchNodeWithFile:path];
	
	// Go through all units in the plist (dictionary objects)
	for (id obj in unit_array) {
		
		unitName = [obj objectForKey:@"Name"]; 
		
		// Retrieve the array holding information for each animation
		unitAnimations = [NSArray arrayWithArray:[obj objectForKey:@"Animations"]];		
		
		// Go through all the different animations for this unit (different dictionaries)
		for (id unitAnimation in unitAnimations) {
			
			// Parse the animation specific information 
			animationName = [unitAnimation objectForKey:@"Name"];		
			animationName = [NSString stringWithFormat:@"%@ %@", unitName, animationName];
			numFr = [[unitAnimation objectForKey:@"Num Frames"] intValue];
			delay = [[unitAnimation objectForKey:@"Animate Delay"] floatValue];
			
			frames = [NSMutableArray arrayWithCapacity:6];
			
			// Store each frame in the array
			for (int i = 0; i < numFr; i++) {
				
				// Formulate the frame name based off the unit's name and the animation's name and add each frame
				// to the animation array
				NSString *frameName = [NSString stringWithFormat:@"%@ %02d.png", animationName, i+1];
				CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
				[frames addObject:frame];
			}
			
			// Create the animation object from the frames we just processed
			animation = [CCAnimation animationWithFrames:frames delay:delay];
			
#if DEBUG_SHOWLOADEDANIMATIONS
			NSLog(@"Loaded animation: %@", animationName);
#endif
			// Store the animation
			[[CCAnimationCache sharedAnimationCache] addAnimation:animation name:animationName];
			
		} // end for-loop of animations
	} // end for-loop of units
}



- (void) loadLevelData
{
    NSUInteger levelNum = 0;
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

- (NSDictionary *) getLevelData:(NSUInteger)levelNum
{
    NSDictionary *data = [levelData_ objectAtIndex:levelNum];
    return data;
}

@end
