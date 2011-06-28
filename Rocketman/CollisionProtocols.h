//
//  CollisionProtocols.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@protocol PrimaryCollisionProtocol <NSObject>

- (void) primaryCollision;

@property (nonatomic, readonly) PVCollide primaryPVCollide;

@end

@protocol PrimaryHitProtocol <NSObject>

- (void) primaryHit;

@property (nonatomic, readonly) PVCollide primaryPVCollide;

@end

