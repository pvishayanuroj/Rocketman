//
//  UFO.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "UFO.h"
#import "GameLayer.h"
#import "AudioManager.h"
#import "Boundary.h"
#import "StaticMovement.h"

@implementation UFO

static NSUInteger countID = 0;

+ (id) ufoWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        name_ = [[NSString stringWithString:@"UFO"] retain];
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];           
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:@selector(primaryCollision) hit:@selector(primaryHit) colStruct:collide]];        

        // Setup the way this obstacle moves
        [movements_ addObject:[StaticMovement staticMovement:self]];        
        // This gets released in the death function
        //movement_ = [[StaticMovement staticMovement:self] retain];        
        
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

- (void) primaryCollision
{
    sprite_.visible = NO;    
    
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [[AudioManager audioManager] playSound:kWerr];                
    [gameLayer slowDown:0.66];    
    
    [super showDeath:kPlopText];
    
    [super collide];    
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

@end
