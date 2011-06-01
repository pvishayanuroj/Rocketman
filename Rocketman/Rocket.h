//
//  Rocket.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface Rocket : CCNode {
    
    CCSprite *sprite_;
 
    CCAction *flyingAnimation_;
    
    CCAction *burningAnimation_;
    
    CCAction *shakingAnimation_;    
    
    BOOL isBurning_;
    
    CGRect rect_;
}

@property (nonatomic, readonly) CGRect rect;

+ (id) rocketWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) realignSprite;

- (void) showFlying;

- (void) showShaking;

- (void) showBurning;

@end
