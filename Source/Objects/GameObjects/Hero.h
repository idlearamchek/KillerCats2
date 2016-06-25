//
//  GhostSprite.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 7/18/13.
//
//

#import "GameObject.h"
#import "XZParticleSystem.h"
#import "RenderComponent.h"
#import "ShatteredSprite.h"

typedef enum{
    POS_NONE,
    POS_1,
    POS_2,
    POS_3,
    POS_4,
    POS_MAX,
}PosHero;

@interface Hero : GameObject{
    float mRadius;
    
    float mInvicibleTimer;
}

-(id) initWithMaxHp:(int) maxHp;
-(void) explode;
-(void) getDamaged:(int) dmg;
-(void) moveLeft;
-(void) moveRight;

@property (nonatomic, readonly) ShatteredSprite * sprite;
@property (nonatomic, readonly) float radius;
@property (nonatomic, readonly) int hp;
@property (nonatomic, readonly) int maxHp;
@property (nonatomic, readonly) PosHero currentPos;
@end

