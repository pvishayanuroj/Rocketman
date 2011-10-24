//
//  Button.h
//  RocketmanLE
//
//  Created by Paul Vishayanuroj on 9/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "ButtonDelegate.h"
#import "Clickable.h"

@interface Button : CCNode <CCTargetedTouchDelegate, Clickable> {
    
    /** Whether or not the button can be toggled */
    BOOL isToggleButton_;
    
    /** Whether or not the button was pressed */
    BOOL isSelected_;
    
    /** Whether or not it is active */
    BOOL isClickable_;    
    
    /** Delegate object */
    id <ButtonDelegate> delegate_;    
    
    NSUInteger numID_;    
    
}

@property (nonatomic, readonly) NSUInteger numID;
@property (nonatomic, assign) id <ButtonDelegate> delegate;
@property (nonatomic, readonly) BOOL isSelected;

+ (id) button:(NSUInteger)numID toggle:(BOOL)toggle;

- (id) initButton:(NSUInteger)numID toggle:(BOOL)toggle;

- (CGRect) rect;

- (void) selectButton;

- (void) unselectButton;

@end


@interface ImageButton : Button {

    /** Button image */
    CCSprite *sprite_;
    
    /** Button selected image */
    CCSprite *selected_;
    
}

+ (id) imageButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected;

+ (id) imageToggleButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected;

- (id) initImageButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected toggle:(BOOL)toggle;

@end


@interface TextButton : Button {

    /** Button text */
    CCLabelTTF *text_;
    
}

+ (id) textButton:(NSUInteger)numID text:(NSString *)text;

+ (id) textToggleButton:(NSUInteger)numID text:(NSString *)text;

- (id) initTextButton:(NSUInteger)numID text:(NSString *)text toggle:(BOOL)toggle;

@end