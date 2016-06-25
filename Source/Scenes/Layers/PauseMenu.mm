//
//  PauseMenu.m
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 5/2/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "PauseMenu.h"
#import "HudLayer.h"
#import "XZWindow.h"
#import "XZSound.h"
#import "SceneGame.h"
#import "SceneMainMenu.h"
#import "Tools3.h"

#define COUNTDOWN_LENGTH 2

__unsafe_unretained static PauseMenu* currentPauseMenu = nil;

@implementation PauseMenu

@synthesize canPause = mCanPause;

+(BOOL) PauseIfYouCanPlz:(BOOL) resumeIfPaused{
    BOOL willPause = NO;
    if(currentPauseMenu){
        if(currentPauseMenu.canPause && !currentPauseMenu.visible){
            willPause = currentPauseMenu.hudLayerRef.gameRef.gameState.currentState == [GameStartedState class];
            
            if(willPause)
                [currentPauseMenu onPauseButton:currentPauseMenu.hudLayerRef.gameRef :YES];
        }
        else if (currentPauseMenu.visible && resumeIfPaused){
            [currentPauseMenu onPlayButton:nil];
        }
    }
    
    return willPause;
}

//+(void) ResumeIfYouCanPlz{
//    if(currentPauseMenu.isOnPause){
//        [currentPauseMenu retain];
//        
//        [currentPauseMenu onPlayButton:nil];
//        [currentPauseMenu release];
//    }
//}

-(id) initWithBackSceneClass:(Class) scene : (NSString*) backStr{
//    [HudLayer preload];
    self = [super initWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.4]];

    mBackScene = scene;
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    //mPauseMenu = [[XZWindow alloc] initWithSize:CGSizeMake(150, 170) backgroundOpacity:200 withStyle:STYLE_WINDOW];
    
    mPauseMenu = [[XZWindow alloc] init9SliceWithSize: CGSizeMake(150, 170) text:@"" asset: @"buttonOneSprite.png" textScale:0.7 textOffset:CGSizeZero :YES];
    
    [self addChild:mPauseMenu];
    
    __weak typeof(self) weakSelf = self;
    
    mMenuBack = [[XZWindow alloc] init9SliceWithSize: CGSizeMake(110, 35) text:backStr  asset: @"buttonOneSprite.png" textScale:0.7];
    
    mMenuBack.block = ^(id sender){
        [weakSelf onStopButton:sender];
    };
        
    mRestart = [[XZWindow alloc] init9SliceWithSize: CGSizeMake(110, 35) text:NSLocalizedString(@"Restart", nil)  asset: @"buttonOneSprite.png" textScale:0.7];

    mRestart.block = ^(id sender){
        [weakSelf onRestartButton:sender];
    };

    //mResume = [[XZWindow alloc] initWithSize:CGSizeMake(150,46)
    //                                        backgroundOpacity:250
    //                                                     text:NSLocalizedString(@"resume", nil) maxTextWidth:100000 textOffset:ccp(0,0)
    //                                         adjustSizeToText:NO];
    
    mResume = [[XZWindow alloc] init9SliceWithSize: CGSizeMake(110, 35) text:NSLocalizedString(@"Resume", nil)  asset: @"buttonOneSprite.png" textScale:0.7];

    mResume.block = ^(id sender){
        [weakSelf resume];
    };

    mPauseMenu.anchorPoint = ccp(0.5, 0.5);
    mMenuBack.anchorPoint = ccp(0.5, 0.5);
    mRestart.anchorPoint = ccp(0.5, 0.5);
    mResume.anchorPoint = ccp(0.5, 0.5);
    
    CCLayoutBox * layoutBox = [[CCLayoutBox alloc] init];
    
    [layoutBox addChild:mMenuBack];
    [layoutBox addChild:mRestart];
    [layoutBox addChild:mResume];
    
    layoutBox.direction = CCLayoutBoxDirectionVertical;
    layoutBox.spacing = 16;

    layoutBox.position = ccp(20, 15);
    [mPauseMenu addChild:layoutBox];
    
    isResuming = NO;
    self.visible = NO;
    mPauseMenu.visible = NO;
    
    mPauseMenu.position = ccp(winSize.width/2, winSize.height/2);

    return self;
}

- (void)onRestartButton:(id)sender{
    [[OALSimpleAudio sharedInstance] setBgMuted:NO];
    [XZSound playEffect:SFX_MENU_ACCEPT];
    
    self.visible = NO;
//    mMenu.visible = NO;
    mPauseMenu.visible = NO;
    
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[SceneGame scene]];
}

- (void)onPauseButton:(id)sender :(BOOL) hasRestartCountdown{
    [self setupControllerForLayer];
//    mLayerUnder = sender;
    
    [_hudLayerRef interruptCountdown];

    [self setOpacity:0.4];
    
    BOOL photoMode = NO;
    
    if (!photoMode){
        [[OALSimpleAudio sharedInstance] setBgMuted:YES];

        self.userInteractionEnabled = YES;
        self.exclusiveTouch = YES;

        [_hudLayerRef.gameRef pauseLayer];

        self.visible = YES;
        mPauseMenu.visible = YES;
    }
    else{
//        if ([CCDirector sharedDirector].isPaused){
//            [[CCDirector sharedDirector] resume];
//            [XZSound resumeAll];
//        }
//        else{
//            [[CCDirector sharedDirector] pause];
//            [XZSound pauseAll];
//        }
    }
}

