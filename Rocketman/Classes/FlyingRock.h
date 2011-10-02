//
//  FlyingRock.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface FlyingRock : Obstacle {
    
}

+ (id) rockAWithPos:(CGPoint)pos;

+ (id) rockBWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos type:(NSString *)type;

@end
