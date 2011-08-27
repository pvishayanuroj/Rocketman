//
//  AlienHoverTurtle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "AlienHoverTurtle.h"
#import "Boundary.h"
#import "ConstantMovementWithStop.h"
#import "SideMovement.h"
#import "AudioManager.h"
#import "TargetedAction.h"
#import "GameManager.h"

@implementation AlienHoverTurtle

static NSUInteger countID = 0;

+ (id) alienHoverTurtleWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        name_ = [[NSString stringWithString:@"Alien Hover Turtle"] retain];
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];                 
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        collide.autoInactive = NO; 
        HP_ = 3;
        
        // Bounding box setup
        boundary_ = [[Boundary boundaryWithTarget:self collide:nil hit:@selector(primaryHit) colStruct:collide] retain];
        [boundaries_ addObject:boundary_];        
        
        CGSize size = [[CCDirector sharedDirector] winSize];        
        CGFloat yTarget = 0.80 * size.height;        
        
        // Setup the initial fall
        ConstantMovementWithStop *initial = [ConstantMovementWithStop constantMovementWithStop:self rate:-1.0f withStop:yTarget];
        [movements_ addObject:initial];        
        
        // Setup side to side movement
        SideMovement *movement = [SideMovement sideMovement:self distance:200 speed:3];
        movement.delegate = self;
        [movement setProximityTrigger:25.0f];        
        [movements_ addObject:movement];
        
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
    
    [super dealloc];
}

- (void) initActions
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Idle", name_];    
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	
    
    animationName = [NSString stringWithFormat:@"%@ Damage", name_];    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	damageAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];    
    
    animationName = [NSString stringWithFormat:@"%@ Attack", name_];    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	attackAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];        
}                 

- (void) showAttack
{
	[sprite_ stopAllActions];	
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)attackAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];	
	[self runAction:[CCSequence actions:animation, delay, method, nil]];	
}

- (void) showDamage
{
	[sprite_ stopAllActions];	
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)damageAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];	
	[self runAction:[CCSequence actions:animation, delay, method, nil]];	
}


- (void) primaryHit
{
    [[AudioManager audioManager] playSound:kPlop];        
    
    // Creature death
    if (--HP_ == 0) {
        [super showDeath:kBamText];
        [super bulletHit];
        PVCollide c = boundary_.collide;
        c.hitActive = NO;
        boundary_.collide = c;   
        [boundary_ release];
    }    
    else {
        [self showDamage];
    }
}

- (void) death
{        
    [super flagToDestroy];
}

- (void) sideMovementProximityTrigger:(SideMovement *)movement
{
    CGPoint pos = CGPointMake(self.position.x, self.position.y - 5);
    //[[GameManager gameManager] addPlasmaBall:pos];
    //[self showAttack];
}

- (void) sideMovementRandomTrigger:(SideMovement *)movement
{
    
}

@end