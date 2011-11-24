//
//  IncrementingTextDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/22/11.
//  Copyright (c) 2011 Paul Vishayanuroj. All rights reserved.
//

@class IncrementingText;

@protocol IncrementingTextDelegate <NSObject>

@optional

- (void) incrementationDone:(IncrementingText *)text;

@end