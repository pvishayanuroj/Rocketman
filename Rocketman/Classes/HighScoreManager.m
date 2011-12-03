//
//  HighscoreManager.m
//  Rocketman
//
//  Created by Jamorn Ho on 6/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HighscoreManager.h"
#import "DataManager.h"

@implementation HighScoreManager

/*
+ (BOOL)addToHighscore:(NSInteger)score {
    
    NSNumber *newScore = [[NSNumber numberWithInt:score] retain];
    
    NSArray *unsortedScores = [HighscoreManager getHighscores];
    NSData *hint = [unsortedScores sortedArrayHint];
    
    NSArray *sortedScores = [unsortedScores sortedArrayUsingFunction:intSort context:nil hint:hint];
    
    NSMutableArray *scores = [[NSMutableArray arrayWithArray:sortedScores] retain];
    
    if ([scores count] >= 10 ) {
        // If the new score is more than the lowest score remove the lowest score.
        if ([newScore compare:(NSNumber *)[scores objectAtIndex:0]] == NSOrderedDescending) {
            [scores removeObjectAtIndex:0];
            
        }
        // If not then break out of this function. The score is too low.
        else {
            [newScore release];
            [scores release];
            return NO;
        }
    }
    
    // Loop through the array from the highest score first and compare it to the new score. If the new score is higher than one of them insert the new score after that score in the array.
    for (int i=1; i <= [scores count]; i++) {
        if ([newScore compare:(NSNumber *)[scores objectAtIndex:[scores count] - i]] == NSOrderedDescending) {
            if (i==1) {
                [scores addObject:newScore];
                break;
            }
            else {
                [scores insertObject:newScore atIndex:[scores count]+1-i];
                break;
            }
        }
    }
    
    // Remove any score that is 0
    if ([[scores objectAtIndex:0] compare:[NSNumber numberWithInt:0]] == NSOrderedSame) {
        [scores removeObjectAtIndex:0];
    }
    
    // Write the score to the plist again
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Highscores" ofType:@"plist"];
    
    if ([manager isWritableFileAtPath:plistPath]) {
        [newScore autorelease];
        [scores autorelease];
        NSLog(@"Writing array to file: %@", scores);
        return [scores writeToFile:plistPath atomically:YES];
    }
    else {
        [newScore release];
        [scores release];
        return NO;
    }

}

+ (MedalType) checkAndRecordScore:(ScoreCategory)scoreCategory score:(NSInteger)score
{
    
}

+ (NSInteger) getIntegerScore:(ScoreCategory)scoreCategory level:(NSInteger)level
{
    NSDictionary *scores = [self getAndCreateScoreData];
    NSString *levelKey = [NSString stringWithFormat:@"%d", level];    
    NSDictionary *levelScores = [scores objectForKey:levelKey];
    
    switch (scoreCategory) {
        case kScoreTimeTaken:
            break;
        case kScoreEnemiesDestroyed:
            break;
        case kScoreMaxCombo:
            break;
        default:
            break;
    }
}

+ (void) setIntegerScore:(ScoreCategory)scoreCategory level:(NSInteger)level
{
    
}

+ (void) resetScores
{
    NSDictionary *scores = [self createNewScoreData];
    [self saveData:scores];
}

+ (NSArray *)getHighscores {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Highscores" ofType:@"plist"];
    NSArray *scores = [NSArray arrayWithContentsOfFile:plistPath];
    
    return scores;
}
     
+ (NSDictionary *) getAndCreateScoreData
{
    NSDictionary *scores = [self loadData];
    if (scores == nil) {
        
        scores = [NSMutableDictionary dictionaryWithCapacity:6];        
        [self saveData:scores];
    }
    return scores;
}

+ (NSDictionary *) createNewScoreData
{
    NSMutableDictionary *scores = [NSMutableDictionary dictionaryWithCapacity:6];
    NSInteger numLevels = [[[DataManager dataManager] mapData] count];
    for (int i = 0; i < numLevels; ++i) {
        NSMutableDictionary *levelScores = [NSMutableDictionary dictionaryWithCapacity:3];
        [levelScores setObject:[NSNumber numberWithInt:-1] forKey:@"Time Taken"];
        [levelScores setObject:[NSNumber numberWithInt:-1] forKey:@"Max Combo"];
        [levelScores setObject:[NSNumber numberWithInt:-1] forKey:@"Enemies Destroyed"];            
        NSString *levelKey = [NSString stringWithFormat:@"%d", i];
        [scores setObject:levelScores forKey:levelKey];
    }    
    return scores;
}

+ (NSDictionary *) loadData
{

}

+ (void) saveData:(NSDictionary *)data
{
    
}

+ (NSString *) getPath
{
    return [[NSBundle mainBundle] pathForResource:R_HIGH_SCORES ofType:@"plist"];
}
*/
@end
