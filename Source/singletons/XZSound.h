//
//  OpenALManager+XZSound.h
//  NewProject
//
//  Created by Ghislain Bernier on 11/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "XZSound.h"
#import "OALSimpleAudio.h"

typedef enum{
    SFX_NONE,
    SFX_BOUNCE,
    SFX_AST_EXPLO,
    SFX_AST_LAUNCH,
    SFX_EARTH_DMG,
    SFX_MENU_ACCEPT,
    SFX_MENU_CANCEL,
    SFX_PWRUP,
    SFX_ROLLING,
    SFX_UNLOCK,
    SFX_WIN,
//    SFX_EARTH_DESTROYED,
    SFX_GAME_OVER,
    SFX_HIGH_SCORE,
    SFX_MAX
}Sfx;


#define MUSIC_MAIN_MENU @"main_menu.m4a"
#define MUSIC_TRACK1 @"track1.m4a"
#define MUSIC_TRACK2 @"track1.m4a"

//#define MUSIC_GAME_OVER @"Mec_game_over_sfx-1a.m4a"
//#define MUSIC_HIGH_SCORE @"Mec_high_score_sfx-1a.m4a"

@interface XZSound : NSObject{
    float mMusicVolume;
    float mSfxVolume;
    
    float mOldMusicVolume;
}

+(XZSound *) sharedInstance;

-(void) checkIfPlayerMusicIsPlaying;


@property (nonatomic, readwrite) float musicVolume;
@property (nonatomic, readwrite) float sfxVolume;

-(void) save;

+(void) pauseAll;
+(void) resumeAll;

+(void) playEffect:(Sfx) sfx;
+(void) playEffect:(Sfx) sfx :(float) volume :(float) pitch :(float) pan :(BOOL) loop;

-(bool) playBg:(NSString*) filePath loop:(bool) loop;

-(void) adjustMusicVolume: (float) volume;
-(void) adjustSfxVolume: (float)volume;

+(NSString*) strSfx:(Sfx) sfx;

+(BOOL) isCurrentlyPlaying:(NSString*) filePath;


@end
