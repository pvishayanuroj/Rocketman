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
#import "PointWrapper.h"

@implementation Boundary

@synthesize collide = collide_;

+ (id) boundary:(id<BoundaryDelegate>)delegate colStruct:(PVCollide)col
{
    return [[[self alloc] initBoundary:delegate colStruct:col boundaryID:0] autorelease];
}

+ (id) boundary:(id<BoundaryDelegate>)delegate colStruct:(PVCollide)col boundaryID:(NSInteger)boundaryID
{
    return [[[self alloc] initBoundary:delegate colStruct:col boundaryID:boundaryID] autorelease];
}

- (id) initBoundary:(id<BoundaryDelegate>)delegate colStruct:(PVCollide)col boundaryID:(NSInteger)boundaryID
{
    if ((self = [super init])) {
        
        boundaryID_ = boundaryID;
        delegate_ = delegate;
        collide_ = col;
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"Boundary dealloc'd");    
#endif    
    
    [super dealloc];
}

- (BOOL) collisionCheckAndHandle:(CGPoint)objectPos rocketBox:(CGRect)rocketBox
{
    if (collide_.collideActive && [self collides:objectPos rocketBox:rocketBox]) {
        // If boundary is turned off after first collision
        if (collide_.autoInactive) {
            collide_.collideActive = NO;
            collide_.hitActive = NO;
        }
        // Let delegate know that collision has occurred
        if ([delegate_ respondsToSelector:@selector(boundaryCollide:)]) {
            [delegate_ boundaryCollide:boundaryID_];
        }
        return YES;
    }
    return NO;
}

- (BOOL) hitCheckAndHandle:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius catType:(CatType)catType
{
    if (collide_.hitActive && [self collides:objectPos catPos:catPos catRadius:catRadius]) {
        // If boundary is turned off after first hit        
        if (collide_.autoInactive) {
            collide_.hitActive = NO;
            collide_.collideActive = NO;
        }
        // Let delegate know that hit has occurred
        if ([delegate_ respondsToSelector:@selector(boundaryHit:boundaryID:catType:)]) {
            [delegate_ boundaryHit:catPos boundaryID:boundaryID_ catType:catType];
        }
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
