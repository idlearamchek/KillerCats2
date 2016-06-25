//
//
//  Created by Sergey Tikhonov http://haqu.net
//  Released under the MIT License
//

#import "cocos2d.h"
#import "GameObject.h"
#import "HudLayer.h"
#import "Hero.h"

@class Sky;

@interface GameLayer : CCNode{
    
    int mTouchActive;
}

@property (nonatomic, readonly) CGSize winSize;
@property (nonatomic, readonly) CGPoint touchBeganPos;
@property (nonatomic, readonly) Sky * sky;
@property (nonatomic, readonly) Hero * hero;
@property (nonatomic, readonly) NSMutableArray<GameObject*> * gameObjectArray;
@property (nonatomic, readonly) GKComponentSystem * moveComponentSystem;

@property (nonatomic, readonly) GKStateMachine * gameState;
@property (nonatomic, readonly, unsafe_unretained) HudLayer * hudLayerRef;
@property (nonatomic, readonly) float timePlayed;


@property (nonatomic, readwrite) float spawnTimer;

+ (CCScene*) scene;

-(id) initWithHud:(HudLayer*) hudLayer;

-(void) addGameObject:(GameObject*) obj;
-(void) addGameObject:(GameObject*) obj :(NSUInteger) z;

-(void) removeGameObject:(GameObject*) obj;
-(NSMutableArray*) getGameObjectArray;
-(void) restart :(BOOL) isFirstGame;

-(void) pauseLayer;
-(void) resumeLayer;
-(BOOL) isAtMaxHP;

-(void) changeState:(Class) state;

@end





/// GAME STATES

@interface PreGameState : GKState

-(id) initWithGameRef:(GameLayer*) layer;
@property (readonly, weak) GameLayer * gameRef;
@end

@interface GameStartedState : GKState
-(id) initWithGameRef:(GameLayer*) layer;

@property (readonly, weak) GameLayer * gameRef;
@end

@interface GamePausedState : GKState

-(id) initWithGameRef:(GameLayer*) layer;
@property (readonly, weak) GameLayer * gameRef;
@end

@interface GameOverState : GKState
-(id) initWithGameRef:(GameLayer*) layer;

@property (readonly, weak) GameLayer * gameRef;
@end

