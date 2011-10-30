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
@class Button;

@interface Notification : NSObject <BannerDelegate, ObstacleDelegate> {
    
    /** Height at which the next event will trigger */
    NSInteger nextHeightTrigger_;
    
    /** Current index of the next upcoming height triggered event */
    NSUInteger heightTriggerIndex_;
    
    /** 
     * Stores in sorted order, the list of all height triggers.
     * Each entry in the array consists of a dictionary with the
     * height and the events array 
     */
    NSMutableArray *heightTriggers_;
    
    /** Stores all object triggers keyed by object type and count */
    NSMutableDictionary *objectTriggers_;
    
    /** Events that must be played before unpausing */
    NSArray *events_;
    
    /** Which event is being played */
    NSUInteger eventCounter_;
    
    /** The banner being shown in the dialogue layer */
    Banner *currentBanner_;

    /** The focus being shown in the dialogue layer */
    NSMutableArray *currentFocuses_;  
    
    /** The set of buttons that can be pressed to advance the banner */
    NSMutableSet *currentFocusButtons_;
    
    /** The obstacle that triggered the event */
    Obstacle *obstacle_;
    
    /** Whether or not we're in the middle of a notification event */
    BOOL inNotification_;
}

/** Convenience constructor for a notification object */
+ (id) notification:(NSUInteger)levelNum;

/** Initializes a notification object by reading from a data file */
- (id) initNotification:(NSUInteger)levelNum;

/** Turns banner clicks off */
- (void) pause;

/** Turns banner clicks on */
- (void) resume;

/** Height updates sent from the GM */
- (void) heightUpdate:(NSInteger)height;

/** Obstacle updates sent from the GM */
- (void) obstacleAdded:(Obstacle *)obstacle;

/** Button click updates */
- (BOOL) buttonClicked:(Button *)button;

/** If the HUD layer receives a general screen tap */
- (void) screenClicked;

/** Loads notification data from file */
- (void) loadData:(NSUInteger)levelNum;

/** Converts button string to enum */
- (ButtonType) buttonNameToType:(NSString *)name;

/** Method for starting an event */
- (void) startEventSequence:(NSArray *)events;

/** Method to cleanup from a previous event and check if there are further events */
- (void) continueEventSequence;

/** 
 * Method for retrieving information about the event and placing the 
 * appropriate banner and focuses on screen 
 */
- (void) runEvent;

@end
