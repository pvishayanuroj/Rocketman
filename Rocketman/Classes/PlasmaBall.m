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
#import "DataManager.h"
#import "GameManager.h"

@implementation PlasmaBall

const CGFloat PB_SCALE = 1.3f;
const CGFloat PB_SCALE_BIG = 1.6f;
const CGFloat PB_GROW_DURATION = 0.15f;
const CGFloat PB_SHRINK_DURATION = 0.1f;
const CGFloat PB_PULSE_DELAY = 0.2f;
const CGFloat PB_SPEED = 6.0f;

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) plasmaBallWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;              
        obstacleType_ = kPlasmaBall;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@.png", name_];                 
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        collide.hitActive = NO;        
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];

        // Setup the way this obstacle moves
        [movements_ addObject:[ConstantMovement constantMovementDown:PB_SPEED]];                
        
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
    CCActionInterval *grow = [CCScaleTo actionWithDuration:PB_GROW_DURATION scale:PB_SCALE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:PB_SHRINK_DURATION scale:PB_SCALE_BIG];    
    CCActionInterval *shrinkEase = [CCEaseIn actionWithAction:shrink rate:2.0];    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:PB_PULSE_DELAY];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:PB_PULSE_DELAY];    
    idleAnimation_ = [[CCRepeatForever actionWithAction:[CCSequence actions:growEase, delay1, shrinkEase, delay2, nil]] retain];
}                 

- (void) boundaryCollide:(NSInteger)boundaryID
{
    if (![[GameManager gameManager] isRocketInvincible]) {
        [[GameManager gameManager] rocketCollision];
    }
    
    sprite_.visible = NO;    
    [[AudioManager audioManager] playSound:kWerr];                
    destroyed_ = YES;
}

@end
