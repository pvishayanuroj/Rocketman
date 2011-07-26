//
//  MapTextDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/24/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class MapText;

@protocol MapTextDelegate <NSObject>

- (void) mapTextMovedDown:(MapText *)mapText;

- (void) mapTextMovedUp:(MapText *)mapText;

@end