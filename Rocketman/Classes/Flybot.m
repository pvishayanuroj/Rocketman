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
#import "DataManager.h"
#import "GameManager.h"
#import "Boundary.h"
#import "DarkBlastCloud.h"
#import "StaticMovement.h"
#import "ArcMovement.h"

@implementation Flybot

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) flyBotWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;    
        originalObstacleType_ = kFlybot;
        obstacleType_ = kFlybot;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];           
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;

        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];        
        
        // Setup the way this obstacle moves
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
    
    [super dealloc];
}

- (void) initActions
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Idle", name_];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	
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
        [[GameManager gameManager] rocketCollision];
        [[AudioManager audioManager] playSound:kWerr];                     
        
        [self death];
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
    
    [[GameManager gameManager] addDoodad:[DarkBlastCloud darkBlastCloudAt:self.position size:0.5f movements:movements_]];
}

@end
