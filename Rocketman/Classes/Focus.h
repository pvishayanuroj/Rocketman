//
//  Focus.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@class Obstacle;

@interface Focus : CCNode {
 
    CCSprite *sprite_;
    
}

+ (id) focusWithObstacle:(Obstacle *)obstacle delay:(CGFloat)delay;

+ (id) focusWithFixed:(ButtonType)buttonType delay:(CGFloat)delay;

- (id) initFocus:(Obstacle *)obstacle buttonType:(ButtonType)buttonType delay:(CGFloat)delay;

- (void) circleAnimation:(CGFloat)delay;

- (CGPoint) getArrowPosition:(ButtonType)buttonType;

- (void) arrowAnimation:(CGFloat)delay;

@end
