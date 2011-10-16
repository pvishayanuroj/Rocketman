//
//  SwarmGenerator.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "SwarmGenerator.h"
#import "GameLayer.h"

@implementation SwarmGenerator

+ (void) addHorizontalSwarm:(NSUInteger)size gameLayer:(GameLayer *)gameLayer type:(ObstacleType)type
{
    NSInteger x = -500;
    NSInteger y = 400;
    NSInteger dx = 30;
    NSInteger dy = 30;
    CGPoint pos;
    pos.x = x;
    NSInteger numAdded = 0;
    
    NSInteger currentCol = 0;
    
    while (numAdded < size) {
        NSInteger toAdd;
        // If an even column, only allow one        
        if (currentCol % 2 == 0) {
            toAdd = 1;
            pos.y = y;
        }
        else {
            // Either of three permutations - 01, 10, or 11
            toAdd = arc4random() % 2 + 1;
            if (toAdd == 1) {
                NSInteger perm = arc4random() % 2;
                if (perm == 1) {
                    pos.y = y + dy;
                }
                else {
                    pos.y = y - dy;
                }
            }
            else {
                pos.y = y + dy;
            }
        }
        
        for (int i = 0; i < toAdd; i++) {
            if (numAdded < size) {
                [gameLayer addObstacle:type pos:pos];            
                numAdded++;
                pos.y -= (2*dy);                
            }
        }
        
        // Next column
        pos.x += dx;
        currentCol++;
    }
}

+ (void) addVerticalSwarm:(NSUInteger)size gameLayer:(GameLayer *)gameLayer type:(ObstacleType)type
{
    NSInteger x = -100;
    NSInteger y = 600;
    NSInteger dx = 30;
    NSInteger dy = 30;
    NSInteger varx = 5;    
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
        lastRowSize = r;
        
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
                [gameLayer addObstacle:type pos:pos];            
                numAdded++;
                // If this was the first turtle added, calculate a new leading and lagging position for the next row
                if (i == 0) {
                    // Give the x location some variance so the rows don't look so lined up
                    NSInteger rx = arc4random() % (varx * 2 + 1) - varx;
                    leadPos = ccp(rx + pos.x + dx/2, pos.y + dy);
                    lagPos = ccp(pos.x - dx/2, pos.y + dy);
                }
                // The next turtle in this row goes behind this turtle
                pos.x -= dx;
            }
        }
    }
}

@end
