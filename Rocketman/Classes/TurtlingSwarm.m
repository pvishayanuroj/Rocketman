//
//  TurtlingSwarm.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TurtlingSwarm.h"
#import "GameLayer.h"

@implementation TurtlingSwarm

+ (void) addSwarm:(NSUInteger)size gameLayer:(GameLayer *)gameLayer
{
    NSInteger x = 100;
    NSInteger y = 200;
    NSInteger dx = 24;
    NSInteger dy = 24;
    CGPoint pos;
    CGPoint leadPos = ccp(x,y);
    CGPoint lagPos = ccp(x - dx, y);
    
    NSInteger lastRowSize = 0;
    NSInteger numAdded = 0;
    while (numAdded < size) {
        // Generate a random number between 1 and 3 to determine how many turtles in this row
        NSInteger r = arc4random() % 3 + 1;
        
        // Do not allow consecutive rows of 1
        if (r == 1 && lastRowSize == 1) {
            r = arc4random() % 2 + 2;
        }
        
        // Randomly determine whether to place the row starting at the leading position or the lagging position
        // If the row size is 1, always choose the lagging position
        if (r == 1) {
            pos = lagPos;
        }
        else {
            if (arc4random() % 2) {
                pos = lagPos;
            }
            else {
                pos = leadPos;
            }
        }
        
        for (int i = 0; i < r; i++) {
            if (numAdded < size) {
                [gameLayer addObstacle:kTurtling pos:pos];            
                numAdded++;
                // If this was the first turtle added, calculate a new leading and lagging position for the next row
                if (i == 0) {
                    leadPos = ccp(pos.x + dx/2, pos.y + dy);
                    lagPos = ccp(pos.x - dx/2, pos.y + dy);
                }
                // The next turtle in this row goes behind this turtle
                pos.x -= dx;
            }
        }
    }

}

@end
