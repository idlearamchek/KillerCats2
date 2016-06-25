//
//  MoveComponent.mm
//  RunPigRun
//
//  Created by Ghislain Bernier on 03/05/2016.
//  Copyright 2016 Apportable. All rights reserved.
//

#import "MoveComponent.h"


@implementation MoveComponent

-(instancetype) initWithInitialPos:(CGPoint) pos direction:(CGPoint) dir :(GameLayer*) gameRef{
    self = [super init];
    
    _gameRef = gameRef;
    _speed = 10;
    _direction = ccpNormalize(dir);
    _position = pos;
    
    return self;
}

-(void) updateWithDeltaTime:(NSTimeInterval)dt{
    _position = ((CCSprite*)self.entity).position;
    
    [self.entity componentForClass:<#(nonnull Class)#>]
    
    ((CCSprite*)self.entity).position = ccpAdd(_position, ccpMult(_direction, _speed * dt));
    
//    if(_position.y < 0){
//        [_gameRef removeGameObject:self.entity];
//    }
}

@end
