//
//  HoverTurtle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HoverTurtle.h"
#import "Boundary.h"
#import "AudioManager.h"
#import "GameManager.h"
#import "DataManager.h"
#import "GameLayer.h"
#import "SideMovement.h"
#import "ConstantMovementWithStop.h"

@implementation HoverTurtle

static NSUInteger countID = 0;

+ (id) hoverTurtleWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        obstacleType_ = kHoverTurtle;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];                 
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:nil hit:@selector(primaryHit) colStruct:collide]];        
        
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
        
        [self initEngine];
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
}                 

- (void) initEngine
{
    CCSprite *engine1 = [CCSprite spriteWithSpriteFrameName:@"Engine Flash Idle 01.png"];
    CCSprite *engine2 = [CCSprite spriteWithSpriteFrameName:@"Engine Flash Idle 01.png"];    
    CGFloat xoffset = 15;
    CGFloat yoffset = -25;    
    engine1.position = CGPointMake(-xoffset, yoffset);
    engine2.position = CGPointMake(xoffset, yoffset);    
    [self addChild:engine1];
    [self addChild:engine2];    
    
    // Make the engine flame animate
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Engine Flash Idle"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	CCAction *e1Animation = [CCRepeatForever actionWithAction:animate];	    
	CCAction *e2Animation = [CCRepeatForever actionWithAction:animate];	        
    [engine1 runAction:e1Animation];
    [engine2 runAction:e2Animation];    
}

- (void) primaryHit
{
    [[AudioManager audioManager] playSound:kPlop];        
    [super showDeath:kBamText];
    
    [super bulletHit];
}

- (void) death
{        
    [super flagToDestroy];
}

- (void) sideMovementProximityTrigger:(SideMovement *)movement
{
    CGPoint pos = CGPointMake(self.position.x, self.position.y - 10);
    [[GameManager gameManager] addObstacle:pos type:kPlasmaBall];
}

- (void) sideMovementRandomTrigger:(SideMovement *)movement
{

}

@end
