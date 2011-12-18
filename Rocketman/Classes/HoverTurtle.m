//
//  HoverTurtle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HoverTurtle.h"
#import "Boundary.h"
#import "AudioManager.h"
#import "GameManager.h"
#import "DataManager.h"
#import "GameLayer.h"
#import "SideMovement.h"
#import "ConstantMovementWithStop.h"
#import "ArcMovement.h"
#import "LightBlastCloud.h"
#import "UtilFuncs.h"

@implementation HoverTurtle

static const NSInteger HT_START_Y = 400;
static const NSInteger HT_START_Y_PLUSMINUS = 40;

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) hoverTurtleWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;   
        originalObstacleType_ = kHoverTurtle;
        obstacleType_ = kHoverTurtle;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];                 
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        // The hover turtle only starts from either side of the screen
		CGSize size = [[CCDirector sharedDirector] winSize];   
        NSInteger yPos = [UtilFuncs randomPlusMinus:HT_START_Y range:HT_START_Y_PLUSMINUS];
        if (pos.x < size.width * 0.5f) {
            self.position = CGPointMake(-50.0f, yPos);
        }
        else {
            self.position = CGPointMake(size.width + 50.0f, yPos);
        }
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 30;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];        
        
        // Setup side to side movement
        SideMovement *movement = [SideMovement sideMovement:self leftCutoff:10 rightCutoff:300 speed:2.5f];
        movement.delegate = self;
        [movement setRandomTrigger:3];
        [movements_ addObject:movement];
        
        [self initEngine];
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

- (void) initEngine
{
    CCSprite *engine1 = [CCSprite spriteWithSpriteFrameName:@"Engine Flash Idle 01.png"];
    CCSprite *engine2 = [CCSprite spriteWithSpriteFrameName:@"Engine Flash Idle 01.png"];    
    CGFloat xoffset = 15;
    CGFloat yoffset = -25;    
    engine1.position = CGPointMake(-xoffset, yoffset);
    engine2.position = CGPointMake(xoffset, yoffset);    
    [self addChild:engine1];
    [self addChild:engine2];    
    
    // Make the engine flame animate
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Engine Flash Idle"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	CCAction *e1Animation = [CCRepeatForever actionWithAction:animate];	    
	CCAction *e2Animation = [CCRepeatForever actionWithAction:animate];	        
    [engine1 runAction:e1Animation];
    [engine2 runAction:e2Animation];    
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

- (void) sideMovementProximityTrigger:(SideMovement *)movement
{
    CGPoint pos = CGPointMake(self.position.x, self.position.y - 10);
    [[GameManager gameManager] addObstacle:pos type:kPlasmaBall];
}

- (void) sideMovementRandomTrigger:(SideMovement *)movement
{
    CGPoint pos = CGPointMake(self.position.x, self.position.y - 10);
    [[GameManager gameManager] addObstacle:pos type:kPlasmaBall];
}

@end
