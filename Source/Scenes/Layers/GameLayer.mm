//
//
//  Created by Sergey Tikhonov http://haqu.net
//  Released under the MIT License
//

#import "GameLayer.h"
#import "Sky.h"
#import "ProfileSettings.h"
#import "AppDelegate.h"
#import "StatsManager.h"
#import "CCNode_private.h"
#import "XZSound.h"
#import "Tools3.h"
#import "SceneGame.h"
#import "Cat.h"
#import "RenderComponent.h"

@implementation GameLayer

+(void) preloadTextures{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameplay.plist"];
}

+ (CCScene*) scene {
	CCScene *scene = [CCScene node];
	[scene addChild:[GameLayer node]];
	return scene;
}

- (id) initWithHud:(HudLayer*) hudLayer {
    [GameLayer preloadTextures];
    
    self = [super init];

    _winSize = [[CCDirector sharedDirector] viewSize];
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
    self.contentSize = _winSize;
    
    _gameState = [GKStateMachine stateMachineWithStates:@[[[PreGameState alloc] initWithGameRef:self],
                                                          [[GameStartedState alloc] initWithGameRef:self],
                                                          [[GamePausedState alloc] initWithGameRef:self],
                                                          [[GameOverState alloc] initWithGameRef:self]]];
    
    [_gameState enterState:[PreGameState class]];
    
    _gameObjectArray = [[NSMutableArray alloc] init];

    _moveComponentSystem = [[GKComponentSystem alloc] initWithComponentClass:[MoveComponent class]];
    
    [self createGameWithSettings:[ProfileSettings sharedInstance].currentGameSettings];
    
    _hudLayerRef = hudLayer;
    _hudLayerRef.gameRef = self;
    [_hudLayerRef createWithGameSettings:[ProfileSettings sharedInstance].currentGameSettings];

    for (int i = 0; i < CAT_LANE_MAX; i++) {
        mSpawnInfos[i].spawnTime = 1.5;
        mSpawnInfos[i].lastCat = nil;
    }
    
    //Force 1 update to remove flicker due to scaling sky
    [self update:0];
    
	return self;
}

-(void) createGameWithSettings:(GameSettings) gameSettings{
//    switch (gameSettings.gamemode) {
//            case G_MODE_ARCADE:
//            break;
//        default:
//            CCLOG(@"UNKNOWN GAMEMODE");
//            break;
//    }

    _sky = [[Sky alloc] init];
    [self addChild:_sky z:0];
    
    _hero = [[Hero alloc] initWithMaxHp:1];
    [self addGameObject:_hero :1];
    
    _gameSpeed = 25.0f;
    _spawnDelay = 0.8f;
}

-(void) addGameObject:(GameObject*) obj :(NSUInteger) z{
    GKComponent * moveComp = [obj componentForClass:[MoveComponent class]];
    if(moveComp) [_moveComponentSystem addComponent:moveComp];
    
    [obj setGameLayer:self];
    [_sky addChild:obj.render.node z:z];
    [_gameObjectArray addObject:obj];
}

-(void) addGameObject:(GameObject*) obj :(NSUInteger) z withParent:(CCNode*) parentNode{
    [obj setGameLayer:self];
    [parentNode addChild:obj.render.node z:z];
    [_gameObjectArray addObject:obj];
}

-(void) addGameObject:(GameObject*) obj{
    [self addGameObject:obj :0];
}

-(void) removeGameObject:(GameObject*) obj{
    [obj.render.node removeFromParent];
    [_gameObjectArray removeObject:obj];
}

-(NSMutableArray*) getGameObjectArray{
    return _gameObjectArray;
}

-(void) gameOver{
    [[OALSimpleAudio sharedInstance] setBgPaused:YES];

    [_hudLayerRef launchGameOver];

    [_hero explode];
    
    [[StatsManager shared] updateStatsAfterGame];
    [[StatsManager shared] updateScoreAfterEndGame];
    [[StatsManager shared] resetForNewGame];
}

