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

@implementation Obstacle

@synthesize radius = radius_;
@synthesize radiusSquared = radiusSquared_;
@synthesize size = size_;
@synthesize circular = circular_;
@synthesize collided = collided_;
@synthesize shootable = shootable_;

- (id) init
{
    if ((self = [super init])) {
        
        circular_ = YES;
        collided_ = NO;
        shootable_ = YES;
        
        // Default sizes (override this)
        radius_ = 10;
        radiusSquared_ = radius_ * radius_;
        size_.width = 10;
        size_.height = 10;

    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) showDestroy:(EventText)text
{
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:0.3];    
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];    
    
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
    collided_ = YES;
    shootable_ = NO; 
}

- (void) collide
{
    collided_ = YES;
    shootable_ = NO;
    
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer setRocketCondition:kRocketWobbling];
}

- (void) destroy
{       
    [self removeFromParentAndCleanup:YES];
}

#if DEBUG_BOUNDINGBOX
- (void) draw
{
    if (circular_) {
        glColor4f(1.0, 0, 0, 1.0);        
        ccDrawCircle(CGPointZero, radius_, 0, 48, NO);    
    }
    else {
        // top left
        CGPoint p1 = ccp(-size_.width / 2, size_.height / 2);
        // top right
        CGPoint p2 = ccp(size_.width / 2, size_.height / 2);
        // bottom left
        CGPoint p3 = ccp(-size_.width / 2, -size_.height / 2);
        // bottom right
        CGPoint p4 = ccp(size_.width / 2, -size_.height / 2);    
        
        glColor4f(1.0, 0, 0, 1.0);            
        ccDrawLine(p1, p2);
        ccDrawLine(p3, p4);    
        ccDrawLine(p2, p4);
        ccDrawLine(p1, p3);            
    }
}
#endif

@end
