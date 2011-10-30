//
//  BannerDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol BannerDelegate <NSObject>

- (BOOL) bannerClicked;

- (void) bannerClosed;

@end