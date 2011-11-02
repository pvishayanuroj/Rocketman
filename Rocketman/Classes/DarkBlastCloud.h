//
//  DarkBlastCloud.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/1/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "Doodad.h"

@interface DarkBlastCloud : Doodad {
 
    CCSprite *smoke_;
    
    CCSprite *blast_;
    
    CCSprite *text_;    
    
}

+ (id) darkBlastCloudAt:(CGPoint)pos;

+ (id) darkBlastCloudAt:(CGPoint)pos size:(CGFloat)size movement:(MovementType)movement;

- (id) initDarkBlastCloudAt:(CGPoint)pos size:(CGFloat)size movement:(MovementType)movement;

- (void) addSprites:(CGFloat)size;

@end
