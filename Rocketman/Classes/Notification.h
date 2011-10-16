//
//  Notification.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "BannerDelegate.h"
#import "ObstacleDelegate.h"

@class Obstacle;
@class Banner;
@class Focus;

@interface Notification : NSObject <BannerDelegate, ObstacleDelegate> {
    
    /* Height at which the next event will trigger */
    NSInteger nextHeightTrigger_;
    
    /* Current index of the next upcoming height triggered event */
    NSUInteger heightTriggerIndex_;
    
    /* 
     * Stores in sorted order, the list of all height triggers.
     * Each entry in the array consists of a dictionary with the
     * height and the events array 
     */
    NSMutableArray *heightTriggers_;
    
    /* Stores all object triggers keyed by object type and count */
    NSMutableDictionary *objectTriggers_;
    
    /* Events that must be played before unpausing */
    NSArray *events_;
    
    /* Which event is being played */
    NSUInteger eventCounter_;
    
    /* The banner being shown in the dialogue layer */
    Banner *currentBanner_;

    /* The focus being shown in the dialogue layer */
    Focus *currentFocus_;    
    
    /* The obstacle that triggered the event */
    Obstacle *obstacle_;
}

+ (id) notification:(NSUInteger)levelNum;

- (id) initNotification:(NSUInteger)levelNum;

- (void) heightUpdate:(NSInteger)height;

- (void) obstacleAdded:(Obstacle *)obstacle;

/** Loads notification data from file */
- (void) loadData:(NSUInteger)levelNum;

- (void) startEventSequence:(NSArray *)events;

- (void) continueEventSequence;

- (void) runEvent;

@end
