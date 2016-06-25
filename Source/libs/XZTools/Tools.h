//
//  Tools.h
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 7/23/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject {    
}


+(void)MenuStatus:(BOOL)_enable Node:(id)_node;
+(NSString *) formatTime:(int)second;
+(NSString *) formatPreciseTime:(float)second;


+(NSString *) getCurrentDay;
+(NSString *) getCurrentDayWithDash;

+(float) frandWithRange:(float)from :(float)to;
+(int) randWithRange:(int)from :(int)to;    

+(void) purgeMemory;
+(void) purgeUnusedMemory;
+(void) purgeUnusedMemoryInGame;

+(NSString*) getStringPrice:(NSLocale*) priceLocale :(NSDecimalNumber*) price;
+(NSString*) getVersionNumber;

@end
