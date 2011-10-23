//
//  Boundary.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/29/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "BoundaryDelegate.h"


@interface Boundary : NSObject {
  
	PVCollide collide_;
 
    id <BoundaryDelegate> delegate_;
    
    NSInteger boundaryID_;
    
}

@property (nonatomic, assign) PVCollide collide;

+ (id) boundary:(id<BoundaryDelegate>)delegate colStruct:(PVCollide)col;

+ (id) boundary:(id<BoundaryDelegate>)delegate colStruct:(PVCollide)col boundaryID:(NSInteger)boundaryID;

- (id) initBoundary:(id<BoundaryDelegate>)delegate colStruct:(PVCollide)col boundaryID:(NSInteger)boundaryID;

- (BOOL) collisionCheckAndHandle:(CGPoint)objectPos rocketBox:(CGRect)rocketBox;

- (BOOL) hitCheckAndHandle:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius;

- (BOOL) collides:(CGPoint)objectPos rocketBox:(CGRect)rocketBox;

- (BOOL) collides:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius;

@end
