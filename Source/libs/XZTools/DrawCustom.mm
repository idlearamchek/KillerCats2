//
//  DrawCustom.m
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 4/7/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "DrawCustom.h"
#import "CCDrawNode.h"

@implementation DrawCustom

+(void) drawRectangle:(CGRect) rect :(ccColor4B) color {
    CGPoint glPoint = ccp(rect.origin.x,rect.origin.y);
    
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    
    glEnable(GL_LINE_WIDTH);
    glLineWidth(2);
    CGPoint vertices2[] = { ccp(glPoint.x,glPoint.y), 
        ccp(glPoint.x+rect.size.width,glPoint.y), 
        ccp(glPoint.x+rect.size.width,glPoint.y+rect.size.height),
        ccp(glPoint.x,glPoint.y+rect.size.height)
    };
    
    ccDrawPoly(vertices2, 4, YES);
    
    glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
    
    CHECK_GL_ERROR_DEBUG();
}

@end
