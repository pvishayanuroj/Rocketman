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
#import "GameManager.h"
#import "GameLayer.h"
#import "PointWrapper.h"
#import "LightBlastCloud.h"
#import "DarkBlastCloud.h"
#import "StaticMovement.h"
#import "ArcMovement.h"

@implementation FlyingRock

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) rockWithPos:(CGPoint)pos
{
    if (arc4random() % 2) {
        return [[[self alloc] initWithPos:pos type:@"A"] autorelease];        
    }
    else {
        return [[[self alloc] initWithPos:pos type:@"B"] autorelease];        
    }
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
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];
     
        // Setup the way this obstacle moves
        [movements_ addObject:[StaticMovement staticMovement]];        
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

- (void) boundaryCollide:(NSInteger)boundaryID
{
    // If invincible, rock explodes
    if ([[GameManager gameManager] isRocketInvincible]) {
        [self death];
    }
    // If not invincible, rock disintegrates
    else {
        [[GameManager gameManager] rocketCollision];
        [[AudioManager audioManager] playSound:kWerr];  
        [[GameManager gameManager] addDoodad:kDebrisGen pos:self.position];
        destroyed_ = YES;
        sprite_.visible = NO;
    }
}

- (void) boundaryHit:(CGPoint)point boundaryID:(NSInteger)boundaryID
{
    [[AudioManager audioManager] playSound:kPlop];    
    // Account for offset, since pos is in terms of screen grid
    CGPoint p = ccpSub(point, self.position);
    // Rock takes no damage on shell hit
    [[GameManager gameManager] addDoodad:[LightBlastCloud lightBlastCloudAt:p]];
}

- (void) death
{        
    destroyed_ = YES;
    sprite_.visible = NO;
    
    [[GameManager gameManager] addDoodad:[DarkBlastCloud darkBlastCloudAt:self.position size:1.0f movements:movements_]];
}

@end
