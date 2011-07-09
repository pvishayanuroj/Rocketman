//
//  BlastCloud.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface BlastCloud : CCNode {
    
    BOOL destroyed_;
    
}

+ (id) blastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text;

- (id) initBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text;

- (void) addSprites:(EventText)text size:(CGFloat)size;

- (void) fall:(CGFloat)speed;

@end
