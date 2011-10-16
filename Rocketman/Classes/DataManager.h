//
//  DataManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

/** Full game persistent singleton that holds any commonly accessed data */
@interface DataManager : NSObject {
 
    /** Sprite batch node holding all spritesheet data */    
    CCSpriteBatchNode *spriteSheet_;
    
    /** Holds all data related to showing the world map screen */    
    NSArray *mapData_;
    
    /** Maps object strings to object types */    
    NSDictionary *objectNameMap_;
    
    /** Maps object enums to object strings */    
    NSDictionary *reverseObjectNameMap_;
}

@property (nonatomic, readonly) NSArray *mapData;
@property (nonatomic, readonly) CCSpriteBatchNode *spriteSheet;

/** 
 * Static method to get a reference to the current Data Manager singleton 
 * and to create one if it doesn't exist 
 */
+ (DataManager *) dataManager;

/** Static method to clear Data Manager singleton */
+ (void) purgeDataManager;

/** Preloads all animation data */
- (void) animationLoader:(NSString *)unitListName spriteSheetName:(NSString *)spriteSheetName;

/** Preloads all world map screen data */
- (void) loadMapData;

/** Preloads all object string/enum mappings */
- (void) loadObjectNameMappings;

/** Returns the object name given the object enum */
- (NSString *) nameForType:(ObstacleType)type;

/** Returns the object enum given the object name */
- (ObstacleType) typeForName:(NSString *)name;

/** 
 * Reads from a level data file. 
 * Note: This does not cause any data to be stored in the singleton 
 */
- (NSDictionary *) getLevelData:(NSUInteger)levelNum;

/** 
 * Reads from a level notifications data file. 
 * Note: This does not cause any data to be stored in the singleton 
 */
- (NSArray *) getLevelNotifications:(NSUInteger)levelNum;

@end
