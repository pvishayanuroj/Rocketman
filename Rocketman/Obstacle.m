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
        
        //[self initDestroyAction];    
    }
    return self;
}

- (void) dealloc
{
    //[destroyAnimation_ release];
    
    [super dealloc];
}

- (void) initDestroyAction
{
    /*  ********* VERY IMPORTANT *************
        Calling CCCallFunc with target self will increase our retain count by 1 every time
        This means that the object will never get to the dealloc function unless the destroyAnimation_
        object is released first, creating a circular reference. Hence we do not use this and instead
        instantiate the action every time it's called.
     */
    /*
    CCFiniteTimeAction *m1 = [CCCallFunc actionWithTarget:self selector:@selector(addCloud)];     
	CCFiniteTimeAction *m2 = [CCCallFunc actionWithTarget:self selector:@selector(addBlast)];
	CCFiniteTimeAction *m3 = [CCCallFunc actionWithTarget:self selector:@selector(addText)];    
    CCFiniteTimeAction *m4 = [CCDelayTime actionWithDuration:0.3];    
	CCFiniteTimeAction *m5 = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];    
    destroyAnimation_ = [[CCSequence actions:m1, m2, m3, m4, m5, nil] retain];  
     */
}

- (void) showDestroy
{
    CCFiniteTimeAction *m1 = [CCCallFunc actionWithTarget:self selector:@selector(addCloud)];     
	CCFiniteTimeAction *m2 = [CCCallFunc actionWithTarget:self selector:@selector(addBlast)];
	CCFiniteTimeAction *m3 = [CCCallFunc actionWithTarget:self selector:@selector(addText)];    
    CCFiniteTimeAction *m4 = [CCDelayTime actionWithDuration:0.3];    
	CCFiniteTimeAction *m5 = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];    
    [self runAction:[CCSequence actions:m1, m2, m3, m4, m5, nil]];      
    
	//[self runAction:destroyAnimation_];	    
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

#if DEBUG_BOUNDINGBOX
- (void) draw
{
    glColor4f(1.0, 0, 0, 1.0);        
    ccDrawCircle(CGPointZero, radius_, 0, 24, NO);    
}
#endif

@end
