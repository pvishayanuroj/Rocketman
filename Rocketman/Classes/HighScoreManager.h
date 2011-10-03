//
//  HighscoreManager.h
//  Rocketman
//
//  Created by Jamorn Ho on 6/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"


@interface HighscoreManager : NSObject {
    
}

+ (BOOL)addToHighscore:(NSInteger)score;
+ (BOOL)resetHighscore;
+ (NSArray *)getHighscores;

@end
