//
//  CatBullet.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "GameObject.h"

@interface CatBullet : GameObject {
 
	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;    
    
    CGFloat radius_;

    CGPoint s_;
    
	NSUInteger unitID_;       
    
    CGFloat explosionRadius_;
    
    NSInteger remainingImpacts_;
}

@property (nonatomic, readonly) CGFloat radius;
@property (nonatomic, readonly) CGFloat explosionRadius;
@property (nonatomic, assign) NSInteger remainingImpacts;

+ (id) catBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;

+ (id) fatBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;

+ (id) longBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;

+ (id) superCatWithPos:(CGPoint)pos withSpeed:(CGPoint)speed;

- (id) initWithPos:(CGPoint)pos withSpeed:(CGPoint)speed explosionRadius:(CGFloat)radius remainingImpacts:(NSInteger)impacts catType:(CatType)type;

- (void) initActions:(CatType)type;

- (void) showIdle;

- (void) fall:(CGFloat)speed;

@end
