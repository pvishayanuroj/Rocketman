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

static NSUInteger countID = 0;

+ (id) catBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed
{
    return [[[self alloc] initWithPos:pos withSpeed:speed] autorelease];
}

- (id) initWithPos:(CGPoint)pos withSpeed:(CGFloat)speed;
{
    if ((self = [super init])) {
        
        unitID_ = countID++;        
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Normal 01.png"] retain];
        [self addChild:sprite_];
        
        self.position = pos;        
        
        velocity_ = speed;
        radius_ = 3;
        
        [self initActions];
        [self showIdle];
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"%@ dealloc'd", self);    
#endif
    
    [sprite_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Cat Bullet %d", unitID_];
}    

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Cat Normal"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];
}                 

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, velocity_ - speed);
    self.position = ccpAdd(self.position, p);        
}

@end
