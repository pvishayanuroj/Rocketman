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
#import "GameLayer.h"
#import "SideMovement.h"

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
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Hover Turtle Idle 01.png"] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:nil hit:@selector(primaryHit) colStruct:collide]];        
        
        CGSize size = [[CCDirector sharedDirector] winSize];        
        yTarget_ = 0.80 * size.height;        
        
        // Setup side to side movement
        SideMovement *movement = [SideMovement sideMovement:self distance:200 speed:3];
        movement.delegate = self;
        // This gets released in the death function
        movement_ = [movement retain];       
        
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
    
    [sprite_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Hover Turtle %d", unitID_];
}    

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Hover Turtle Idle"];
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

- (void) fall:(CGFloat)speed
{
    [movement_ move:speed];
    
    CGFloat dy = 0;
    if (self.position.y > yTarget_) {
        dy = -1;
    }
    
    CGPoint p = CGPointMake(0, dy);
    self.position = ccpAdd(self.position, p);    
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

- (void) sideMovementRandomTrigger:(SideMovement *)movement
{
    
}

@end
