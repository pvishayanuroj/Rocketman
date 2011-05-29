//
//  SlowCloud.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/29/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "SlowCloud.h"


@implementation SlowCloud

+ (id) slowCloudWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super initWithPos:pos])) {
        
        CGFloat rand = arc4random() % 10;
        rand *= 0.02;
        rand -= 0.1;
        sprite_.scale = 0.3 + rand;
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, speed*0.2);
    self.position = ccpSub(self.position, p);        
}

@end
