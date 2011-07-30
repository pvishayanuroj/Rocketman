//
//  MapScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface MapScene : CCScene {
    
}

+ (id) mapWithLastUnlocked:(NSUInteger)lastUnlockedLevel;

- (id) initMapWithLastUnlocked:(NSUInteger)lastUnlockedLevel;

@end
