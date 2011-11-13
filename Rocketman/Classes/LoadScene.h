//
//  LoadScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

/** 
 * Scene used to delay the loading of the game scene so that
 * players do not see a noticeable pause when tapping "Start"
 * from the map screen. This happens because a transition will
 * load the scene THEN start to fade
 */
@interface LoadScene : CCScene {
 
    NSUInteger levelNum_;
    
}

+ (id) stage:(NSUInteger)levelNum;

- (id) initStage:(NSUInteger)levelNum;

@end
