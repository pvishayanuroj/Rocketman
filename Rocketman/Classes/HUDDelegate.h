//
//  HUDDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/23/11.
//  Copyright (c) 2011 Paul Vishayanuroj. All rights reserved.
//

@class Button;

@protocol HUDDelegate <NSObject>

@required

- (void) catButtonPressed:(Button *)button;

- (void) bombButtonPressed:(Button *)button;

- (void) superCatButtonPressed:(Button *)button;

- (void) slowButtonPressed:(Button *)button;

- (void) slowButtonReleased:(Button *)button;

- (void) boostButtonPressed:(Button *)button;

- (void) screenClicked;

@end