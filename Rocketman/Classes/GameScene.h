//
//  GameScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface GameScene : CCScene {

}

+ (id) stage:(NSUInteger)levelNum;

- (id) initStage:(NSUInteger)levelNum;

@end
