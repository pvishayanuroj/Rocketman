//
//  EngineParticleSystem.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

#if defined(__ARM_NEON__) || defined(__MAC_OS_X_VERSION_MAX_ALLOWED) || TARGET_IPHONE_SIMULATOR
    #define ARCH_OPTIMAL_PARTICLE_SYSTEM CCParticleSystemQuad

// ARMv6 use "Point" particle
#elif __arm__
    #define ARCH_OPTIMAL_PARTICLE_SYSTEM CCParticleSystemPoint
#else
    #error(unknown architecture)
#endif

@interface EngineParticleSystem : ARCH_OPTIMAL_PARTICLE_SYSTEM {
    
}

+ (id) PSForRocketFlame;

+ (id) PSForBoostFlame;

+ (id) PSForBossTurtleFlame;

- (id) initWithTotalParticles:(NSUInteger)p;

- (id) initPSForRocketFlame;

- (id) initPSForBoostFlame;

- (id) initPSForBossTurtleFlame;

@end
