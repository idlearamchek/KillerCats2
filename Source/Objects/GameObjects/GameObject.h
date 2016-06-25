//
//  GameObject.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 4/13/13.
//
//

#import "CCSprite.h"
#import <GameplayKit/GameplayKit.h>
#import "RenderComponent.h"

@protocol GameObjectProtocol <NSObject>
-(CGRect) getTouchBox;
-(void) updateGameObject:(CCTime)delta;
-(void) despawnObject;
-(void) handleReceivedCollision: (id) sender;
-(void) disableStuffWhenOutOfScreen;
-(void) enableStuffWhenOutOfScreen;

@end

typedef enum{
    GO_TYPE_UNKNOWN,
    GO_TYPE_HERO,
    GO_TYPE_CAT,
    
}GameObjectType;

@class GameLayer;

@interface GameObject : GKEntity<GameObjectProtocol>{
    GameObjectType mType;
    __unsafe_unretained GameLayer * mGameRef;
}

@property (nonatomic, readonly) RenderComponent * render;
@property (nonatomic, readonly) GameObjectType type;
@property (nonatomic, readonly) GameLayer * gameRef;
//@property (nonatomic, readonly) BOOL hittableByProj; //optimisation
@property (nonatomic, readwrite) BOOL isIncapacitated;
//@property (nonatomic, readonly) BOOL isNotOnScreen;
//@property (nonatomic, readonly) GKEntity * entity;


-(void) setGameLayer:(GameLayer*) gameLayer;
//-(void) triggerSelfDestroy;

@end
