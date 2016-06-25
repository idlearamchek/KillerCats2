//
//  MoveComponent.h
//  RunPigRun
//
//  Created by Ghislain Bernier on 03/05/2016.
//  Copyright 2016 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import <GameplayKit/GameplayKit.h>


@interface EntityNode : CCSprite
@property (nonatomic, weak) GKEntity * entity;
@end

@interface RenderComponent : GKComponent {
    
}

-(instancetype) initWithEntity:(GKEntity*) entity;

@property (nonatomic, readonly) EntityNode * node;

@end
