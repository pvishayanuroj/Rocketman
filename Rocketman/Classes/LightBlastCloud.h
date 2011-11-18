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

+ (id) lightBlastCloudAt:(CGPoint)pos movements:(NSMutableArray *)movements;

+ (id) lightBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text movements:(NSMutableArray *)movements;

- (id) initLightBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text movements:(NSMutableArray *)movements;

- (void) addSprites:(EventText)text size:(CGFloat)size;

@end
