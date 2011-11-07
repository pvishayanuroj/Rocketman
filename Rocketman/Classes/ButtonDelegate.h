//
//  ButtonDelegate.h
//  RocketmanLE
//
//  Created by Paul Vishayanuroj on 9/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class Button;

@protocol ButtonDelegate <NSObject>

@optional

- (void) buttonClicked:(Button *)button;

- (void) buttonSelected:(Button *)button;

- (void) buttonUnselected:(Button *)button;

@end