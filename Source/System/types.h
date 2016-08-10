//
//  DRWAPStypes.h
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 6/2/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

//#import "SDCloudUserDefaults.h"

#import <mach/mach.h>
#import <mach/mach_time.h>

#define RANDOM_SIGN (rand() % 2 == 0 ? -1 : 1)

#define BUTTON_SELECTED_OPACITY 125

#define IS_ON_IPAD [GlobalSettings sharedInstance].isOnIpad
#define OUR_TILE_SIZE [GlobalSettings sharedInstance].TILE_SIZE

#define TUTO_BOAT_MONEY 50

#define ENUM_INC(e, cast) e = (cast) (((int)e) + 1)
#define ENUM_DEC(e, cast) e = (cast)(((int)e) - 1)

#ifdef ANDROID

#define START_PROFILING

#elif DEBUG
#define START_PROFILING                     \
mach_timebase_info_data_t in;             \
mach_timebase_info(&in);                  \
uint64_t s = mach_absolute_time();      \
uint64_t a;                             \
int millisec = 0;                           \

#else
#define START_PROFILING
#endif

#ifdef ANDROID

#define END_PROFILING(precision, txt, thresholdLog)


#elif DEBUG
#define END_PROFILING(precision, log, thresholdLog) \
a = mach_absolute_time() - s;      \
a *= in.numer;                                \
a /= in.denom;                                \
millisec = a/(1000 * precision);            \
if(millisec > thresholdLog)                         \
CCLOG(log, millisec);                           \
mach_timebase_info(&in);                  \
s = mach_absolute_time();      \

#else

#define END_PROFILING(precision, txt, thresholdLog)

#endif

#define SYNCHRONIZE_SAVE        \
@try {                          \
    [NSUserDefaults synchronize];\
}\
@catch (NSException *exception) {\
    CCLOG(@"Exception -- %@", exception.debugDescription);\
}\

#define NAME_DEFAULT @"player"

#define ICLOUD_TAG @"iCloud"

@protocol PBRMenuProtocol

-(void) hideMenu;
-(void) showMenu;
-(void) closeAndGoToParent;
//-(void) refreshMenu;
@end

@class CCLayer;
typedef CCLayer<PBRMenuProtocol> PBRMenuLayer;

@protocol ControlProtocol
-(void) setupControllerForLayer;
@end

typedef enum{
    G_MODE_UNKNOWN = 0,
    G_MODE_ARCADE,
    G_MODE_CREDIT,
}GameMode;

typedef enum{
    CAT_LANE_NONE = -1,
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



#define GL_BLEND_NO_TRANSPARENCY (ccBlendFunc){GL_ONE, GL_ZERO}
#define GL_BLEND_ADDITIVE (ccBlendFunc){GL_SRC_ALPHA, GL_ONE}

CG_INLINE CGRect 
CGRectFast(CGPoint origin, CGSize size){
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

typedef struct{
    CGPoint startPosition;
    CGPoint trajectorySpeed;
    CGRect collisionBox; //both hit and touch
    float rotation;
    BOOL isFlippedX;
    BOOL hasCollisions;
    BOOL canBounceBack;
    CGPoint scale;
}sProjectileInfos;

CG_INLINE sProjectileInfos
proj_make_default(CGPoint startPosition,
                  CGPoint trajectorySpeed,
                  CGRect collisionBox,
                  BOOL hasCollisions,
                  BOOL canBounceBack){
	sProjectileInfos s;
    
    s.startPosition = startPosition;
    s.trajectorySpeed = trajectorySpeed;
    s.collisionBox = collisionBox;
    s.rotation = 0;
    s.scale = CGPointMake(1,1);
    s.isFlippedX = NO;
    s.hasCollisions = hasCollisions;
    s.canBounceBack = canBounceBack;
	return s;
}

CG_INLINE sProjectileInfos
proj_make(CGPoint startPosition,
          CGPoint trajectorySpeed,
          CGRect collisionBox,
          float rotation,
          CGPoint scale,
          BOOL isFlippedX,
          BOOL hasCollisions,
          BOOL canBounceBack){
	sProjectileInfos s;
    
    s.startPosition = startPosition;
    s.trajectorySpeed = trajectorySpeed;
    s.collisionBox = collisionBox;
    s.rotation = rotation;
    s.scale = scale;
    s.isFlippedX = isFlippedX;
    s.hasCollisions = hasCollisions;
    s.canBounceBack = canBounceBack;
	return s;
}

typedef enum {
	P_FLAG_AIR = 0,
    P_FLAG_REWARD,
    P_FLAG_COIN,
    P_FLAG_AMMO,
    P_FLAG_M_AMMO,
    //P_FLAG_MAGNET,
    P_FLAG_SPEED,
    P_FLAG_DAMAGE,
    P_FLAG_SHIELD,
    P_FLAG_REPAIR,
    P_FLAG_ROCK,
	P_FLAG_MAX = 0xFF
} PhysicsFlags;


typedef struct {
    PhysicsFlags physFlag;
    //More infos eventualy?
}AnimInfo;

CG_INLINE AnimInfo
animInfo_Empty(){
	AnimInfo s;
	s.physFlag = P_FLAG_AIR;
    
	return s;
}

typedef struct{
    CGPoint pt;
    CGRect rect;
	PhysicsFlags physFlag;
//    AnimInfo animInfo;
}sTileCollisionInfos;

CG_INLINE sTileCollisionInfos
tci(CGPoint pt,
    CGRect rect,
    PhysicsFlags physFlag){
	sTileCollisionInfos s;
	memset(&s, 0, sizeof(s));
    
    s.pt = pt;
    s.rect = rect;
    s.physFlag = physFlag;
//    s.animInfo = animInfo;
	return s;
}

CG_INLINE sTileCollisionInfos
tci_Empty(){
	sTileCollisionInfos s;
	memset(&s, 0, sizeof(s));
	return s;
}

typedef enum{
    TAB_G_MODE_UNKNOWN = -1,
    TAB_G_MODE_ENDLESS,
    TAB_G_MODE_STORY,
    TAB_G_MODE_DIFFSELECTION,
    TAB_G_MODE_COUNT
}GameModeTab;

typedef enum{
    G_DIFF_UNKNOWN = -1,
    G_DIFF_EASY,
    G_DIFF_NORMAL,
    G_DIFF_HARD,
    G_DIFF_COUNT
}GameDifficulty;

typedef struct{
    BOOL isUnlocked;
}LevelUnlockInfos;

typedef enum{
    PROFILE_UNKNOWN = -1,
    PROFILE_1,
    PROFILE_2,
    PROFILE_3,
    PROFILE_MAX,
}ProfileSlot;

@protocol SceneBackProtocol <NSObject>
-(void) androidBackButton;
@end


