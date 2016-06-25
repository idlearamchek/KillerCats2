//
//  SceneMainMenu.h
//  GravitationDefense
//
//  Created by Patrick Jacob on 10-05-02.
//  Copyright 2010 XperimentalZ Games Inc. All rights reserved.
//


#import "MainMenuLayer.h"
#import "cocos2d.h"

//#import "ComicLayer.h"

@interface SceneMainMenu : CCScene<SceneBackProtocol> {
    MainMenuLayer * mainMenuLayer;
}

+(id) scene;

@end