//
//  PointTransformationIpad.h
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 9/5/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import <Availability.h>
#import "CGPointExtension.h"
#import "GlobalSettings.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <CoreGraphics/CGGeometry.h>
    #define isIpad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
    #define isMac NO
    #define isRetina4 [GlobalSettings sharedInstance].isOnRetina4
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
#import <Foundation/Foundation.h>
    #define isRetina4 NO
    #define isIpad NO
    #define isMac YES
#endif

#define fromRetina3toRetina4X 1.1833
#define fromRetina3toRetina4Y 1
#define retina4ScaleX 2.3666
#define retina4ScaleY 2

#define xRetina4Offset 44

#define iPadScaleX 2.1333
#define iPadScaleY 2.4
#define iPadPhysicsScale 2

#define fromRetinaToIpadX 1.0666
#define fromRetinaToIpadY 1.2

#define xOffset 32
#define yOffset 64

CG_INLINE CGPoint
ccpIpad(CGFloat x, CGFloat y){
    if (isIpad){
        x *= iPadScaleX;
        y *= iPadScaleY;
    }
    else if(isMac){
        x *= 2;
        y *= 2;
    }
    else if(isRetina4){
        x *= fromRetina3toRetina4X;
        y *= fromRetina3toRetina4Y;        
    }
    
    return ccp(x,y);
}

CG_INLINE CGFloat 
xIpad(CGFloat x){
    if (isIpad){
        x *= iPadScaleX;
    }
    else if(isMac){
        x *= 2;
    }
    else if(isRetina4){
        x *= fromRetina3toRetina4X;
    }


    return x;
}

CG_INLINE CGFloat 
yIpad(CGFloat y){
    if (isIpad){
        y *= iPadScaleY;
    }
    else if(isMac){
        y *= 2;
    }
    else if(isRetina4){
        y *= fromRetina3toRetina4Y;
    }

    return y;
}

CG_INLINE CGPoint 
ccpIpadWithOffset(CGFloat x, CGFloat y){
    if (isIpad){
        x *= 2;
        y *= 2;
        
        x += xOffset;
        y += yOffset;
    }
    else if(isMac){
        x *= 2;
        y *= 2;
    }
    else if(isRetina4){
        x *= fromRetina3toRetina4X;
        y *= fromRetina3toRetina4Y;
    }

    return ccp(x,y);
}

CG_INLINE CGFloat 
xIpadWithOffset(CGFloat x){
    if (isIpad){
        x *= 2;
        x += xOffset;
    }
    else if(isMac){
        x *= 2;
    }
    else if(isRetina4){
        x *= fromRetina3toRetina4X;
        x += xRetina4Offset;
    }

    
    return x;
}

CG_INLINE CGFloat 
yIpadWithOffset(CGFloat y){
    if (isIpad){
        y *= 2;
        y += yOffset;
    }
    else if(isMac){
        y *= 2;
        //super specific parameter, this can introduce lots of bugs. Added offset on mac to match iPad screen size and fix bugs but this could introduce bugs in other projects
        y += yOffset;
    }
    else if(isRetina4){
        y *= fromRetina3toRetina4Y;
    }

    return y;
}

CG_INLINE CGRect
CGRectScalarMult(CGRect rect, float f){
    return CGRectMake(rect.origin.x * f, rect.origin.y * f, rect.size.width * f, rect.size.height * f);
}

CG_INLINE CGRect
CGRectIpadDouble(CGRect rect){
    if (isIpad){
        return CGRectScalarMult(rect, 2);
    }
    else if(isMac){
        return CGRectScalarMult(rect, 2);
    }
    else
    {
        return rect;
    }

}

CG_INLINE CGRect
CGRectIpadScale(CGRect rect){
    if (isIpad){
        rect = CGRectMake(rect.origin.x * iPadScaleX, rect.origin.y * iPadScaleY, rect.size.width * iPadScaleX, rect.size.height * iPadScaleY);
    }
    else if(isMac){
        return CGRectScalarMult(rect, 2);
    }
    else if (isRetina4){
        rect = CGRectMake(rect.origin.x * fromRetina3toRetina4X, rect.origin.y * fromRetina3toRetina4Y, rect.size.width * fromRetina3toRetina4X, rect.size.height * fromRetina3toRetina4Y);
    }

    return rect;
}

CG_INLINE float
getRetina4ScaleX(){
    if (isRetina4){
        return fromRetina3toRetina4X;
    }
    else{
        return 1;
    }
}

CG_INLINE float
ipadDouble(float f){
    if (isIpad){
        f *= 2;
    }
    else if(isMac){
        f *= 2;
    }

    return f;
}

CG_INLINE CGPoint
ipadDoublePt(float x, float y){
    if (isIpad){
        x *= 2;
        y *= 2;
    }
    else if(isMac){
        x *= 2;
        y *= 2;
    }

    return ccp(x, y);
}

CG_INLINE CGPoint
ipadDoubleCGpt(CGPoint pt){
    if (isIpad){
        pt.x *= 2;
        pt.y *= 2;
    }
    else if(isMac){
        pt.x *= 2;
        pt.y *= 2;
    }

    return ccp(pt.x, pt.y);
}

CG_INLINE CGSize
CGSizeDouble(CGFloat x, CGFloat y){
    if (isIpad || isMac){
        x *= 2;
        y *= 2;
    }
    
    return CGSizeMake(x,y);
}
