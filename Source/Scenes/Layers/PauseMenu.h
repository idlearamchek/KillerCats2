//
//  PauseMenu.h
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 5/2/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "cocos2d.h"
#import "XZWindow.h"
//#import "Navig2DMenuContainer.h"
//#import "ControlProfile.h"

@class HudLayer;

@interface PauseMenu : CCNodeColor {
    BOOL mIsOnPause;
    
    BOOL isResuming;
    CCLabelBMFont * mCountDownTxt;
    
    XZWindow * mPauseMenu;
    
//    XZWindow * mMainMenu;
    XZWindow * mRestart;
    XZWindow * mResume;
    XZWindow * mMenuBack;
    XZWindow * mDoubleDirection;
        
    Class mBackScene;
    
//    XZWindow * mBackBut;
//    BOOL mHasRestartCountDown;
    
    BOOL mCanPause;
    
#ifdef CONTROLLER_ENABLED
    ControlProfile * mControlProfile;
    Navig2DMenuContainer * mNavigButton;
#endif
    
//    CCLayer<ControlProtocol> * mLayerUnder;
}

-(id) initWithBackSceneClass:(Class) scene : (NSString*) backStr;

-(void) setVisible:(BOOL)visible;
-(void) onPauseButton:(id)sender :(BOOL)hasRestartCountdown;
-(void) resume;
-(void) onPlayButton:(id)sender;

+(BOOL) PauseIfYouCanPlz :(BOOL) resumeIfPaused;


@property (nonatomic, assign, unsafe_unretained) HudLayer * hudLayerRef;
@property (nonatomic, readwrite) BOOL canPause;
//@property (nonatomic, readonly) BOOL isOnPause;
@end
