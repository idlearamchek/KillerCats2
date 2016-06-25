//
//  XZWindow.h
//  PixelBoatRush
//
//  Created by Ghislain Bernier on 5/16/13.
//
//

#import "cocos2d.h"
#import "types.h"
#import "CCControl.h"

#ifdef CONTROLLER_ENABLED
#import "Navig2DMenuContainer.h"
#import "ControlProfile.h"
#endif

#define DEFAULT_SIDE_COLOR ccc3(255, 255, 255)
#define DEFAULT_SIDE_COLOR3 ccc3(45, 110, 235)
#define DEFAULT_SIDE_COLOR2 ccc3(29, 20, 230)
#define DEFAULT_SIDE_COLOR4 ccc3(25, 182, 205)
#define DEFAULT_CORNER_COLOR ccc3(255, 255, 255)
#define END_RACE_CENTER_COLOR ccc3(235, 110, 45)

typedef struct{
    __unsafe_unretained NSString * font;
    __unsafe_unretained NSString * blSprite;
    __unsafe_unretained NSString * bSprite;
    __unsafe_unretained NSString * brSprite;
    __unsafe_unretained NSString * lSprite;
    __unsafe_unretained NSString * rSprite;
    __unsafe_unretained NSString * tlSprite;
    __unsafe_unretained NSString * tSprite;
    __unsafe_unretained NSString * trSprite;
    __unsafe_unretained NSString * cSprite;
}sPBRWindowInfo;

CG_INLINE sPBRWindowInfo
PBRWinDefault(){
    sPBRWindowInfo pbrInfo;
    
    pbrInfo.font = @"digitalFontLarge.fnt";
    pbrInfo.blSprite = @"bottom_left_corner2.png";
    pbrInfo.bSprite = @"bottom.png";
    pbrInfo.brSprite = @"bottom_right_corner2.png";
    pbrInfo.lSprite = @"left.png";
    pbrInfo.rSprite = @"right.png";
    pbrInfo.tlSprite = @"top_left_corner2.png";
    pbrInfo.tSprite = @"top.png";
    pbrInfo.trSprite = @"top_right_corner2.png";
    pbrInfo.cSprite = @"centerAlone.png";
    
    return pbrInfo;
}

CG_INLINE sPBRWindowInfo
PBRWinAlternative(){
    sPBRWindowInfo pbrInfo;
    
    pbrInfo.font = @"digitalFontLarge.fnt";
    pbrInfo.blSprite = @"bottom_left_cornerB.png";
    pbrInfo.bSprite = @"bottomB.png";
    pbrInfo.brSprite = @"bottom_right_cornerB.png";
    pbrInfo.lSprite = @"leftB.png";
    pbrInfo.rSprite = @"rightB.png";
    pbrInfo.tlSprite = @"top_left_cornerB.png";
    pbrInfo.tSprite = @"topB.png";
    pbrInfo.trSprite = @"top_right_cornerB.png";
    pbrInfo.cSprite = @"centerB.png";
    
    return pbrInfo;
}

typedef enum{
    STYLE_NONE = 0,
	STYLE_BUTTON = 1,
    STYLE_WINDOW = 2,
    STYLE_WITH_TOP_BORDER = 4,
    STYLE_WITH_REFLECTION = 8,
    STYLE_NO_BORDER =  16,
    STYLE_DYNAMIC = 32, //means you can change colors/size after creation
    STYLE_OK = 64,
    STYLE_YES_NO = 128,
    STYLE_9SLICE = 256, //incompatible with most of the other style

}WindowStyle;

typedef enum{
    TXT_TOP_LEFT,
    TXT_TOP,
    TXT_TOP_RIGHT,
    TXT_MIDDLE_LEFT,
    TXT_MIDDLE,
    TXT_MIDDLE_RIGHT,
    TXT_BOT_LEFT,
    TXT_BOT,
    TXT_BOT_RIGHT
}XZTextAnchor;


typedef enum{
    BTN_OK,
    BTN_YES,
    BTN_NO    
}PBRButtonPressed;

