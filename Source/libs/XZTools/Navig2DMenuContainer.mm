//
//  Navig2DContainer.mm
//  Don't Run With a Plasma Sword
//
//  Created by Ghislain Bernier on 12/20/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "Navig2DMenuContainer.h"
#import "XZWindow.h"
#import "CCControlSubclass.h"

//#import "PBRColor.h"
//#import "PBRSlot.h"
//#import "PBRSlotEquipment.h"

typedef enum{
    MOVE_LEFT,
    MOVE_RIGHT,
    MOVE_UP,
    MOVE_DOWN,
}MoveDirection;

#define NORMAL_SCALE 1
#define SELECTED_SCALE 1.05f

@implementation Navig2DMenuContainer

@synthesize matrixSize = mMatrixSize;
@synthesize currentPosition = mCurrentPosition;

                                            //loopBack means that after going to the max position in x or y, the position goes back to 0
-(id) initWithSize:(CGSize)matrixSize :(BOOL)loopBack{
    self = [super init];
        
//    mMatrixSize = matrixSize;
//    mMatrix = (id **)malloc(sizeof(id) * matrixSize.width);
//    
//    for(int i = 0; i < matrixSize.width; i++){
//        mMatrix[i] = (id *)malloc(sizeof(id) * matrixSize.height);
//    }
//    
//    mCurrentPosition = ccpInt(0,0);
//    mLoopBack = loopBack;
    
    return self;
}

-(id) initWithArray:(NSArray*)arrayOfArrays :(BOOL)loopBack{
    self = [super init];
    
    int rows = [arrayOfArrays count];
    int column = [arrayOfArrays[0] count];
    
    mMatrixSize = CGSizeMake(column, rows);
        
    mArrayOfArrays = [NSMutableArray arrayWithArray:arrayOfArrays];
    
    mCurrentPosition = ccpInt(0,0);
    mLoopBack = loopBack;
    
    [self scaleArraysOrArray:mArrayOfArrays];
    
    mFocusColor = ccWHITE;
    
    return self;
}

-(void) scaleArraysOrArray:(NSArray*)arrayOfArrays{
    for (NSArray * arrayRow in arrayOfArrays) {
        for (id objColumn in arrayRow) {
            
            if([objColumn respondsToSelector:@selector(scale)]){
//            if([objColumn isKindOfClass:[CCMenuItemSprite class]] || [objColumn isKindOfClass:[PBRWindow class]]
//               || [objColumn isKindOfClass:[PBRColor class]] || [objColumn isKindOfClass:[PBRSlotEquipment class]]){
                //Only supports 1 scale atm
                mOriginScale = ((CCNode*)objColumn).scale;
                break;
            }
        }
    }
}

//Array should be constructed by appending rows.   row0-rows1-rows2-rows3...
-(void) populateContainer:(NSArray*)array{
//    NSAssert([array count] == mMatrixSize.width * mMatrixSize.height, @"array and matrix needs to have the same amount of data");
//    
//    for(int i = 0; i< mMatrixSize.height; i++){
//        for(int j = 0; j< mMatrixSize.width; j++){
//            
//            id obj = [array objectAtIndex:(i*mMatrixSize.width)+j];
//            
//            if([obj isKindOfClass:[CCMenuItemSprite class]] || [obj isKindOfClass:[PBRWindow class]]){
//                //Only supports 1 scale atm
//                mOriginScale = ((CCNode*)obj).scale;
//
//                mMatrix[j][i] = obj;
//            }
//            else{
//                CCLOG(@"Navig only supports CCMenuItem");
//            }
//        }
//    }
}

-(id) ptrAtCurrentPos{
    if(mArrayOfArrays &&
       mCurrentPosition.y < [mArrayOfArrays count] &&
       mCurrentPosition.x < [mArrayOfArrays[mCurrentPosition.y] count]){
        return (id) mArrayOfArrays[mCurrentPosition.y][mCurrentPosition.x];
    }
    else
        return nil;
//
//    if(mArrayOfArrays)
//        return (id) mArrayOfArrays[mCurrentPosition.y][mCurrentPosition.x];
//    else
//        return nil;
}

-(void) setPosition:(CGPoint)pt{
    int maxY = [mArrayOfArrays count];

    if(pt.x < 0)
        pt.x = 0;
    if(pt.y < 0)
        pt.y = 0;

    if(pt.y >= maxY)
        pt.y = maxY - 1;

    int maxX = [mArrayOfArrays[(int)pt.y] count];
    
    if(pt.x >= maxX)
        pt.x = maxX - 1;

    mCurrentPosition = ccpInt((int)pt.x, (int)pt.y);
}

-(BOOL) isCurrentPosValid{
    BOOL isValid = NO;
    
    @try {

        id objAt = nil;

        if(mArrayOfArrays &&
           mCurrentPosition.y < [mArrayOfArrays count] &&
           mCurrentPosition.x < [mArrayOfArrays[mCurrentPosition.y] count]){
            objAt = mArrayOfArrays[mCurrentPosition.y][mCurrentPosition.x];
        }

//        if([objAt conformsToProtocol:@protocol(XZNavigProtocol)]){
//            if([objAt isEnabled] && [objAt visible])
//                isValid = YES;
//        }
//        else
        if([objAt isKindOfClass:[CCNode class]]){
            isValid = [((CCNode*)objAt) visible];
        }
    }
    @catch (NSException *exception) {
    }
    
    return isValid;
}

