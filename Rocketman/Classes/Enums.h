//
//  Enums.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

enum {
    kBackgroundDepth = 0,
    kGroundDepth = 1,
	kCloudDepth = 2,
	kObstacleDepth = 3,    
    kBulletDepth = 4,    
    kRocketFlameDepth = 5,
	kRocketDepth = 6,
    kCatDepth = 7,
    kLabelDepth = 8
};

typedef enum {
    kSpeedUp,
    kSpeedDown,
    kCatPlus,
    kBoostPlus,
    kBamText,
    kPlopText
} EventText;

typedef enum {
    kTheme01,
    kMeow,
    kCollectMeow,
    kPlop,
    kEngine,
    kKerrum,
    kWerr,
    kPowerup,
    kExplosion01,
    kSlap
} SoundType;

typedef enum {
    kCatNormal,
    kCatBomb,
    kCatPierce
} CatType;

typedef enum {
    kDino = 0,
    kAlien = 1,
    kShell = 2,
    kAngel = 3,
    kUFO = 4,
    kFlybot = 5,
    kShockTurtling = 6,
    kHoverTurtle = 7,
    kAlienHoverTurtle = 8,
    kYellowBird = 9,
    kBoost = 10,
    kCat = 11,
    kFuel = 12,
    kBossTurtle = 13,
    kTurtling = 14,
    kPlasmaBall = 15
} ObstacleType;

typedef enum {
    kRocketBurning,
    kRocketWobbling,
    kRocketHearts
} RocketCondition;

typedef enum {
	kLeftButton,
    kRightButton
} ButtonType;