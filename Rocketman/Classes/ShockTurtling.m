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
#import "DataManager.h"
#import "GameManager.h"
#import "LightBlastCloud.h"
#import "StaticMovement.h"
#import "ArcMovement.h"

@implementation ShockTurtling

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) shockTurtlingWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++; 
        originalObstacleType_ = kShockTurtling;
        obstacleType_ = kShockTurtling;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];         
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        collide.offset.y = -10;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];
        
        // This gets released in the death function
        [movements_ addObject:[StaticMovement staticMovement]];        
        
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
    
    animationName = [NSString stringWithFormat:@"%@ Attack", name_];    
    animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];                 
    animate = [CCAnimate actionWithAnimation:animation];
    shockAnimation_ = [[CCRepeat actionWithAction:animate times:5] retain];
    
}                 

- (void) showAttacking
{
	[sprite_ stopAllActions];	
	
	TargetedAction *attack = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)shockAnimation_];    
	CCFiniteTimeAction *shock = [CCCallFunc actionWithTarget:self selector:@selector(startShock)];	
	CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(doneAttacking)];	
	[self runAction:[CCSequence actions:attack, shock, done, nil]];	
}

- (void) doneAttacking
{
    [self death];
}

- (void) startShock
{
    //GameLayer *gameLayer = (GameLayer *)[self parent];    
    //[gameLayer setRocketCondition:kRocketBurning];    
}

- (void) boundaryCollide:(NSInteger)boundaryID
{
    if ([[GameManager gameManager] isRocketInvincible]) {
        [movements_ removeAllObjects];
        [movements_ addObject:[ArcMovement arcFastRandomMovement:self.position]];
        [[AudioManager audioManager] playSound:kPlop];      
        [[GameManager gameManager] enemyKilled:originalObstacleType_ pos:self.position];        
    }
    else {
        [[AudioManager audioManager] playSound:kWerr];                
        [[GameManager gameManager] rocketCollision];
        [self showAttacking];
    }
}

- (void) boundaryHit:(CGPoint)point boundaryID:(NSInteger)boundaryID catType:(CatType)catType
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
