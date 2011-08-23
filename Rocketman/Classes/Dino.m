//
//  Dino.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Dino.h"
#import "TargetedAction.h"
#import "GameLayer.h"
#import "AudioManager.h"
#import "GameManager.h"
#import "Boundary.h"
#import "StaticMovement.h"

@implementation Dino

static NSUInteger countID = 0;

+ (id) dinoWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                        
        name_ = [[NSString stringWithString:@"Dino"] retain];
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];         
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:@selector(primaryCollision) hit:@selector(primaryHit) colStruct:collide]];        
        
        // This gets released in the death function
        movement_ = [[StaticMovement staticMovement:self] retain];        
        
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
    [flameAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Idle", name_];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		
    
    animationName = [NSString stringWithFormat:@"%@ Attack", name_];
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	flameAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}   

- (void) showAttacking
{
	[sprite_ stopAllActions];	
	
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)flameAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneAttacking)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) doneAttacking
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer setRocketCondition:kRocketBurning];
    
    [self showIdle];
}

- (void) primaryCollision
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [[AudioManager audioManager] playSound:kWerr];            
    [gameLayer slowDown:0.66];    
    
    [self showAttacking];
}

- (void) primaryHit
{
    [[AudioManager audioManager] playSound:kExplosion01];            
    [super showDeath:kBamText];
    
    [super bulletHit];
}

- (void) death
{
    [super flagToDestroy];
}
         
@end
