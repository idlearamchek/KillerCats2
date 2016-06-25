//
//  Projectile.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 3/28/13.
//
//

#import "Projectile.h"
#import "GameLayer.h"
#import "Terrain.h"
#import "CCNode_anchor.h"
#import "PointTransformationIpad.h"
#import "PBRSounds.h"
#import "XZParticleSystem.h"
#import "Tools.h"

@implementation Projectile

@synthesize owner = mOwner;
//@synthesize isActive = mIsActive;
@synthesize mHasDisablingFailed, mIsDisabled;
@synthesize damageToDo = mDamageToDo;
@synthesize width = mWidth;
@synthesize sprite = mProjSprite;
@synthesize damageBonus = mDamageBonus;

//@synthesize hasAnimatedExplo = mHasAnimatedExplo;

#define PROJECTILE_Z 0
#define MAX_PROJ 200

#define PROJ_ANIM_AK47 @"proj_anim_ak47"
#define PROJ_ANIM_GRENADE @"proj_anim_grenade"
#define PROJ_ANIM_FIRE_GRENADE @"proj_anim_fire_grenade"
#define PROJ_ANIM_GATLING @"proj_anim_gatling"
#define PROJ_ANIM_FIREBALL @"proj_anim_fireball"
#define PROJ_ANIM_FIREBALLYELLOW @"proj_anim_fireballyellow"
#define PROJ_ANIM_FIREBALLBLUE @"proj_anim_fireballblue"
#define PROJ_ANIM_FIREBALLPURPLE @"proj_anim_fireballblue"
#define PROJ_ANIM_PLASMA_BALL @"proj_anim_plasma_ball"
#define PROJ_ANIM_STUNNER @"proj_anim_stunner"
#define PROJ_ANIM_LASER @"proj_anim_laser"
#define PROJ_ANIM_ROCKET @"proj_anim_rocket"
#define PROJ_ANIM_ROCKETMINI @"proj_anim_rocketmini"
#define PROJ_ANIM_TORPEDO @"proj_anim_torpedo"
#define PROJ_ANIM_MINE @"proj_anim_mine"
#define PROJ_ANIM_RAILGUN @"proj_anim_railgun"
#define PROJ_ANIM_RAILGUN2 @"proj_anim_railgun2"
#define PROJ_ANIM_RAILWAVE @"proj_anim_railwave"
#define PROJ_ANIM_GHOST @"proj_anim_ghost"
#define PROJ_ANIM_BOOMRANG @"proj_anim_boomrang"
#define PROJ_ANIM_BEAM @"proj_anim_beam"
#define PROJ_ANIM_BURST @"proj_anim_burst"
#define PROJ_ANIM_SMOKEPUFF @"proj_anim_smokepuff"
#define PROJ_ANIM_TOMAHAWK @"proj_anim_tomahawk"
#define PROJ_ANIM_SNAKE @"proj_anim_snake"
#define PROJ_ANIM_SNAKEFADE @"proj_anim_snakefade"

//static XZParticleSplash * particleSystemTest;


static NSMutableArray * allInactiveProjectile = nil;
static CCSpriteBatchNode * projBatchNode = nil;

