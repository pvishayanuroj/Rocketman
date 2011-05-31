//
//  GameScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCScene {
    
}

- (void) animationLoader:(NSString *)unitListName spriteSheetName:(NSString *)spriteSheetName;

- (void) preloadAudio;

@end
