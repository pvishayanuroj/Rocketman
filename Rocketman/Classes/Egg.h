//
//  Egg.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface Egg : Obstacle <BoundaryDelegate> {
    
}

+ (id) redEggWithPos:(CGPoint)pos rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

+ (id) blueEggWithPos:(CGPoint)pos rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

- (void) death;

+ (void) resetID;

@end
