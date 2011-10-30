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
    // Enemies
    kShell,
    kAlien,
    kUFO,
    kFlybot,
    kTurtling,
    kTurtlingSwarm,
    kShockTurtling,
    kHoverTurtle,    
    kAlienHoverTurtle,
    kShieldedAlienHoverTurtle,
    kYellowBird,
    kYellowBirdSwarm,
    kBlueBird,
    kBlueBirdSwarm,
    kBat,
    kBatSwarm,
    kSquid,
    kBlueFish,
    kBlueFishSwarm,
    kSalamander,
    kFlyingRock,
    // Bosses
    kBossTurtle,
    kAlienBossTurtle,
    kDummyBoss,
    // Collectables/Helpers
    kAngel,
    kBoost,
    kFuel,
    kCat,
    kCatBundle,
    // Auxiliary Objects
    kRedEgg,
    kBlueEgg,
    kPlasmaBall
} ObstacleType;

typedef enum {
    kCloud,
    kSlowCloud,
    kRockDebris,
    kDebrisGen,
    kAirplane
} DoodadType;

typedef enum {
    kRocketBurning,
    kRocketWobbling,
    kRocketHearts
} RocketCondition;

typedef enum {
    kCatButton,
    kBombButton,
    kSlowButton,
    kBoostButton
} ButtonType;