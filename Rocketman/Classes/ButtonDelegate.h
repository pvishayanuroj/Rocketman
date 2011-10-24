//
//  ButtonDelegate.h
//  RocketmanLE
//
//  Created by Paul Vishayanuroj on 9/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class Button;

@protocol ButtonDelegate <NSObject>

@required

- (void) buttonClicked:(Button *)button;

@end