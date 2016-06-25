//
//  WeightArray.h
//  PinballBreaker
//
//  Created by Ghislain Bernier on 02/04/2016.
//  Copyright 2016 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WeightCouple : NSObject{
}

@property (nonatomic, readonly) int weight;
@property (nonatomic, readonly) id object;

-(id) initWith:(id) obj :(int) weight;

@end


@interface WeightArray : NSObject {
}

-(void) addObject:(id) object :(int) weight;
-(WeightCouple*) getRandomCouple;

@property (nonatomic, readonly) int totalWeight;
@property (nonatomic, readonly) NSMutableArray<WeightCouple*> * array;

@end
