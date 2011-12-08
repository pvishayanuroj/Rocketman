//
//  Salamander.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/31/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Salamander.h"

#import "AudioManager.h"
#import "DataManager.h"
#import "GameManager.h"
#import "Boundary.h"
#import "LightBlastCloud.h"
#import "StaticMovement.h"
#import "ArcMovement.h"
#import "Flame.h"
#import "TargetedAction.h"

@implementation Salamander

const CGFloat SL_FLAME_COOLDOWN = 1.5f;
const CGFloat SL_FLAME_DURATION = 1.0f;
const CGFloat SL_FLAME_XOFFSET = 75.0f;
const CGFloat SL_FLAME_YOFFSET = 18.0f;

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

#pragma mark - Object Lifecycle

+ (id) salamanderWithPos:(CGPoint)pos type:(ObstacleType)type
{
    return [[[self alloc] initWithPos:pos type:type] autorelease];
}

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type
{
	if ((self = [super init])) {
        
		unitID_ = countID++;     
        originalObstacleType_ = type;        
        obstacleType_ = type;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];           
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];        
        
        // Setup the way this obstacle moves
        [movements_ addObject:[StaticMovement staticMovement]];             
        
        // Flame configuration
        FlameDirection flameDirection;
        if (type == kSalamanderLeft || type == kProximitySalamanderLeft) {
            flameDirection = kFlameLeft;
        }
        else {
            flameDirection = kFlameRight;
        }
        
        CGPoint flamePos = CGPointMake(self.position.x, self.position.y + SL_FLAME_YOFFSET);
        flamePos.x += (type == kSalamanderRight) ? SL_FLAME_XOFFSET : -SL_FLAME_XOFFSET; 
        flame_ = [[Flame repeatingFlameWithPos:flamePos flameDirection:flameDirection flameDuration:SL_FLAME_DURATION] retain];
        flame_.flameDelegate = self;
        [[GameManager gameManager] addObstacle:flame_];
        [childObstacles_ addObject:flame_];        
        
        [self initActions];
        [self showIdle];        
        
        [self schedule:@selector(attack) interval:SL_FLAME_COOLDOWN + SL_FLAME_DURATION + 0.5f];        
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
    [attackAnimation_ release];
    [flame_ release];
    
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
    animate = [CCAnimate actionWithAnimation:animation];
    attackAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	
}                 

- (void) showAttack
{
    [sprite_ stopAllActions];
    [sprite_ runAction:attackAnimation_];
}

#pragma mark - Delegate Methods

- (void) boundaryCollide:(NSInteger)boundaryID
{
    if ([[GameManager gameManager] isRocketInvincible]) {
        [flame_ cutFlame];
        [movements_ removeAllObjects];
        [movements_ addObject:[ArcMovement arcFastRandomMovement:self.position]];
        [[AudioManager audioManager] playSound:kPlop];         
        [[GameManager gameManager] enemyKilled:originalObstacleType_ pos:self.position];        
    }
    else {  
        [[GameManager gameManager] rocketCollision];
        [[AudioManager audioManager] playSound:kWerr];                     
        
        [self death];
    } 
}

- (void) boundaryHit:(CGPoint)point boundaryID:(NSInteger)boundaryID
{
    [[GameManager gameManager] enemyKilled:originalObstacleType_ pos:self.position];    
    [[AudioManager audioManager] playSound:kPlop];        
    [self death];
}

- (void) flameFinished
{
    [self showIdle];
}

#pragma mark - Object Methods

- (void) attack
{
    [self showAttack];
    [flame_ startFlame];
}

- (void) death
{    
    destroyed_ = YES;    
    sprite_.visible = NO;        
    
    [[GameManager gameManager] addDoodad:[LightBlastCloud lightBlastCloudAt:self.position movements:movements_]];
}
@end
