//
//  WallModule.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@class Wall;

@interface WallModule : NSObject {
    
    NSString *wallName_;
    
    CGFloat nextHeight_;
    
    CGFloat wallWidth_;
    
    Wall *lastWall_;
}

@property (nonatomic, readonly) CGFloat wallWidth;

+ (id) wallModule:(NSString *)wallName;

- (id) initWallModule:(NSString *)wallName;

- (void) heightUpdate:(CGFloat)height;

- (void) placeWall:(CGFloat)y;

@end
