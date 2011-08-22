//
//  ShockTurtling.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ShockTurtling.h"
#import "Boundary.h"
#import "TargetedAction.h"
#import "GameLayer.h"
#import "AudioManager.h"
#import "StaticMovement.h"

@implementation ShockTurtling

static NSUInteger countID = 0;

+ (id) shockTurtlingWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;              
        name_ = [[NSString stringWithString:@"Turtling"] retain];
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];         
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        collide.offset.y = -10;
        
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
    [preshockAnimation_ release];
    [shockAnimation_ release];
    
    [super dealloc];
}  

- (void) initActions
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Idle", name_];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];
	
    animationName = [NSString stringWithFormat:@"%@ Preshock", name_];    
    animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
    preshockAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
    
    animationName = [NSString stringWithFormat:@"%@ Shock", name_];    
    animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];                 
    animate = [CCAnimate actionWithAnimation:animation];
    shockAnimation_ = [[CCRepeat actionWithAction:animate times:5] retain];
    
}                 

- (void) showAttacking
{
	[sprite_ stopAllActions];	
	
	TargetedAction *a1 = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)preshockAnimation_];
	TargetedAction *a2 = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)shockAnimation_];    
	CCFiniteTimeAction *shock = [CCCallFunc actionWithTarget:self selector:@selector(startShock)];	
	CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(doneAttacking)];	
	[self runAction:[CCSequence actions:a1, shock, a2, done, nil]];	
}

- (void) doneAttacking
{
    sprite_.visible = NO;
    [super showDeath:kPlopText];    
}

- (void) startShock
{
    GameLayer *gameLayer = (GameLayer *)[self parent];    
    [gameLayer setRocketCondition:kRocketBurning];    
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
    [[AudioManager audioManager] playSound:kPlop];        
    [super showDeath:kBamText];
    
    [super bulletHit];
}

- (void) death
{    
    GameLayer *gameLayer = (GameLayer *)[self parent];    
    [gameLayer removeObstacle:self];      
    
    [super destroy];
}


@end
