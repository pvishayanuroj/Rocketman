//
//  VictoryLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 12/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface VictoryLayer : CCLayer {
    
    BOOL clickable_;
    
}

@property (nonatomic, assign) BOOL clickable;

@end
