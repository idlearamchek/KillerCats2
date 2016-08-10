//
//
//  Created by Sergey Tikhonov http://haqu.net
//  Released under the MIT License
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCAnimationCache.h"
#import "CCAnimation.h"

@class GameLayer;

#define STAR_SMALL_ANIM @"star_small_anim"
#define STAR_MED_ANIM @"star_med_anim"
#define STAR_LARGE_ANIM @"star_large_anim"

@interface Sky : CCNode{
    CCSprite * mSprite;
    
    CCTime mStarTimer;
    
    int mScreenW;
    int mScreenH;
}

-(void) showStarAt:(CGPoint) pt :(NSString*) starAnim;

-(void) updateManual:(CCTime)dt;

@end
