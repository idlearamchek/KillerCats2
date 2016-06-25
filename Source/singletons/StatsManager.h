//
//  StatsManager.h
//  Template
//
//  Created by Ghislain Bernier on 12/21/10.
//  Copyright 2010 XperimentalZ Games Inc. All rights reserved.
//

#import "types.h"

#pragma mark -
#pragma mark StatsManager

@interface StatsManager : NSObject {
}

+(StatsManager *) shared;

@property (nonatomic, readonly) int currentScore;
@property (nonatomic, readonly) int bestScore;

-(void) addScore:(float)score;
-(void) resetForNewGame;

-(void) updateScoreAfterEndGame;
-(void) updateStatsAfterGame;

-(void) save;

@end
