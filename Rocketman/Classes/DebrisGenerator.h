//
//  DebrisGenerator.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@class GameLayer;

@interface DebrisGenerator : NSObject {
    
}

+ (void) addDebris:(GameLayer *)gameLayer type:(DoodadType)type pos:(CGPoint)pos;

@end
