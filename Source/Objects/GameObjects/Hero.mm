//
//  GhostSprite.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 7/18/13.
//
//

#import "Hero.h"
#import "CCAnimationCache.h"
#import "cocos2d.h"
#import "CCAnimation.h"
#import "Tools3.h"
#import "XZSound.h"
#import "StatsManager.h"
#import "GameLayer.h"

@implementation Hero

-(id) initWithMaxHp:(int) maxHp{
    self = [super init];
    
    _hp = _maxHp = maxHp;

    mType = GO_TYPE_HERO;
    
    _sprite = [ShatteredSprite spriteWithImageNamed:@"pig.png"];
    [self.render.node addChild:_sprite];
    
    _currentPos = POS_1;
    [self setPositionFor:_currentPos];

    return self;
}

-(void) getDamaged:(int) dmg{
    if(mInvicibleTimer <= 0){
        mInvicibleTimer = 0.5;
        _hp -= dmg;
        
        if (_hp < 0)
            _hp = 0;
        else if(_hp > _maxHp)
            _hp = _maxHp;
    }
}

-(void) explode{
    [_sprite shatterWithPiecesX:10 withPiecesY:10 withSpeed:0.3 withRotation:23 withDirection:ccp(0,0)];
}

-(void) moveLeft{
    ENUM_DEC(_currentPos, PosHero);
    
    if(_currentPos <= POS_NONE)
        _currentPos = POS_1;
    
    [self setPositionFor:_currentPos];
}

-(void) moveRight{
    ENUM_INC(_currentPos, PosHero);
    
    if(_currentPos >= POS_MAX)
        _currentPos = POS_4;
    
    [self setPositionFor:_currentPos];
}

-(void) setPositionFor:(PosHero) posHero{
    switch(posHero){
        case POS_1:
            self.render.node.position = ccp([CCDirector sharedDirector].viewSize.width/8, 30);
            self.sprite.flipX = YES;
            break;
        case POS_2:
            self.render.node.position = ccp([CCDirector sharedDirector].viewSize.width*3/8, 30);
            self.sprite.flipX = YES;
            break;
        case POS_3:
            self.render.node.position = ccp([CCDirector sharedDirector].viewSize.width*5/8, 30);
            self.sprite.flipX = NO;
            break;
        case POS_4:
            self.render.node.position = ccp([CCDirector sharedDirector].viewSize.width*7/8, 30);
            self.sprite.flipX = NO;
            break;
        default:
            break;
    }
}


-(CGRect) getTouchBox{
    return CGRectMake(self.render.node.position.x, self.render.node.position.y, _sprite.contentSize.width, _sprite.contentSize.height * 0.8);
}

- (void)updateWithDeltaTime:(NSTimeInterval)dt{
    mInvicibleTimer -= dt;
    
    //collision check
    NSArray * objects = [self.gameRef gameObjectArray];
    
    CGRect touchBox = [self getTouchBox];
    
    for (GameObject * go in objects) {
        if(!go.isIncapacitated && go.type == GO_TYPE_CAT){
            
            CGRect catBox = [go getTouchBox];
            
            if(CGRectIntersectsRect(catBox, touchBox)){
               //Collision
                [self getDamaged:1];
            }
        }
    }
    
}

@end