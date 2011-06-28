//
//  UtilFuncs.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface UtilFuncs : NSObject {
    
}

+ (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b;

+ (BOOL) intersects:(CGPoint)circle radius:(CGFloat)r rect:(CGRect)rect;

+ (BOOL) intersects:(CGRect)a b:(CGRect)b;

/** Collision method used for circular or retangular collisions with the rocket (modeled as a rectangular box) */
+ (BOOL) collides:(PVCollide)collide objectPos:(CGPoint)objectPos rocketBox:(CGRect)rocketBox;

/** Collision method used for circular or retangular collisions with the cat bullets (modeled as a circle) */
+ (BOOL) collides:(PVCollide)collide objectPos:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius;

@end