+(void) PreloadWithBaseNode:(CCNode*) baseNode :(GameLayer*) gameLayer{
    if(projBatchNode == nil){
        [[CCTextureCache sharedTextureCache] addImage:@"boat.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"boat.plist"];
        
        CCSpriteFrame * spi = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bulletA.png"];
        projBatchNode = [[CCSpriteBatchNode alloc] initWithTexture:spi.texture capacity:MAX_PROJ];
        [baseNode addChild:projBatchNode z:PROJECTILE_Z];
        
//        particleSystemTest = [[XZParticleSplash alloc] initWithTotalParticles:40];
        
        [self loadAnimations];
    }
    
    [self CreateProjectileCache];
    
//    for (Projectile * proj in allInactiveProjectile) {
//        [proj setGameLayer:gameLayer];
//    }
}

+(void) CreateProjectileCache{
    if(allInactiveProjectile == nil){
        allInactiveProjectile = [[NSMutableArray alloc] initWithCapacity:MAX_PROJ];
        
        for(int i = 0; i< MAX_PROJ; i++){
            Projectile * proj = [[Projectile alloc] init];
            [allInactiveProjectile addObject:proj];
        }
    }
    else{
//        if(allInactiveProjectile.count < (MAX_PROJ - 0)){
//            CCLOG(@"allInactiveProjectile lost some proj! - create new ones?");
//        }
    }
}

+(BOOL) InsertProjectileToCache:(Projectile*) proj{
    if(![allInactiveProjectile containsObject:proj]){
        [allInactiveProjectile addObject:proj];
        return YES;
    }
    
    CCLOG(@"insert failed");
    return NO;
}

+(Projectile*) PopProjectileFromCache{
    Projectile* proj = nil;
    
    int count = (int)[allInactiveProjectile count];
    
    if(count > 0){
        proj = [allInactiveProjectile objectAtIndex:count-1];
    }
    
    if(proj)
        [allInactiveProjectile removeLastObject];
    
    return proj;
}

+(NSMutableArray *) GetAllProjectile{
    return allInactiveProjectile;
}

+(void) CleanBatchNode{
    [projBatchNode release];
    projBatchNode = nil;
}

+(CCSpriteBatchNode*) GetBatchNode{
    return projBatchNode;
}

-(id) init{
    self = [super init];
//    self = [super initWithSpriteFrameName:@"emptyPixel.png"];
    
    mProjSprite = [[CCSprite alloc] initWithSpriteFrameName:@"emptyPixel.png"]; //init bidon for spritebatchnode    
//    mExplosionAction = [[CCSequence actions:
//                         [CCFadeIn actionWithDuration:0.1f],
//                         [CCFadeOut actionWithDuration:0.1f],
//                         [CCCallFuncXZ actionWithTarget:self selector:@selector(explosionDone)],
//                         nil] retain];
    
//    mExplosion = [CCSprite spriteWithSpriteFrameName:@"smallExplosion.png"];
//    mExplosion.visible = NO;
//    mExplosion.scale = 1.0;
//    [mProjSprite addChild:mExplosion z:4];
            
    mType = GO_TYPE_PROJ;
    mHittableByProj = NO;
    
//    mIsActive = NO;
    mIsIncapacited = YES;
    mIsDisabled = NO;
    mHasDisablingFailed = NO;
    mOwner = nil;
    mIsExploading = NO;
    mHasHit = NO;
    mTargetDirection = ccp(1,1);
    mIsNotOnScreen = NO;
    return self;
}

// Add an end point to tell when the proj becomes inactive?
-(void) spawnWithType:(ProjectileType) type
                atPos:(CGPoint) pos
                withAnchor:(CGPoint)anchorInPos
                withTrajectory:(CGPoint) trajectory
                withManager: (GameLayer*) manager
                withOwner: (GameObject*) goOwner
             withLifetime: (float) lifetime
            withBaseDamage: (float) baseDamage
            withDamageBonus: (float) damageBonus
{
    mOwner = goOwner;
    mGameRef = manager;
    mLifeTime = lifetime;
    mLifeTimeBuffer = lifetime;
    
    //    mIsActive = YES;
    mIsIncapacited = NO;

//    mExplosion.visible = NO;
//    [mExplosion stopAllActions];

    mProjType = type;
    mTrajectory = trajectory;
    mTrajectoryBuffer = trajectory;
    
    //Reset
    CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"emptyPixel.png"];
    [mProjSprite setTextureRect:frame.rect];
    mProjSprite.opacity = 255;
    mProjSprite.position = pos;
    
    mDamageToDo = baseDamage*damageBonus;
    mDamageBonus = damageBonus;
//    mIsActive = [self getAnimationForType:type];
    mIsIncapacited = ![self getAnimationForType:type];

    mWidth = 4;
    mSpawnRate = -1;
        
    switch (mProjType) {
        case PROJ_TYPE_GATLING:
            break;
        case PROJ_TYPE_PISTOL:
        case PROJ_TYPE_AK47:
            break;
        case PROJ_TYPE_GRENADE:{
            if (baseDamage < 40 ){
                
                CCAnimate * exploAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:EXPLO_MEDIUM_ANIM]];
                mExplosionAction = [[CCSequence actions:exploAnim,
                                [CCCallBlock actionWithBlock:^(void){
                                    [self explosionDone];
                                }], nil] retain];
            }
            else{
                CCAnimate * exploAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:EXPLO_LARGE_ANIM]];
                mExplosionAction = [[CCSequence actions:exploAnim,
                                     [CCCallBlock actionWithBlock:^(void){
                    [self explosionDone];
                }], nil] retain];
            }

            mWidth = 12;
            break;
        }
        case PROJ_TYPE_STUNNER:
            mWidth = 0;
            break;
        case PROJ_TYPE_BOOMRANG:
            mWidth = 8;
            break;
        case PROJ_TYPE_BLASTER:
            mWidth = 10;
            break;
        case PROJ_TYPE_BEAM:
            mWidth = 4;
            break;
        case PROJ_TYPE_BURST:
            mWidth = 4;
            break;
        case PROJ_TYPE_WAVE:
            mWidth = 8;
            break;
        case PROJ_TYPE_PLASMA_BALL:
            mWidth = 12;
            break;
        case PROJ_TYPE_ROCKET:{
            if (baseDamage < 30 ){
                CCAnimate * exploAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:EXPLO_MEDIUM_ANIM]];
                mExplosionAction = [[CCSequence actions:exploAnim,
                                [CCCallBlock actionWithBlock:^(void){
                    [self explosionDone];
                }], nil] retain];
            }
            else{
                CCAnimate * exploAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:EXPLO_LARGE_ANIM]];
                mExplosionAction = [[CCSequence actions:exploAnim,
                                     [CCCallBlock actionWithBlock:^(void){
                    [self explosionDone];
                }], nil] retain];
            }
            
            //mSpawnRate = 0.05;
            
            mWidth = 16;
        }
            break;
        case PROJ_TYPE_TORPEDO:{
            if (baseDamage < 30 ){
                CCAnimate * exploAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:EXPLO_MEDIUM_ANIM]];
                mExplosionAction = [[CCSequence actions:exploAnim,
                                     [CCCallBlock actionWithBlock:^(void){
                    [self explosionDone];
                }], nil] retain];
            }
            else{
                CCAnimate * exploAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:EXPLO_LARGE_ANIM]];
                mExplosionAction = [[CCSequence actions:exploAnim,
                                     [CCCallBlock actionWithBlock:^(void){
                    [self explosionDone];
                }], nil] retain];
            }
            mWidth = 16;
        }
            break;
        case PROJ_TYPE_MINE:{
            CCAnimate * exploAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:EXPLO_LARGE_ANIM]];
            mExplosionAction = [[CCSequence actions:exploAnim,
                                [CCCallBlock actionWithBlock:^(void){
                [self explosionDone];
            }], nil] retain];
            mWidth = 16;
        }
            break;
        case PROJ_TYPE_RAILGUN:
            mWidth = 4;
            mSpawnRate = 0.1;
            break;
        default:
            break;
    }
    
    if(!mIsIncapacited){
        [projBatchNode addChild:mProjSprite];
        [mGameRef addProjectile:self :-1];
        [mProjSprite runAction:mProjAnim];
        
        if([GlobalSettings sharedInstance].lowEffects)
            mSpawnRate = -1;
        
        if(mSpawnRate > 0){
            if(!mIsNotOnScreen )
                [self schedule:@selector(spawnEffect) interval:mSpawnRate];
        }
    }
}

