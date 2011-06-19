//
//  EngineParticleSystem.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "EngineParticleSystem.h"


@implementation EngineParticleSystem

+ (id) PSForRocketFlame
{
    return [[[self alloc] initPSForRocketFlame] autorelease];
}

+ (id) PSForBoostFlame
{
    return [[[self alloc] initPSForBoostFlame] autorelease];
}

+ (id) PSForBossTurtleFlame
{
    return [[[self alloc] initPSForBossTurtleFlame] autorelease];
}

+ (id) PSForRocketHearts
{
    return [[[self alloc] initPSForRocketHearts] autorelease];
}

- (id) initPSForRocketFlame
{
    if ((self = [self initWithTotalParticles:300])) {
        
        ccColor4B orange = ccc4(255, 165, 0, 255);
        ccColor4F c1 = ccc4FFromccc4B(orange);
        ccColor4F c2 = c1;
        c2.a = 0;
        self.startColor = c1;
        self.endColor = c2;
        
        self.startSize = 10.0f;
        self.startSizeVar = 5.0f;
        self.endSize = kCCParticleStartSizeEqualToEndSize;    
        
        // Gravity & Speed
        self.gravity = ccp(0, -100);        
		self.speed = 20;
		self.speedVar = 5;               
        
        // life of particles
        self.life = 0.5;
        self.lifeVar = 0.25f;
        
        // emits per seconds
        self.emissionRate = 0;    
    }
    return self;
}

- (id) initPSForBoostFlame
{
    if ((self = [self initWithTotalParticles:700])) {
     
        ccColor4B purple = ccc4(255, 20, 147, 255);
        ccColor4F c1 = ccc4FFromccc4B(purple);
        ccColor4F c2 = c1;
        c2.a = 0;
        self.startColor = c1;
        self.endColor = c2;
        
        self.startSize = 20.0f;
        self.startSizeVar = 5.0f;
        self.endSize = kCCParticleStartSizeEqualToEndSize;    
        
        // Gravity & Speed
        self.gravity = ccp(0, -300);        
		self.speed = 20;
		self.speedVar = 5;        
        
        // life of particles
        self.life = 0.5;
        self.lifeVar = 0.25f;
        
        // emits per seconds
        self.emissionRate = 0;             
        
    }
    return self;
}

- (id) initPSForBossTurtleFlame
{
    if ((self = [self initWithTotalParticles:500])) {
   
        ccColor4B purple = ccc4(255, 20, 147, 255);
        ccColor4F c1 = ccc4FFromccc4B(purple);
        self.startColor = c1;
        self.endColor = c1;
        
        self.startSize = 25.0f;
        self.startSizeVar = 5.0f;
        self.endSize = kCCParticleStartSizeEqualToEndSize;    
        
        // life of particles
        self.life = 0.4f;
        self.lifeVar = 0.1f;
        
        // emits per seconds
        self.emissionRate = self.totalParticles/self.life;        
        
    }
    return self;
}

- (id) initPSForRocketHearts
{
    if ((self = [self initWithTotalHearts:10])) {
        
        ccColor4B purple = ccc4(255, 20, 147, 255);
        ccColor4F c1 = ccc4FFromccc4B(purple);
        self.startColor = c1;
        self.endColor = c1; 
        
        self.startSize = 10.0f;
        self.startSizeVar = 0;
        self.endSize = kCCParticleStartSizeEqualToEndSize;    
        
        // Gravity & Speed
        self.gravity = ccp(0, -70);        
		self.speed = 20;
		self.speedVar = 5;               
        
        // life of particles
        self.life = 0.5;
        self.lifeVar = 0.25f;
        
        // emits per seconds
        self.emissionRate = 0;    
    }
    return self;
}

- (id) initWithTotalParticles:(NSUInteger)p
{
	if( (self = [super initWithTotalParticles:p]) ) {
        
		// additive
		self.blendAdditive = YES;
        
		// duration
		self.duration = kCCParticleDurationInfinity;
		
		// Gravity Mode
		self.emitterMode = kCCParticleModeGravity;
		
		// Gravity mode: radial acceleration
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		
		// angle
		self.angle = 90;
		self.angleVar = 360;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
	}
	return self;
}

- (id) initWithTotalHearts:(NSUInteger)p
{
	if( (self = [super initWithTotalParticles:p]) ) {
        
		// additive
		self.blendAdditive = NO;
        
		// duration
		self.duration = kCCParticleDurationInfinity;
		
		// Gravity Mode
		self.emitterMode = kCCParticleModeGravity;
		
		// Gravity mode: radial acceleration
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		
		// angle
		self.angle = 270;
		self.angleVar = 180;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"heart.png"];
	}
	return self;    
}

@end
