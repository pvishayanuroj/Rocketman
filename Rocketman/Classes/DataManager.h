//
//  DataManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface DataManager : NSObject {
    
    NSMutableArray *levelData_;
 
    NSUInteger numLevels_;
}

/** 
 * Static method to get a reference to the current Data Manager singleton 
 * and to create one if it doesn't exist 
 */
+ (DataManager *) dataManager;

/** Static method to clear Data Manager singleton */
+ (void) purgeDataManager;

- (void) loadLevelData;

- (NSArray *) getLevelNames;

- (NSArray *) getLevelDescs;

- (NSString *) getLevelBackground:(NSUInteger)levelNum;

- (NSString *) getLevelGround:(NSUInteger)levelNum;

- (NSString *) getLevelParallax:(NSUInteger)levelNum;

@end
