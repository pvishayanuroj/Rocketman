//
//  BigExplosion.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface BigExplosion : CCNode {
       
    CCSprite *smoke_;
    
    CCSprite *blast_;
    
    CCSprite *text_;
    
}

+ (id) bigExplosionAt:(CGPoint)pos;

- (id) initBigExplosionAt:(CGPoint)pos size:(CGFloat)size;

- (void) addSprites:(CGFloat)size;

- (void) fall:(CGFloat)speed;

@end
