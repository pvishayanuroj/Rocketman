//
//  Angel.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Angel.h"
#import "TargetedAction.h"
#import "GameLayer.h"
#import "AudioManager.h"
#import "DataManager.h"
#import "Boundary.h"
#import "StaticMovement.h"

@implementation Angel

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) angelWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;        
        obstacleType_ = kAngel;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];           
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;

        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.hitActive = NO;
        collide.radius = 30;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];        
        
        // Setup the way this obstacle moves
        [movements_ addObject:[StaticMovement staticMovement]];        
        
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
    
    [name_ release];
    [sprite_ release];
    [idleAnimation_ release];
    [slapAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Idle", name_];    
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		
    
    animationName = [NSString stringWithFormat:@"%@ Kiss", name_];
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	slapAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}   

- (void) showAttacking
{
	[sprite_ stopAllActions];	

    //CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)slapAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneAttacking)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) doneAttacking
{
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.7];
    CCActionInstant *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];
    [self runAction:[CCSequence actions:delay, method, nil]];
}

- (void) boundaryCollide:(NSInteger)boundaryID
{
    [self showAttacking];
}

@end
