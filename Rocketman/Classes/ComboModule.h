//
//  ComboModule.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/19/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "ComboModuleDelegate.h"

@interface ComboModule : NSObject {
    
    double lastComboTimestamp_;
    
    double maxComboInterval_;
    
    NSInteger comboCount_;
    
    NSInteger targetComboCount_;
    
    id <ComboModuleDelegate> delegate_;
    
}

+ (id) comboModule;

- (id) initComboModule;

- (void) enemyKilled:(ObstacleType)type pos:(CGPoint)pos;

@end
