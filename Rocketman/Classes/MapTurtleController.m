//
//  MapTurtleController.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MapTurtleController.h"
#import "MapTurtle.h"
#import "PointWrapper.h"
#import "UtilFuncs.h"

@implementation MapTurtleController

const CGFloat MTC_RIGHT_X = 400.0f;
const CGFloat MTC_LEFT_X = -100.0f;
const CGFloat MTC_GROUP_X_OFFSET = 10.0f;
const CGFloat MTC_GROUP_Y_OFFSET = 15.0f;
const NSInteger MTC_MIN_RANDOM_SPEED = 9;
const NSInteger MTC_MAX_RANDOM_SPEED = 6;
const NSInteger MTC_MIN_RANDOM_TIME = 3;
const NSInteger MTC_MAX_RANDOM_TIME = 10;

#pragma mark - Object Lifecycle

+ (id) mapTurtleControllerWithImmediateAdd:(NSInteger)numTurtles yPos:(CGFloat)yPos turtleStyle:(MapTurtleStyle)turtleStyle
{
    return [[[self alloc] initMapTurtleController:numTurtles yPos:yPos turtleStyle:turtleStyle immediateAdd:YES] autorelease]; 
}

+ (id) mapTurtleController:(NSInteger)numTurtles yPos:(CGFloat)yPos turtleStyle:(MapTurtleStyle)turtleStyle
{
    return [[[self alloc] initMapTurtleController:numTurtles yPos:yPos turtleStyle:turtleStyle immediateAdd:NO] autorelease];
}

- (id) initMapTurtleController:(NSInteger)numTurtles yPos:(CGFloat)yPos turtleStyle:(MapTurtleStyle)turtleStyle immediateAdd:(BOOL)immediateAdd
{
    if ((self = [super init])) {
        
        yPos_ = yPos;
        turtleStyle_ = turtleStyle;
        maxNumTurtles_ = numTurtles;
        if (immediateAdd) {
            [self addTurtleGroup];
        }
        else {
            [self randomizeNextGroupTiming];
        }
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark - Delegate Methods

- (void) mapTurtleDoneMoving:(MapTurtle *)mapTurtle
{
    [mapTurtle removeFromParentAndCleanup:YES];

    if (++numTurtlesReturned_ == numTurtlesActive_) {
        [self randomizeNextGroupTiming];
    }
}

- (void) randomizeNextGroupTiming
{
    NSInteger randomDelay = [UtilFuncs randomIncl:MTC_MIN_RANDOM_TIME*10 b:MTC_MAX_RANDOM_TIME*10];
    CGFloat delayTime = randomDelay/10.0f;
    CCActionInterval *delay = [CCDelayTime actionWithDuration:delayTime];
    CCActionInstant *add = [CCCallFunc actionWithTarget:self selector:@selector(addTurtleGroup)];
    [self runAction:[CCSequence actions:delay, add, nil]];
}

- (void) addTurtleGroup
{
    if (maxNumTurtles_ <= 0) {
        return;
    }
    
    // Randomize number of turtles and side
    NSInteger numTurtles = [UtilFuncs randomIncl:1 b:maxNumTurtles_];
    MapTurtleSide side = (arc4random() % 2 == 0) ? kMapLeft : kMapRight;
    
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:numTurtles];
    CGFloat xPos = (side == kMapLeft) ? MTC_LEFT_X : MTC_RIGHT_X;
    CGFloat yPos = yPos_;
    
    // First turtle always goes on start point
    PointWrapper *p1 = [PointWrapper cgPoint:CGPointMake(xPos, yPos)];
    [points addObject:p1];
    
    // Randomly add unique points in different diagonal positions from the main point
    while ([points count] < numTurtles) {
        // Randomly choose an xoffset
        NSInteger x = (arc4random() % 2 == 0) ? 1 : -1;
        NSInteger y = (arc4random() % 2 == 0) ? 1 : -1;
        CGPoint pos = CGPointMake(xPos + x * MTC_GROUP_X_OFFSET, yPos + y * MTC_GROUP_X_OFFSET);        
        PointWrapper *p = [PointWrapper cgPoint:pos];        
        if ([points containsObject:p]) {
            continue;
        }
        else {
            [points addObject:p];
        }
    }
    
    // Flying from left to right
    if (side == kMapLeft) {
        // Sort to ensure descending y order followed by ascending x order
        // (lower turtles placed over upper, right turtles places over left)
        // Return Ascending if obj 1 comes before obj 2
        [points sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CGPoint p1 = ((PointWrapper *)obj1).point;
            CGPoint p2 = ((PointWrapper *)obj2).point;        
            // If y equal
            if (fabs(p1.y - p2.y) < 0.01f) {
                // P1 before P2
                if (p1.x < p2.x) {
                    return NSOrderedAscending;
                }
                if (p1.x > p2.x) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }
            else {
                // P1 before P2
                if (p1.y > p2.y) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
            }
        }];        
    }
    // Flying from right to left
    else {
        // Sort to ensure descending y order followed by descending x order
        // (lower turtles placed over upper, left turtles places over right)
        // Return true if obj 1 comes before obj 2
        [points sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CGPoint p1 = ((PointWrapper *)obj1).point;
            CGPoint p2 = ((PointWrapper *)obj2).point;        
            // If y equal
            if (fabs(p1.y - p2.y) < 0.01f) {
                // P1 before P2                
                if (p1.x > p2.x) {
                    return NSOrderedAscending;
                }
                if (p1.x < p2.x) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }
            else {
                // P1 before P2
                if (p1.y > p2.y) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
            }
        }];
    }
    
    NSInteger randomSpeed = [UtilFuncs randomIncl:MTC_MIN_RANDOM_SPEED*10 b:MTC_MAX_RANDOM_SPEED*10];
    CGFloat speed = randomSpeed/10.0f; 
    for (PointWrapper *p in points) {
        MapTurtle *turtle = [MapTurtle mapTurtle:p.point speed:speed side:side type:turtleStyle_];
        turtle.delegate = self;
        [self addChild:turtle];
    }
    numTurtlesActive_ = numTurtles;
    numTurtlesReturned_ = 0;
}

@end