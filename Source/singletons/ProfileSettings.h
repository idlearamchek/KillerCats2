//
//  ProfileSettings.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 8/24/14.
//
//

#import "types.h"

struct GameSettings{
	GameMode gamemode;
    
//    NSString * music;
    
//    GameSettings(){
//        gamemode = G_MODE_UNKNOWN;
////        music = @"";
//    }
};

typedef struct GameSettings GameSettings;

@interface ProfileSettings : NSObject{
    GameSettings currentGameSettings;
    BOOL isTutoOver;
}

+(ProfileSettings *) sharedInstance;

-(void) setGame:(GameSettings) settings;
//+(void) destroy;
-(void) reset;
-(void) load;
-(void) save;

@property (nonatomic, readwrite) GameSettings currentGameSettings;
@property (nonatomic, readwrite) BOOL isTutoOver;

@end
