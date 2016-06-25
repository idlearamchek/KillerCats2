//
//  Navig2DContainer.h
//  Don't Run With a Plasma Sword
//
//  Created by Ghislain Bernier on 12/20/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "cocos2d.h"
#import "CCProtocols.h"


@protocol NavigColorProtocol <NSObject>

-(void) colorPerimeter:(BOOL) isSelected;
@end

@class PBRWindow;

typedef struct{
    int x;
    int y;
}CGIntPoint;

CG_INLINE CGIntPoint ccpInt(int x, int y){
    CGIntPoint pt;
    pt.x = x;
    pt.y = y;
    return pt;
}

@interface Navig2DMenuContainer : NSObject {
    CGSize mMatrixSize;
    CGIntPoint mCurrentPosition;
//    void*
//    id ** mMatrix;
    BOOL mLoopBack;
    
    float mOriginScale;
    
    CGSize mCurrentMovement;
    
    NSMutableArray * mArrayOfArrays;
    
    ccColor3B mFocusColor;
}

-(id) initWithArray:(NSArray*)arrayOfArrays :(BOOL)loopBack;

-(id) initWithSize:(CGSize)matrixSize :(BOOL)loopBack;
-(void) populateContainer:(NSArray*)array;
-(id) ptrAtCurrentPos;

-(void) activate;

-(id) moveUpAndColor;
-(id) moveDownAndColor;
-(id) moveLeftAndColor;
-(id) moveRightAndColor;

-(id) moveUpAndColor:(BOOL) willColor;
-(id) moveDownAndColor:(BOOL) willColor;
-(id) moveLeftAndColor:(BOOL) willColor;
-(id) moveRightAndColor:(BOOL) willColor;

-(void) colorCurrentSelection;
//-(void) colorPerimeter:(id) item :(BOOL) isSelected;
//-(void) colorPBRWindowCorners:(PBRWindow*) window :(BOOL) isSelected;

-(void) selectCurrent;
-(void) unselectCurrent;
-(BOOL) selectItem:(id) item;

-(void) setPosition:(CGPoint)pt;

-(void) clearColors;

-(void) setFocusColor:(ccColor3B) color;

-(void) free;

@property (nonatomic, readonly) CGSize matrixSize;
@property (nonatomic, readonly) CGIntPoint currentPosition;
@end
