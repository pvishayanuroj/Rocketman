//
//  Flybot.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Flybot.h"
#import "GameLayer.h"
#import "AudioManager.h"
#import "Boundary.h"

@implementation Flybot

static NSUInteger countID = 0;

+ (id) flyBotWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Flybot Idle 01.png"] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;

        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:@selector(primaryCollision) hit:@selector(primaryHit) colStruct:collide]];        
        
        
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
    return [NSString stringWithFormat:@"Flybot %d", unitID_];
}    

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Flybot Idle"];
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
    GameLayer *gameLayer = (GameLayer *)[self parent];    
    [gameLayer removeObstacle:self];      
    
    [super destroy];
}

@end