@interface XZWindow : CCControl<CCTextureProtocol>{
//    CCSprite * mWindow;
//    
//    NSString * mText;
//    CGSize mSizeOrPadding;
//    GLubyte mOpacity;
//    
//    float mMaxtxtWidth;
//    CGPoint mTxtOffset;
//    BOOL mAdaptToTxt;
//    BOOL mHasBorder;
//    XZTextAnchor  mTxtAnchor;
//    int mWindowStyle;
//    
    CCLabelBMFont * mLabelText;
//    CCNode * mBatch;
//    
//    float mTextureWidth;
//    float mTextureHeight;
//
//    CCSprite * bl, *b, *br, *l, *r, *tl, *t, *tr, *c, *et, *li;
//    
//    id<ControlProtocol> mTarget;
//    SEL mCallback;
//
    void(^mBlock)(BOOL clickedYes);
//
//    ccColor3B mOriginalCenterColor;
//    ccColor3B mOriginalCornerColor;
    
    CCSprite9Slice * m9SliceSprite;
    
#ifdef CONTROLLER_ENABLED
    ControlProfile * mControlProfile;
    Navig2DMenuContainer * mNavigButton;
#endif

}

+(void) preloadTextures;

//-(CCRenderTexture*) createTexture;

//-(void) recolorCenter:(ccColor3B) color;
//-(void) recolorSide:(ccColor3B) color;
//-(void) recolorCorners:(ccColor3B) color;
//-(void) resetColors;
-(void) changeString:(NSString*) str;
-(void) changeStringColor:(ccColor3B) color;

@property (nonatomic, readonly, retain) NSString * text;
@property (nonatomic, readonly) int windowStyle;

//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat)opacity
//         withStyle: (int) style;
//
//-(id) initWithSize:(CGSize) sizeOrPadding backgroundOpacity:(CGFloat)opacity text:(NSString*) string maxTextWidth: (float) maxTextWidth textOffset:(CGPoint) txtOffset adjustSizeToText: (BOOL) adaptToText;
//
//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat)opacity
//              text:(NSString*) string
//      maxTextWidth: (float) maxTextWidth
//        textOffset:(CGPoint) txtOffset
//  adjustSizeToText: (BOOL) adaptToText
//        textAnchor:(XZTextAnchor) txtAnchor;
//
//-(id) initWithSize:(CGSize) sizeOrPadding
// backgroundOpacity:(CGFloat)opacity
//              text:(NSString*) string
//      maxTextWidth: (float) maxTextWidth
//        textOffset:(CGPoint) txtOffset
//  adjustSizeToText: (BOOL) adaptToText
//        textAnchor:(XZTextAnchor) txtAnchor
//         withStyle: (int) style;
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
//centerAndSideColor: (ccColor3B) centerAndSideColor;
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
//centerAndSideColor : (ccColor3B) centerAndSideColor
//                  :(sPBRWindowInfo) pbrWinInfo;

-(id) init9SliceWithSize:(CGSize) size
                    text:(NSString*) string
                   asset:(NSString*) asset
               textScale:(float) textScale;

-(id) init9SliceWithSize:(CGSize) size
                    text:(NSString*) string
                   asset:(NSString*) asset
               textScale:(float) textScale
              textOffset:(CGSize) txtOffset
                        :(BOOL) isWindow;

//-(id) initConfirmWindowWithTxt:(NSString*) str
//                    textAnchor:(XZTextAnchor) txtAnchor
//                     withStyle:(int) windowStyle
//                   cornerColor:(ccColor3B) cornerColor
//            centerAndSideColor:(ccColor3B) centerColor
//                         block:(void(^)(BOOL clickedYes))block;
//
//-(id) initConfirmWindowWithTxt:(NSString*) str
//                    textAnchor:(XZTextAnchor) txtAnchor
//                     withStyle:(int) windowStyle
//                   cornerColor:(ccColor3B) cornerColor
//            centerAndSideColor:(ccColor3B) centerColor
//                        target: (id<ControlProtocol>) target
//                     selector :(SEL) selector;

//@property (nonatomic,copy) void(^block)(id sender);

@end
