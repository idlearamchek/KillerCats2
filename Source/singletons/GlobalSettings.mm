//
//  GlobalSettings.m
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 10/21/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "GlobalSettings.h"
#import "cocos2d.h"
#import "Tools3.h"
#import "NSData_NSDataZip.h"

@implementation GlobalSettings

static GlobalSettings *_sharedInstance = nil;

+(GlobalSettings *) sharedInstance{
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
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    _isOnIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    _isOnMac = NO;
    
//    NSLog(@"platform : %@", [[UIDevice currentDevice] platform]);
//    NSLog(@"platform code: %@", [[UIDevice currentDevice] platformCode]);
//    NSLog(@"platform string: %@", [[UIDevice currentDevice] platformString]);
//    NSLog(@"platform type: %d", [[UIDevice currentDevice] platformType]);

    //DETECT using iphone5 here
    
    CGRect winSize = [[UIScreen mainScreen] bounds];
    CCLOG(@"winSize w : %.2f, h : %.2f", winSize.size.width, winSize.size.height);
    float width;
    float height;
    
    if(winSize.size.width > winSize.size.height){
        width = winSize.size.width;
        height = winSize.size.height;
    }
    else{
        width = winSize.size.height;
        height = winSize.size.width;
    }
    
    if(width == 480)
        _isOnRetina4 = NO;
    else if(width == 568)
        _isOnRetina4 = YES;

#endif
    _GAMEPLAY_FPS = 0.017;
    
    
    return self;
}

@end
