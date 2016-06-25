//
//  Projectile.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 3/28/13.
//
//

#import "cocos2d.h"
#import "Hero.h"
#import "PBRTypes.h"

@interface Projectile : GameObject{
    int mDamageToDo;
    int mWidth;
    
    float mDamageBonus;
    
//    BOOL mIsActive;
    CGPoint mTrajectory;
    CGPoint mTrajectoryBuffer;
    CGPoint mTargetDirection;
    ProjectileType mProjType;
    float mLifeTime;
    float mLifeTimeBuffer;
    BOOL mIsExploading;
    BOOL mHasHit;
    BOOL mIsDisabled;
    BOOL mHasDisablingFailed;

    CCSequence * mExplosionAction;
    CCSprite * mProjSprite;
    CCAction * mProjAnim;
    
    GameObject * mOwner;
    
    float mSpawnRate;
}

//@property (nonatomic, readonly) BOOL isActive;
@property (nonatomic, readwrite) BOOL mIsDisabled;
@property (nonatomic, readwrite) BOOL mHasDisablingFailed;
@property (nonatomic, readwrite) int damageToDo;
@property (nonatomic, readonly) float damageBonus;
@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) GameObject * owner;
@property (nonatomic, readonly) CCSprite * sprite;

//@property (nonatomic, readwrite) BOOL hasAnimatedExplo;

+(void) PreloadWithBaseNode:(CCNode*) baseNode :(GameLayer*) gameLayer;
+(void) CreateProjectileCache;


+(CCSpriteBatchNode*) GetBatchNode;
+(void) CleanBatchNode;

+(NSMutableArray *) GetAllProjectile;
+(BOOL) InsertProjectileToCache:(Projectile*) proj;
+(Projectile*) PopProjectileFromCache;

-(void) spawnWithType:(ProjectileType) type
                atPos:(CGPoint) pos
           withAnchor:(CGPoint)anchorInPos
       withTrajectory:(CGPoint) trajectory
          withManager: (GameLayer*) manager
            withOwner: (GameObject*) owner
         withLifetime: (float) lifetime
       withBaseDamage: (float) baseDamage
      withDamageBonus: (float) damageBonus;

-(ProjectileType) getType;
-(void) hasHit;
- (void) launchExplosion;
-(BOOL) getHit;
-(void) setTargetDirection:(CGPoint)dir;
-(void) markAsInactive;
@end
