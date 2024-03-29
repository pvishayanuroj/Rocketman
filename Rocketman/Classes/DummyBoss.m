//
//  DummyBoss.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "DummyBoss.h"
#import "DataManager.h"
#import "AudioManager.h"
#import "GameManager.h"
#import "Boundary.h"
#import "ConstantMovementWithStop.h"
#import "SideMovement.h"
#import "LightBlastCloud.h"
#import "DarkBlastCloud.h"

@implementation DummyBoss

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

#pragma mark - Object Lifecycle

+ (id) dummyBossWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;    
        originalObstacleType_ = kDummyBoss;
        obstacleType_ = kDummyBoss;
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
        
        CGSize size = [[CCDirector sharedDirector] winSize];        
        CGFloat yTarget = 0.80 * size.height;        
        
        // Setup the initial fall
        ConstantMovementWithStop *initial = [ConstantMovementWithStop constantMovementWithStop:-1.5f withStop:yTarget];
        [movements_ addObject:initial];        
        
        // Setup side to side movement
        SideMovement *movement = [SideMovement sideMovement:self distance:200 speed:1.5f];
        movement.delegate = self;      
        [movements_ addObject:movement];       
        
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

- (void) showDamage
{
	[sprite_ stopAllActions];	
 
    [self showIdle];
    /*
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)damageAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];	
	[self runAction:[CCSequence actions:animation, delay, method, nil]];	
     */
}

- (void) boundaryHit:(CGPoint)point boundaryID:(NSInteger)boundaryID
{
    [[AudioManager audioManager] playSound:kPlop];        
    
    // Creature death
    if (--HP_ == 0) {
        PVCollide c = boundary_.collide;
        c.hitActive = NO;
        boundary_.collide = c;   
        [boundary_ release];
        [self death];
    }    
    else {
        [self showDamage];
        // Turtle takes no damage on shell hit
        [[GameManager gameManager] addDoodad:[LightBlastCloud lightBlastCloudAt:point movements:movements_]];
    }
}

- (void) death
{        
    destroyed_ = YES;
    sprite_.visible = NO;
    
    [[GameManager gameManager] addDoodad:[DarkBlastCloud darkBlastCloudAt:self.position]];
    [[GameManager gameManager] enemyKilled:originalObstacleType_ pos:self.position];    
}

- (void) sideMovementLeftTurnaround:(SideMovement *)movement
{
    sprite_.flipX = NO;    
}

- (void) sideMovementRightTurnaround:(SideMovement *)movement
{
    sprite_.flipX = YES;     
}

@end
