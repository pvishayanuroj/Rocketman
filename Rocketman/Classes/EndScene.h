//
//  EndScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface EndScene : CCScene {
    
}

+ (id) endSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score;

- (id) initEndSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score;

@end