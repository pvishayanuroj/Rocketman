//
//  UtilFuncs.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface UtilFuncs : NSObject {
    
}

/** Takes a string containing 2D coordindates and returns the representative CGPoint */
+ (CGPoint) parseCoords:(NSString *)coords;

/** Returns the 2D Euclidean distance squared (without the final square root) */
+ (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b;

/** 
 * Returns a random number inclusive of the given integers (a or b could be chosen).
 * Ordering of a and b does not matter
 */
+ (NSInteger) randomIncl:(NSInteger)a b:(NSInteger)b;

/** Returns true or false at random */
+ (BOOL) randomChoice;

/** Returns a random value inclusive of val +/- range */
+ (NSInteger) randomPlusMinus:(NSInteger)val range:(NSInteger)range;

/** Returns whether or not the given circle intersects with the rectangle */
+ (BOOL) intersects:(CGPoint)circle radius:(CGFloat)r rect:(CGRect)rect;

/** Returns whether or not two rectangles intersect with each other */
+ (BOOL) intersects:(CGRect)a b:(CGRect)b;

/** Collision method used for circular or retangular collisions with the rocket (modeled as a rectangular box) */
+ (BOOL) collides:(PVCollide)collide objectPos:(CGPoint)objectPos rocketBox:(CGRect)rocketBox;

/** Collision method used for circular or retangular collisions with the cat bullets (modeled as a circle) */
+ (BOOL) collides:(PVCollide)collide objectPos:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius;

/** Removes the ".<extension>" part of the filename */
+ (NSString *) removeFileExtension:(NSString *)filename;

/** Maps object strings to enums */
+ (NSDictionary *) mapObjectTypes;

/** Maps object enums to object strings */
+ (NSDictionary *) reverseMapObjectTypes:(NSDictionary *)nameMap;

/** Returns true if the passed in type is considered a boss */
+ (BOOL) isBoss:(ObstacleType)type;

@end
