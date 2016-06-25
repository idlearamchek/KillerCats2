//
//  GlobalSettings.h
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 10/21/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "types.h"


@interface GlobalSettings : NSObject {
}

@property (nonatomic, readwrite) BOOL isOnIpad;
@property (nonatomic, readwrite) float GAMEPLAY_FPS;
@property (nonatomic, readwrite) BOOL isOnMac;
@property (atomic, readwrite) BOOL isInIAPTransaction;
@property (nonatomic, readwrite) BOOL isOnRetina4;
@property (nonatomic, readwrite) BOOL isProbablyJB;
@property (nonatomic, readwrite) BOOL lowEffects;
@property (nonatomic, readwrite) BOOL isControllerActivated;
@property (nonatomic, readwrite) BOOL taggedAsPremium;
@property (nonatomic, readonly) NSDate * dateFirstInstall;

+(GlobalSettings *) sharedInstance;

@end
