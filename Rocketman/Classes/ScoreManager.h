//
//  ScoreManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 12/3/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@interface ScoreManager : NSObject {
    
}


/** Checks the score against the benchmark file to determine what medal it qualifies for */
+ (MedalType) checkBenchmark:(ScoreCategory)scoreCategory level:(NSInteger)level score:(NSInteger)score;

/** Determines the medal the score qualifies for, given the different levels */
+ (MedalType) getMedal:(NSInteger)score silver:(NSInteger)silver gold:(NSInteger)gold higherIsBetter:(BOOL)higherIsBetter;

/** 
 * Checks the score against the existing score to see if it was beaten. If so, returns
 * true and stores the record, otherwise returns false
 */
+ (BOOL) checkAndStoreRecord:(ScoreCategory)scoreCategory level:(NSInteger)level score:(NSInteger)score;

/** Returns true if the new score beats the old score */
+ (BOOL) checkRecordBroken:(ScoreCategory)scoreCategory oldScore:(NSInteger)oldScore newScore:(NSInteger)newScore;

/** Resets all scores to their initial min max values */
+ (void) resetScores;

/** Gets the score data dictionary. Will create it and return a new one if it doesn't exist */
+ (NSMutableDictionary *) getAndCreateScoreData;

/** Returns a new score data dictionary, with all values initialized to min or max */
+ (NSMutableDictionary *) createNewScoreData;

/** Returns the score for a category and level given a score data dictionary */
+ (NSInteger) getIntegerScore:(ScoreCategory)scoreCategory level:(NSInteger)level scores:(NSMutableDictionary *)scores;

/** Sets the score for a category and level for a score data dictionary */
+ (void) setIntegerScore:(ScoreCategory)scoreCategory level:(NSInteger)level score:(NSInteger)score scores:(NSMutableDictionary *)scores;

/** Loads the score data dictionary from persistent storage */
+ (NSMutableDictionary *) loadData;

/** Stores a score data dictionary to persistent storage */
+ (void) saveData:(NSDictionary *)data;

/** Loads bundled benchmark data */
+ (NSDictionary *) loadBenchmarkData;

@end
