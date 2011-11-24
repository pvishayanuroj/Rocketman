//
//  EndScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface EndScene : CCScene {
    
    NSUInteger score_;
    
    NSUInteger finalScore_;
    
    NSUInteger incrementSpeed_;
    
}

+ (id) endSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score;

- (id) initEndSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score;

@end
