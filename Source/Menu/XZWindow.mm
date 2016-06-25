//
//  XZWindow.m
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 5/16/13.
//
//

#import "XZWindow.h"


#import "cocos2d.h"
#import "CCTextureCache.h"

#import "CCNode_private.h"
#import "CCControlSubclass.h"

@implementation XZWindow
@synthesize text = mText;
@synthesize windowStyle = mWindowStyle;

+(void) preloadTextures
{
    [[CCTextureCache sharedTextureCache] addImage:@"window.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"window.plist"];
}

//-(id) initConfirmWindowWithTxt:(NSString*) str
//                    textAnchor:(XZTextAnchor) txtAnchor
//                     withStyle:(int) windowStyle
//                   cornerColor:(ccColor3B) cornerColor
//            centerAndSideColor:(ccColor3B) centerColor
//                         block:(void(^)(BOOL clickedYes))block{
//    
//    self = [self initWithSize:CGSizeMake(0, 0)
//            backgroundOpacity:255 text:str
//                 maxTextWidth:10000
//                   textOffset:CGPointZero
//             adjustSizeToText:YES
//                   textAnchor:TXT_MIDDLE
//                    withStyle:windowStyle
//                  cornerColor:cornerColor
//           centerAndSideColor:centerColor];
//    
//    mBlock = [block copy];
//    
//    return self;
//}
//
//-(id) initConfirmWindowWithTxt:(NSString*) str
//                    textAnchor:(XZTextAnchor) txtAnchor
//                     withStyle:(int) windowStyle
//                   cornerColor:(ccColor3B) cornerColor
//            centerAndSideColor:(ccColor3B) centerColor
//                        target: (id<ControlProtocol>) target
//                     selector :(SEL) selector{
//
//    self = [self initWithSize:CGSizeMake(0, 0)
//            backgroundOpacity:255 text:str
//                 maxTextWidth:10000
//                   textOffset:CGPointZero
//             adjustSizeToText:YES
//                   textAnchor:TXT_MIDDLE
//                    withStyle:windowStyle
//              cornerColor:cornerColor
//       centerAndSideColor:centerColor];
//
//    mTarget = target;
//    mCallback = selector;
//    
//    return self;
//}

//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat)opacity
//         withStyle: (int) style
//{
//    return [self initWithSize:sizeOrPadding backgroundOpacity:opacity text:@""
//                 maxTextWidth:0 textOffset:CGPointZero adjustSizeToText:NO textAnchor:TXT_MIDDLE withStyle:style cornerColor:DEFAULT_CORNER_COLOR
//                    centerAndSideColor:DEFAULT_SIDE_COLOR];
//}
//
//
//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat)opacity
//              text:(NSString*) string
//      maxTextWidth: (float) maxTextWidth
//        textOffset:(CGPoint) txtOffset
//  adjustSizeToText: (BOOL) adaptToText{
//    
//    return [self initWithSize:sizeOrPadding
//            backgroundOpacity:opacity
//                         text:string
//                 maxTextWidth:maxTextWidth
//                   textOffset:txtOffset
//             adjustSizeToText:adaptToText
//                   textAnchor:TXT_MIDDLE];
//}
//
//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat)opacity
//              text:(NSString*) string
//      maxTextWidth: (float) maxTextWidth
//        textOffset:(CGPoint) txtOffset
//  adjustSizeToText: (BOOL) adaptToText
//        textAnchor:(XZTextAnchor) txtAnchor
//{
//    return [self initWithSize:sizeOrPadding
//            backgroundOpacity:opacity
//                         text:string
//                 maxTextWidth:maxTextWidth
//                   textOffset:txtOffset
//             adjustSizeToText:adaptToText
//                   textAnchor:txtAnchor
//                    withStyle: STYLE_NONE
//                  cornerColor:DEFAULT_CORNER_COLOR
//                    centerAndSideColor:DEFAULT_SIDE_COLOR];
//}
//
//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat)opacity
//              text:(NSString*) string
//      maxTextWidth: (float) maxTextWidth
//        textOffset:(CGPoint) txtOffset
//  adjustSizeToText: (BOOL) adaptToText
//        textAnchor:(XZTextAnchor) txtAnchor
//         withStyle: (int) style
//{
//
//    return [self initWithSize:sizeOrPadding
//            backgroundOpacity:opacity
//                         text:string
//                 maxTextWidth:maxTextWidth
//                   textOffset:txtOffset
//             adjustSizeToText:adaptToText
//                   textAnchor:txtAnchor
//                    withStyle: style
//                  cornerColor:DEFAULT_CORNER_COLOR
//           centerAndSideColor:DEFAULT_SIDE_COLOR];
//}
//
//
//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat)opacity
//              text:(NSString*) string
//      maxTextWidth: (float) maxTextWidth
//        textOffset:(CGPoint) txtOffset
//  adjustSizeToText: (BOOL) adaptToText
//        textAnchor:(XZTextAnchor) txtAnchor
//         withStyle: (int) style
//      cornerColor : (ccColor3B) cornerColor
//centerAndSideColor : (ccColor3B) centerAndSideColor{
//    
//    sPBRWindowInfo pbrDefaultInfo = PBRWinDefault();
//    
//    return [self initWithSize:sizeOrPadding
//            backgroundOpacity:opacity
//                         text:string
//                 maxTextWidth:maxTextWidth
//                   textOffset:txtOffset
//             adjustSizeToText:adaptToText
//                   textAnchor:txtAnchor
//                    withStyle: style
//                  cornerColor:DEFAULT_CORNER_COLOR
//           centerAndSideColor:DEFAULT_SIDE_COLOR
//            :pbrDefaultInfo];
//}


-(id) init9SliceWithSize:(CGSize) size
                    text:(NSString*) string
                   asset:(NSString*) asset
               textScale:(float) textScale{

    return [self init9SliceWithSize:size text:string asset:asset textScale:textScale textOffset:CGSizeZero :NO];
}

-(id) init9SliceWithSize:(CGSize) size
              text:(NSString*) string
            asset:(NSString*) asset
               textScale:(float) textScale
              textOffset:(CGSize) txtOffset
                        :(BOOL) isWindow{
    [XZWindow preloadTextures];
    
    self = [super init];
    
    self.state = CCControlStateNormal;

    mWindowStyle = STYLE_9SLICE;
    
    if (isWindow) {
        self.userInteractionEnabled = NO;
        self.exclusiveTouch = NO;
    }

    mText = string;
    
    mLabelText = [[CCLabelBMFont alloc] initWithString:string
                                               fntFile:@"digitalFontLarge.fnt"
                                                 width:size.width/textScale
                                             alignment:CCTextAlignmentCenter];
    mLabelText.scale = textScale;
    
    self.contentSize = size;
    self.preferredSize = size;
    self.maxSize = size;

    if(asset){
        m9SliceSprite = [[CCSprite9Slice alloc] initWithImageNamed:asset];
        m9SliceSprite.contentSize = size;
        
        [self addChild:m9SliceSprite];
        [self addChild:mLabelText z:2];
    }
    else{
        m9SliceSprite = [CCSprite emptySprite];
        m9SliceSprite.contentSize = size;
        
        [self addChild:m9SliceSprite];
        [self addChild:mLabelText z:2];
    }
    
    self.texture = m9SliceSprite.texture;
    
    m9SliceSprite.position = ccp(m9SliceSprite.contentSize.width/2, m9SliceSprite.contentSize.height/2);
    mLabelText.position = ccp(m9SliceSprite.contentSize.width/2 + txtOffset.width, m9SliceSprite.contentSize.height/2 + txtOffset.height);
    
    return self;
}
//
//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat) opacity
//              text:(NSString*) string
//      maxTextWidth: (float) maxTextWidth
//        textOffset:(CGPoint) txtOffset
//  adjustSizeToText: (BOOL) adaptToText
//textAnchor:(XZTextAnchor) txtAnchor
//         withStyle: (int) style
//      cornerColor : (ccColor3B) cornerColor
//        centerAndSideColor : (ccColor3B) centerAndSideColor
//                  :(sPBRWindowInfo) pbrWinInfo
//{
//    [XZWindow preloadTextures];
//    
//    self = [super init];
//
//    self.state = CCControlStateNormal;
//    
//    //    self.userInteractionEnabled = NO;
//
//    mWindowStyle = style;
//
//    BOOL hasBorder = YES;
//    if(mWindowStyle & STYLE_NO_BORDER)
//        hasBorder = NO;
//
//    BOOL isDynamic = NO;
//    if(mWindowStyle & STYLE_DYNAMIC)
//        isDynamic = YES;
//
//    if (mWindowStyle & STYLE_WINDOW) {
//        self.userInteractionEnabled = NO;
//        self.exclusiveTouch = NO;
//    }
//
//    mOriginalCornerColor = cornerColor;
//    mOriginalCenterColor = centerAndSideColor;
//    
//    mSizeOrPadding.width = sizeOrPadding.width;
//    mSizeOrPadding.height = sizeOrPadding.height;
//        
//    mText = string;
//    
//    mLabelText = [[CCLabelBMFont alloc] initWithString:string
//                                                        fntFile:pbrWinInfo.font
//                                                          width:maxTextWidth
//                                                      alignment:CCTextAlignmentCenter];
//    mLabelText.scale = 0.85f;
//    
////    CCTexture * tex = [[CCTextureCache sharedTextureCache] textureForKey:@"window.png"];
////    mBatch = [[CCSpriteBatchNode alloc] initWithTexture:tex capacity:8];
//    
//    mBatch = [CCNode node];
//    bl = b = br = l = r = tl = t = tr = nil;
//
//    if(hasBorder){
//        bl = [CCSprite spriteWithImageNamed:pbrWinInfo.blSprite];
//        [mBatch addChild:bl];
//        
//        b = [CCSprite spriteWithImageNamed:pbrWinInfo.bSprite];
//        [mBatch addChild:b];
//        
//        br = [CCSprite spriteWithImageNamed:pbrWinInfo.brSprite];
//        [mBatch addChild:br];
//        
//        l = [CCSprite spriteWithImageNamed:pbrWinInfo.lSprite];
//        [mBatch addChild:l];
//        
//        r = [CCSprite spriteWithImageNamed:pbrWinInfo.rSprite];
//        [mBatch addChild:r];
//        
//        tl = [CCSprite spriteWithImageNamed:pbrWinInfo.tlSprite];
//        [mBatch addChild:tl];
//        
//        t = [CCSprite spriteWithImageNamed:pbrWinInfo.tSprite];
//        [mBatch addChild:t];
//        
//        tr = [CCSprite spriteWithImageNamed:pbrWinInfo.trSprite];
//        [mBatch addChild:tr];
//        
//        [self recolorSide:mOriginalCenterColor];
//        [self recolorCorners:mOriginalCornerColor];
//    }
//    else{
//        bl = b = br = l = r = tl = t = tr = nil; //[[[CCSprite alloc] init]; //No border!
//    }
//    
//    c = [CCSprite spriteWithImageNamed:pbrWinInfo.cSprite];
//    
//    [self recolorCenter:mOriginalCenterColor];
//    c.opacity = opacity;
//    [mBatch addChild:c z:-1];
//
//    if (mWindowStyle & STYLE_WITH_TOP_BORDER){
//        et = [CCSprite spriteWithImageNamed:pbrWinInfo.cSprite];
//        //et.opacity = opacity;
//        et.color = [CCColor colorWithCcColor3b:ccc3(mOriginalCenterColor.r/1.5,mOriginalCenterColor.g/1.5,mOriginalCenterColor.b/1.5)];
//        [mBatch addChild:et z:-1];
//        
//        li = [CCSprite spriteWithImageNamed:pbrWinInfo.cSprite];
//        //li.opacity = opacity;
//        li.color = [CCColor colorWithCcColor3b: ccc3(50, 50, 50)];
//        [mBatch addChild:li];
//    }
//    
//    if (mWindowStyle & STYLE_WITH_REFLECTION){
//        et = [CCSprite spriteWithImageNamed:pbrWinInfo.cSprite];
//        et.opacity = opacity;
//        et.color = [CCColor colorWithCcColor3b:ccc3(mOriginalCenterColor.r/1.5,mOriginalCenterColor.g/1.5,mOriginalCenterColor.b/1.5)];
//        [mBatch addChild:et z:-1];
//    }
//    
//    mAdaptToTxt = adaptToText;
//    mHasBorder = hasBorder;
//    mTxtAnchor = txtAnchor;
//    mTxtOffset = txtOffset;
//    CGSize size = [self adaptSize];
//
//    if(isDynamic){
//        //Shouldnt work
//        self = [super init];
//        
//        mBatch.position = ccp(0,0);
//        mBatch.anchorPoint = ccp(0,0);
//
//        _contentSize = size;
//        
//        [self addChild:mBatch];
//        [self addChild:mLabelText];
//        
//        [self setCascadeOpacityEnabled:YES];
//    }
//    else{
//        __unsafe_unretained CCRenderTexture *rt = [self createTexture:mTextureWidth :mTextureHeight];
//        mWindow = [CCSprite spriteWithTexture:rt.sprite.texture];
//        
//        mWindow.anchorPoint = ccp(0,0);
//        [self addChild:mWindow];
//        
//        self.contentSize = mWindow.contentSize;
//        self.preferredSize = mWindow.contentSize;
//        self.maxSize = mWindow.contentSize;
//    }

//    if (mWindowStyle & STYLE_OK) {
//        XZWindow * okButton = [[[XZWindow alloc] initWithSize:CGSizeDouble(0,0)
//                                              backgroundOpacity:255 text:NSLocalizedString(@"Ok", nil)
//                                                  maxTextWidth:1000 textOffset:ccp(0,0)
//                                              adjustSizeToText:YES textAnchor:TXT_MIDDLE withStyle:STYLE_DYNAMIC
//                                                   cornerColor:cornerColor centerAndSideColor:centerAndSideColor];
//        
//        
//        CCSprite * okButtonSelected = [CCSprite spriteWithTexture:okButton.texture];
//        okButtonSelected.flipY = YES;
//        okButtonSelected.opacity = 128;
//        
//        CCMenuItemSprite * okMenuItem = [CCMenuItemSprite itemWithNormalSprite:okButton selectedSprite:okButtonSelected block:^(id sender) {
//            if(mBlock){
//                mBlock(YES);
//            }
//            else{
//                CCCallFuncXZND * callback = [[[CCCallFuncXZND alloc] initWithTarget:mTarget selector:mCallback data:(void*)BTN_OK];
//                [callback execute];
//                [mTarget setupControllerForLayer];
//            }
//            
//            [self removeFromParent];
//        }];
//
//        okMenuItem.anchorPoint = ccp(0.5, 1);
//        okMenuItem.position = ccp(self.contentSize.width/2, 0);
//
//        CCMenu * menu = [CCMenu menuWithItems:okMenuItem, nil];
//        menu.position = ccp(0,0);
//        [self addChild:menu];
//        
//        menu.touchPriority = -1001;
//        
//        [self createNavig:[NSMutableArray arrayWithObjects:okMenuItem, nil]];
//    }
//    else if(mWindowStyle & STYLE_YES_NO){
//        XZWindow * yesButton = [[XZWindow alloc] initWithSize:CGSizeDouble(100,40)
//                                             backgroundOpacity:255 text:NSLocalizedString(@"Yes", nil)
//                                                  maxTextWidth:1000 textOffset:ccp(0,0)
//                                              adjustSizeToText:NO textAnchor:TXT_MIDDLE withStyle:STYLE_DYNAMIC
//                                                   cornerColor:ccGREEN centerAndSideColor:centerAndSideColor];
//        
//        
//        CCSprite * yesButtonSelected = [CCSprite spriteWithTexture:yesButton.texture];
//        yesButtonSelected.flipY = YES;
//        yesButtonSelected.opacity = 128;
//        
//        CCMenuItemSprite * yesMenuItem = [CCMenuItemSprite itemWithNormalSprite:yesButton selectedSprite:yesButtonSelected block:^(id sender) {
//
//            if(mBlock){
//                mBlock(YES);
//            }
//            else{
//                CCCallFuncND * callback = [[[CCCallFuncND alloc] initWithTarget:mTarget selector:mCallback data:(void*)BTN_YES];
//                [mTarget setupControllerForLayer];
//                [callback execute];
//            }
//            
//            [self removeFromParent];
//        }];
//                
//
//        XZWindow * noButton = [[XZWindow alloc] initWithSize:CGSizeDouble(100,40)
//                                              backgroundOpacity:255 text:NSLocalizedString(@"No", nil)
//                                                   maxTextWidth:1000 textOffset:ccp(0,0)
//                                               adjustSizeToText:NO textAnchor:TXT_MIDDLE withStyle:STYLE_DYNAMIC
//                                                    cornerColor:ccRED centerAndSideColor:centerAndSideColor];
//        
//        
//        CCSprite * noButtonSelected = [CCSprite spriteWithTexture:noButton.texture];
//        noButtonSelected.flipY = YES;
//        noButtonSelected.opacity = 128;
//        
//        CCMenuItemSprite * noMenuItem = [CCMenuItemSprite itemWithNormalSprite:noButton selectedSprite:noButtonSelected block:^(id sender) {
//            if(mBlock){
//                mBlock(NO);
//            }
//            else{
//                CCCallFuncXZND * callback = [[[CCCallFuncXZND alloc] initWithTarget:mTarget selector:mCallback data:(void*)BTN_NO];
//                [mTarget setupControllerForLayer];
//                [callback execute];
//            }
//            
//            [self removeFromParent];
//        }];
//
//        yesMenuItem.anchorPoint = ccp(0, 1);
//        yesMenuItem.position = ccp(0, 0);
//
//        noMenuItem.anchorPoint = ccp(1, 1);
//        noMenuItem.position = ccp(self.contentSize.width, 0);
//        
//        CCMenu * menu = [CCMenu menuWithItems:yesMenuItem, noMenuItem, nil];
//        menu.position = ccp(0,0);
//        [self addChild:menu];
//        
//        menu.touchPriority = -1001;
//        
//        [self createNavig:[NSMutableArray arrayWithObjects:noMenuItem, yesMenuItem, nil]];
//    }
//    
//    return self;
//}


//-(void) setBlock:(void (^)(id))block{
//    [super setBlock:block];
//    
////    self.userInteractionEnabled = YES;
//}

- (void) touchEntered:(UITouch*) touch withEvent:(UIEvent*)event{
    self.opacity = 0.5;
}

- (void) touchExited:(UITouch*) touch withEvent:(UIEvent*) event{
    self.opacity = 1.0;
}

- (void) touchUpInside:(UITouch*) touch withEvent:(UIEvent*) event{
    self.opacity = 1.0;
    
    [self triggerAction];
}

- (void) touchUpOutside:(UITouch*) touch withEvent:(UIEvent*) event{
    self.opacity = 1.0;
}

-(void) recolorCenter:(ccColor3B) color{
//    c.color = [CCColor colorWithCcColor3b:color];
//    
//    if (mWindowStyle & STYLE_WITH_TOP_BORDER ||
//        mWindowStyle & STYLE_WITH_REFLECTION){
//        et.color = [CCColor colorWithCcColor3b: ccc3(color.r/1.5, color.g/1.5, color.b/1.5)];
//    }
}

-(void) recolorSide:(ccColor3B) color{
//    b.color = [CCColor colorWithCcColor3b:color];
//    l.color = [CCColor colorWithCcColor3b:color];
//    r.color = [CCColor colorWithCcColor3b:color];
//    t.color = [CCColor colorWithCcColor3b:color];
}

-(void) recolorCorners:(ccColor3B) color{
//    bl.color = [CCColor colorWithCcColor3b:color];
//    br.color = [CCColor colorWithCcColor3b:color];
//    tl.color = [CCColor colorWithCcColor3b:color];
//    tr.color = [CCColor colorWithCcColor3b:color];
}

-(void) resetColors{
//    [self recolorCorners:mOriginalCornerColor];
//    [self recolorCenter:mOriginalCenterColor];
//    [self recolorSide:mOriginalCenterColor];
}

-(void) changeStringColor:(ccColor3B) color{
    mLabelText.color = [CCColor colorWithCcColor3b: color];
}

-(void) changeString:(NSString*) str{
    mLabelText.string = str;
    
//    [self adaptSize];
}

//-(CGSize) adaptSize{
//    CGSize size = mSizeOrPadding;
//    CCSprite * legoPart = [CCSprite spriteWithImageNamed:@"bottom_left_corner2.png"];
//
//    if(mAdaptToTxt){
//        size = CGSizeMake(mSizeOrPadding.width + mLabelText.contentSize.width + legoPart.contentSize.width * 1 + (40),
//                          mSizeOrPadding.height + mLabelText.contentSize.height + legoPart.contentSize.height * 1 +(10));
//    }
//    
//    float stretchWidth = size.width;
//    float stretchHeight = size.height;
//    
//    if(mHasBorder){
//        stretchWidth -= (legoPart.contentSize.width * 2);
//        stretchHeight -= (legoPart.contentSize.height * 2);
//    }
//    
//    if(stretchWidth < 0) stretchWidth = 0;
//    if(stretchHeight < 0) stretchHeight = 0;
//    
//    float stretchScaleX = 2*stretchWidth/legoPart.contentSize.width;
//    float stretchScaleY = 2*stretchHeight/legoPart.contentSize.height;
//    
//    bl.anchorPoint = ccp(0,0);
//    bl.position = ccp(0,0);
//    b.anchorPoint = ccp(0,0);
//    b.scaleX = stretchScaleX;
//    b.position = ccp(bl.position.x + bl.contentSize.width, bl.position.y);
//    br.anchorPoint = ccp(0,0);
//    br.position = ccp(b.position.x + b.contentSize.width * stretchScaleX, bl.position.y);
//    l.anchorPoint = ccp(0,0);
//    l.scaleY = stretchScaleY;
//    l.position = ccp(bl.position.x, bl.position.y + bl.contentSize.height);
//    r.anchorPoint = ccp(0,0);
//    r.scaleY = stretchScaleY;
//    r.position = ccp(br.position.x+r.contentSize.width, l.position.y);
//    tl.anchorPoint = ccp(0,0);
//    tl.position = ccp(l.position.x, l.position.y + l.contentSize.height * stretchScaleY);
//    t.anchorPoint = ccp(0,0);
//    t.scaleX = stretchScaleX;
//    t.position = ccp(tl.position.x + tl.contentSize.width, tl.position.y+t.contentSize.height);
//    tr.anchorPoint = ccp(0,0);
//    tr.position = ccp(t.position.x + t.contentSize.width * stretchScaleX, tl.position.y);
//    c.anchorPoint = ccp(0,0);
//    c.scaleX = stretchScaleX+2;
//    c.scaleY = stretchScaleY+2;
//    c.position = ccp(b.position.x-b.contentSize.height, l.position.y-b.contentSize.width);
//    
//    if (mWindowStyle & STYLE_WITH_TOP_BORDER){
//        et.anchorPoint = ccp(0,1);
//        et.scaleX = stretchScaleX+2;
//        et.scaleY = 3.0f;
//        
//        et.position = ccp(b.position.x-b.contentSize.height, t.position.y);
//        
//        li.anchorPoint = ccp(0,1);
//        li.scaleX = stretchScaleX+2;
//        li.scaleY = 0.1f;
//        
//        li.position = ccp(b.position.x-b.contentSize.height, et.position.y- (24));
//    }
//    
//    if (mWindowStyle & STYLE_WITH_REFLECTION){
//        et.anchorPoint = ccp(0,0);
//        et.scaleX = stretchScaleX+2;
//        et.scaleY = 2;
//        et.position = ccp(b.position.x-b.contentSize.height, l.position.y-b.contentSize.height);
//    }
//    
//    mTextureWidth = bl.contentSize.width * 2 + stretchScaleX * legoPart.contentSize.width/2;
//    mTextureHeight = bl.contentSize.height * 2 + stretchScaleY * legoPart.contentSize.height/2;
//    
//    CGPoint txtPositionAnchor;
//    
//    float borderWidth = 0;
//    
//    if(mHasBorder)
//        borderWidth = (5);
//    
//    switch (mTxtAnchor) {
//        case TXT_TOP_LEFT:
//            mLabelText.anchorPoint = ccp(0,1);
//            txtPositionAnchor = ccp(borderWidth, mTextureHeight - borderWidth);
//            break;
//        case TXT_TOP:
//            mLabelText.anchorPoint = ccp(0.5,1);
//            txtPositionAnchor = ccp(mTextureWidth/2, mTextureHeight - borderWidth);
//            break;
//        case TXT_TOP_RIGHT:
//            mLabelText.anchorPoint = ccp(1,1);
//            txtPositionAnchor = ccp(mTextureWidth - borderWidth, mTextureHeight - borderWidth);
//            break;
//        case TXT_MIDDLE_LEFT:
//            mLabelText.anchorPoint = ccp(0,0.5);
//            txtPositionAnchor = ccp(borderWidth+ (3), mTextureHeight/2);
//            break;
//        case TXT_MIDDLE:
//            txtPositionAnchor = ccp(mTextureWidth/2, mTextureHeight/2);
//            break;
//        case TXT_MIDDLE_RIGHT:
//            mLabelText.anchorPoint = ccp(1,0.5);
//            txtPositionAnchor = ccp(mTextureWidth - borderWidth, mTextureHeight/2);
//            break;
//        case TXT_BOT_LEFT:
//            mLabelText.anchorPoint = ccp(0,0);
//            txtPositionAnchor = ccp(mTextureWidth - borderWidth, borderWidth);
//            break;
//        case TXT_BOT:
//            mLabelText.anchorPoint = ccp(0.5,0);
//            txtPositionAnchor = ccp(mTextureWidth/2, borderWidth);
//            break;
//        case TXT_BOT_RIGHT:
//            mLabelText.anchorPoint = ccp(1,0);
//            txtPositionAnchor = ccp(mTextureWidth - borderWidth, mTextureHeight - borderWidth);
//            break;
//        default:
//            break;
//    }
//    
//    mLabelText.position = ccpAdd(txtPositionAnchor, mTxtOffset);
//    
//    return size;
//}

//-(CCRenderTexture*) createTexture{
//    return [self createTexture:mTextureWidth :mTextureHeight];
//}
//
//-(CCRenderTexture*) createTexture:(int) width : (int) height{
//    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:width
//                                                           height:height];
//	[rt begin];
//    [mBatch visit];
//    [mLabelText visit];
//    [rt end];
//    
//    return rt;
//}
//
//-(CCTexture*) texture{
//    if(mWindowStyle & STYLE_DYNAMIC)
//        return [self createTexture].sprite.texture;
//    else
//        return self.texture;
//}

-(void) setOpacity:(CGFloat)opacity{
    [self updateDisplayedOpacity:opacity];
}

//-(void) updateDisplayedOpacity:(CGFloat)opacity{
//    if(mWindowStyle & STYLE_DYNAMIC){
//        c.opacity = et.opacity = li.opacity = bl.opacity = b.opacity = br.opacity = l.opacity = r.opacity = tl.opacity = t.opacity = tr.opacity = opacity;
//        mLabelText.opacity = opacity;
//    }
//    else{
//        [super updateDisplayedOpacity:opacity];
//    }
//}

//-(void) createNavig :(NSMutableArray*) navigArray{
//    mNavigButton = [[Navig2DMenuContainer alloc] initWithSize:CGSizeMake([navigArray count], 1) :YES];
//    [mNavigButton populateContainer:navigArray];
//    [self setupControllerForLayer];
//}

//-(void) onExit{
//    [[ControllerManager sharedInstance] removeControlProfile:mControlProfile];
//    mControlProfile = nil;
//
//    [super onExit];
//}
//
//-(void) setupControllerForLayer{
//    [[ControllerManager sharedInstance] setupMFIController];
//
//    if([GameKitManager sharedInstance].controllerConnected && mNavigButton){
//        [mNavigButton colorCurrentSelection];
//    }
//
//    if(mControlProfile == nil){
//        mControlProfile = [[ControlProfile alloc] initWithBlock:^(iCadeInfos icadeInfos){
//            
//            if(icadeInfos.button != iDpadNone){
//                //HANDLE iCade
//                
//                switch(icadeInfos.button){
//                    case iDpadDown:
//                        if(icadeInfos.isPressed)
//                            [mNavigButton moveDownAndColor];
//                        break;
//                    case iDpadUp:
//                        if(icadeInfos.isPressed)
//                            [mNavigButton moveUpAndColor];
//                        break;
//                    case iDpadLeft:
//                        if(icadeInfos.isPressed)
//                            [mNavigButton moveLeftAndColor];
//                        break;
//                    case iDpadRight:
//                        if(icadeInfos.isPressed)
//                            [mNavigButton moveRightAndColor];
//                        break;
//                        
//                    case iButtonA:
//                        if(icadeInfos.isPressed)
//                            [mNavigButton activate];
//                        break;
//                        
//                    case iButtonB:
////                        if(icadeInfos.isPressed)
////                            [mNavigButton activate];
//                        break;
//                    default:
//                        CCLOG(@"ignored iCade -> %d %d", icadeInfos.button, icadeInfos.isPressed);
//                        break;
//                }
//            }
//        }];
//    }
//    
//    [[ControllerManager sharedInstance] setControlProfile:mControlProfile];
//}

//-(void) setAnchorPoint:(CGPoint)anchorPoint{
//    [super setAnchorPoint:anchorPoint];
//
//    if(mWindowStyle & STYLE_DYNAMIC){
//        mBatch.anchorPoint = anchorPoint;
//    }
//    
////    if(m9SliceSprite)
////        [m9SliceSprite setAnchorPoint:anchorPoint];
//}

@end
