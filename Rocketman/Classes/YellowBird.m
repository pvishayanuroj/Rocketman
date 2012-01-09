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
#import "StaticMovement.h"
#import "ConstantMovement.h"
#import "AudioManager.h"
#import "DataManager.h"
#import "TargetedAction.h"
#import "GameManager.h"
#import "ArcMovement.h"
#import "LightBlastCloud.h"

@implementation YellowBird

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) swarmYellowBirdWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:kSwarmYellowBird] autorelease];
}

+ (id) yellowBirdWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:kYellowBird] autorelease];
}

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type
{
	if ((self = [super init])) {
        
		unitID_ = countID++; 
        originalObstacleType_ = type;        
        obstacleType_ = kYellowBird;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];         
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        
        if (type == kYellowBird) {
            [movements_ addObject:[StaticMovement staticMovement]];
        }
        else if (type == kSwarmYellowBird) {                
            CGPoint fallRate = CGPointMake(3, 0);
            [movements_ addObject:[ConstantMovement constantMovement:fallRate]];
        }
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];
        
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
    [self death];
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
    [self showDamage];
}

- (void) death
{    
    destroyed_ = YES;    
    sprite_.visible = NO;        
    
    [[GameManager gameManager] addDoodad:[LightBlastCloud lightBlastCloudAt:self.position movements:movements_]];
}

@end
