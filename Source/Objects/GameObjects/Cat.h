//
//  GhostSprite.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 7/18/13.
//
//

#import "GameObject.h"
#import "MoveComponent.h"
#import "RenderComponent.h"
#import "ShatteredSprite.h"

typedef enum{
    CAT_LANE_NONE,
    CAT_LANE_1,
    CAT_LANE_2,
    CAT_LANE_3,
    CAT_LANE_4,
    CAT_LANE_MAX,
}CatLane;


typedef enum{
    CAT_NONE,
    CAT_1,
    CAT_2,
    CAT_3,
    CAT_4,
    CAT_5,
    CAT_6,
    CAT_MAX,
}CatType;



@interface Cat : GameObject{
}

-(id) initWithLane:(CatLane) lane speed:(float) speed;

@property (nonatomic, readonly) MoveComponent * moveComponent;
@property (nonatomic, readonly) ShatteredSprite * sprite;

@end