-(void) disableStuffWhenOutOfScreen{
    [super disableStuffWhenOutOfScreen];
    
    mProjSprite.visible = NO;
    if(mSpawnRate > 0)
        [self unschedule:@selector(spawnEffect)];
}

-(void) enableStuffWhenOutOfScreen{
    [super enableStuffWhenOutOfScreen];

    mProjSprite.visible = YES;

    if(mSpawnRate > 0)
        [self schedule:@selector(spawnEffect) interval:mSpawnRate];
}

-(BOOL) getAnimationForType:(ProjectileType) type{
    BOOL gotAnim = YES;
    
    [mProjAnim release];
    mProjAnim = nil;

    switch (mProjType) {
        case PROJ_TYPE_AK47:
            if (mDamageToDo < 5)
                mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_FIREBALLYELLOW]]];
            else
                mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_FIREBALLPURPLE]]];
            
            break;
        case PROJ_TYPE_PISTOL:
            
            if (mDamageToDo <= 10)
                mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_FIREBALL]]];
            else
                mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_FIREBALLBLUE]]];

            break;
            
        case PROJ_TYPE_GRENADE:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_FIRE_GRENADE]]];

            break;
            
        case PROJ_TYPE_GATLING:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_GATLING]]];
            
            break;
            
        case PROJ_TYPE_BURST:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_BURST]]];
            
            break;
            
        case PROJ_TYPE_STUNNER:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_STUNNER]]];
            break;
            
        case PROJ_TYPE_BOOMRANG:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_BOOMRANG]]];
            break;
            
        case PROJ_TYPE_BLASTER:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_GHOST]]];
            break;
            
        case PROJ_TYPE_BEAM:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_BEAM]]];
            break;
            
        case PROJ_TYPE_WAVE:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_TOMAHAWK]]];
            break;
            
        case PROJ_TYPE_LASER:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_LASER]]];
            break;
            
        case PROJ_TYPE_PLASMA_BALL:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_PLASMA_BALL]]];
            break;
            
        case PROJ_TYPE_ROCKET:
            if (mDamageToDo < 40)
                    mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_ROCKETMINI]]];
            else
                    mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_ROCKET]]];
            break;
        case PROJ_TYPE_TORPEDO:

                mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_TORPEDO]]];
            break;
        case PROJ_TYPE_MINE:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_MINE]]];
            break;
        case PROJ_TYPE_RAILGUN:
            mProjAnim = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_RAILGUN2]]];

            break;
        default:
            gotAnim = NO;
            break;
    }

    return gotAnim;
}