-(void) resume{
    [[CCDirector sharedDirector] resume];
    
    mPauseMenu.visible = NO;
    self.visible = NO;

    [[OALSimpleAudio sharedInstance] setMuted:NO];
    [[OALSimpleAudio sharedInstance] setBgMuted:YES];
    
    [_hudLayerRef launchCountdown:^(){
        self.userInteractionEnabled = NO;
        self.exclusiveTouch = NO;

        [_hudLayerRef.gameRef resumeLayer];
        
        [[OALSimpleAudio sharedInstance] setBgMuted:NO];
        [XZSound resumeAll];
    }];
}

- (void)onPlayButton:(id)sender{
    [XZSound playEffect:SFX_MENU_ACCEPT];

    [self resume];
    
//    [mLayerUnder setupControllerForLayer];
//
//    [self setOpacity:0];
//    
//    if(!isResuming){
//        isResuming = YES;
//        mPauseMenu.visible = NO;
////        mAutoRotMenu.visible = NO;
//        mCountDownTxt.visible = YES;
//        [self visit];
//        for(int i = COUNTDOWN_LENGTH; i > 0; i--){
//            [[PBRSounds sharedInstance] playSFXWithPitch:(float)((4.0f-(float)i)/2.0f) :0:START_LIGHTS_SFX :NO];
//            
//            mCountDownTxt.string = [NSString stringWithFormat:@"%d", i];
//            [mCountDownTxt visit];
//            [[CCDirector sharedDirector] drawScene];        
//            usleep(500000);
//        }
//
//        [[PBRSounds sharedInstance] playSFXWithPitch:2.0 :0:START_LIGHTS_SFX :NO];
//
//        mCountDownTxt.visible = NO;
//        [self resume];
//        isResuming = NO;
//    }
}

- (void)onStopButton:(id)sender{
    [[OALSimpleAudio sharedInstance] setBgMuted:NO];

    [XZSound playEffect:SFX_MENU_CANCEL];

//    [[GlobalDataManager sharedInstance] midgameSave];
//    
//    isResuming = NO;
    [[CCDirector sharedDirector] resume];
    [[OALSimpleAudio sharedInstance] stopEverything];
    
    [[CCDirector sharedDirector] replaceScene:[mBackScene scene] withTransition:[CCTransition  transitionFadeWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:1] duration:0.4]];
}

-(void) setVisible:(BOOL)visible{
    [super setVisible:visible];
}

-(void) createNavig :(NSMutableArray*) navigArray{
#ifdef CONTROLLER_ENABLED
    [mNavigButton release];
    mNavigButton = [[Navig2DMenuContainer alloc] initWithSize:CGSizeMake(1, [navigArray count]) :YES];
    [mNavigButton populateContainer:navigArray];
#endif
}

-(void) onExit{
#ifdef CONTROLLER_ENABLED
#if defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    [[ControllerManager sharedInstance] removeControlProfile:mControlProfile];
#else
    RootViewController * viewController = [AppDelegate getViewController];
    [viewController removeControlProfile:mControlProfile];
#endif
    [mControlProfile release];
#endif    
    currentPauseMenu = nil;

    [super onExit];
}

-(void) setupControllerForLayer{
#ifdef CONTROLLER_ENABLED

#if !defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    RootViewController * viewController = [AppDelegate getViewController];
    [viewController setupMFIController];
#else
    [[ControllerManager sharedInstance] setupMFIController];
#endif
    
    if([GlobalSettings sharedInstance].isControllerActivated && mNavigButton){
        [mNavigButton colorCurrentSelection];
    }

    if(mControlProfile == nil){
        mControlProfile = [[ControlProfile alloc] initWithBlock:^(iCadeInfos icadeInfos){

            if(icadeInfos.button != iCadeJoystickNone){
                //HANDLE iCade
                
                switch(icadeInfos.button){
                    case iCadeJoystickDown:
                        if(icadeInfos.isPressed)
                            [mNavigButton moveDownAndColor];
                        break;
                    case iCadeJoystickUp:
                        if(icadeInfos.isPressed)
                            [mNavigButton moveUpAndColor];
                        break;
                    case iCadeJoystickLeft:
                        if(icadeInfos.isPressed)
                            [mNavigButton moveLeftAndColor];
                        break;
                    case iCadeJoystickRight:
                        if(icadeInfos.isPressed)
                            [mNavigButton moveRightAndColor];
                        break;
                        
                    case iCadeButtonA:
                        if(icadeInfos.isPressed)
                            [mNavigButton activate];
                        break;
                        
                    case iCadeButtonB:
                        if(icadeInfos.isPressed)
                            [mResume activate];
                        break;
                        
                    case iCadeButtonG:
                    case iCadeButtonH:
                        if(icadeInfos.isPressed)
                            [PauseMenu PauseIfYouCanPlz :YES];
                        break;

                    default:
                        CCLOG(@"ignored iCade -> %d %d", icadeInfos.button, icadeInfos.isPressed);
                        break;
                }
            }
        }];
    }
    
#if defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    [[ControllerManager sharedInstance] setControlProfile:mControlProfile];
#else
    [viewController setControlProfile:mControlProfile];
#endif
#endif
}

-(void) onEnterTransitionDidFinish{
    currentPauseMenu = self;
    
    [super onEnterTransitionDidFinish];
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
}

//-(void) dealloc{
//#ifdef CONTROLLER_ENABLED
//    [mNavigButton release];
//#endif
//    [super dealloc];
//}

@end
