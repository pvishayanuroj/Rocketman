//
//  Obstacle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle

@synthesize radius = radius_;
@synthesize radiusSquared = radiusSquared_;
@synthesize collided = collided_;
@synthesize shootable = shootable_;

- (id) init
{
    if ((self = [super init])) {
     
        collided_ = NO;
        shootable_ = YES;
        
        [self initDestroyAction];
    }
    return self;
}

- (void) dealloc
{
    [destroyAnimation_ release];
    
    [super dealloc];
}

- (void) initDestroyAction
{
    CCFiniteTimeAction *m1 = [CCCallFunc actionWithTarget:self selector:@selector(addCloud)];     
	CCFiniteTimeAction *m2 = [CCCallFunc actionWithTarget:self selector:@selector(addBlast)];
	CCFiniteTimeAction *m3 = [CCCallFunc actionWithTarget:self selector:@selector(addText)];    
    CCFiniteTimeAction *m4 = [CCDelayTime actionWithDuration:0.3];    
	CCFiniteTimeAction *m5 = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];    
    destroyAnimation_ = [[CCSequence actions:m1, m2, m3, m4, m5, nil] retain];  
}

- (void) showDestroy
{
	[self runAction:destroyAnimation_];	    
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, speed);
    self.position = ccpSub(self.position, p);    
}

- (void) bulletHit
{
    sprite_.visible = NO;
    shootable_ = NO; 
    //NSAssert(NO, @"hit must be implemented in the child class of Obstacle");    
}

- (void) collide
{
    collided_ = YES;
}

- (void) addCloud
{
    NSAssert(NO, @"addCloud must be implemented in the child class of Obstacle");    
}

- (void) addBlast
{
    NSAssert(NO, @"addBlast must be implemented in the child class of Obstacle");    
}

- (void) addText
{
    NSAssert(NO, @"addText must be implemented in the child class of Obstacle");    
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
}

@end
