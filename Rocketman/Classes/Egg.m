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
#import "GameManager.h"
#import "ArcMovement.h"
#import "LightBlastCloud.h"

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
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];
        
        [movements_ addObject:[CircularMovement circularMovement:rate radius:radius angle:angle]];
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

- (void) boundaryCollide:(NSInteger)boundaryID
{
    if ([[GameManager gameManager] isRocketInvincible]) {
        
        [movements_ removeAllObjects];
        [movements_ addObject:[ArcMovement arcFastRandomMovement:self.position]];
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
    
    [[GameManager gameManager] addDoodad:[LightBlastCloud lightBlastCloudAt:self.position movements:movements_]];
}

@end
