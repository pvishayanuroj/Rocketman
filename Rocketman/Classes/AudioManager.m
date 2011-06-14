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
        [sae preloadBackgroundMusic:@"SRSMTheme01.mp3"];
        [sae preloadEffect:@"meow01.mp3"];
        [sae preloadEffect:@"meow02.mp3"];
        [sae preloadEffect:@"meow03.wav"];    
        [sae preloadEffect:@"plop.wav"];    
        [sae preloadEffect:@"kerrum.wav"];    
        [sae preloadEffect:@"werr.wav"];    
        [sae preloadEffect:@"explosion01.wav"];        
        [sae preloadEffect:@"powerup.wav"];        
        [sae preloadEffect:@"slap.wav"];                
        engineSound_ = [[sae soundSourceForFile:@"engine.wav"] retain];        
        
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
    NSUInteger rand;
    NSString *name;
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    
    switch (type) {
        case kTheme01:
            name = [NSString stringWithFormat:@"SRSMTheme01.mp3"];
            [engine playBackgroundMusic:name];
            break;
        case kMeow:
            rand = arc4random() % 2 + 1;
            name = [NSString stringWithFormat:@"meow%02d.mp3", rand];
            [engine playEffect:name];            
            break;
        case kPlop:
            name = [NSString stringWithFormat:@"plop.wav"];
            [engine playEffect:name];
            break;
        case kKerrum:
            name = [NSString stringWithFormat:@"kerrum.wav"];
            [engine playEffect:name];
            break;            
        case kWerr:
            name = [NSString stringWithFormat:@"werr.wav"];
            [engine playEffect:name];
            break;            
        case kPowerup:
            name = [NSString stringWithFormat:@"powerup.wav"];
            [engine playEffect:name];
            break;                   
        case kCollectMeow:
            name = [NSString stringWithFormat:@"meow03.wav"];
            [engine playEffect:name];
            break;                 
        case kExplosion01:
            name = [NSString stringWithFormat:@"explosion01.wav"];
            [engine playEffect:name];
            break;                   
        case kSlap:
            name = [NSString stringWithFormat:@"slap.wav"];
            [engine playEffect:name];
            break;                             
        case kEngine:
            engineSound_.looping = YES;
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
            break;
        default:
            NSAssert(NO, @"Invalid effect type");        
    }
}

@end
