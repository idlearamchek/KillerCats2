//
//  MoveComponent.mm
//  RunPigRun
//
//  Created by Ghislain Bernier on 03/05/2016.
//  Copyright 2016 Apportable. All rights reserved.
//

#import "RenderComponent.h"

@implementation EntityNode
@end


@implementation RenderComponent

-(instancetype) initWithEntity:(GKEntity*) entity{
    self = [super init];
    
    _node = [EntityNode emptySprite];
    _node.entity = entity;
    
    return self;
}

-(void) updateWithDeltaTime:(NSTimeInterval)dt{
}

@end
