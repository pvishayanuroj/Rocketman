//
//  WallModule.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface WallModule : NSObject {
    
    NSString *wallName_;
    
}

+ (id) wallModule:(NSString *)wallName;

- (id) initWallModule:(NSString *)wallName;

- (void) heightUpdate:(CGFloat)height;

@end
