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
 
	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;    
    
    CGFloat radius_;
    
    CGFloat velocity_;
    
	NSUInteger unitID_;       
}

@property (nonatomic, readonly) CGFloat radius;

+ (id) catBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;

- (id) initWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;

- (void) initActions;

- (void) showIdle;

- (void) fall:(CGFloat)speed;

@end
