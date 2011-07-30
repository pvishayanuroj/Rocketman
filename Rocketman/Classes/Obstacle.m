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

@implementation Obstacle

@synthesize markToRemove = markToRemove_;
@synthesize boundaries = boundaries_;

- (id) init
{
    if ((self = [super init])) {
        
        // Default collision parameters (override some of these)
        defaultPVCollide_.circular = YES;
        defaultPVCollide_.collideActive = YES;        
        defaultPVCollide_.hitActive = YES;
        defaultPVCollide_.autoInactive = YES;
        defaultPVCollide_.radius = 10;
        defaultPVCollide_.size.width = 10;
        defaultPVCollide_.size.height = 10;
        defaultPVCollide_.offset = CGPointZero;
        
        markToRemove_ = NO;
        boundaries_ = [[NSMutableArray arrayWithCapacity:1] retain];
    }
    return self;
}

- (void) dealloc
{
    // Do this in the destroy function to avoid circular referencing
    //[boundaries_ release];
    
    [super dealloc];
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
    CGPoint p = CGPointMake(0, speed);
    self.position = ccpSub(self.position, p);    
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

- (void) destroy
{       
    [self removeFromParentAndCleanup:YES];
    
    // Do this here, otherwise the boundaries' ref to obstacles will never be release, thus causing a circular reference
    [boundaries_ release];
    boundaries_ = nil;
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
