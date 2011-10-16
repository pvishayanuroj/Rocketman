//
//  Obstacle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"
#import "BlastCloud.h"
#import "GameLayer.h"
#import "Boundary.h"
#import "Movement.h"

@implementation Obstacle

@synthesize obstacleType = obstacleType_;
@synthesize unitID = unitID_;
@synthesize destroyed = destroyed_;
@synthesize boundaries = boundaries_;

#pragma mark - Object Lifecycle

- (id) init
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        heightTriggerActive_ = NO;
        
        // Default collision parameters (override some of these)
        defaultPVCollide_.circular = YES; // Circular radius
        defaultPVCollide_.collideActive = YES; // Can be collided with by the rocket
        defaultPVCollide_.hitActive = YES; // Can be shot at
        defaultPVCollide_.autoInactive = YES; // Defaults hit and collide to inactive after first hit or collide
        defaultPVCollide_.radius = 10;
        defaultPVCollide_.size.width = 10;
        defaultPVCollide_.size.height = 10;
        defaultPVCollide_.offset = CGPointZero;
        
        destroyed_ = NO;
        boundaries_ = [[NSMutableArray arrayWithCapacity:1] retain];
        movements_ = [[NSMutableArray arrayWithCapacity:1] retain];
        childObstacles_ = [[NSMutableArray array] retain];
    }
    return self;
}

- (void) dealloc
{
    // Do this in the destroy function to avoid circular referencing
    //[boundaries_ release];
    //[movements_ release];
    
    [super dealloc];
}

#pragma mark - Object Manipulators

- (NSString *) description
{
    return [NSString stringWithFormat:@"%@ %d", name_, unitID_];
}  

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) showDeath:(EventText)text
{
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:0.3];    
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(death)];    
    
    BlastCloud *blast = [BlastCloud blastCloudAt:CGPointZero size:1.0 text:text];
    [self addChild:blast];
    
    [self runAction:[CCSequence actions:delay, method, nil]];
}

- (void) fall:(CGFloat)speed
{
    // Go through all chained movements and keep track of the total movement
    CGPoint moveAmt = self.position;
    for (Movement *movement in movements_) {
        [movement move:speed];
    }
    moveAmt = ccpSub(self.position, moveAmt);
    
    // Move all children belonging to this obstacle by the same amount
    for (Obstacle *obstacle in childObstacles_) {
        obstacle.position = ccpAdd(obstacle.position, moveAmt);
    }
    
    // Check if the height trigger will be activated
    if (heightTriggerActive_ && self.position.y < triggerHeight_) {
        [delegate_ obstacleHeightTriggered:self];
        heightTriggerActive_ = NO;
    }
}

- (void) bulletHit
{
    sprite_.visible = NO;
}

- (void) collide
{    
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer setRocketCondition:kRocketWobbling];
}

- (void) flagToDestroy
{       
    destroyed_ = YES;
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
    
    // Do this here, otherwise the boundaries' ref to obstacles will never be release, thus causing a circular reference
    [boundaries_ release];
    boundaries_ = nil;

    // Likewise, remove movements here, because each movement has a reference to this obstacle    
    [movements_ release];
    movements_ = nil;
    
    // Take care of cleanup of child obstacles
    for (Obstacle *obstacle in childObstacles_) {
        [obstacle flagToDestroy];
    }
    
    [childObstacles_ release];
    childObstacles_ = nil;
}

- (void) setHeightTrigger:(CGFloat)height delegate:(id <ObstacleDelegate>)delegate
{
    delegate_ = delegate;
    heightTriggerActive_ = YES;
    triggerHeight_ = height;
}

#pragma mark - Debug Methods

#if DEBUG_BOUNDINGBOX
- (void) draw
{    
    for (Boundary *b in boundaries_) {
        if (b.collide.circular) {
            glColor4f(1.0, 0, 0, 1.0);        
            ccDrawCircle(b.collide.offset, b.collide.radius, 0, 48, NO);    
        }
        else {
            // top left
            CGPoint p1 = ccp(-b.collide.size.width / 2, b.collide.size.height / 2);
            p1 = ccpAdd(p1, b.collide.offset);
            // top right
            CGPoint p2 = ccp(b.collide.size.width / 2, b.collide.size.height / 2);
            p2 = ccpAdd(p2, b.collide.offset);            
            // bottom left
            CGPoint p3 = ccp(-b.collide.size.width / 2, -b.collide.size.height / 2);
            p3 = ccpAdd(p3, b.collide.offset);            
            // bottom right
            CGPoint p4 = ccp(b.collide.size.width / 2, -b.collide.size.height / 2);    
            p4 = ccpAdd(p4, b.collide.offset);            
            
            glColor4f(1.0, 0, 0, 1.0);            
            ccDrawLine(p1, p2);
            ccDrawLine(p3, p4);    
            ccDrawLine(p2, p4);
            ccDrawLine(p1, p3);            
        }
    }
}
#endif

@end
