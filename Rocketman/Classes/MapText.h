//
//  MapText.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/24/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "MapTextDelegate.h"

@interface MapText : CCNode {
    
    CCLabelTTF *text_;
    
    NSString *title_;
    
    NSString *desc_;
    
    /** Delegate object */
    id <MapTextDelegate> delegate_;            
}

@property (nonatomic, assign) id <MapTextDelegate> delegate;

+ (id) mapTextWithPos:(CGPoint)pos;

- (id) initMapTextWithPos:(CGPoint)pos;

- (void) setTitle:(NSString *)title;

- (void) setDesc:(NSString *)desc;

- (void) moveDown;

- (void) moveUp;

@end
