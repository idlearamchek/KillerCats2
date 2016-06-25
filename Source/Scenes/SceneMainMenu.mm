//
//  SceneMainMenu.m
//  GravitationDefense
//
//  Created by Patrick Jacob on 10-05-02.
//  Copyright 2010 XperimentalZ Games Inc. All rights reserved.
//

#import "SceneMainMenu.h"

@implementation SceneMainMenu

+ (CCScene *)scene
{
    return [[self alloc] init];
}

-(void) load{
    if(mainMenuLayer == nil){
        mainMenuLayer = [[MainMenuLayer alloc] init];
     
        [self addChild:mainMenuLayer z:0];
    }
}

-(void) onEnter{
    [super onEnter];

    [self load];
    
//    [PBRSounds stopBackGroundMusic];
//    [[PBRSounds sharedInstance] stopAllEffect];
}

-(void) onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    
    [[CCDirector sharedDirector] purgeCachedData];
}


-(id) init
{
    self = [super init];
        
    return self;
}

-(void) onExit{
    [super onExit];
}

-(void) androidBackButton{
    exit(0);
}

@end
