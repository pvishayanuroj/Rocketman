//
//  AudioManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "AudioManager.h"
#import "SimpleAudioEngine.h"

// For singleton
static AudioManager *_audioManager = nil;

@implementation AudioManager

#pragma mark - Object Lifecycle

+ (AudioManager *) audioManager
{
	if (!_audioManager)
		_audioManager = [[self alloc] init];
	
	return _audioManager;
}

+ (id) alloc
{
	NSAssert(_audioManager == nil, @"Attempted to allocate a second instance of a Audio Manager singleton.");
	return [super alloc];
}

+ (void) purgeAudioManager
{
	[_audioManager release];
	_audioManager = nil;
}

- (id) init
{
	if ((self = [super init])) {
        
        SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
        [sae preloadBackgroundMusic:R_01_MUSIC];
        [sae preloadEffect:R_MEOW_01_SOUND];
        [sae preloadEffect:R_MEOW_02_SOUND];
        [sae preloadEffect:R_MEOW_03_SOUND];    
        [sae preloadEffect:R_PLOP_SOUND];    
        [sae preloadEffect:R_KERRUM_SOUND];    
        [sae preloadEffect:R_WERR_SOUND];    
        [sae preloadEffect:R_EXPLOSION_01_SOUND];        
        [sae preloadEffect:R_POWERUP_SOUND];        
        [sae preloadEffect:R_SLAP_SOUND];
        [sae preloadEffect:R_DAMAGED_01_SOUND];
        engineSound_ = [[sae soundSourceForFile:R_ENGINE_SOUND] retain];       
        enginePlaying_ = NO;
        backgroundMusicPlaying_ = NO;
        
	}
	return self;
}

- (void) dealloc
{	
    [engineSound_ release];
    
	[super dealloc];
}

#pragma mark - Sound Methods

- (void) playSound:(SoundType)type
{
#if DEBUG_NOSOUND
    return;
#endif
    
    NSString *name;
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    
    switch (type) {
        case kTheme01:
            [engine playBackgroundMusic:R_01_MUSIC];
            backgroundMusicPlaying_ = YES;
            break;
        case kMeow:
            name = (arc4random() % 2) ? R_MEOW_01_SOUND : R_MEOW_02_SOUND;
            [engine playEffect:name];            
            break;
        case kPlop:
            [engine playEffect:R_PLOP_SOUND];
            break;
        case kKerrum:
            [engine playEffect:R_KERRUM_SOUND];
            break;            
        case kWerr:
            [engine playEffect:R_WERR_SOUND];
            break;            
        case kPowerup:
            [engine playEffect:R_POWERUP_SOUND];
            break;                   
        case kCollectMeow:
            [engine playEffect:R_MEOW_03_SOUND];
            break;                 
        case kExplosion01:
            [engine playEffect:R_EXPLOSION_01_SOUND];
            break;                   
        case kSlap:
            [engine playEffect:R_SLAP_SOUND];
            break;
        case kDamaged01:
            [engine playEffect:R_DAMAGED_01_SOUND];
            break;
        case kEngine:
            engineSound_.looping = YES;
            enginePlaying_ = YES;
            [engineSound_ play];
            break;
        default:
            NSAssert(NO, @"Invalid effect type");
    }
}

- (void) stopSound:(SoundType)type
{
#if DEBUG_NOSOUND
    return;
#endif
    
    switch (type) {
        case kEngine:
            [engineSound_ stop];
            enginePlaying_ = NO;
            break;
        default:
            NSAssert(NO, @"Invalid effect type");        
    }
}

- (void) stopMusic
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void) pauseSound
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    
    [engine pauseBackgroundMusic];
    
    if (enginePlaying_) {
        [engineSound_ stop];
    }
}

- (void) resumeSound
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];    
    
    if (backgroundMusicPlaying_) {
        [engine resumeBackgroundMusic];
    }
    
    if (enginePlaying_) {
        [engineSound_ play];
    }
}

@end
