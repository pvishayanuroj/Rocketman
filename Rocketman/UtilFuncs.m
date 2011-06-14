//
//  UtilFuncs.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "UtilFuncs.h"


@implementation UtilFuncs

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

@end
