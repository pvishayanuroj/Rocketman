//
//  YellowBird.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "YellowBird.h"
#import "Boundary.h"
#import "Movement.h"
#import "GameLayer.h"
#import "ConstantMovement.h"
#import "AudioManager.h"
#import "DataManager.h"
#import "TargetedAction.h"
#import "GameManager.h"
#import "ArcMovement.h"

@implementation YellowBird

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) swarmYellowBirdWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

+ (id) yellowBirdWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        obstacleType_ = kYellowBird;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];         
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        
        CGPoint fallRate = CGPointMake(3, 0);
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];
        
        [movements_ addObject:[ConstantMovement constantMovement:fallRate]];
        
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
    [damageAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Idle", name_];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	
    
    animationName = [NSString stringWithFormat:@"%@ Damage", name_];    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	damageAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];        
}                 

- (void) showDamage
{
    [sprite_ stopAllActions];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)damageAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(finishHit)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	    
}

- (void) finishHit
{
    [[AudioManager audioManager] playSound:kPlop];            
    [super showDeath:kBamText];
    [super bulletHit];    
}

- (void) boundaryCollide:(NSInteger)boundaryID
{
    if ([[GameManager gameManager] isRocketInvincible]) {
        
        [movements_ removeAllObjects];
        [movements_ addObject:[ArcMovement arcFastRandomMovement:self.position]];
    }
    else {  
        sprite_.visible = NO;    
        
        [[GameManager gameManager] rocketCollision];
        [[AudioManager audioManager] playSound:kWerr];                     
        
        [super showDeath:kPlopText];
    }         
}

- (void) boundaryHit:(CGPoint)point boundaryID:(NSInteger)boundaryID
{
    [self showDamage];
}

- (void) death
{    
    [super flagToDestroy];
}

@end
