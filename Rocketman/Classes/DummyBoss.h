//
//  DummyBoss.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "cocos2d.h"
#import "SideMovementDelegate.h"
#import "BoundaryDelegate.h"

@class Boundary;

@interface DummyBoss : Obstacle <BoundaryDelegate, SideMovementDelegate> {
    
    NSInteger HP_;    

    Boundary *boundary_;    
    
}

+ (id) dummyBossWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

+ (void) resetID;

@end