-(ProjectileType) getType{
    return mProjType;
}

-(void) setTargetDirection:(CGPoint)dir{
    mTargetDirection = dir;
}

-(void) markAsInactive{
    mIsIncapacited = YES;
}

-(void) despawnObject{
    mOwner = nil;

    [mProjAnim release];
    mProjAnim = nil;
    
    [mProjSprite removeFromParent];
    [self removeFromParent];
    
    [mExplosionAction release];
    mExplosionAction = nil;
    
    mIsIncapacited = YES;
    
    mHasDisablingFailed = NO;
    mIsDisabled = NO;
    mHasHit = NO;
    mIsExploading = NO;
    mIsNotOnScreen = NO;
    
    if(mSpawnRate > 0)
        [self unschedule:@selector(spawnEffect)];
    mSpawnRate = -1;
    
    [Projectile InsertProjectileToCache:self];
}

-(void) update:(ccTime) dt{
    if(!mIsIncapacited){
        //update
        if (mProjType == PROJ_TYPE_GRENADE ){
            mTrajectory.y -= ipadDouble(400.0f)*dt;
        }
        else if ( mProjType == PROJ_TYPE_MINE ){
            mTrajectory.y -= ipadDouble(400.0f)*dt;
            float y = [mGameRef getTerrainHeightAtX:self.sprite.position.x];
            if ( self.sprite.position.y < y )
            {
              mTrajectory.y += ipadDouble(800.0f)*dt;
                mTrajectory = ccpMult(mTrajectory,0.95f);
            }
        }
        else if (mProjType == PROJ_TYPE_BOOMRANG ){
            if (mLifeTime < mLifeTimeBuffer/1.7f && mTrajectory.x > -mTrajectoryBuffer.x/2.0f)
                mTrajectory = ccp(mTrajectory.x-mTrajectoryBuffer.x/10.0f,mTrajectory.y-mTrajectoryBuffer.y/10.0f);
            
            self.sprite.rotation += 30;
        }
        else if (mProjType == PROJ_TYPE_WAVE ){
            CGPoint dir = ccpNormalize(mTrajectory);

            mTrajectory = ccp(mTrajectoryBuffer.x +dir.y*(500.0f*sinf((mLifeTimeBuffer-mLifeTime)*12)),mTrajectoryBuffer.y + dir.x*(500.0f*sinf((mLifeTimeBuffer-mLifeTime)*10)));
            self.sprite.rotation += 30;
        }
        else if (mProjType == PROJ_TYPE_ROCKET ){
            CGPoint dir = ccpNormalize(ccp(mTargetDirection.x,mTargetDirection.y +ipadDouble(0) ));
            if (mIsDisabled)
                dir = ccp(-dir.x,-dir.y);
            
            mTrajectory = ccpAdd(mTrajectory, ipadDoubleCGpt(ccpMult(dir,28.0f)));
            float lgt = ccpLength(mTrajectory);
            if (lgt > ipadDouble(900.0f)){
                mTrajectory = ccpMult(mTrajectory,ipadDouble(900.0f)/lgt);
            }
            
            float angle = atan(mTrajectory .y/mTrajectory .x);
            self.sprite.rotation = -CC_RADIANS_TO_DEGREES(angle);
            
            if (mProjSprite.position.y < [mGameRef getTerrainHeightAtX:mProjSprite.position.x] -ipadDouble(5)){
                [self launchExplosion];
            }
        }
        else if (mProjType == PROJ_TYPE_TORPEDO ){
            CGPoint dir = ccpNormalize(mTargetDirection);
            if (mIsDisabled)
                dir = ccp(-dir.x,-dir.y);
            
            if (mProjSprite.position.y > [mGameRef getTerrainHeightAtX:mProjSprite.position.x]){
                mTrajectory = ccpAdd(mTrajectory, ipadDoubleCGpt(ccpMult(ccp(0,-1),15.0f)));
            }
            else{
                mTrajectory = ccpAdd(mTrajectory, ipadDoubleCGpt(ccpMult(dir,15.0f)));
                
                if (mTrajectory.y < -200)
                     mTrajectory = ccpAdd(mTrajectory, ipadDoubleCGpt(ccpMult(ccp(0,1),30.0f)));
                
                float angle = atan(mTrajectory .y/mTrajectory .x);
                self.sprite.rotation -= (self.sprite.rotation+CC_RADIANS_TO_DEGREES(angle))/10.0f;
            }
            
            float lgt = ccpLength(mTrajectory);
            if (lgt > ipadDouble(800.0f)){
                mTrajectory = ccpMult(mTrajectory,ipadDouble(800.0f)/lgt);
            }
        }
        
        //if (mProjSprite.opacity > 0 )
        mProjSprite.position = ccpAdd(mProjSprite.position, ccpMult(mTrajectory, dt));
        
        mLifeTime -= dt;
        if (mLifeTime <= 0 && mProjType != PROJ_TYPE_GRENADE && mProjType != PROJ_TYPE_ROCKET && mProjType != PROJ_TYPE_TORPEDO){
            mIsIncapacited = YES;
//            [self despawnObject];
        }
        else if ( mLifeTime <= 0 && !mIsExploading){
            [self launchExplosion];
        }
//        else
//            [self checkForCollisions];
    }
}

