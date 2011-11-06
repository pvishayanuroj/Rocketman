//
//  PhysicsModuleDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/5/11.
//  Copyright (c) 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol PhysicsModuleDelegate <NSObject>

- (void) boostDisengaged:(BoostType)boostType;

@end

