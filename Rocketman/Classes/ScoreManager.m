//
//  ScoreManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 12/3/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ScoreManager.h"
#import "DataManager.h"

@implementation ScoreManager

+ (MedalType) checkBenchmark:(ScoreCategory)scoreCategory level:(NSInteger)level score:(NSInteger)score
{
    NSDictionary *data = [self loadBenchmarkData];
    NSString *levelKey = [NSString stringWithFormat:@"Stage %02d", level];    
    NSDictionary *levelData = [data objectForKey:levelKey];    
    NSDictionary *recordData;
    switch (scoreCategory) {
        case kScoreTimeTaken:
            recordData = [levelData objectForKey:@"Time Taken"];
            break;
        case kScoreEnemiesDestroyed:
            recordData = [levelData objectForKey:@"Enemies Destroyed"];            
            break;
        case kScoreMaxCombo:
            recordData = [levelData objectForKey:@"Max Combo"];            
            break;
        default:
            break;
    }
    NSInteger silver = [[recordData objectForKey:@"Silver"] integerValue];
    NSInteger gold = [[recordData objectForKey:@"Gold"] integerValue];
    
    MedalType medal = kMedalNone;
    switch (scoreCategory) {
        case kScoreTimeTaken:
            medal = [self getMedal:score silver:silver gold:gold higherIsBetter:NO];
            break;
        case kScoreEnemiesDestroyed:
        case kScoreMaxCombo:
            medal = [self getMedal:score silver:silver gold:gold higherIsBetter:YES];
            break;            
        default:
            break;
    }
    return medal;
}

+ (MedalType) getMedal:(NSInteger)score silver:(NSInteger)silver gold:(NSInteger)gold higherIsBetter:(BOOL)higherIsBetter
{
    if (score == INT_MAX || score == INT_MIN) {
        return kMedalNone;
    }
    
    if (higherIsBetter) {
        if (score > gold) {
            return kMedalGold;
        }
        else if (score > silver) {
            return kMedalSilver;
        }
        else {
            return kMedalBronze;
        }
    }
    else {
        if (score < gold) {
            return kMedalGold;
        }
        else if (score < silver) {
            return kMedalSilver;
        }
        else {
            return kMedalBronze;
        }
    }
}

+ (BOOL) checkAndStoreRecord:(ScoreCategory)scoreCategory level:(NSInteger)level score:(NSInteger)score 
{
    // Get current scores or a new one
    NSMutableDictionary *scores = [self getAndCreateScoreData];
    NSInteger record = [self getIntegerScore:scoreCategory level:level scores:scores];
    
    // If new score beats old score, record it
    if ([self checkRecordBroken:scoreCategory oldScore:record newScore:score]) {
        [self setIntegerScore:scoreCategory level:level score:score scores:scores];
        [self saveData:scores];
        return YES;
    }
    return NO;
}

+ (BOOL) checkRecordBroken:(ScoreCategory)scoreCategory oldScore:(NSInteger)oldScore newScore:(NSInteger)newScore
{
    switch (scoreCategory) {
        case kScoreTimeTaken:
            return newScore < oldScore;
        case kScoreEnemiesDestroyed:
        case kScoreMaxCombo:
            return newScore > oldScore;
        default:
            break;
    }
    return NO;
}

+ (void) resetScores
{
    NSDictionary *scores = [self createNewScoreData];
    [self saveData:scores];
}

+ (NSMutableDictionary *) getAndCreateScoreData
{
    NSMutableDictionary *scores = [self loadData];
    if (scores == nil) {
        
        scores = [self createNewScoreData];
        [self saveData:scores];
    }
    return scores;
}

+ (NSMutableDictionary *) createNewScoreData
{
    NSMutableDictionary *scores = [NSMutableDictionary dictionaryWithCapacity:6];
    NSInteger numLevels = [[[DataManager dataManager] mapData] count];
    for (int i = 0; i < numLevels; ++i) {
        NSMutableDictionary *levelScores = [NSMutableDictionary dictionaryWithCapacity:3];
        [levelScores setObject:[NSNumber numberWithInt:INT_MAX] forKey:@"Time Taken"];
        [levelScores setObject:[NSNumber numberWithInt:INT_MIN] forKey:@"Max Combo"];
        [levelScores setObject:[NSNumber numberWithInt:INT_MIN] forKey:@"Enemies Destroyed"];            
        NSString *levelKey = [NSString stringWithFormat:@"%d", i];
        [scores setObject:levelScores forKey:levelKey];
    }    
    return scores;
}

+ (NSInteger) getIntegerScore:(ScoreCategory)scoreCategory level:(NSInteger)level scores:(NSMutableDictionary *)scores
{
    NSString *levelKey = [NSString stringWithFormat:@"%d", level];    
    NSMutableDictionary *levelScores = [scores objectForKey:levelKey];
    
    NSInteger score = -1;
    switch (scoreCategory) {
        case kScoreTimeTaken:
            score = [[levelScores objectForKey:@"Time Taken"] integerValue];
            break;
        case kScoreEnemiesDestroyed:
            score = [[levelScores objectForKey:@"Enemies Destroyed"] integerValue];            
            break;
        case kScoreMaxCombo:
            score = [[levelScores objectForKey:@"Max Combo"] integerValue];            
            break;
        default:
            break;
    }
    return score;
}

+ (void) setIntegerScore:(ScoreCategory)scoreCategory level:(NSInteger)level score:(NSInteger)score scores:(NSMutableDictionary *)scores
{
    NSString *levelKey = [NSString stringWithFormat:@"%d", level];    
    NSMutableDictionary *levelScores = [scores objectForKey:levelKey];
    NSNumber *scoreValue = [NSNumber numberWithInteger:score];
    switch (scoreCategory) {
        case kScoreTimeTaken:
            [levelScores setObject:scoreValue forKey:@"Time Taken"];
            break;
        case kScoreEnemiesDestroyed:
            [levelScores setObject:scoreValue forKey:@"Enemies Destroyed"];     
            break;
        case kScoreMaxCombo:
            [levelScores setObject:scoreValue forKey:@"Max Combo"];
            break;
        default:
            break;
    }
}

+ (NSMutableDictionary *) loadData
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:R_HIGH_SCORES_NAME];
}

+ (void) saveData:(NSDictionary *)data
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:R_HIGH_SCORES_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *) loadBenchmarkData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:R_MEDAL_BENCHMARKS_NAME ofType:@"plist"];    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

@end
