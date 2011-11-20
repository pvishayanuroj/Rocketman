//
//  Bat.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/31/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Bat.h"
#import "DataManager.h"
#import "AudioManager.h"
#import "GameManager.h"
#import "StaticMovement.h"
#import "ConstantMovement.h"
#import "LightBlastCloud.h"
#import "Boundary.h"
#import "ArcMovement.h"

@implementation Bat

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

#pragma mark - Object Lifecycle

+ (id) batWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:kBat] autorelease];
}

+ (id) swarmBatWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:kSwarmBat] autorelease];    
}

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type
{
	if ((self = [super init])) {
        
		unitID_ = countID++; 
        originalObstacleType_ = type;        
        obstacleType_ = kBat;
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
        
        if (type == kBat) {
            [movements_ addObject:[StaticMovement staticMovement]];
        }
        else if (type == kSwarmBat) {
            CGPoint fallRate = CGPointMake(2, -3);            
            [movements_ addObject:[ConstantMovement constantMovement:fallRate]];            
        }
        
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

#pragma mark - Boundary Delegate Methods

- (void) boundaryCollide:(NSInteger)boundaryID
{
    if ([[GameManager gameManager] isRocketInvincible]) {
        
        [movements_ removeAllObjects];
        [movements_ addObject:[ArcMovement arcFastRandomMovement:self.position]];
        [[AudioManager audioManager] playSound:kPlop];        
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

- (void) death
{
    destroyed_ = YES;    
    sprite_.visible = NO;        
    
    [[GameManager gameManager] addDoodad:[LightBlastCloud lightBlastCloudAt:self.position movements:movements_]];
}

@end
