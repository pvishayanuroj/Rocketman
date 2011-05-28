//
//  CatBullet.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CatBullet.h"


@implementation CatBullet

@synthesize radius = radius_;

+ (id) catBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed
{
    return [[[self alloc] initWithPos:pos withSpeed:speed] autorelease];
}

- (id) initWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;
{
    if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Bullet.png"] retain];
        [self addChild:sprite_];
        
        self.position = pos;        
        
        velocity_ = speed;
        radius_ = 3;
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, velocity_ - speed);
    self.position = ccpAdd(self.position, p);        
}

@end
