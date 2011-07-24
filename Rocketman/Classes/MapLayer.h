//
//  MapLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "CatButtonDelegate.h"

@class CatMapButton;

typedef enum {
    kStateNeutral,
    kStateSelected
} MapState;

@interface MapLayer : CCLayer <CatButtonDelegate> {
    
    MapState mapState_;
    
    CatMapButton *selectedButton_;
    
    NSMutableArray *levelTitles_;
    
    NSMutableArray *levelDescs_;
    
}

@property (nonatomic, retain) CatMapButton *selectedButton;

+ (id) mapWithFile:(NSString *)filename;

- (id) initWithFile:(NSString *)filename;

- (void) catButtonPressed:(CatMapButton *)button;

@end
