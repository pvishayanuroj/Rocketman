//
//  Wall.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "cocos2d.h"
#import "BoundaryDelegate.h"

@class Boundary;

@interface Wall : Obstacle <BoundaryDelegate> {
    
    Boundary *boundary_;
    
}

+ (id) wallWithPos:(CGPoint)pos wallName:(NSString *)wallName side:(WallSide)side;

- (id) initWithPos:(CGPoint)pos wallName:(NSString *)wallName side:(WallSide)side;

@end
