//
//  PBRWindow.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 5/16/13.
//
//

#import "PBRGrid.h"
#import "PointTransformationIpad.h"
#import "League.h"
#import "Boat.h"
#import "Ship.h"
#import "Opponent.h"
#import "Hero.h"
#import "GlobalDataManager.h"
#import "Tools.h"

#define MAX_TEXTURE_SIZE 1024

#define CHAMPION_PER_LEAGUE 4 //static or we have to count them?

@implementation PBRGrid

+(void) preloadTextures
{
    [[CCTextureCache sharedTextureCache] addImage:@"window.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"window.plist"];

    [[CCTextureCache sharedTextureCache] addImage:@"boats.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"boats.plist"];
}

-(id) createTitleGrid :(float) rowHeight :(BOOL) showAdditionalInfos{
    float widthSize[5] = {ipadDouble(35), ipadDouble(160), ipadDouble(64), ipadDouble(40), ipadDouble(82)};
    float heightSize = rowHeight;
    int nbColumn = 3;
    
    NSMutableArray * gridObjectArray = [NSMutableArray array];
    
    CCLabelBMFont * lblPos = [[[CCLabelBMFont alloc] initWithString:NSLocalizedString(@"pos", nil) fntFile:@"pixelFontLarge2.fnt"] autorelease];
    CCLabelBMFont * lblBoat = [[[CCLabelBMFont alloc] initWithString:NSLocalizedString(@"boat", nil) fntFile:@"pixelFontLarge2.fnt"] autorelease];
    lblPos.scale = 0.95;
    lblBoat.scale = 0.95;
    
    [gridObjectArray addObject:lblPos];
    [gridObjectArray addObject:[[[CCLabelBMFont alloc] initWithString:NSLocalizedString(@"name", nil) fntFile:@"pixelFontLarge2.fnt"] autorelease]];
    [gridObjectArray addObject:lblBoat];
    
    CCLabelBMFont *setColor = [gridObjectArray objectAtIndex:0];
    setColor.color = (ccColor3B){255, 255, 0};
    setColor = [gridObjectArray objectAtIndex:1];
    setColor.color = (ccColor3B){255, 255, 0};
    setColor = [gridObjectArray objectAtIndex:2];
    setColor.color = (ccColor3B){255, 255, 0};
    
    if(showAdditionalInfos){
        nbColumn += 2;
        [gridObjectArray addObject:[[[CCLabelBMFont alloc] initWithString:NSLocalizedString(@"kills2", nil) fntFile:@"pixelFontLarge2.fnt"] autorelease]];
        [gridObjectArray addObject:[[[CCLabelBMFont alloc] initWithString:NSLocalizedString(@"time", nil) fntFile:@"pixelFontLarge2.fnt"] autorelease]];

        setColor = [gridObjectArray objectAtIndex:3];
        setColor.color = (ccColor3B){255, 255, 0};
        setColor = [gridObjectArray objectAtIndex:4];
        setColor.color = (ccColor3B){255, 255, 0};
    }
        
    return [self initWithSize:widthSize :NO :&heightSize :YES :nbColumn :1 :gridObjectArray];
}

+(NSMutableArray *) createGridObjectArrayFor:(NSMutableArray*) mRacerListInOrder :(BOOL) showAdditionalInfos{
    float widthSize[5] = {ipadDouble(35), ipadDouble(160), ipadDouble(64), ipadDouble(40), ipadDouble(82)};

    NSMutableArray * gridObjectArray = [NSMutableArray array];
    CCLabelBMFont *setColor = nil;
    
    int line = 1;
    for (Ship * racersShip in mRacerListInOrder) {
        NSString * name = NSLocalizedString(@"Anonymous", nil);
        
        CCSprite * boatPtr = nil;
        
        if(racersShip.type == GO_TYPE_OPPONENT){
            Opponent * racer = (Opponent*) racersShip;
            if (racer.pilotInfos.name)
                name = racer.pilotInfos.name;
            
            BoatStats * boatStats = [((Ship*)racersShip) getBoatRef].stats;
            boatPtr = [CCSprite spriteWithSpriteFrameName:[BoatStats spriteNameForBoatType:boatStats.boatInfos.boatType]];
//[[[Boat alloc] initWithBoatStats:boatStats] autorelease];
            boatPtr.color = ((Ship*)racersShip).color;
        }
        else if(racersShip.type == GO_TYPE_HERO){
            name = [GlobalDataManager sharedInstance].pilotPlayer.name;
            BoatStats * boatStats = [((Ship*)racersShip) getBoatRef].stats;
            boatPtr = [CCSprite spriteWithSpriteFrameName:[BoatStats spriteNameForBoatType:boatStats.boatInfos.boatType]];
            boatPtr.color = ((Ship*)racersShip).color;
        }
        
        boatPtr.scale = 0.6;
        [gridObjectArray addObject:[[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"#%d", line] fntFile:@"pixelFontLarge2.fnt"] autorelease]];
        
        setColor = [gridObjectArray objectAtIndex:gridObjectArray.count-1];
        setColor.color = (ccColor3B){255, 255, 0};
        
        CCLabelBMFont * nameLbl = [[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%@", name] fntFile:@"pixelFontLarge2.fnt"] autorelease];
        
        //name scale strategy
        if(nameLbl.contentSize.width > (widthSize[1] - ipadDouble(5))){
            float scale = (widthSize[1] - ipadDouble(5))/nameLbl.contentSize.width;
            nameLbl.scale = scale;
        }
        
        [gridObjectArray addObject:nameLbl];
        
        if (racersShip.type == GO_TYPE_HERO){
            setColor = [gridObjectArray objectAtIndex:gridObjectArray.count-1];
            setColor.color = (ccColor3B){0, 150, 255};
        }
        
        [gridObjectArray addObject:boatPtr];
        
        if(showAdditionalInfos){
            [gridObjectArray addObject:[[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d", racersShip.killCount] fntFile:@"pixelFontLarge2.fnt"] autorelease]];
            [gridObjectArray addObject:[[[CCLabelBMFont alloc] initWithString:[racersShip formatTotalTime] fntFile:@"pixelFontLarge2.fnt"] autorelease]];
        }
        
        line++;
    }

    return gridObjectArray;
}

-(id) initWithGridObj:(NSMutableArray *) gridObjArray :(NSMutableArray*) racerListInOrder :(float) rowHeight :(BOOL) showAdditionalInfos{
    float widthSize[5] = {ipadDouble(35), ipadDouble(160), ipadDouble(64), ipadDouble(40), ipadDouble(82)};
    float heightSize = rowHeight;
    int nbColumn = 3;
    
    if(showAdditionalInfos)
        nbColumn += 2;

    //Refresh data inside gridObjArray
    
    return [self initWithSize:widthSize :NO :&heightSize :YES :nbColumn :[racerListInOrder count] :gridObjArray];
}

-(id) initWithForResults:(NSMutableArray*) racerListInOrder :(float) rowHeight :(BOOL) showAdditionalInfos{
    float widthSize[5] = {ipadDouble(35), ipadDouble(160), ipadDouble(64), ipadDouble(40), ipadDouble(82)};
    float heightSize = rowHeight;
    int nbColumn = 3;

    if(showAdditionalInfos)
        nbColumn += 2;
    
    NSMutableArray * gridObjArray = [PBRGrid createGridObjectArrayFor:racerListInOrder :showAdditionalInfos];

    return [self initWithSize:widthSize :NO :&heightSize :YES :nbColumn :[racerListInOrder count] :gridObjArray];
}

//-(id) initWithForResults:(NSMutableArray*) racerListInOrder :(float) rowHeight :(BOOL) showAdditionalInfos{
//    float widthSize[5] = {ipadDouble(30), ipadDouble(160), ipadDouble(60), ipadDouble(34), ipadDouble(80)};
//    float heightSize = rowHeight;
//    int nbColumn = 3;
//    
//    if(showAdditionalInfos)
//        nbColumn += 2;
//    
//    NSMutableArray * gridObjArray = [PBRGrid createGridObjectArrayFor:racerListInOrder :showAdditionalInfos];
//    
//    return [self initWithSize:widthSize :NO :&heightSize :YES :nbColumn :[racerListInOrder count] :gridObjArray];
//}

////Simplified method to create PBRGrid for league
//-(id) initWithLeague:(League*) league{
//    float widthSize[4] = {ipadDouble(25), ipadDouble(200), ipadDouble(50), ipadDouble(65)};
//    float height = ipadDouble(22);
//    
//    return [self initWithSize:widthSize :NO :&height :YES :4 :[league.pilots count] :league :256 :nil];
//}

-(id) initWithSize:(float*) columnWidthArray
                  :(BOOL) hasFixedWidth
                  :(float*) columnHeightArray
                  :(BOOL) hasFixedHeight
                  :(int) nbColumn :(int) nbRow
                  :(NSMutableArray*) labels{
    return [self initWithSize:columnWidthArray :hasFixedWidth: columnHeightArray :hasFixedHeight :nbColumn :nbRow :MAX_TEXTURE_SIZE :labels];
}

-(id) initWithSize:(float*) columnWidthArray
                  :(BOOL) hasFixedWidth
                  :(float*) columnHeightArray
                  :(BOOL) hasFixedHeight
                  :(int) nbColumn :(int) nbRow {
    return [self initWithSize:columnWidthArray :hasFixedWidth :columnHeightArray :hasFixedHeight :nbColumn :nbRow :MAX_TEXTURE_SIZE :nil];
}

-(id) initWithSize:(CGSize) size :(int) nbColumn :(int) nbRow{
    return [self initWithSize:(float*)&size.width :YES :(float*)&size.height :YES :nbColumn :nbRow :MAX_TEXTURE_SIZE :nil];
}

-(id) initWithSize:(CGSize) size :(int) nbColumn :(int) nbRow :(NSMutableArray*) labels{
    return [self initWithSize:(float*)&size.width :YES :(float*)&size.height :YES :nbColumn :nbRow :MAX_TEXTURE_SIZE :labels];
}


-(id) initWithSize:(float*) columnWidthArray
                  :(BOOL) hasFixedWidth
                  :(float*) columnHeightArray
                  :(BOOL) hasFixedHeight
                  :(int) nbColumn :(int) nbRow :(int) textureSize
                  :(NSMutableArray*) labels{
    self = [super init];
    
    if(columnHeightArray[0] == 0 || columnWidthArray[0] == 0){
        CCLOG(@"PBRGrid width or height is nil!");
        return nil;
    }
    
    mNbColumn = nbColumn;
    mNbRow = nbRow;
    
    mTotalWidth = 0;
    mTotalHeight = 0;
    mNbRowBatchGrid = mNbRow;
    mLabels = [labels retain];

    int texSize = min(textureSize, MAX_TEXTURE_SIZE);
    
    if(hasFixedHeight){
        mNbRowBatchGrid = 1 + texSize/columnHeightArray[0];
    }
    
    mNbRowBatchGrid = min(mNbRow, mNbRowBatchGrid);
    
    if(mNbRowBatchGrid > mNbRow){
        CCLOG(@"Grid is too big, not supported!");
    }
    
    mTotalHeightPerBatch = 0;
    
    [self createBatchNodeGrid:columnWidthArray :hasFixedWidth
                             :columnHeightArray :hasFixedHeight :nbColumn :mNbRowBatchGrid
                             :&mTotalWidth :&mTotalHeightPerBatch];
    
    if(hasFixedHeight){ //override mTotalHeight
        mTotalHeight = columnHeightArray[0] * mNbRow;
    }
    else{
        mTotalHeight = mTotalHeightPerBatch * (mNbRow / mNbRowBatchGrid);
    }
    
    //    int toRow = min(mCurrentStartRow+mNbRowBatchGrid, mNbRow);
    
    if(mLabels){
        mLabelsToNode = [[self createLabels: mNbColumn :mNbRow] retain];
    }

    [self renderGridTexture];
    
    return self;
}

-(void) renderGridTexture{
    mCurrentStartRow = 0;
    
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:mTotalWidth height:mTotalHeightPerBatch];
    
    [rt begin];
    
    [mBatch visit];
    
    for (CCNode * label in mLabelsToNode) {
        [label visit];
    }
    
    [rt end];
    
    mCurrentStartRow += mNbRowBatchGrid;
    
    [mGridSprite removeFromParent];
    mGridSprite = [CCSprite spriteWithTexture:rt.sprite.texture];
    [self addChild:mGridSprite];

    mGridSprite.anchorPoint = ccp(0, 0);
    mGridSprite.flipY = YES;
    
    mLastGridSprite = nil;
    
//    if(mCurrentStartRow < mNbRow){
//        [self finishConstructing];
//    }    
}

-(CGSize) contentSize{
    return mGridSprite.contentSize;
}

-(NSMutableArray*) createLabels{
    NSMutableArray * labelArray = nil;

    int toRow = min(mCurrentStartRow+mNbRowBatchGrid, mNbRow);

    if(mLabels){
        labelArray = [self createLabels: mNbColumn :toRow];
    }
    
    return labelArray;
}

//-(void) refreshGridForNewRacerTime:(NSMutableArray*) racersList{
//    if([self refreshObjectArray:racersList]){
//        [self renderGridTexture];
//    }
//}

//-(BOOL) refreshObjectArray :(NSMutableArray*) racersList{
//    BOOL wasModified = NO;
//    
//    int racerCount = [racersList count];
//    int timeColumn = mNbColumn - 1;
//
//    int labelCount = [mLabels count];
//    
//    for(int racerIdx = 0; racerIdx < racerCount; racerIdx++){
//        Ship * racer = [racersList objectAtIndex:racerIdx];
//        int labelIdx = timeColumn + (racerIdx*mNbColumn);
//        
//        if(labelIdx > labelCount){
//            CCLOG(@"ERR!");
//        }
//        else{
//            CCLabelBMFont * label = (CCLabelBMFont *)[mLabels objectAtIndex:labelIdx];
//            CCLOG(@"idx:%d - label=%@", labelIdx, label.string);
//            
//            if([label.string isEqualToString:NO_TIME]){
//                    NSString * strTime = [racer formatTotalTime];
//                
//                if(![strTime isEqualToString:NO_TIME]){
//                    wasModified = YES;
//                    label.string = strTime;
//                }
//            }
//        }
//    }
//    
//    return wasModified;
//}


//-(void) finishConstructing{
//#ifdef DEBUG
//    mach_timebase_info_data_t info;
//    mach_timebase_info(&info);
//    
//    uint64_t start = mach_absolute_time();
//#endif
//    
//    NSMutableArray * labelArray = [self createLabels];
//
//    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:mTotalWidth height:mTotalHeightPerBatch];
//
//    [rt beginWithClear:0 g:0 b:0 a:0];
//
//    [mBatch visit];
//    for (CCNode * label in labelArray) {
//        [label visit];
//    }
//
//    [rt end];
//    
//    mCurrentStartRow += mNbRowBatchGrid;
//
//    CCSprite * spi = [[[CCSprite alloc] initWithTexture:rt.sprite.texture] autorelease];
//    spi.flipY = YES;
//    
//    spi.anchorPoint = ccp(0,1);
//    
//    if(mLastGridSprite)
//        [mLastGridSprite addChild:spi];
//    else
//        [self addChild:spi];
//    
//    mLastGridSprite = spi;
//    
//#ifdef DEBUG
//    uint64_t after = mach_absolute_time() - start;
//    after *= info.numer;
//    after /= info.denom;
//    
//    int millisec = after/1000000;
//    
//    if(millisec > 10)
//        CCLOG(@"create textures took: %d ms", millisec);
//#endif
//    
//    [self unschedule:@selector(finishConstructing)];
//    if(mCurrentStartRow < mNbRow){
//        [self schedule:@selector(finishConstructing) interval:0.1f];
//    }
//}

-(CGRect) totalBoundingBox{
    return CGRectMake(self.position.x,
                      self.position.y,
                      mTotalWidth, mTotalHeight);
}


-(NSMutableArray*) createLabels:(int) nbColumn :(int) toRow{
    NSMutableArray * labelArray = [NSMutableArray array];
    
    int idx = 0;
    float midWidthOfCell = mCellWidth[0]/2;
    float midHeightOfCell = mTotalHeightPerBatch-mCellHeight[0]/2;
    
    for(int i = 0; i < (toRow-mCurrentStartRow); i++){
        midWidthOfCell = mCellWidth[0]/2;

        if(i != 0){ //1st row height is already set
            if(mHasFixedHeight)
                midHeightOfCell -= mCellHeight[0];
            else{
                midHeightOfCell -= (mCellHeight[i-1]/2 + mCellHeight[i]/2);
            }
        }
        
        for(int j = 0; j < nbColumn; j++){
            
            if(j!=0){//1st column width is already set
                if(mHasFixedWidth)
                    midWidthOfCell += mCellWidth[0];
                else
                    midWidthOfCell += (mCellWidth[j-1]/2 + mCellWidth[j]/2);
            }
            
            if(idx >= 0 && idx < mLabels.count){
                CCNode * node = [mLabels objectAtIndex:idx];
                node.position = ccp(midWidthOfCell, midHeightOfCell);
                [labelArray addObject:node];
            }
            else{
                CCLOG(@"out of bound in pbrgrid");
            }
            
            idx++;
        }
    }
    
    return labelArray;
}

//-(NSMutableArray*) createLabelsFor:(League*) league :(float) totalWidth :(float) totalHeight
//                                  :(int) fromRow :(int) toRow{
//#ifdef DEBUG
//    mach_timebase_info_data_t info;
//    mach_timebase_info(&info);
//    
//    uint64_t start = mach_absolute_time();
//#endif
//
//    float midWidthOfCell = mCellWidth[0]/2;
//    float midHeightOfCell = totalHeight-mCellHeight[0]/2;
//    
//    NSMutableArray * labelArray = [NSMutableArray array];
//    
////    BOOL lastLignWasTitle = NO;
////    BOOL currentLignIsTitle = NO;
////    CCNode * dummyNode = [[[CCNode alloc] init] autorelease];
//
//    ccColor3B lineColor = ccWHITE;
//    int pilotPosOffset = 0;
//    
//    for (int i = fromRow; i < toRow; i++) {
//        midWidthOfCell = mCellWidth[0]/2;
//
////        if(lastLignWasTitle)
////            lastLignWasTitle = NO;
////        else if(currentLignIsTitle){
////            lastLignWasTitle = YES;
////            currentLignIsTitle = NO;
////            pilotPosOffset--;
////        }
////        else
//
//        lineColor = ccWHITE;
//
//        Pilot * pilotOnRow = [league pilotAt:i+pilotPosOffset];
//        PilotLeagueInfo * pilotLeagueInfo = [pilotOnRow getLeagueInfo:league.category];
//
//        
//        switch(pilotLeagueInfo.title){
//            case TITLE_LOCAL_NOOB:
//                lineColor = ccGRAY;
//                break;
//            case TITLE_REGIONAL_CHAMP:
//                lineColor = ccBLUE;
//                break;
//            case TITLE_NATIONAL_CHAMP:
//                lineColor = ccRED;
//                break;
//            case TITLE_WORLD_CHAMP:
//                lineColor = ccYELLOW;
//                break;
//            default:
//                break;
//        }
//        
//    
//        if(i != fromRow){ //1st row height is already set
//            if(mHasFixedHeight)
//                midHeightOfCell -= mCellHeight[0];
//            else{
//                midHeightOfCell -= (mCellHeight[i-1]/2 + mCellHeight[i]/2);
//            }
//        }
//       
//        CCNode * obj = nil;
//
//        BOOL isPlayer = NO;
//        if([pilotOnRow isKindOfClass:[PilotPlayer class]]){
//            isPlayer = YES;
//            lineColor = ccBLACK;
//        }
//
//        for (int j = 0; j < mNbColumn; j++) {
//            if(j!=0){//1st column width is already set
//                if(mHasFixedWidth)
//                    midWidthOfCell += mCellWidth[0];
//                else
//                    midWidthOfCell += (mCellWidth[j-1]/2 + mCellWidth[j]/2);
//            }
//            
//            switch (j) {
//                case 0:{     //rank
//                    CCLabelBMFont * label = [[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d", pilotLeagueInfo.rank]
//                                                                           fntFile:@"pixelFontLarge2.fnt"] autorelease];
//                    label.color = lineColor;
//                    
//                    obj = label;
//                }
//                    break;
//                case 1:{//name
//                    CCLabelBMFont * label = [[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%@", pilotOnRow.name]
//                                                                           fntFile:@"pixelFontLarge2.fnt"] autorelease];
//
//                    label.color = lineColor;
//                    obj = label;
//                }
//                    break;
//                case 2:{     //fame
//                    CCLabelBMFont * label = [[[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d", pilotOnRow.currentFame]
//                                                                           fntFile:@"pixelFontLarge2.fnt"] autorelease];
//                    label.color = lineColor;
//                    obj = label;
//                }
//                    break;
//                case 3:{     //boat
//                    CCSprite * boat = [CCSprite spriteWithSpriteFrameName:[BoatStats spriteNameForBoatType:pilotLeagueInfo.currentBoatType]];
//                    boat.scale = 0.5f;
//                    obj = boat;
//                }
//                    break;
//                default:
//                    break;
//            }
//
//            if(isPlayer){
//                obj.scale += 0.1;
//            }
//            
//            obj.position = ccp(midWidthOfCell, midHeightOfCell);
//            [labelArray addObject:obj];
////            else{
////                if(j == 1){
////                    //NaME
////                    CCLabelBMFont * label = [[[CCLabelBMFont alloc] initWithString:[League nameForTitle:pilotLeagueInfo.title]
////                                                                           fntFile:@"pixelFontLarge2.fnt"] autorelease];
////                    
////                    label.color = lineColor;
////                    label.scale = 1.1;
////                    label.position = ccp(midWidthOfCell, midHeightOfCell);
////
////                    [labelArray addObject:label];
////                }
////                else{
////                    [labelArray addObject:dummyNode];
////                }
////            }
//        
//
////            if(j==0)
////                CCLOG(@"row : %d -> label pos : (%.2f,%.2f)", i, obj.position.x, obj.position.y);
//        }
//    }
//   
//#ifdef DEBUG
//    uint64_t after = mach_absolute_time() - start;
//    after *= info.numer;
//    after /= info.denom;
//    
//    int millisec = after/1000000;
//    
////    if(millisec > 1)
//        CCLOG(@"createLabelsFor took: %d ms", millisec);
//#endif
//
//    return labelArray;
//}


-(void) createBatchNodeGrid:(float*) columnWidthArray
                                         :(BOOL) hasFixedWidth
                                         :(float*) columnHeightArray
                                         :(BOOL) hasFixedHeight
                                         :(int) nbColumn :(int) nbRow
                                         :(float*) outTotalWidth :(float*) outTotalHeight{
    
    [mBatch release];
    CCTexture2D * tex = [[CCTextureCache sharedTextureCache] textureForKey:@"window.png"];
    mBatch = [[CCSpriteBatchNode alloc] initWithTexture:tex capacity:8];

    [PBRGrid preloadTextures];
    
    if(hasFixedWidth){
        mHasFixedWidth = YES;
        mCellWidth = (float*)malloc(sizeof(float) * 1);
        mCellWidth[0] = columnWidthArray[0];
    }
    else{
        mCellWidth = (float*)malloc(sizeof(float) * nbColumn);
        
        for(int i = 0; i< nbColumn;i++)
            mCellWidth[i] = columnWidthArray[i];
    }
    
    if(hasFixedHeight){
        mHasFixedHeight = YES;
        mCellHeight = (float*)malloc(sizeof(float) * 1);
        mCellHeight[0] = columnHeightArray[0];
    }
    else{
        mCellHeight = (float*)malloc(sizeof(float) * nbRow);
        
        for(int i = 0; i< nbRow;i++)
            mCellHeight[i] = columnHeightArray[i];
    }
    
    CCSprite * centerSprite = [CCSprite spriteWithSpriteFrameName:@"center.png"];

    *outTotalWidth = 0;
    *outTotalHeight = 0;
    
    CGSize size;
    
    for(int i = 0; i < nbRow; i++){
        *outTotalWidth = 0;
        
        if(mHasFixedHeight)
            size.height = mCellHeight[0];
        else
            size.height = mCellHeight[i];
        
        float stretchScaleY = size.height/centerSprite.contentSize.height;
        
        for(int j = 0; j < nbColumn; j++){
            
            if(mHasFixedWidth)
                size.width = mCellWidth[0];
            else
                size.width = mCellWidth[j];
            
            float stretchScaleX = size.width/centerSprite.contentSize.width;
            
            CCSprite * c = [CCSprite spriteWithSpriteFrameName:@"center.png"];
            c.anchorPoint = ccp(0,0);
            c.position = ccp(*outTotalWidth, *outTotalHeight);
            c.scaleX = stretchScaleX;
            c.scaleY = stretchScaleY;
            
            if((i+j) % 2 == 0)
                c.color = ccc3(170, 170, 170);
            else
                c.color = ccc3(85, 85, 85);
            
            [mBatch addChild:c];
            
            CCSprite * li = [CCSprite spriteWithSpriteFrameName:@"center.png"];
            li.anchorPoint = ccp(0,1);
            li.position = ccp(*outTotalWidth, *outTotalHeight+size.height);
            li.scaleX = stretchScaleX;
            li.scaleY = 0.1f;
            
            li.color = ccc3(0, 0, 0);
            [mBatch addChild:li];
            
            if (j>0){
                CCSprite * li2 = [CCSprite spriteWithSpriteFrameName:@"center.png"];
                li2.anchorPoint = ccp(0,0);
                li2.position = ccp(*outTotalWidth, *outTotalHeight);
                li2.scaleX = 0.1f;
                li2.scaleY = stretchScaleY;
                
                li2.color = ccc3(0, 0, 0);
                [mBatch addChild:li2];
            }
            
            *outTotalWidth += size.width;
        }
        
        *outTotalHeight += size.height;
    }
    
    mBatch.anchorPoint = ccp(0,1);
    mBatch.position = ccp(0,0);
}


-(void) dealloc{
    [mLabelsToNode release];
    [mLabels release];
    [mBatch release];
    
    delete[] mCellHeight;
    delete[] mCellWidth;
    
    [super dealloc];
}

@end
