//
//  Notification.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Notification.h"
#import "GameManager.h"
#import "DataManager.h"
#import "Banner.h"
#import "Focus.h"
#import "Obstacle.h"
#import "Pair.h"

@implementation Notification

const CGFloat NF_HEIGHT_TRIGGER = 400.0f;
const CGFloat NF_BANNER_X = 160.0f;
const CGFloat NF_BANNER_Y = 250.0f;

#pragma mark - Object Lifecycle

+ (id) notification:(NSUInteger)levelNum;
{
    return [[[self alloc] initNotification:levelNum] autorelease];
}

- (id) initNotification:(NSUInteger)levelNum;
{
    if ((self = [super init])) {
        
        currentBanner_ = nil;
        currentFocus_ = nil;
        events_ = nil;
        
        objectTriggers_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
        heightTriggers_ = [[NSMutableArray arrayWithCapacity:10] retain];
        
        [self loadData:levelNum];
        
        // Set up the first height based trigger
        if ([heightTriggers_ count] > 0) {
            
            heightTriggerIndex_ = 0;
            NSDictionary *trigger = [heightTriggers_ objectAtIndex:0];
            nextHeightTrigger_ = [[trigger objectForKey:@"Height"] integerValue];
        }
        // Else there are no height-based triggers
        else {
            nextHeightTrigger_ = INT_MAX;
        }
    }
    return self;
}

- (void) dealloc
{
    [currentBanner_ release];
    [currentFocus_ release];
 
    [objectTriggers_ release];
    [heightTriggers_ release];
    
    [events_ release];
    
    [super dealloc];
}

#pragma mark - Delegate Methods

- (void) bannerClicked
{
    [self continueEventSequence];
}

- (void) obstacleHeightTriggered:(Obstacle *)obstacle
{
    // Store the obstacle
    obstacle_ = [obstacle retain];
    
    // Form the key pair, this is the (type, count)
    // Be careful, converting unsigned to signed!
    Pair *key = [Pair pair:obstacle.obstacleType second:obstacle.unitID];    
    
    // Start the event sequence
    NSArray *events = [objectTriggers_ objectForKey:key];
    [self startEventSequence:events];
}

#pragma mark - Notification Methods

- (void) heightUpdate:(NSInteger)height
{
    // Check if trigger height has been reached
    if (height >= nextHeightTrigger_) {
        
        // Start the event sequence
        NSDictionary *trigger = [heightTriggers_ objectAtIndex:heightTriggerIndex_];
        NSArray *events = [trigger objectForKey:@"Events"];
        [self startEventSequence:events];
        
        // Setup for the next height event
        heightTriggerIndex_++;
        
        // Determine the next height to trigger on
        if (heightTriggerIndex_ < [heightTriggers_ count]) {
            NSDictionary *nextTrigger = [heightTriggers_ objectAtIndex:heightTriggerIndex_];
            nextHeightTrigger_ = [[nextTrigger objectForKey:@"Height"] integerValue];
        }
        // No more objects to add
        else {
            nextHeightTrigger_ = INT_MAX;
        }
    }
}

- (void) obstacleAdded:(Obstacle *)obstacle
{
    // Form the key pair, this is the (type, count)
    // Be careful, converting unsigned to signed!
    Pair *key = [Pair pair:obstacle.obstacleType second:obstacle.unitID];
    
    // Check if key exists as a trigger, if it does, add a height trigger
    if ([objectTriggers_ objectForKey:key]) {
        [obstacle setHeightTrigger:NF_HEIGHT_TRIGGER delegate:self];
    }
}

#pragma mark - File Input

