//
//  ProfileSettings.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 8/24/14.
//
//

#import "ProfileSettings.h"

@implementation ProfileSettings

@synthesize currentGameSettings;
@synthesize isTutoOver;

static ProfileSettings *_sharedInstance = nil;

+(ProfileSettings *) sharedInstance{
    if(!_sharedInstance){
        _sharedInstance = [[self alloc] init];
    }
	return _sharedInstance;
}

+(id)alloc
{
	NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

- (id) init{
    self = [super init];
    
    [self load];
    
    return self;
}

-(void) load{
    isTutoOver = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutoOver"];
}

-(void) save{
    [[NSUserDefaults standardUserDefaults] setBool:isTutoOver forKey:@"tutoOver"];
}

-(void) resetGameSettings{
    currentGameSettings.gamemode = G_MODE_UNKNOWN;
//    currentGameSettings.music = @"";
}

-(void) setGame:(GameSettings) settings{
    [self resetGameSettings];
    
    currentGameSettings = settings;
    
    switch (settings.gamemode) {
        case G_MODE_ARCADE:
            
            CCLOG(@"G_MODE_ARCADE");
            break;

        default:
            CCLOG(@"unknown game mode");
            break;
    }
}

-(void) reset{
    [self resetGameSettings];
    isTutoOver = NO;
}

@end