-(void) restart :(BOOL) isFirstGame{
    [[CCDirector sharedDirector] replaceScene:[SceneGame scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void) tryChangingTrack{
    //40% chance to change track
    int random = rand() % 100;
    if(random <= 40){
        NSString * song = MUSIC_TRACK1;
        
        if([XZSound isCurrentlyPlaying:song])
            song = MUSIC_TRACK2;
        
        [[XZSound sharedInstance] playBg:song loop:YES];
    }
}

-(void) pauseLayer{
    self.userInteractionEnabled = NO;
    
    [self setPaused:YES];
    
    for (id child in self.children) {
        if([child isKindOfClass:[CCNode class]]){
            CCNode * node = (CCNode *)child;
            
            [node setPaused:YES];
        }
    }
}

-(void) resumeLayer{
    self.userInteractionEnabled = YES;

    [self setPaused:NO];

    for (id child in self.children) {
        if([child isKindOfClass:[CCNode class]]){
            CCNode * node = (CCNode *)child;
            
            [node setPaused:NO];
        }
    }
    
    [self changeState:[GameStartedState class]];
}

-(void) updateGameObject:(CCTime) dt{
    for(int i = 0; i< _gameObjectArray.count; i++){
        GameObject * obj = [_gameObjectArray objectAtIndex:i];
        
        [obj updateWithDeltaTime:dt];
    }
}

-(BOOL) touchBeganAt:(CGPoint)location :(UITouch *)touch{
    BOOL hasHandled = NO;
    
    
    _touchBeganPos = location;
    mTouchActive++;
    
    return hasHandled;
}

-(BOOL) touchEndedAt:(CGPoint)location :(UITouch *)touch{
//    CGPoint diffPos = ccpSub(location, _touchBeganPos);
    
    if([_gameState.currentState isKindOfClass:[PreGameState class]]){
        [_gameState enterState:[GameStartedState class]];
    }
    else if([_gameState.currentState isKindOfClass:[GameStartedState class]]){
        if(location.x > _winSize.width/2){
            [_hero moveRight];
        }
        else{
            [_hero moveLeft];
        }
    }
    else if([_gameState.currentState isKindOfClass:[GameOverState class]]){
        
        if(location.y > _winSize.height/2)
            [[CCDirector sharedDirector] replaceScene:[SceneGame scene]];
    }
    
	return YES;
}
    
-(void) screenShakeTest{
    [self stopAllActions];
    self.position = ccp(0,0);
    CCActionSequence * screenShakeSeq = [CCActionSequence actions:[CCActionEaseIn actionWithAction:[CCActionMoveTo actionWithDuration:0.02 position:ccp(-2, 0)]],
                                                        [CCActionEaseIn actionWithAction:[CCActionMoveTo actionWithDuration:0.02 position:ccp(0, 0)]],
                                                        [CCActionEaseIn actionWithAction:[CCActionMoveTo actionWithDuration:0.02 position:ccp(2, 0)]],
                                                        [CCActionEaseIn actionWithAction:[CCActionMoveTo actionWithDuration:0.02 position:ccp(0, 0)]], nil];

    CCAction * screenShake = [CCActionRepeat actionWithAction:screenShakeSeq times:8];
    [self runAction:screenShake];
}

-(void) clearGameObjects{
    for (GameObject * obj in _gameObjectArray) {
        [_sky removeChild:obj.render.node cleanup:NO];
//        [obj despawnObject];
    }
    
    [_gameObjectArray removeAllObjects];
}
  

- (void) update:(CCTime)dt {
    if(dt > 0.05f)
        dt = 0.05f;
    
    _timePlayed += dt;
    
    [_gameState updateWithDeltaTime:dt];
}


-(NSMutableArray*) getRandomLaneOrder{
    NSMutableArray * adjCatLanes = [NSMutableArray array];
    
    for (CatLane lane = CAT_LANE_1; lane < CAT_LANE_MAX; ENUM_INC(lane, CatLane)) {

        if(arc4random() % 2 == 0){
            [adjCatLanes addObject:@(lane)];
        }
        else{
            [adjCatLanes insertObject:@(lane) atIndex:0];
        }
    }

//    switch (catLane) {
//        case CAT_LANE_1:
//            adjCatLanes = @[@(CAT_LANE_2)];
//            break;
//        case CAT_LANE_2:
//            adjCatLanes = rand() % 2 == 0 ? @[@(CAT_LANE_1), @(CAT_LANE_3)] : @[@(CAT_LANE_3), @(CAT_LANE_1)];
//            break;
//        case CAT_LANE_3:
//            adjCatLanes = rand() % 2 == 0 ? @[@(CAT_LANE_2), @(CAT_LANE_4)] : @[@(CAT_LANE_4), @(CAT_LANE_2)];
//            break;
//        case CAT_LANE_4:
//            adjCatLanes = @[@(CAT_LANE_3)];
//            break;
//            
//        default:
//            break;
//    }
    
    return adjCatLanes;
}

-(NSArray*) getAdjLaneFrom:(CatLane) lane{
    NSArray * adjCatLanes = nil;

        switch (lane) {
            case CAT_LANE_1:
                adjCatLanes = @[@(CAT_LANE_2)];
                break;
            case CAT_LANE_2:
                adjCatLanes = rand() % 2 == 0 ? @[@(CAT_LANE_1), @(CAT_LANE_3)] : @[@(CAT_LANE_3), @(CAT_LANE_1)];
                break;
            case CAT_LANE_3:
                adjCatLanes = rand() % 2 == 0 ? @[@(CAT_LANE_2), @(CAT_LANE_4)] : @[@(CAT_LANE_4), @(CAT_LANE_2)];
                break;
            case CAT_LANE_4:
                adjCatLanes = @[@(CAT_LANE_3)];
                break;
    
            default:
                break;
        }
    
    return adjCatLanes;
}

-(void) handleSpawn:(NSTimeInterval) dt{
    _gameSpeed += dt * 1.1;
    
    _spawnTimer -= dt;
    
    if(_spawnTimer <= 0){
        _spawnTimer = _spawnDelay;
        _spawnDelay -= 0.005;
        if(_spawnDelay < 0)
            _spawnDelay = 0;
        
        //temp
        float catHeight = 60;
        float hamsterHeight = 60;

        float spawnPos = _winSize.height - 10;
        
        NSMutableArray * lanesToCheck = [self getRandomLaneOrder];
        NSMutableArray * lanesWhereSpawnIsPossible = [NSMutableArray array];
        
        for (NSNumber * nbLane in lanesToCheck) {
            CatLane catLane = (CatLane)[nbLane intValue];
            
            Cat * lastCat = mSpawnInfos[[nbLane intValue]].lastCat;
            if(lastCat && lastCat.render.node.parent == nil){ //cat is dead
                mSpawnInfos[[nbLane intValue]].lastCat = nil;
            }
            
            if(lastCat == nil){
                [lanesWhereSpawnIsPossible addObject:@([nbLane intValue])];
            }
            else{
                BOOL isAdjBlocked = YES;

                CGPoint norm = ccpNormalize(lastCat.moveComponent.direction);
                float diff = spawnPos - lastCat.render.node.position.y;
                
                float diffSpeed = _gameSpeed/lastCat.speed;
                
                if(diff > (catHeight + hamsterHeight) * fabs(norm.y) * diffSpeed){
                    NSArray * adjArray = [self getAdjLaneFrom:catLane];

                    for (NSNumber * nbAdjLane in adjArray) {
                        CatLane adjLane = (CatLane)[nbAdjLane intValue];
                        
                        Cat * adjLastCat = mSpawnInfos[adjLane].lastCat;

                        if(adjLastCat){
                            float adjDiffSpeed = _gameSpeed/adjLastCat.speed;
                            CGPoint adjNorm = ccpNormalize(adjLastCat.moveComponent.direction);
                            float adjDiff = spawnPos - adjLastCat.render.node.position.y;
                            
                            if(adjDiff > (catHeight + hamsterHeight) * fabs(adjNorm.y) * adjDiffSpeed){
                                isAdjBlocked = NO;
                            }
                        }
                        else
                            isAdjBlocked = NO;
                        
                        if(!isAdjBlocked)
                            break;
                    }
                    
                    if(!isAdjBlocked){
                        // hamster can move freely here
                        [lanesWhereSpawnIsPossible addObject:@(catLane)];
                    }
                }
            }
        }
        

        if([lanesWhereSpawnIsPossible count] > 1){
            CatLane spawnLane = (CatLane)[[lanesWhereSpawnIsPossible objectAtIndex:[Tools randWithRange:0 :(int)[lanesWhereSpawnIsPossible count]]] intValue];
            
            Cat * newCat = [[Cat alloc] initWithLane:spawnLane speed:_gameSpeed];
            [self addGameObject:newCat];
            mSpawnInfos[spawnLane].lastCat = newCat;
        }
    }
}

-(BOOL) isAtMaxHP{
    BOOL isMax = NO;
    
    if (_hero.hp == _hero.maxHp)
        isMax = YES;
    
    return isMax;
}

-(void) changeState:(Class) state{
    [_gameState enterState:state];
}

#pragma mark -
#pragma mark touches
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
   
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    [self touchBeganAt:location :touch];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
//    //tentative to go around the input misses bug (acceleration stuck).
//    //on iPad, touch begin events are lost when draging from outside the screen on one side.
//    //this conditions makes sure not to be able to cheat on lights start
//    if(mIsGameStarted){
//        [self touchBeganAt:location: touch];
//    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    [self touchEndedAt:location:(UITouch *)touch];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
//    if(event.type == UIEventTypeTouches && event.subtype == UIEventSubtypeNone)
    [self touchEndedAt:location:(UITouch *)touch];
    
//    CCLOG(@"Touch cancelled type : %d, subtype :%d", event.type, event.subtype);
}
    
#endif
    
@end
    
    
    
    
@implementation PreGameState
    
-(id) initWithGameRef:(GameLayer*) layer{
    self = [super init];
    
    _gameRef = layer;
    
    return self;
}
    
-(BOOL) isValidNextState:(Class)stateClass{
    return stateClass == [GameStartedState class];
}

-(void) updateWithDeltaTime:(NSTimeInterval) dt{
    
}

@end

@implementation GameStartedState

-(id) initWithGameRef:(GameLayer*) layer{
    self = [super init];
    _gameRef = layer;
    
    return self;
}

-(BOOL) isValidNextState:(Class)stateClass{
    return stateClass == [GamePausedState class] || stateClass == [GameOverState class];
}

-(void) updateWithDeltaTime:(NSTimeInterval) dt{
    [_gameRef.moveComponentSystem updateWithDeltaTime:dt];
    
    [_gameRef updateGameObject:dt];
    
    [_gameRef handleSpawn:dt];
    
    [_gameRef.sky updateManual:dt];
    
    if (_gameRef.hero.hp <= 0)
        [_gameRef.gameState enterState:[GameOverState class]];
}

- (void)didEnterWithPreviousState:(nullable GKState *)previousState{
    
}

@end

@implementation GamePausedState
-(id) initWithGameRef:(GameLayer*) layer{
    self = [super init];
    _gameRef = layer;
    
    return self;
}

-(BOOL) isValidNextState:(Class)stateClass{
    return stateClass == [GameStartedState class];
}

- (void)didEnterWithPreviousState:(nullable GKState *)previousState{
    [_gameRef.hudLayerRef.pauseLayer onPauseButton:self :YES];
}

@end

@implementation GameOverState
-(id) initWithGameRef:(GameLayer*) layer{
    self = [super init];
    _gameRef = layer;

    return self;
}

-(BOOL) isValidNextState:(Class)stateClass{
    return NO; //stateClass == [GameStartedState class];
}

- (void)didEnterWithPreviousState:(nullable GKState *)previousState{
    [_gameRef gameOver];
}

-(void) updateWithDeltaTime:(NSTimeInterval) dt{
    
}


@end
