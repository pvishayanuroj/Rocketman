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
    
    BOOL catBombEnabled_;
    
}
// Creating the 
@property (nonatomic, readonly) BOOL catBombEnabled_;

+ (id) stage:(NSUInteger)levelNum;

- (id) initStage:(NSUInteger)levelNum;

@end
