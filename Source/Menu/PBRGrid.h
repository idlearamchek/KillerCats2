//
//  PBRWindow.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 5/16/13.
//
//

#import "cocos2d.h"
#import "PointTransformationIpad.h"

@interface PBRGrid : CCSprite{
    CCSprite * mGridSprite;
    
    float * mCellWidth;
    float * mCellHeight;
    
    int mNbRow;
    int mNbColumn;
    BOOL mHasFixedWidth;
    BOOL mHasFixedHeight;
    
    float mTotalWidth;
    float mTotalHeight;
    
    CCSpriteBatchNode * mBatch;
    
    CCSprite * mLastGridSprite;
    
    int mNbRowBatchGrid;
    float mTotalHeightPerBatch;
    int mCurrentStartRow;
    
//    League * mLeague; //should probably make a PBRLeagueGrid class
    NSMutableArray * mLabels;
    
    NSMutableArray * mLabelsToNode;
}

-(id) initWithForResults:(NSMutableArray*) mRacerListInOrder :(float) rowHeight :(BOOL) showAdditionalInfos;
-(id) createTitleGrid :(float) rowHeight :(BOOL) showAdditionalInfos;

-(id) initWithSize:(CGSize) size :(int) nbColumn :(int) nbRow;

-(id) initWithSize:(CGSize) size :(int) nbColumn :(int) nbRow :(NSMutableArray*) labels;

-(id) initWithSize:(float*) columnWidthArray
                  :(BOOL) hasFixedWidth
                  :(float*) columnHeightArray
                  :(BOOL) hasFixedHeight
                  :(int) nbColumn :(int) nbRow
                  :(NSMutableArray*) labels;


-(id) initWithSize:(float*) columnWidthArray
                  :(BOOL) hasFixedWidth
                  :(float*) columnHeightArray
                  :(BOOL) hasFixedHeight
                  :(int) nbColumn :(int) nbRow :(int) textureSize
                  :(NSMutableArray*) labels;

-(void) renderGridTexture;

-(CGRect) totalBoundingBox;
//-(void) refreshGridForNewRacerTime:(NSMutableArray*) racersList;

@end
