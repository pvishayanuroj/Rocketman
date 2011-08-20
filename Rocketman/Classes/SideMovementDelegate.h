//
//  SideMovementDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class SideMovement;

@protocol SideMovementDelegate <NSObject>

@optional

- (void) sideMovementLeftTurnaround:(SideMovement *)movement;

- (void) sideMovementRightTurnaround:(SideMovement *)movement;

@end