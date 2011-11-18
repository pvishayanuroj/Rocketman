//
//  GameObject.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface GameObject : CCNode {
    
    /** Doodad's sprite */
    CCSprite *sprite_;    
    
    /** The array of movements that an obstacle can have */    
    NSMutableArray *movements_;        
    
}

@property (nonatomic, copy) NSMutableArray *movements;

+ (id) gameObject;

- (id) initGameObject;

@end
