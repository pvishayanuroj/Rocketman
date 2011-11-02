//
//  LightBlastCloud.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/1/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "Doodad.h"

@interface LightBlastCloud : Doodad {
    
}

/** Default blast cloud */
+ (id) lightBlastCloudAt:(CGPoint)pos;

+ (id) lightBlastCloudAt:(CGPoint)pos movement:(MovementType)movement;

+ (id) lightBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text movement:(MovementType)movement;

- (id) initLightBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text movement:(MovementType)movement;

- (void) addSprites:(EventText)text size:(CGFloat)size;

@end
