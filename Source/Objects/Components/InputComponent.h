//
//  MoveComponent.h
//  RunPigRun
//
//  Created by Ghislain Bernier on 03/05/2016.
//  Copyright 2016 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import <GameplayKit/GameplayKit.h>
#import "GameLayer.h"

@interface MoveComponent : GKComponent {
    
}

-(instancetype) initWithInitialPos:(CGPoint) pos direction:(CGPoint) dir :(GameLayer*) gameRef;

@property (nonatomic, readonly) float speed; //should make that global, since elements have to be synced with same speed all the time
@property (nonatomic, readonly) CGPoint direction;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly, weak) GameLayer * gameRef;

@end
