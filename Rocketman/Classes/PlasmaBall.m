//
//  PlasmaBall.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PlasmaBall.h"
#import "Boundary.h"
#import "ConstantMovement.h"
#import "GameLayer.h"
#import "AudioManager.h"

@implementation PlasmaBall

const CGFloat PB_SCALE = 1.3f;
const CGFloat PB_SCALE_BIG = 1.6f;
const CGFloat PB_GROW_DURATION = 0.15f;
const CGFloat PB_SHRINK_DURATION = 0.1f;
const CGFloat PB_PULSE_DELAY = 0.2f;
const CGFloat PB_SPEED = 6.0f;

static NSUInteger countID = 0;

+ (id) plasmaBallWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Plasma Bullet.png"] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:@selector(primaryCollision) hit:nil colStruct:collide]];
        
        // This gets released in the death function
        movement_ = [[ConstantMovement constantMovement:self rate:PB_SPEED] retain];
        
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
    return [NSString stringWithFormat:@"Plasma Bullet %d", unitID_];
}    

- (void) initActions
{
    CCActionInterval *grow = [CCScaleTo actionWithDuration:PB_GROW_DURATION scale:PB_SCALE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:PB_SHRINK_DURATION scale:PB_SCALE_BIG];    
    CCActionInterval *shrinkEase = [CCEaseIn actionWithAction:shrink rate:2.0];    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:PB_PULSE_DELAY];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:PB_PULSE_DELAY];    
    idleAnimation_ = [[CCRepeatForever actionWithAction:[CCSequence actions:growEase, delay1, shrinkEase, delay2, nil]] retain];
}                 

- (void) primaryCollision
{
    sprite_.visible = NO;    
    
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [[AudioManager audioManager] playSound:kWerr];                
    [gameLayer slowDown:0.66];    
    
    [super collide];    
    [self death];
}

- (void) death
{    
    GameLayer *gameLayer = (GameLayer *)[self parent];    
    [gameLayer removeObstacle:self];      
    
    [super destroy];
}

@end
