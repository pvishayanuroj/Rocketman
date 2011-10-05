//
//  MapLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "MapButtonDelegate.h"

@interface MapLayer : CCLayer <MapButtonDelegate> {
    
    NSMutableArray *levelDescs_;
    
}

+ (id) mapWithFile:(NSString *)filename lastUnlocked:(NSUInteger)lastUnlockedLevel;

- (id) initWithFile:(NSString *)filename lastUnlocked:(NSUInteger)lastUnlockedLevel;

/** Does not allow user input for the map screen */
- (void) lockInput;

/** Allows user input for the map screen */
- (void) unlockInput;

@end
