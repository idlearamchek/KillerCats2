//
//  MoveComponent.mm
//  RunPigRun
//
//  Created by Ghislain Bernier on 03/05/2016.
//  Copyright 2016 Apportable. All rights reserved.
//

#import "MoveComponent.h"
#import "RenderComponent.h"

@implementation MoveComponent

-(instancetype) initWithInitialPos:(CGPoint) pos direction:(CGPoint) dir speed:(float) speed :(GameObject*) gameObj{
    self = [super init];
    
    _gameObj = gameObj;
    _speed = speed;
    _direction = ccpNormalize(dir);
    _gameObj.render.node.position = pos;
    
    return self;
}

-(void) updateWithDeltaTime:(NSTimeInterval)dt{
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    float realSpeed = _speed * (pow((winSize.height - _gameObj.render.node.position.y), 1.6) / winSize.height);
    
//    if(_gameObj.render.node.position.y > winSize.height * 0.8){
//        realSpeed += 2;
//    }

    if(realSpeed < 100)
        realSpeed = 100;

    if(realSpeed > 300)
        realSpeed = 300;

    _gameObj.render.node.position = ccpAdd(_gameObj.render.node.position, ccpMult(_direction, realSpeed * dt));
}

@end
