//
//  Egg.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Egg.h"
#import "Boundary.h"
#import "CircularMovement.h"
#import "GameLayer.h"
#import "AudioManager.h"
#import "DataManager.h"

@implementation Egg

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) redEggWithPos:(CGPoint)pos rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle
{
    return [[[self alloc] initWithPos:pos type:kRedEgg rate:rate radius:radius angle:angle] autorelease];
}

+ (id) blueEggWithPos:(CGPoint)pos rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle
{
    return [[[self alloc] initWithPos:pos type:kBlueEgg rate:rate radius:radius angle:angle] autorelease];
}

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle
{
	if ((self = [super init])) {
        
		unitID_ = countID++;    
        obstacleType_ = type;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];        
        
        NSString *spriteName = [NSString stringWithFormat:@"%@.png", name_];         
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 10;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:@selector(primaryCollision) hit:@selector(primaryHit) colStruct:collide]];
        
        [movements_ addObject:[CircularMovement circularMovement:self rate:rate radius:radius angle:angle]];
        
        //[self initActions];
        //[self showIdle];        
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
    //[idleAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
    /*
    NSString *animationName = [NSString stringWithFormat:@"%@ Idle", name_];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	
     */
}                 

- (void) primaryCollision
{
    sprite_.visible = NO;    
    
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [[AudioManager audioManager] playSound:kWerr];                
    [gameLayer slowDown:0.66];    
    
    [super showDeath:kPlopText];
    
    [super collide];   
}

- (void) primaryHit
{
    [[AudioManager audioManager] playSound:kPlop];        
    [super showDeath:kBamText];
    
    [super bulletHit];
}

- (void) death
{    
    [super flagToDestroy];
}

@end
