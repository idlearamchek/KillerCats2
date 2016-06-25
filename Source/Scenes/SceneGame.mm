//
//  SceneGame.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 4/12/13.
//
//

#import "cocos2d.h"
#import "SceneGame.h"
#import "GlobalSettings.h"
#import "Sky.h"
#import "SceneMainMenu.h"
#import "XZSound.h"

@implementation SceneGame

+ (CCScene *)scene
{
    return [[self alloc] init];
}

-(void) load{
    [self cleanBatchNodes];

    if(mGameLayer == nil){
        mHudLayer = [[HudLayer alloc] init];
        mGameLayer = [[GameLayer alloc] initWithHud:mHudLayer];
        
        [self addChild:mGameLayer z:0];
        [self addChild:mHudLayer z:1];
    }
}

-(void) onEnter{
    int random = rand() % 100;
    NSString * song = MUSIC_TRACK1;
    
    if(random < 33)
        song = MUSIC_TRACK2;
    
    [[XZSound sharedInstance] playBg:song loop:YES];

    [[CCDirector sharedDirector] purgeCachedData];
    
    [super onEnter];
}

-(id) init{
    self = [super init];
    
    [self load];

    return self;
}

-(void) onExit{
    [super onExit];
}


-(void) androidBackButton{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[SceneMainMenu scene]];
}

-(void) cleanBatchNodes{
//    [Hero CleanBatchNode];
//    [Projectile CleanBatchNode];
//    [TerrainAnimation ClearBatchNode];
//    [Terrain ClearBatchNode];
//    [Sky ClearBatchNode];
}


@end