- (void) launchExplosion{
    if (!mHasHit && !mIsExploading){
        mIsExploading = YES;
        
        [mProjSprite stopAllActions];
        [mProjSprite runAction:mExplosionAction];
    }
}

-(void) spawnEffect {
    //non-optimized test

    if(mIsIncapacited || !mProjSprite.visible)
        [self unschedule:@selector(spawnEffect)];
    else{
        switch (mProjType) {
            case PROJ_TYPE_ROCKET:
            {
                CCSprite * sprite = [CCSprite spriteWithSpriteFrameName:@"emptyPixel.png"];
                [projBatchNode addChild:sprite];
                sprite.position = ccpAdd(mProjSprite.position,ccp(ipadDouble(20)*[Tools frandWithRange:-0.5 :0], ipadDouble(20)*[Tools frandWithRange:-0.25 :0.5]));
                sprite.scale = [Tools frandWithRange:0.5 :1];
                CCAnimate * puffAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_SMOKEPUFF]];
                
                CCAction * actAnim = [CCSequence actions:puffAnim,
                                      [CCCallBlock actionWithBlock:^(void){
                    [sprite removeFromParent];
                }], nil];
                
                [sprite runAction:actAnim];
                break;
            }
            case PROJ_TYPE_GRENADE:
            {
                CCSprite * sprite = [CCSprite spriteWithSpriteFrameName:@"emptyPixel.png"];
                [projBatchNode addChild:sprite];
                sprite.position = ccpAdd(mProjSprite.position, ccp(ipadDouble(10)*[Tools frandWithRange:-0.5 :0], ipadDouble(10)*[Tools frandWithRange:-0.25 :0.5]));
                sprite.scale = [Tools frandWithRange:0.5 :1];
                CCAnimate * puffAnim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_SMOKEPUFF]];
                
                CCAction * actAnim = [CCSequence actions:puffAnim,
                                      [CCCallBlock actionWithBlock:^(void){
                    [sprite removeFromParent];
                }], nil];
                
                [sprite runAction:actAnim];
                break;
            }
            case PROJ_TYPE_RAILGUN:
            {
                CCSprite * sprite = [CCSprite spriteWithSpriteFrameName:@"emptyPixel.png"];
                [projBatchNode addChild:sprite];
                sprite.position = mProjSprite.position;
                sprite.rotation = mProjSprite.rotation;
                CCAnimate * anim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_RAILWAVE]];
                
                CCAction * actAnim = [CCSequence actions:anim,
                                      [CCCallBlock actionWithBlock:^(void){
                    [sprite removeFromParent];
                }], nil];
                
                [sprite runAction:actAnim];
                break;
            }
            case PROJ_TYPE_WAVE:
            {
                CCSprite * sprite = [CCSprite spriteWithSpriteFrameName:@"emptyPixel.png"];
                [projBatchNode addChild:sprite];
                sprite.position = mProjSprite.position;
                sprite.rotation = mProjSprite.rotation;
                CCAnimate * anim = [CCAnimate actionWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_SNAKEFADE]];
                
                CCAction * actAnim = [CCSequence actions:anim,
                                      [CCCallBlock actionWithBlock:^(void){
                    [sprite removeFromParent];
                }], nil];
                
                [sprite runAction:actAnim];
                break;
            }
            default:
                break;
        }
    }
}

