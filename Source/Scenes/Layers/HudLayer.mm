//
//  HudLayer.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 5/7/13.
//
//

#import "HudLayer.h"
#import "GameLayer.h"
#import "SceneMainMenu.h"
#import "SceneGame.h"
#import "CCAnimationCache.h"
#import "StatsManager.h"
#import "XZSound.h"
#import "CCTextureCache.h"

@implementation HudLayer

-(id) init{
    self = [super init];
    
    _gameRef = nil;

//    self.userInteractionEnabled = YES;
    
    mScreenSize = [CCDirector sharedDirector].viewSize;
        
    return self;
}

-(void) createWithGameSettings:(GameSettings) gameSettings{

    [self createHud:gameSettings];
    
    //PAUSE
    [self createPauseMenuWith:gameSettings.gamemode];

    
    [self initPosHudElements];
    [self showHudElements];
}

-(void) setGameRef:(GameLayer *)gameRef{
    _gameRef = gameRef;
    
    float updateTime = 1/10.0f;
    [self schedule:@selector(updateHud:) interval:updateTime];
}

-(void) createHud:(GameSettings) gameSettings{
    mLabelScoreNumber = [CCLabelBMFont labelWithString:@"0000" fntFile:@"digitalFontLarge.fnt"];
    mLabelScoreNumber.anchorPoint = ccp(1, 0.5);
    mLabelScoreNumber.scale = 1.0;
    
    [self addChild:mLabelScoreNumber];

    mLabelBestScore = [CCLabelBMFont labelWithString:NSLocalizedString(@"Best: 0", nil) fntFile:@"digitalFontLarge.fnt"];
    mLabelBestScore.anchorPoint = ccp(1, 0.5);
    mLabelBestScore.scale = 0.7;

    [self addChild:mLabelBestScore];
    
//    [self createHp];
}

-(void) initPosHudElements{
    mLabelScoreNumber.position = ccp(mScreenSize.width + 110, mScreenSize.height - 10);
    mLabelBestScore.position = ccp(mScreenSize.width - 34, mScreenSize.height - 30);
    
    mPauseButton.position = ccp(-170, mScreenSize.height);
}

-(void) showHudElements{
    [mLabelScoreNumber stopAllActions];
    [mLabelBestScore stopAllActions];
    [mPauseButton stopAllActions];

    [mLabelScoreNumber runAction:[CCActionEaseRate actionWithAction:[CCActionMoveTo actionWithDuration:0.4 position:ccp(mScreenSize.width - 5, mScreenSize.height - 10)] rate:2]];
    [mLabelBestScore runAction:[CCActionEaseRate actionWithAction:[CCActionMoveTo actionWithDuration:0.4 position:ccp(mScreenSize.width - 5, mScreenSize.height - 30)] rate:2]];
    [mPauseButton runAction:[CCActionEaseRate actionWithAction:[CCActionMoveTo actionWithDuration:0.4 position:ccp(10, mScreenSize.height - 10)] rate:2]];
}

-(void) launchGameOver{
    [self hideHudElements:1.5];
}

-(void) hideHudElements:(CCTime) delay{
    [mLabelScoreNumber stopAllActions];
    [mLabelBestScore stopAllActions];
    [mPauseButton stopAllActions];
    
    [self runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:delay], [CCActionCallBlock actionWithBlock:^(){
        [mLabelScoreNumber runAction:[CCActionEaseRate actionWithAction:[CCActionMoveTo actionWithDuration:0.4 position:ccp(mScreenSize.width + 110, mScreenSize.height - 10)] rate:2]];
        [mPauseButton runAction:[CCActionEaseRate actionWithAction:[CCActionMoveTo actionWithDuration:0.4 position:ccp(-170, mScreenSize.height)] rate:2]];
    }], [CCActionDelay actionWithDuration:0.4], [CCActionCallBlock actionWithBlock:^(){
        
        [mLabelBestScore runAction:[CCActionEaseRate actionWithAction:[CCActionMoveTo actionWithDuration:0.4 position:ccp(mScreenSize.width - 5, mScreenSize.height/2 + 95)] rate:2]];
    }], nil]];
}

-(void) interruptCountdown{
    CCLabelBMFont * lblCountdown = (CCLabelBMFont *)[self getChildByName:@"countdown" recursively:YES];
    
    [lblCountdown stopAllActions];
    [lblCountdown removeFromParent];
}

-(void) launchCountdown:(void(^)())block{
    CCLabelBMFont * labelCountdown = [CCLabelBMFont labelWithString:@"3" fntFile:@"digitalFont.fnt"];
    labelCountdown.opacity = 0;
    labelCountdown.position = ccp(mScreenSize.width/2, mScreenSize.height * 0.75);
    [self addChild:labelCountdown z:0 name:@"countdown"];
    [labelCountdown runAction:[CCActionFadeIn actionWithDuration:0.3]];
    
    [XZSound playEffect:SFX_ROLLING :1 :0.25 :0 :NO];
    
    [labelCountdown runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:0.3],
                               [CCActionFadeOut actionWithDuration:0.3],
                     [CCActionCallBlock actionWithBlock:^(){
        labelCountdown.string = @"2";
        labelCountdown.opacity = 0;
        [XZSound playEffect:SFX_ROLLING :1 :0.5 :0 :NO];

    }],  [CCActionFadeIn actionWithDuration:0.3],
         [CCActionFadeOut actionWithDuration:0.3],
    [CCActionCallBlock actionWithBlock:^(){
        labelCountdown.string = @"1";
        labelCountdown.opacity = 0;
        [XZSound playEffect:SFX_ROLLING :1 :1 :0 :NO];
    }],
                               [CCActionFadeIn actionWithDuration:0.3],
                               [CCActionFadeOut actionWithDuration:0.3],
                               [CCActionCallBlock actionWithBlock:^(){
        [labelCountdown removeFromParent];
        block();
    }],
                               nil]];
}

-(void) pause{
    [XZSound playEffect:SFX_MENU_ACCEPT];

    [_gameRef changeState:[GamePausedState class]];
}

-(void) createPauseMenuWith:(GameMode) gameMode{
    
    NSString * backMenuStr = NSLocalizedString(@"Main Menu", nil);
    Class backScene = [SceneMainMenu class];
    
    _pauseLayer = [[PauseMenu alloc] initWithBackSceneClass:backScene :backMenuStr];

    mPauseButton = [XZButton buttonWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"pause.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"pause.png"]
                               disabledSpriteFrame:nil];
    [mPauseButton setBackgroundOpacity:0.5 forState:CCControlStateHighlighted];
    
    __weak typeof(self) weakSelf = self;
    
    mPauseButton.block = ^(id){
        [weakSelf pause];
    };
    
    mPauseButton.anchorPoint = ccp(0, 1);

    [self addChild:mPauseButton z:10];
    [self addChild:_pauseLayer z:10];
    
    _pauseLayer.canPause = YES;
    _pauseLayer.hudLayerRef = self;
}

-(void) updateHud:(CCTime)dt{
    
    //or update in GameStartedState itself
    if([_gameRef.gameState.currentState isKindOfClass:[GameStartedState class]]){
        mLabelScoreNumber.string = [NSString stringWithFormat:@"%04d", (int)[StatsManager shared].currentScore];
        mLabelBestScore.string = [NSString stringWithFormat:NSLocalizedString(@"Best: %d", nil), (int)[StatsManager shared].bestScore];
}
}

@end
