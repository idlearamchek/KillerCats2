//
//  MainMenuLayer.m
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 5/24/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "MainMenuLayer.h"
#import "SceneMainMenu.h"
#import "types.h"
#import "SceneGame.h"

#import "AppDelegate.h"

#import "XZWindow.h"
#import "XZSound.h"

@implementation MainMenuLayer

+(void) preloadTextures{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hud.plist"];
}

-(id) init{
    [MainMenuLayer preloadTextures];
    
	self = [super init];
    winSize = [CCDirector sharedDirector].viewSize;
    
    [self createMainMenu];

    [[XZSound sharedInstance] playBg:MUSIC_MAIN_MENU loop:YES];

    return self;
}

-(void) createMainMenu{
    winSize = [CCDirector sharedDirector].viewSize;
    
    mStartBut = [[XZWindow alloc] init9SliceWithSize: CGSizeMake(160, 45) text:NSLocalizedString(@"Let's Have Fun!", nil) asset: @"buttonOneSprite.png" textScale:0.9];
    
    __weak typeof(self) weakSelf = self;
    
    mStartBut.block = ^(id){
        [weakSelf launchGame];
    };

    mStartBut.anchorPoint = ccp(0.5, 0.5);
    mStartBut.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:mStartBut];
}


-(void) launchGame{
    [mStartBut setEnabled:NO];

    [XZSound playEffect:SFX_MENU_ACCEPT];
    
    [[CCDirector sharedDirector] replaceScene:[SceneGame scene] withTransition:[CCTransition transitionFadeWithDuration:0.75]];
}


@end
