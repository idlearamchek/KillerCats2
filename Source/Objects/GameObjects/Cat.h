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
#import "types.h"


@interface Cat : GameObject{
}

-(id) initWithLane:(CatLane) lane speed:(float) speed;

@property (nonatomic, readonly) MoveComponent * moveComponent;
@property (nonatomic, readonly) ShatteredSprite * sprite;
@property (nonatomic, readonly) float speed;

@end
