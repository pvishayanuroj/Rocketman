//
//  BlueBird.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/31/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BlueBird.h"
#import "Boundary.h"
#import "ConstantMovement.h"
#import "ArcMovement.h"
#import "StaticMovement.h"
#import "DataManager.h"
#import "GameManager.h"
#import "AudioManager.h"
#import "LightBlastCloud.h"

@implementation BlueBird

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) swarmBlueBirdWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:kSwarmBlueBird] autorelease];
}

+ (id) blueBirdWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:kBlueBird] autorelease];
}

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        obstacleType_ = kBlueBird;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];         
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        
        if (type == kBlueBird) {
            [movements_ addObject:[StaticMovement staticMovement]];
        }
        else if (type == kSwarmBlueBird) {                
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
    [[AudioManager audioManager] playSound:kPlop];        
    [self death];
}

- (void) death
{
    destroyed_ = YES;    
    sprite_.visible = NO;        
    
    [[GameManager gameManager] addDoodad:[LightBlastCloud lightBlastCloudAt:self.position]];        
}

@end
