//
//  CatBullet.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface CatBullet : CCNode {
 
    CCSprite *sprite_;
 
    CGFloat radius_;
    
    CGFloat radiusSquared_;
    
    CGFloat velocity_;
}

@property (nonatomic, readonly) CGFloat radiusSquared;

+ (id) catBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;

- (id) initWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;

- (void) fall:(CGFloat)speed;

@end
