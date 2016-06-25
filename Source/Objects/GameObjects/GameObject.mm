//
//  GameObject.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 4/13/13.
//
//

#import "cocos2d.h"
#import "GameObject.h"

typedef enum{
    COL_ACTION_UNKNOWN,    
}CollisionAction;

typedef struct{
    CollisionAction action;
}CollisionActionStruct;

@implementation GameObject
    
@synthesize type = mType;
@synthesize gameRef = mGameRef;

-(id) init{
    self = [super init];
    
    _render = [[RenderComponent alloc] initWithEntity:self];
    
    return self;
}

-(CGRect) getTouchBox{
    CCLOG(@"OVERIDDE THIS! - getTouchBox GameObject");
    return CGRectMake(0,0,0,0);
}
//
//-(void) updateGameObject:(CCTime)delta{
//    CCLOG(@"OVERIDDE THIS! - update GameObject");
//}
//
//-(void) despawnObject{
////    CCLOG(@"OVERIDDE THIS! - despawn GameObject");
//}
//
////-(void) checkForCollisions{
////    CCLOG(@"OVERIDDE THIS! - checkForCollisions GameObject");
////}
//
//-(void) handleReceivedCollision: (id) sender{
//    CCLOG(@"OVERIDDE THIS! - handleReceivedCollision GameObject");
//}
//
-(void) setGameLayer:(GameLayer*) gameLayer{
    mGameRef = gameLayer;
}
//
//-(void) triggerSelfDestroy{
//    
//}
//
//-(void) disableStuffWhenOutOfScreen{
//    self.visible = NO;
//    mIsNotOnScreen = YES;
//}
//
//-(void) enableStuffWhenOutOfScreen{
//    self.visible = YES;
//    mIsNotOnScreen = NO;
//}

//#ifdef DEBUG
//-(void) visit{
//    [super visit];
//
////    [self drawRectangle:[self getTouchBox]:ccc4(125, 255, 125, 255)];
////    [self drawRectangle:[self getHitBox]:ccc4(255, 125, 255, 255)];
//}
//#endif


//-(void) drawRectangle:(CGRect) rect :(ccColor4B) color {
//    ccDrawColor4B(color.r, color.g, color.b, color.a);
//    ccDrawRect( ccp(rect.origin.x, rect.origin.y), ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height) );
//}

@end
