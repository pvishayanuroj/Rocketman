//
//  BoundaryDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/23/11.
//  Copyright (c) 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol BoundaryDelegate <NSObject>

@optional

- (void) boundaryCollide:(NSInteger)boundaryID;

- (void) boundaryHit:(CGPoint)point boundaryID:(NSInteger)boundaryID catType:(CatType)catType;

@end