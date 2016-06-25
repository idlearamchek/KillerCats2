//
//  SceneGame.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 4/12/13.
//
//

#import "CCScene.h"
#import "GameLayer.h"
#import "HudLayer.h"


@interface SceneGame : CCScene<SceneBackProtocol>{
    GameLayer * mGameLayer;
    HudLayer * mHudLayer;
}

+(id) scene;


@end
