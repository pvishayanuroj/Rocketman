//
//  UtilFuncs.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "UtilFuncs.h"


@implementation UtilFuncs

+ (CGPoint) parseCoords:(NSString *)coords
{
    NSScanner *scanner = [NSScanner scannerWithString:coords];
	// Ignore new lines, spaces, and commas and enclosing symbols
	NSCharacterSet *toIgnore = [NSCharacterSet characterSetWithCharactersInString:@", \n\r()[]{}<>"];
	[scanner setCharactersToBeSkipped:toIgnore];
	
	// Scan
    NSInteger x;
    NSInteger y;
    [scanner scanInteger:&x];    
    [scanner scanInteger:&y];
    
    return CGPointMake(x, y);
}

+ (NSInteger) randomIncl:(NSInteger)a b:(NSInteger)b
{
    NSInteger range = abs(a-b) + 1;
    NSInteger res = arc4random() % range;
    
    if (a < b) {
        return a + res;
    }
    else {
        return b + res;
    }
}

+ (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b
{
	CGFloat t1 = a.x - b.x;
	CGFloat t2 = a.y - b.y;
	return t1*t1 + t2*t2;
}

+ (BOOL) intersects:(CGPoint)circle radius:(CGFloat)r rect:(CGRect)rect
{
    CGPoint circleDistance;
    circleDistance.x = fabs(circle.x - rect.origin.x);
    circleDistance.y = fabs(circle.y - rect.origin.y);
    
    if (circleDistance.x > (rect.size.width/2 + r)) { return NO; }
    if (circleDistance.y > (rect.size.height/2 + r)) { return NO; }
    
    if (circleDistance.x <= (rect.size.width/2)) { return YES; } 
    if (circleDistance.y <= (rect.size.height/2)) { return YES; }
    
    CGFloat a = circleDistance.x - rect.size.width/2;
    CGFloat b = circleDistance.y - rect.size.height/2;
    
    return (a*a + b*b) <= r*r;
}

+ (BOOL) intersects:(CGRect)a b:(CGRect)b
{
    // Top left
    CGPoint a1 = ccp(a.origin.x - a.size.width/2, a.origin.y + a.size.height/2);
    // Bottom right
    CGPoint a2 = ccp(a.origin.x + a.size.width/2, a.origin.y - a.size.height/2);    
    
    // Top left
    CGPoint b1 = ccp(b.origin.x - b.size.width/2, b.origin.y + b.size.height/2);
    // Bottom right
    CGPoint b2 = ccp(b.origin.x + b.size.width/2, b.origin.y - b.size.height/2);        
    
    return (a1.x < b2.x) && (a2.x > b1.x) && (a1.y > b2.y) && (a2.y < b1.y);
}

+ (BOOL) collides:(PVCollide)collide objectPos:(CGPoint)objectPos rocketBox:(CGRect)rocketBox
{
    objectPos = ccpAdd(objectPos, collide.offset);
    
    // Handle rectangle on circle checks
    if (collide.circular) {
        return [self intersects:objectPos radius:collide.radius rect:rocketBox];
    }
    // Handle rectangle on rectangle checks
    else {
        CGRect obstacleBox = CGRectMake(objectPos.x, objectPos.y, collide.size.width, collide.size.height);        
        return [self intersects:rocketBox b:obstacleBox];
    }
}

+ (BOOL) collides:(PVCollide)collide objectPos:(CGPoint)objectPos catPos:(CGPoint)catPos catRadius:(CGFloat)catRadius
{
    objectPos = ccpAdd(objectPos, collide.offset);
    
    // Handle circle on circle checks
    if (collide.circular) {
        CGFloat distance = [self distanceNoRoot:objectPos b:catPos];
        CGFloat threshold = catRadius + collide.radius;
        return (distance < threshold * threshold);        
    }
    // Handle circle on rectangle checks
    else {
        CGRect obstacleBox = CGRectMake(objectPos.x, objectPos.y, collide.size.width, collide.size.height);                
        return [self intersects:catPos radius:catRadius rect:obstacleBox];
    }
}

@end
