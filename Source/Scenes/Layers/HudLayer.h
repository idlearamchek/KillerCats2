//
//  HudLayer.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 5/7/13.
//
//

#import "cocos2d.h"
#import "GlobalSettings.h"
#import "types.h"
#import "ProfileSettings.h"

#import "PauseMenu.h"
#import "XZButton.h"

@class GameLayer;

@interface HudLayer : CCNode{
    CGSize mScreenSize;
    
    CCLabelBMFont *mLabelScoreNumber;
    CCLabelBMFont *mLabelBestScore;
    
    XZButton * mPauseButton;
}

-(void) createWithGameSettings:(GameSettings) gameSettings;

-(void) initPosHudElements;
-(void) showHudElements;
-(void) hideHudElements:(CCTime) delay;

//-(void) destroyHp;
//-(void) createHp;

-(void) launchCountdown:(void(^)())block;
-(void) interruptCountdown;

-(void) launchGameOver;

-(void) pause;


@property (nonatomic, assign) __unsafe_unretained GameLayer * gameRef;
@property (nonatomic, readonly) PauseMenu * pauseLayer;

@end
