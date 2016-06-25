//
//  Tools.m
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 7/23/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "Tools.h"
#import "cocos2d.h"
#ifdef SNEAKY_BUTTON
#import "SneakyButton.h"
#endif

#ifdef MUTABLE_SPRITE
#import "CCMutableSpriteFrameCache.h"
#import "CCMutableTextureCache.h"
#endif

@implementation Tools

+(void)MenuStatus:(BOOL)_enable Node:(id)_node
{
    for (id result in ((CCNode *)_node).children) {
        if ([result isKindOfClass:[CCMenu class]]) {
            ((CCMenu *)result).touchEnabled = _enable;
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            ((CCMenu *)result).mouseEnabled = _enable;
            ((CCMenu *)result).keyboardEnabled = _enable;
#endif
        }
#ifdef SNEAKY_BUTTON
        else if([result isKindOfClass:[SneakyButton class]]){
            ((SneakyButton*)result).enabled = _enable;
        }
#endif
        else
            [self MenuStatus:_enable Node:result];
    }
}

+(NSString *) getCurrentDay{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyy"];   
    NSString * currentDate = [formatter stringFromDate:[NSDate date]] ;
    [formatter release];
    
    return currentDate;
}

+(NSString *) getCurrentDayWithDash{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yy"];
    NSString * currentDate = [formatter stringFromDate:[NSDate date]] ;
    [formatter release];
    
    return currentDate;
}

+(NSString *) formatTime:(int)second{
    NSString * formattedTime;
    
    int hours = second/3600;
    int mins = (second%3600)/60;
    //int mins = (second - (hours*3600))/60;
    int seconds = second%60;
    //second - (mins*60) - (hours*3600);
    
    if(hours >= 1)
        formattedTime = [NSString stringWithFormat:@"%d h %d m", hours, mins];
    else if(mins >= 1)
        formattedTime = [NSString stringWithFormat:@"%d m %d s", mins, seconds];
    else
        formattedTime = [NSString stringWithFormat:@"%d s", seconds];
    
    return formattedTime;
}


+(NSString *) formatPreciseTime:(float)second{
    NSString * formattedTime;
    
    int mins = (fmod(second,3600))/60;
    float seconds = fmod(second,60);
    
    if(mins >= 1)
        formattedTime = [NSString stringWithFormat:@"%d:%05.2fs", mins, seconds];
    else
        formattedTime = [NSString stringWithFormat:@"%05.2fs", seconds];
    
    return formattedTime;
}

+(float) frandWithRange:(float)from :(float)to{
    return ((rand() / (float)0x7fffffff )) * (to-from ) + from;
}

// from to (to-1)
+(int) randWithRange:(int)from :(int)to{    
    return (int) (((rand() / (float)0x7fffffff )) * (to-from )) + from;
}


+(void) purgeMemory{
    [CCLabelBMFont purgeCachedData];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache]; 
    [CCTextureCache purgeSharedTextureCache];
#ifdef MUTABLE_SPRITE
    [CCMutableSpriteFrameCache purgeSharedSpriteFrameCache];
    [CCMutableTextureCache purgeSharedTextureCache];
#endif
}

+(void) purgeUnusedMemory{
    [CCLabelBMFont purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames]; 
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
#ifdef MUTABLE_SPRITE
    [[CCMutableSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCMutableTextureCache sharedTextureCache] removeUnusedTextures];
#endif
}

+(void) purgeUnusedMemoryInGame{
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
#ifdef MUTABLE_SPRITE
    [[CCMutableTextureCache sharedTextureCache] removeUnusedTextures];
#endif
}

+(NSString*) getStringPrice:(NSLocale*) priceLocale :(NSDecimalNumber*) price{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:priceLocale];
    NSString *stringPrice = [numberFormatter stringFromNumber:price];
    [numberFormatter release];
    return stringPrice;
}

+(NSString*) getVersionNumber{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
}


@end


//                for (id result1 in ((CCMenu *)result).children) {
//                    if ([result1 isKindOfClass:[CCMenuItem class]]) {
//                        [((CCMenuItem *)result1) setIsEnabled:_enable];
//                    }
//                }
