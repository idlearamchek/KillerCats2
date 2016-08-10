//
//  GhostSprite.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 7/18/13.
//
//

#import "Cat.h"
#import "GameLayer.h"
#import "CCAnimationCache.h"
#import "CCAnimation.h"
#import "StatsManager.h"
#import "Tools3.h"

@implementation Cat

-(id) initWithLane:(CatLane) lane speed:(float) speed{
    self = [super init];
    
    CGSize winSize = [[CCDirector sharedDirector] viewSize];

    mType = GO_TYPE_CAT;

    _sprite = [ShatteredSprite spriteWithImageNamed:[self strForCat:(CatType)[Tools randWithRange:CAT_1 :CAT_MAX]]];
    _sprite.scale = 0.3;
    [self.render.node addChild:_sprite];

//    //Necessary for batchnode
//    self.texture = _sprite.texture;
//
    
    self.render.node.cascadeOpacityEnabled = YES;
    _sprite.cascadeOpacityEnabled = YES;
    
    CGPoint initPos;
    CGPoint direction;
    
    switch(lane){
        case CAT_LANE_1:
            initPos = ccp(winSize.width/2, winSize.height);
            direction = ccp(winSize.width/8 - initPos.x, -initPos.y);

            break;
        case CAT_LANE_2:
            initPos = ccp(winSize.width/2, winSize.height);
            direction = ccp(winSize.width*3/8 - initPos.x, -initPos.y);
            
            break;
        case CAT_LANE_3:
            initPos = ccp(winSize.width/2, winSize.height);
            direction = ccp(winSize.width*5/8 - initPos.x, -initPos.y);
            
            break;
        case CAT_LANE_4:
            initPos = ccp(winSize.width/2, winSize.height);
            direction = ccp(winSize.width*7/8 - initPos.x, -initPos.y);
            
            break;
        default:
            break;
    }
    
    _moveComponent = [[MoveComponent alloc] initWithInitialPos:initPos direction:direction speed:speed :self];
    [self addComponent:_moveComponent];
    
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds{
    if(self.isIncapacitated) return;
    
    if(self.render.node.position.y > 300)
        _sprite.scale = 0.4;
    else{
        _sprite.scale = 0.4 + (300 - self.render.node.position.y) * 0.0045;
    }
    
    if(self.render.node.position.y < 15){
        self.isIncapacitated = YES;
        
        [[StatsManager shared] addScore:1];
        
        [_sprite shatterWithPiecesX:8 withPiecesY:8 withSpeed:1.5 withRotation:0.6 withDirection:ccp(0, 0)];
        
        [_sprite runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:2.2],
                            [CCActionFadeOut actionWithDuration:0.4],
                            [CCActionCallBlock actionWithBlock:^(){
            [mGameRef removeGameObject:self];
        }], nil]];
    }
}

//-(void) setGameLayer:(GameLayer *)gameLayer{
//    [super setGameLayer:gameLayer];

//    [gameLayer ]
//}

-(CGRect) getTouchBox{
    return CGRectMake(self.render.node.position.x, self.render.node.position.y, _sprite.contentSize.width, _sprite.contentSize.height);
}


-(NSString*) strForCat:(CatType) type{
    return [NSString stringWithFormat:@"cat%d.png", type];
    
}


@end
