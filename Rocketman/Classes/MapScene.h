//
//  MapScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface MapScene : CCScene {
    
}

+ (id) mapWithLastUnlocked:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel;

- (id) initMapWithLastUnlocked:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel;

@end
