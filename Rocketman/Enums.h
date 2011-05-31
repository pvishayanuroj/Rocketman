//
//  Enums.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

enum {
    kBackgroundDepth = 0,
	kCloudDepth = 1,
	kObstacleDepth = 2,    
    kBulletDepth = 3,    
    kRocketFlameDepth = 4,
	kRocketDepth = 5,
    kCatDepth = 6,
    kLabelDepth = 7
};

typedef enum {
    kSpeedUp,
    kSpeedDown,
    kCatPlus,
    kBoostPlus
} EventText;

typedef enum {
	kLeftButton,
    kRightButton
} ButtonType;