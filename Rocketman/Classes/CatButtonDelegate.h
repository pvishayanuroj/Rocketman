//
//  CatButtonDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class CatMapButton;

@protocol CatButtonDelegate <NSObject>

- (void) catButtonPressed:(CatMapButton *)button;

- (void) catButtonSpinComplete:(CatMapButton *)button;

@end
