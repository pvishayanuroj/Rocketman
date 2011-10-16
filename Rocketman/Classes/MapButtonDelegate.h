//
//  MapButtonDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/4/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class MapButton;

@protocol MapButtonDelegate <NSObject>

- (void) mapButtonPressed:(MapButton *)button;

@end
