//
//  Enums.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

enum {
    kBackgroundDepth = 0,
    kParallaxDepth = 1,
    kGroundDepth = 2,
	kDoodadDepth = 3,
	kObstacleDepth = 4,    
    kBlastCloudDepth = 5,
    kBulletDepth = 6,    
    kRocketFlameDepth = 7,
	kRocketDepth = 8,
    kCatDepth = 9,
    kLabelDepth = 10
};

typedef enum {
    kSpeedUp,
    kSpeedDown,
    kCatPlus,
    kBoostPlus,
    kRandomDeathText,
    kBamText,
    kPlopText
} EventText;

typedef enum {
    kStartBoost,
    kBoosterBoost,
    kRingBoost,
    kAngelBoost,
    kInvincibilityBoost
} BoostType;

typedef enum {
    kNoMovement,    
    kStaticMovement
} MovementType;

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
    kBatBoss,
    kBirdBoss,
    kWhaleBoss,
    kAlienBossTurtle,
    kCatBoss,
    kDummyBoss,
    // Collectables/Helpers
    kAngel,
    kBoost,
    kFuel,
    kBombCat,
    kCat,
    kCatBundle,
    // Auxiliary Objects
    kRedEgg,
    kBlueEgg,
    kPlasmaBall,
    // Object Swarm version
    kSwarmTurtling,
    kSwarmYellowBird,
    kSwarmBlueBird,
    kSwarmBlueFish,
    kSwarmBat
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