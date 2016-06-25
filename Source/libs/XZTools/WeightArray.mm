//
//  WeightArray.mm
//  PinballBreaker
//
//  Created by Ghislain Bernier on 02/04/2016.
//  Copyright 2016 Apportable. All rights reserved.
//

#import "WeightArray.h"

@implementation WeightCouple

-(id) initWith:(id) obj :(int) weight{
    self = [super init];

    _object = obj;
    _weight = weight;
    
    return self;
}

@end

@implementation WeightArray

-(id) init{
    self = [super init];
    
    _array = [NSMutableArray array];
    _totalWeight = 0;
    
    return self;
}

-(void) addObject:(id) object :(int) weight{
    if(weight > 0){
        [_array addObject:[[WeightCouple alloc] initWith:object :weight]];
        _totalWeight += weight;
    }
}

-(WeightCouple*) getRandomCouple{
    int rand = arc4random_uniform(_totalWeight);
    
    WeightCouple* randomObj = nil;
    int cumulWeight = 0;
    
    for (WeightCouple * objCouple in _array) {
        cumulWeight += objCouple.weight;
        
        if(rand < cumulWeight){
            randomObj = objCouple;
            break;
        }
    }
    
    return randomObj;
}


@end
