//
//  MapButton.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/4/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "MapButtonDelegate.h"

@interface MapButton : CCNode <CCTargetedTouchDelegate> {

    CCSprite *sprite_;
    
    BOOL isLocked_;
    
    BOOL isClickable_;
    
    BOOL isShrunk_;
    
    NSUInteger levelNum_;
    
    id <MapButtonDelegate> delegate_;        
}

@property (nonatomic, readonly) NSUInteger levelNum;
@property (nonatomic, readonly) BOOL isLocked;
@property (nonatomic, assign) BOOL isClickable;
@property (nonatomic, assign) id <MapButtonDelegate> delegate;

+ (id) mapButton:(NSUInteger)levelNum locked:(BOOL)locked;

- (id) initMapButton:(NSUInteger)levelNum locked:(BOOL)locked;

- (void) shrink;

- (void) unshrink;

@end