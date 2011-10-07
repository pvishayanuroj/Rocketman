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
 
    CCSpriteBatchNode *spriteSheet_;
    
    NSMutableArray *levelData_;
 
    NSUInteger numLevels_;
}

@property (nonatomic, readonly) CCSpriteBatchNode *spriteSheet;

/** 
 * Static method to get a reference to the current Data Manager singleton 
 * and to create one if it doesn't exist 
 */
+ (DataManager *) dataManager;

/** Static method to clear Data Manager singleton */
+ (void) purgeDataManager;

- (void) animationLoader:(NSString *)unitListName spriteSheetName:(NSString *)spriteSheetName;

- (void) loadLevelData;

- (NSArray *) getLevelNames;

- (NSArray *) getLevelDescs;

- (NSDictionary *) getLevelData:(NSUInteger)levelNum;

@end