- (void) loadData:(NSUInteger)levelNum
{
    NSArray *data = [[DataManager dataManager] getLevelNotifications:levelNum];
    
    // If this level has no notifications
    if (!data) {
        return;
    }
    
    // For all triggers in the file
    for (NSDictionary *trigger in data) {
        
        NSArray *events = [trigger objectForKey:@"Events"];
        
        // Determine what kind of trigger it is
        NSString *triggerType = [trigger objectForKey:@"Trigger"];
        NSArray *tokens = [triggerType componentsSeparatedByString:@" "];
        NSString *firstToken = [tokens objectAtIndex:0];
        
        // If this is a height trigger, determine the height
        if ([firstToken isEqualToString:@"Height"]) {
            
            // Create the dictionary object associated with height triggers
            NSInteger height = [[tokens objectAtIndex:1] integerValue];
            NSMutableDictionary *heightTrigger = [NSMutableDictionary dictionaryWithCapacity:2];
            [heightTrigger setObject:[NSNumber numberWithInteger:height] forKey:@"Height"];
            [heightTrigger setObject:events forKey:@"Events"];
            [heightTriggers_ addObject:heightTrigger];
        }
        // Otherwise this is an object trigger
        else {
            // Scan for the object count
            NSInteger count;
            NSScanner *scanner = [NSScanner scannerWithString:firstToken];
            [scanner setCharactersToBeSkipped:[NSCharacterSet letterCharacterSet]];
            [scanner scanInteger:&count];
            
            NSString *objectName = [tokens objectAtIndex:1];
            ObstacleType obstacleType = [[DataManager dataManager] typeForName:objectName];
            
            Pair *key = [Pair pair:obstacleType second:(count - 1)]; // Assuming humans start from one
            [objectTriggers_ setObject:events forKey:key];
        }
    }
    
    // Sort the height triggers array by height
    [heightTriggers_ sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    
        NSDictionary *d1 = (NSDictionary *)obj1;
        NSDictionary *d2 = (NSDictionary *)obj2;
        
        NSNumber *n1 = [d1 objectForKey:@"Height"];
        NSNumber *n2 = [d2 objectForKey:@"Height"];
        
        return [n1 compare:n2];
    }];
}

#pragma mark - Event Methods

- (void) startEventSequence:(NSArray *)events
{
    NSAssert([events count] > 0, @"Cannot start an event sequence with no events");
    
    // Pause the game
    [[GameManager gameManager] dialoguePause];
    
    events_ = [events retain];
    eventCounter_ = 0;
    
    [self runEvent];
}

- (void) continueEventSequence
{
    // Cleanup old event
    if (currentBanner_) {
        [currentBanner_ removeFromParentAndCleanup:YES];
    }
    if (currentFocus_) {
        [currentFocus_ removeFromParentAndCleanup:YES];
    }
    [currentBanner_ release];
    [currentFocus_ release];
    [obstacle_ release];
    currentBanner_ = nil;
    currentFocus_ = nil;
    obstacle_ = nil;
    
    // Check if any more events
    if (++eventCounter_ < [events_ count]) {
        [self runEvent];
    }
    // Otherwise no more events
    else {
        // Unpause and release
        [events_ release];
        events_ = nil;
        
        [[GameManager gameManager] dialogueResume];
    }
}

- (void) runEvent
{
    NSDictionary *event = [events_ objectAtIndex:eventCounter_];
    NSString *bannerName = [event objectForKey:@"Banner"];
    NSString *focusName = [event objectForKey:@"Focus"]; 
    NSNumber *delayNumber = [event objectForKey:@"Delay"];
    CGFloat delay = 0.0f;
    
    if (delayNumber) {
        delay = [delayNumber floatValue];
    }
    
    if (bannerName) {
        currentBanner_ = [[Banner banner:bannerName delay:delay] retain];
        currentBanner_.delegate = self;
        currentBanner_.position = CGPointMake(NF_BANNER_X, NF_BANNER_Y);
        [[GameManager gameManager] addToDialogueLayer:currentBanner_];
    }
    
    if (focusName) {
        // If the focus is meant to be on the trigger
        if ([focusName isEqualToString:@"Trigger"]) {
            currentFocus_ = [[Focus focusWithObstacle:obstacle_ delay:delay] retain];
        }
        // Else focus is to be on a preset UI element
        else {
            currentFocus_ = [[Focus focusWithFixed:focusName delay:delay] retain];
        }
        [[GameManager gameManager] addToDialogueLayer:currentFocus_];
    }    
}

@end