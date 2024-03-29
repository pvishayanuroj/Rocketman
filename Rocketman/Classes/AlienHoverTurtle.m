//
//  AlienHoverTurtle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "AlienHoverTurtle.h"
#import "Boundary.h"
#import "ConstantMovementWithStop.h"
#import "SideMovement.h"
#import "AudioManager.h"
#import "DataManager.h"
#import "TargetedAction.h"
#import "GameManager.h"
#import "Egg.h"
#import "LightBlastCloud.h"

@implementation AlienHoverTurtle

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

#pragma mark - Object Lifecycle

+ (id) shieldedAlienHoverTurtleWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:kShieldedAlienHoverTurtle] autorelease];
}

+ (id) alienHoverTurtleWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:kAlienHoverTurtle] autorelease];
}

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type
{
	if ((self = [super init])) {
        
		unitID_ = countID++;   
        originalObstacleType_ = kAlienHoverTurtle;
        obstacleType_ = kAlienHoverTurtle;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];                 
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        collide.autoInactive = NO; 
        HP_ = 3;
        sprite_.flipX = YES;        
        
        // Bounding box setup
        boundary_ = [[Boundary boundary:self colStruct:collide] retain];
        [boundaries_ addObject:boundary_];        

        // Setup side to side movement
        SideMovement *movement = [SideMovement sideMovement:self leftCutoff:10 rightCutoff:300 speed:3.0f];
        movement.delegate = self;
        [movement setProximityTrigger:20.0f];        
        [movements_ addObject:movement];        
        
        if (type == kShieldedAlienHoverTurtle) {
            int numEggs = 3;
            for (int i = 0; i < numEggs; i++) {
                Egg *egg = [Egg redEggWithPos:self.position rate:0.1f radius:40.0f angle:(M_PI * i * (2.0f/numEggs))];
                [[GameManager gameManager] addObstacle:egg];
                [childObstacles_ addObject:egg];            
            }
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
    [damageAnimation_ release];
    [attackAnimation_ release];
    
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
    
    animationName = [NSString stringWithFormat:@"%@ Attack", name_];    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	attackAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];        
}                 

- (void) showAttack
{
	[sprite_ stopAllActions];	
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)attackAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];	
	[self runAction:[CCSequence actions:animation, delay, method, nil]];	
}

- (void) showDamage
{
	[sprite_ stopAllActions];	
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)damageAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];	
	[self runAction:[CCSequence actions:animation, delay, method, nil]];	
}


- (void) boundaryHit:(CGPoint)point boundaryID:(NSInteger)boundaryID catType:(CatType)catType
{
    [[AudioManager audioManager] playSound:kPlop];        
    
    // Creature death
    if (--HP_ == 0) {
        PVCollide c = boundary_.collide;
        c.hitActive = NO;
        boundary_.collide = c;   
        [boundary_ release];
        [self death];
        [[GameManager gameManager] enemyKilled:originalObstacleType_ pos:self.position];        
        
        // Make eggs invisible
        for (Obstacle *obstacle in childObstacles_) {
            obstacle.visible = NO;
        }
    }    
    else {
        [self showDamage];
    }
}

- (void) death
{        
    destroyed_ = YES;
    sprite_.visible = NO;
    
    [[GameManager gameManager] addDoodad:[LightBlastCloud lightBlastCloudAt:self.position movements:movements_]];
}

- (void) sideMovementLeftTurnaround:(SideMovement *)movement
{
    sprite_.flipX = NO;                   
}

- (void) sideMovementRightTurnaround:(SideMovement *)movement
{
    sprite_.flipX = YES; 
}

- (void) sideMovementProximityTrigger:(SideMovement *)movement
{
    if (self.position.y <= yTarget_) {
        CGPoint pos = CGPointMake(self.position.x, self.position.y - 5);
        [[GameManager gameManager] addObstacle:pos type:kPlasmaBall];
        [self showAttack];
    }
}

- (void) sideMovementRandomTrigger:(SideMovement *)movement
{
    
}

@end
