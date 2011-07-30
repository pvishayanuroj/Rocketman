//
//  CatMapButton.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "CatButtonDelegate.h"

typedef enum {
    kActiveButton,
    kInactiveButton
} CatButtonType;

//const CGFloat BUTTON_SCALE;
//const CGFloat BUTTON_SCALE_BIG;

@interface CatMapButton : CCNode <CCTargetedTouchDelegate> {
    
    /** The image used for this button */
    CCSprite *sprite_;
    
    /** The level that this button corresponds to */
    NSUInteger levelNum_;
    
    /** Whether or not this button can be pressed */
    BOOL isLocked_;
    
    BOOL isPulsing_;
    
    /** Specifies whether button is active or inactive */
    CatButtonType buttonType_;
    
    /** Delegate object */
    id <CatButtonDelegate> delegate_;        
}

@property (nonatomic, readonly) NSUInteger levelNum;
@property (nonatomic, assign) id <CatButtonDelegate> delegate;

/** Constructor for inactive cat buttons */
+ (id) inactiveButtonAt:(CGPoint)pos levelNum:(NSUInteger)levelNum;

/** Constructor for active cat buttons */
+ (id) activeButtonAt:(CGPoint)pos levelNum:(NSUInteger)levelNum;

/** Initializer for inactive cat buttons */
- (id) initInactiveButtonAt:(CGPoint)pos levelNum:(NSUInteger)levelNum;

/** Initializer for active cat buttons */
- (id) initActiveButtonAt:(CGPoint)pos levelNum:(NSUInteger)levelNum;

/** Common initializer for all cat buttons */
- (id) initButton:(CGPoint)pos levelNum:(NSUInteger)levelNum;

/** Does not allow this button to be pressed */
- (void) lock;

/** Allows this button to be pressed */
- (void) unlock;

/** Animation to indicate the last unlocked level */
- (void) setToPulse;

/** Animation used when user selects a locked level - button gets bigger momentarily */
- (void) pop;

/** Animation for when user selects button to read level description */
- (void) selectSpin;

/** Method to stop the select spin animation */
- (void) stopSpin;

/** Animation for when user selects button to start a level */
- (void) disappearSpin;

@end
