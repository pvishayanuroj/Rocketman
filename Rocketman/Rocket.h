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
    
}

+ (id) rocketWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showFlying;

- (void) showBurning;

@end
