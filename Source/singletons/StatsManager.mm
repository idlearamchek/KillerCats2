//
//  StatsManager.m
//  Template
//
//  Created by Ghislain Bernier on 12/21/10.
//  Copyright 2010 XperimentalZ Games Inc. All rights reserved.
//

#import "StatsManager.h"
#import "cocos2d.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#endif

#pragma mark -
#pragma mark StatsManager

@implementation StatsManager


static StatsManager * _sharedInstance = nil;

+(StatsManager *) shared{
    if(!_sharedInstance){
        _sharedInstance = [[self alloc] init];
    }
    
	return _sharedInstance;
}

-(id) init{
    self = [super init];

    [self load];
    
    return self;
}

+(id)alloc{
	NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

-(void) addScore:(float)score{
    _currentScore += score;
    
    if (_currentScore > _bestScore) {
        _bestScore = _currentScore;
    }
}

-(void) updateScoreAfterEndGame{
//    if (_currentScore > _bestScore) {
//        _bestScore = _currentScore;
    
        [self save];
        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

-(void) updateStatsAfterGame{
//    mTotalGamePlayed++;
}

-(void) resetForNewGame{
    _currentScore = 0;
}


-(void) load{
    _bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
}

-(void) save{
    [[NSUserDefaults standardUserDefaults] setInteger:_bestScore forKey:@"score"];
}



@end
