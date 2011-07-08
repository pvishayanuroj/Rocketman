//
//  Boundary.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/29/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Boundary.h"
#import "Obstacle.h"
#import "UtilFuncs.h"

@implementation Boundary

@synthesize collide = collide_;

+ (id) boundaryWithTarget:(Obstacle *)obstacle collide:(SEL)cSel hit:(SEL)hSel colStruct:(PVCollide)col
{
    return [[[self alloc] initWithTarget:obstacle collide:cSel hit:hSel colStruct:col] autorelease];
}

- (id) initWithTarget:(Obstacle *)obstacle collide:(SEL)cSel hit:(SEL)hSel colStruct:(PVCollide)col
{
    if ((self = [super init])) {
        
        // Weak reference, otherwise we get into a circular reference
        target_ = [obstacle retain];
        collideSel_ = cSel;
        hitSel_ = hSel;
        
        collide_ = col;
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"Boundary dealloc'd");    
#endif    
    [target_ release];
    
    [super dealloc];
}

- (BOOL) collisionCheckAndHandle:(CGPoint)objectPos rocketBox:(CGRect)rocketBox
{
    if (collide_.collideActive && [self collides:objectPos rocketBox:rocketBox]) {
        if (collide_.autoInactive) {
            collide_.collideActive = NO;
            collide_.hitActive = NO;
        }
        [target_ performSelector:collideSel_];
        return YES;
    }
    return NO;
}

- (BOOL) hitCheckAndHandle:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius
{
    if (collide_.hitActive && [self collides:objectPos catPos:catPos catRadius:catRadius]) {
        if (collide_.autoInactive) {
            collide_.hitActive = NO;
            collide_.collideActive = NO;
        }
        [target_ performSelector:hitSel_];
        return YES;
    }
    return NO;
}

- (BOOL) collides:(CGPoint)objectPos rocketBox:(CGRect)rocketBox
{
    objectPos = ccpAdd(objectPos, collide_.offset);
    
    // Handle rectangle on circle checks
    if (collide_.circular) {
        return [UtilFuncs intersects:objectPos radius:collide_.radius rect:rocketBox];
    }
    // Handle rectangle on rectangle checks
    else {
        CGRect obstacleBox = CGRectMake(objectPos.x, objectPos.y, collide_.size.width, collide_.size.height);        
        return [UtilFuncs intersects:rocketBox b:obstacleBox];
    }
}

- (BOOL) collides:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius
{
    objectPos = ccpAdd(objectPos, collide_.offset);
    
    // Handle circle on circle checks
    if (collide_.circular) {
        CGFloat distance = [UtilFuncs distanceNoRoot:objectPos b:catPos];
        CGFloat threshold = catRadius + collide_.radius;
        return (distance < threshold * threshold);        
    }
    // Handle circle on rectangle checks
    else {
        CGRect obstacleBox = CGRectMake(objectPos.x, objectPos.y, collide_.size.width, collide_.size.height);                
        return [UtilFuncs intersects:catPos radius:catRadius rect:obstacleBox];
    }
}

@end
