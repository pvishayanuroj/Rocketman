//
//  AudioManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class CDSoundSource;

@interface AudioManager : NSObject {
    
    CDSoundSource *engineSound_;    
    
}

+ (AudioManager *) audioManager;

- (void) playSound:(SoundType)type;

- (void) stopSound:(SoundType)type;

@end