-(void) explosionDone{
    mIsIncapacited = YES;
//    [self despawnObject];
//
//    [mProjSprite stopAllActions];
//    mIsActive = NO;
//    mIsExploading = NO;
//    mHasHit = NO;
//    [self unschedule:@selector(spawnEffect)];
}

-(void) hasHit{
    mHasHit = YES;
}

-(BOOL) getHit{
    return mHasHit;
}

-(CGRect) getTouchBox{
    CGRect rect;
    
    if (mIsExploading){
        rect = CGRectMake(mProjSprite.position.x - 30,
                          mProjSprite.position.y - 30,
                          60,60);
    }
    else{
        rect = CGRectMake(mProjSprite.position.x - mProjSprite.contentSize.width/2,
                          mProjSprite.position.y - mProjSprite.contentSize.height/2,
                          mProjSprite.contentSize.width, mProjSprite.contentSize.height);
    }
    return rect;
}

+(void) loadAnimations{
    if(![[CCAnimationCache sharedAnimationCache] animationByName:PROJ_ANIM_AK47]){
        /*************** AK47 ANIMATION *******************/
        NSMutableArray * frames = [NSMutableArray array];

        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bulletA.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_AK47];
        
        /*************** FIREBALL ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireball_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireball_2.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_FIREBALL];

        
        /*************** FIREBALL YELLOW ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireballYellow_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireballYellow_2.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_FIREBALLYELLOW];
        
        /*************** FIREBALL BLUE ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireballBlue_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireballBlue_2.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_FIREBALLBLUE];
        
        /*************** FIREBALL PURPLE ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireballPurple_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireballPurple_2.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_FIREBALLPURPLE];
        
        /*************** GRENADE ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bulletB.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_GRENADE];

        /*************** FIRE GRENADE ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireGrenade_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireGrenade_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireGrenade_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fireGrenade_2.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_FIRE_GRENADE];

        
        /*************** PLASMA BALL ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"plasmaBall_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"plasmaBall_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"plasmaBall_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"plasmaBall_4.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"plasmaBall_5.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.1f] name:PROJ_ANIM_PLASMA_BALL];
     
        /*************** STUNNER ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"meduse_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"meduse_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"meduse_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"meduse_2.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.1f] name:PROJ_ANIM_STUNNER];

        /*************** LASER ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"laserBeam.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_LASER];

        /*************** ROCKET ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_4.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_5.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_6.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_7.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocket_8.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_ROCKET];
        
        /*************** ROCKET MINI ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketMini_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketMini_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketMini_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketMini_4.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketMini_5.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketMini_6.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketMini_7.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketMini_8.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_ROCKETMINI];
        
        /*************** TORPEDO ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"torpedo_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"torpedo_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"torpedo_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"torpedo_4.png"]];

        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_TORPEDO];

        /*************** ROCKET ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"mine.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_MINE];
        

        /*************** RAILGUN ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"railBullet_1.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_RAILGUN];

        /*************** RAILGUN 2 ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"railBullet_1.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_RAILGUN2];
        
        /*************** GATLING GUN ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gatling_bullet.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_GATLING];
        
        /*************** RAILWAVE ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rail_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rail_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rail_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rail_4.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rail_5.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rail_6.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rail_7.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.07f] name:PROJ_ANIM_RAILWAVE];
        
        /*************** GHOST ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ghost_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ghost_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ghost_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ghost_4.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ghost_5.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ghost_6.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ghost_7.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.1f] name:PROJ_ANIM_GHOST];
        
        /*************** BOOMRANG ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"boomrang_1.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_BOOMRANG];
        
        /*************** BEAM ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"beam_1.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_BEAM];
        
        /*************** BURST ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"beam_2.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_BURST];
        
        /*************** SMOKE PUFF ANIMATION *******************/
        [frames removeAllObjects];
        //[frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"smokepuff_1.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"smokepuff_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"smokepuff_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"smokepuff_4.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"smokepuff_5.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"smokepuff_6.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.1f] name:PROJ_ANIM_SMOKEPUFF];
        
        /*************** TOMAHAWK ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tomahwak.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_TOMAHAWK];
        
        /*************** SNAKE ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"snake_1.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.08f] name:PROJ_ANIM_SNAKE];
        
        /*************** SNAKE FADE ANIMATION *******************/
        [frames removeAllObjects];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"snake_2.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"snake_3.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"snake_4.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"snake_5.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.04f] name:PROJ_ANIM_SNAKEFADE];
    }
}

-(void) dealloc{
    [mExplosionAction release];
    [mProjAnim release];
    [mProjSprite release];

    [super dealloc];
}


@end