-(void) executeLeft{
    mCurrentPosition.x--;
    if(mCurrentPosition.x < 0){
        if(mLoopBack)
            mCurrentPosition.x = mMatrixSize.width-1;
        else
            mCurrentPosition.x = 0;
    }
}

-(void) moveDirection:(MoveDirection) direction{
    mCurrentMovement = CGSizeZero;
    id objBeforeMove = nil;
    id objBeforeAfter = nil;
    
    do{
        objBeforeMove = [self ptrAtCurrentPos];
        
        switch (direction) {
            case MOVE_LEFT:
                [self executeLeft];
                mCurrentMovement.width++;
                break;
            case MOVE_RIGHT:
                [self executeRight];
                mCurrentMovement.width++;
                break;
            case MOVE_UP:
                [self executeUp];
                mCurrentMovement.height++;
                break;
            case MOVE_DOWN:
                [self executeDown];
                mCurrentMovement.height++;
                break;
                
            default:
                break;
        }
        
        objBeforeAfter = [self ptrAtCurrentPos];
        
        if(!mLoopBack && objBeforeAfter == nil){
            //Reset movement and select previous item
            mCurrentMovement = CGSizeZero;
            [self selectItem:objBeforeMove];
            
            break;
        }

        
    }while (((objBeforeAfter == nil || ![self isCurrentPosValid] || objBeforeMove == objBeforeAfter) &&
             (mCurrentMovement.width < mMatrixSize.width && mCurrentMovement.height < mMatrixSize.height)));
}


-(void) executeRight{
    mCurrentPosition.x++;
    if(mCurrentPosition.x >= mMatrixSize.width){
        if(mLoopBack)
            mCurrentPosition.x = 0;
        else
            mCurrentPosition.x = mMatrixSize.width-1;
    }
}

-(void) executeUp{
    mCurrentPosition.y--;    
    if(mCurrentPosition.y < 0){
        if(mLoopBack)
            mCurrentPosition.y = mMatrixSize.height-1;
        else
            mCurrentPosition.y = 0;
    }
}

-(void) executeDown{
    mCurrentPosition.y++;
    if(mCurrentPosition.y >= mMatrixSize.height){
        if(mLoopBack)
            mCurrentPosition.y = 0;
        else
            mCurrentPosition.y = mMatrixSize.height-1;
    }
}

-(void) activate{
    id item = [self ptrAtCurrentPos];
    
    if([item isKindOfClass:[CCControl class]]){
        CCControl * itemCtrl = (CCControl*) item;
        
        [itemCtrl triggerAction];
    }
    
//    if([item isKindOfClass:[CCMenuItem class]]){
//        if([item isKindOfClass:[CCMenuItemSprite class]]){
//            CCMenuItemSprite * itemSprite = (CCMenuItemSprite *)item;
//
//            if (itemSprite.normalImage.displayedOpacity > 0) {
//                [item activate];
//            }
//        }
//        else{
//            [item activate];
//        }
//    }
//        
//    else{
//        CCLOG(@"using activate on non-CCMenuItemSprite");
//    }
}

-(void) unselectCurrent{
    CCNode * item = (CCNode *)[self ptrAtCurrentPos];
    
    [item stopActionByTag:2093];
    item.scale = mOriginScale;

//    if([item isKindOfClass:[CCMenuItem class]]){
//        [(CCMenuItem*)item unselected];
//    }
//    else if([item conformsToProtocol:@protocol(CCRGBAProtocol)]){
//        id<CCRGBAProtocol> colorableNode = (id<CCRGBAProtocol>) item;
//        colorableNode.opacity = 255;
//    }
//    else{
//        CCLOG(@"using unselectCurrent on non-CCMenuItemSprite");
//    }
}

-(void) selectCurrent{
    CCNode * item = (CCNode *)[self ptrAtCurrentPos];
    
//    if([item isKindOfClass:[CCMenuItem class]]){
//        [(CCMenuItem*)item selected];
//    }
//    else if([item conformsToProtocol:@protocol(CCRGBAProtocol)]){
//        id<CCRGBAProtocol> colorableNode = (id<CCRGBAProtocol>) item;
//        colorableNode.opacity = 100;
//    }
//    else{
//        CCLOG(@"using selectCurrent on non-CCMenuItemSprite");
//    }
}

-(void) setFocusColor:(ccColor3B) color{
    mFocusColor = color;
}

//-(void) colorPBRWindowCorners:(PBRWindow*) window :(BOOL) isSelected{
//    if((window.windowStyle & STYLE_DYNAMIC) == STYLE_DYNAMIC){
//        [self colorWindowCorner:window :isSelected];
//        [self colorWindowSide:window :isSelected];
//    }
//    else{
//        CCLOG(@"PBRWindow isnt dynamic, cant color corners");
//    }
//}

