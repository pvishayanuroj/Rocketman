//
//  PButtonDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@protocol PButtonDelegate <NSObject>

- (void) leftButtonPressed;

- (void) leftButtonDepressed;

- (void) rightButtonPressed;

- (void) rightButtonDepressed;

@end
