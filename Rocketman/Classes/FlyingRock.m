//
//  FlyingRock.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "FlyingRock.h"
#import "Boundary.h"
#import "AudioManager.h"
#import "DataManager.h"
#import "GameLayer.h"
#import "PointWrapper.h"
#import "BlastCloud.h"
#import "StaticMovement.h"

@implementation FlyingRock

static NSUInteger countID = 0;

+ (id) rockAWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:@"A"] autorelease];
}

+ (id) rockBWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos type:@"B"] autorelease];
}

- (id) initWithPos:(CGPoint)pos type:(NSString *)type
{
	if ((self = [super init])) {
        
		unitID_ = countID++;        
        obstacleType_ = kFlyingRock;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];        
          
        NSString *spriteName = [NSString stringWithFormat:@"%@ %@.png", name_, type];
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 32;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:@selector(primaryCollision) hit:@selector(primaryHit:) colStruct:collide]];
     
        // Setup the way this obstacle moves
        [movements_ addObject:[StaticMovement staticMovement:self]];        
        
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
    
    [super dealloc];
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

- (void) primaryHit:(PointWrapper *)pos
{
    [[AudioManager audioManager] playSound:kPlop];    
    // Account for offset, since pos is in terms of screen grid
    CGPoint p = ccpSub(pos.point, self.position);
    // Turtle takes no damage on shell hit
    BlastCloud *blast = [BlastCloud blastCloudAt:p size:1.0 text:kBamText];
    [self addChild:blast];  
}

- (void) death
{        
    [super flagToDestroy];
}

@end