-(void) colorPerimeter:(id) item :(BOOL) isSelected{
////    BOOL hasPlanBColoring = NO;
//    
//    if([item isKindOfClass:[CCMenuItemSprite class]]){
//        CCMenuItemSprite * menuItem = item;
//
//        BOOL hasColored = NO;
//        
//        if([menuItem.normalImage isKindOfClass:[PBRWindow class]]){
//            [self colorPBRWindowCorners:(PBRWindow *)menuItem.normalImage :isSelected];
//            hasColored = YES;
//        }
//    }
//    else if([item isKindOfClass:[PBRWindow class]]){
//        [self colorPBRWindowCorners:(PBRWindow *)item :isSelected];
//    }
//    else if([item conformsToProtocol:@protocol(NavigColorProtocol)]){
//        [item colorPerimeter :isSelected];
//    }
//    
//    
//    if(isSelected && [item isKindOfClass:[CCNode class]]){
//        CCNode * node = item;
//    
//        CCAction * action = [CCSequence actions:[CCEaseBackIn actionWithAction:[CCScaleTo actionWithDuration:0.15 scale:mOriginScale*1.06]],
//                                                [CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.15 scale:mOriginScale]], nil];
//
//        action.tag = 2093;
//        
//        [node stopActionByTag:2093];
//        node.scale = mOriginScale;
//        [node runAction:action];
//    }
}
//
//-(void) colorWindowSide:(PBRWindow *) windowItem :(BOOL) isSelected{
//    if(isSelected)
//        [windowItem recolorSide:mFocusColor];
//    else
//        [windowItem resetColors];
//}
//
//-(void) colorWindowCorner:(PBRWindow *) windowItem :(BOOL) isSelected{
//    if(isSelected)
//        [windowItem recolorCorners:mFocusColor];
//    else
//        [windowItem resetColors];
//}

-(BOOL) selectItem:(id) item{
    int i = 0;
    int j = 0;
    BOOL hasFound = NO;
    
    for (NSArray * array in mArrayOfArrays) {
        j = 0;
        for (id anItem in array) {
            if (anItem == item) {
                hasFound = YES;
                break;
            }
            j++;
        }
        if(hasFound)
            break;
        i++;
    }
    
    if(hasFound){
        mCurrentPosition.x = j;
        mCurrentPosition.y = i;
    
        if(![self isCurrentPosValid]){
            mCurrentPosition.x = 0;
            mCurrentPosition.y = 0;
            hasFound = NO;
        }
    }
    
    return hasFound;
}

-(void) clearColors{
    for (NSArray * array in mArrayOfArrays) {
        for (id item in array) {
            [self colorPerimeter:item :NO];
        }
    }
}

-(void) colorCurrentSelection{
    id currentItem = [self ptrAtCurrentPos];
    
    [self colorPerimeter:currentItem :YES];
}

-(id) moveUpAndColor{
    return [self moveUpAndColor:YES];
}

-(id) moveDownAndColor{
    return [self moveDownAndColor:YES];
}

-(id) moveLeftAndColor{
    return [self moveLeftAndColor:YES];
}

-(id) moveRightAndColor{
    return [self moveRightAndColor:YES];
}

-(id) moveUpAndColor:(BOOL) willColor{
    id itemBefore = [self ptrAtCurrentPos];
    [self moveDirection:MOVE_UP];
    id itemAfter = [self ptrAtCurrentPos];
    
    if(itemAfter != itemBefore){
        [self colorPerimeter:itemBefore :NO];
        [self colorPerimeter:itemAfter :willColor];
    }

    return itemAfter;
}

-(id) moveDownAndColor:(BOOL) willColor{
    id itemBefore = [self ptrAtCurrentPos];
    [self moveDirection:MOVE_DOWN];
    id itemAfter = [self ptrAtCurrentPos];
    
    if(itemAfter != itemBefore){
        [self colorPerimeter:itemBefore :NO];
        [self colorPerimeter:itemAfter :willColor];
    }
    
    return itemAfter;
}

-(id) moveLeftAndColor:(BOOL) willColor{
    id itemBefore = [self ptrAtCurrentPos];
    [self moveDirection:MOVE_LEFT];
    id itemAfter = [self ptrAtCurrentPos];
    
    if(itemAfter != itemBefore){
        [self colorPerimeter:itemBefore :NO];
        [self colorPerimeter:itemAfter :willColor];
    }
    
    return itemAfter;
}

-(id) moveRightAndColor:(BOOL) willColor{
    id itemBefore = [self ptrAtCurrentPos];
    [self moveDirection:MOVE_RIGHT];
    id itemAfter = [self ptrAtCurrentPos];
    
    if(itemAfter != itemBefore){
        [self colorPerimeter:itemBefore :NO];
        [self colorPerimeter:itemAfter :willColor];
    }
    
    return itemAfter;
}

-(void) free{
    [mArrayOfArrays removeAllObjects];
}

@end
