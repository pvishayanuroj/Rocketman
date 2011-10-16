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

+ (id) focusWithFixed:(NSString *)fixed delay:(CGFloat)delay;

- (id) initFocus:(Obstacle *)obstacle fixed:(NSString *)fixed delay:(CGFloat)delay;

- (void) circleAnimation:(CGFloat)delay;

- (CGPoint) getArrowPosition:(NSString *)element;

- (void) arrowAnimation:(CGFloat)delay;

@end
