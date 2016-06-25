//
//  OpenALManager+XZSound.m
//  NewProject
//
//  Created by Ghislain Bernier on 11/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "XZSound.h"
#import "types.h"
#import "OALTools.h"

@implementation XZSound

@synthesize musicVolume = mMusicVolume;
@synthesize sfxVolume = mSfxVolume;

static XZSound *_sharedInstance = nil;

+(XZSound *) sharedInstance{
    if(!_sharedInstance){
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

+(id)alloc{
    NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

- (id) init{
    self = [super init];
    
    [self load];
    
    return self;
}

-(void) checkIfPlayerMusicIsPlaying{
     BOOL hasMusicPlaying = [[AVAudioSession sharedInstance] isOtherAudioPlaying];
    
    if(hasMusicPlaying){
        if(mMusicVolume != 0)
            mOldMusicVolume = mMusicVolume;
        
        mMusicVolume = 0;
    }
    else{
        if(mOldMusicVolume != 0)
            mMusicVolume = mOldMusicVolume;
    }
    
    [OALSimpleAudio sharedInstance].bgVolume = mMusicVolume;

}

+(NSString*) strSfx:(Sfx) sfx{
    NSString * fileName = @"";
    
    switch (sfx) {
        case SFX_AST_EXPLO:
            fileName = @"sfx_asteroid_destroy.wav";
            break;
        case SFX_BOUNCE:
            fileName = @"sfx_bounce.wav";
            break;
        case SFX_AST_LAUNCH:
            fileName = @"sfx_asteroid_launch.wav";
            break;
        case SFX_EARTH_DMG:
            fileName = @"sfx_earth_damaged.wav";
            break;
        case SFX_MENU_ACCEPT:
            fileName = @"sfx_menu_accept.wav";
            break;
        case SFX_MENU_CANCEL:
            fileName = @"sfx_menu_cancel.wav";
            break;
        case SFX_PWRUP:
            fileName = @"sfx_powerup.wav";
            break;
        case SFX_ROLLING:
            fileName = @"sfx_rolling2.wav";
            break;
        case SFX_UNLOCK:
            fileName = @"sfx_unlock.wav";
            break;
        case SFX_WIN:
            fileName = @"sfx_win_roar.wav";
            break;
//        case SFX_EARTH_DESTROYED:
//            fileName = @"Mec_earth_destroyed_sfx-1a.wav";
//            break;
        case SFX_GAME_OVER:
            fileName = @"sfx_game_over.wav";
            break;
        case SFX_HIGH_SCORE:
            fileName = @"sfx_high_score.wav";
            break;
            
        default:
            break;
    }
        
    return fileName;
}

-(void) load{
    [[OALSimpleAudio sharedInstance] setAllowIpod:YES];
//    [[OALSimpleAudio sharedInstance] setUseHardwareIfAvailable:NO];
//    [[OALSimpleAudio sharedInstance] setHonorSilentSwitch:YES];
    
    for(Sfx sfx = (Sfx)(SFX_NONE + 1); sfx < SFX_MAX ; ENUM_INC(sfx, Sfx)){
        [[OALSimpleAudio sharedInstance] preloadEffect:[XZSound strSfx:sfx] reduceToMono:NO];
    }

    [[OALSimpleAudio sharedInstance] preloadBg:MUSIC_MAIN_MENU];
    [[OALSimpleAudio sharedInstance] preloadBg:MUSIC_TRACK1];
    [[OALSimpleAudio sharedInstance] preloadBg:MUSIC_TRACK2];
//    [[OALSimpleAudio sharedInstance] preloadBg:MUSIC_HIGH_SCORE];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"sfx_volume"])
        [self adjustSfxVolume:[[NSUserDefaults standardUserDefaults] floatForKey:@"sfx_volume"]];
    else
        [self adjustSfxVolume:1];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"music_volume"])
        [self adjustMusicVolume:[[NSUserDefaults standardUserDefaults] floatForKey:@"music_volume"]];
    else
        [self adjustMusicVolume:1];
}

-(void) save{
    [[NSUserDefaults standardUserDefaults] setFloat:mMusicVolume forKey:@"music_volume"];
    [[NSUserDefaults standardUserDefaults] setFloat:mSfxVolume forKey:@"sfx_volume"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void) playEffect:(Sfx) sfx :(float) volume :(float) pitch :(float) pan :(BOOL) loop{
    [[OALSimpleAudio sharedInstance] playEffect:[XZSound strSfx:sfx] volume:volume pitch:pitch pan:pan loop:loop];
}

+(void) playEffect:(Sfx) sfx{
    [[OALSimpleAudio sharedInstance] playEffect:[XZSound strSfx:sfx]];
}

+(BOOL) isCurrentlyPlaying:(NSString*) filePath{
    return [[OALSimpleAudio sharedInstance].backgroundTrack.currentlyLoadedUrl isEqual:[OALTools urlForPath:filePath]];
}

- (bool) playBg:(NSString*) filePath loop:(bool) loop{
    bool played = NO;
    
    if(![XZSound isCurrentlyPlaying:filePath]){
        played = [[OALSimpleAudio sharedInstance] playBg:filePath loop:loop];
        
        [XZSound resumeAll];
    }
    
//    if (![[OALSimpleAudio sharedInstance].backgroundTrack.currentlyLoadedUrl isEqual:[OALTools urlForPath:filePath]]){
//    }
    
    return played;
}

+(void) pauseAll{
    [[OALSimpleAudio sharedInstance] setMuted:YES];

    [OALSimpleAudio sharedInstance].bgPaused = YES;
    [OALSimpleAudio sharedInstance].effectsPaused = YES;
}

+(void) resumeAll{
    [[OALSimpleAudio sharedInstance] setMuted:NO];

    [OALSimpleAudio sharedInstance].bgPaused = NO;
    [OALSimpleAudio sharedInstance].effectsPaused = NO;
}

-(void) adjustMusicVolume: (float) volume{
    float localMusicVol = volume;
    mMusicVolume = volume;

//    if (![[OALSimpleAudio sharedInstance].backgroundTrackURL isEqual:[OALTools urlForPath:@"track"]]) {
//        localMusicVol = [self realMusicVolumeFor:[OALSimpleAudio sharedInstance].backgroundTrackURL];
//    }
    
    [OALSimpleAudio sharedInstance].bgVolume = localMusicVol;
}

-(float) realMusicVolumeFor:(NSURL*) musicURL{
    float extraGainPercent = [XZSound gainAdjustmentForMusicTrack:musicURL];
    
    return mMusicVolume + (mMusicVolume * ((float)extraGainPercent/100.0f));
}

+(float) gainAdjustmentForMusicTrack:(NSURL*) trackURL{
    float gain = 0;
    
//    if([track isEqualToString:TRACK1_MUSIC])
//        gain = -30;
//    else if([track isEqualToString:TRACK2_MUSIC])
//        gain = -40;
//    else if([track isEqualToString:TRACK3_MUSIC])
//        gain = -30;
//    else if([track isEqualToString:TRACK4_MUSIC])
//        gain = -30;
//    else if([track isEqualToString:TRACK5_MUSIC])
//        gain = -30;
//    else if([track isEqualToString:TRACK6_MUSIC])
//        gain = 0;
//    else if([track isEqualToString:INTRO_MUSIC])
//        gain = -60;
//    else if([track isEqualToString:TRACK7_MUSIC])
//        gain = -20;
//    else if([track isEqualToString:TRACK8_MUSIC])
//        gain = -30;
    
    return gain;
}

-(void) adjustSfxVolume: (float)volume{
    mSfxVolume = volume;
    
    [OALSimpleAudio sharedInstance].effectsVolume = mSfxVolume;
}

@end
