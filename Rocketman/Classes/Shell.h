//
//  Shell.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/1/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface Shell : Obstacle <BoundaryDelegate> {
    
}

+ (id) shellWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) boundaryCollide:(NSInteger)boundaryID;

- (void) boundaryHit:(CGPoint)point boundaryID:(NSInteger)boundaryID;

+ (void) resetID;

@end
