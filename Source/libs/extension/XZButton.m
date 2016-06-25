/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "XZButton.h"
#import "CCControlSubclass.h"

#import "cocos2d.h"
#import <objc/runtime.h>

#import "CCTextureCache.h"

#define kCCFatFingerExpansion 70

@implementation XZButton

+(void) preloadTextures
{
    [[CCTextureCache sharedTextureCache] addImage:@"window.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"window.plist"];
}

+ (id) buttonWithSpriteFrame:(CCSpriteFrame*) spriteFrame
{
    return [[self alloc] initWithSpriteFrame:spriteFrame];
}

+ (id) buttonWithSpriteFrame:(CCSpriteFrame*) spriteFrame highlightedSpriteFrame:(CCSpriteFrame*) highlighted disabledSpriteFrame:(CCSpriteFrame*) disabled
{
    return [[self alloc] initWithSpriteFrame:spriteFrame highlightedSpriteFrame: highlighted disabledSpriteFrame:disabled];
}

- (id) initWithSpriteFrame:(CCSpriteFrame*) spriteFrame
{
    self = [self initWithSpriteFrame:spriteFrame highlightedSpriteFrame:NULL disabledSpriteFrame:NULL];
    
    // Setup default colors for when only one frame is used
    [self setBackgroundColor:[CCColor colorWithWhite:0.7 alpha:1] forState:CCControlStateHighlighted];
    
    [self setBackgroundOpacity:0.5f forState:CCControlStateDisabled];
    
    return self;
}

- (id) initWithSpriteFrame:(CCSpriteFrame*) spriteFrame highlightedSpriteFrame:(CCSpriteFrame*) highlighted disabledSpriteFrame:(CCSpriteFrame*) disabled
{
    [XZButton preloadTextures];
    
    self = [super init];
    if (!self) return NULL;
    
    self.anchorPoint = ccp(0.5f, 0.5f);
    
    // Setup holders for properties
    _backgroundColors = [NSMutableDictionary dictionary];
    _backgroundOpacities = [NSMutableDictionary dictionary];
    _backgroundSpriteFrames = [NSMutableDictionary dictionary];
    
    // Setup background image
    if (spriteFrame)
    {
        _background = [CCSprite9Slice spriteWithSpriteFrame:spriteFrame];
        [self setBackgroundSpriteFrame:spriteFrame forState:CCControlStateNormal];
        self.preferredSize = spriteFrame.originalSize;
    }
    else
    {
        _background = [[CCSprite9Slice alloc] init];
    }
        
    if (highlighted)
    {
        [self setBackgroundSpriteFrame:highlighted forState:CCControlStateHighlighted];
        [self setBackgroundSpriteFrame:highlighted forState:CCControlStateSelected];
    }
    
    if (disabled)
    {
        [self setBackgroundSpriteFrame:disabled forState:CCControlStateDisabled];
    }
    
    [self addChild:_background z:0];
    
    // Setup original scale
    _originalScaleX = _originalScaleY = 1;
    
    [self needsLayout];
    [self stateChanged];
    
    return self;
}

- (void) layout
{
    CGSize size = [self convertContentSizeToPoints: self.preferredSize type:self.contentSizeType];
    
    CGSize maxSize = [self convertContentSizeToPoints:self.maxSize type:self.contentSizeType];
    
    if (maxSize.width > 0 && maxSize.width < size.width)
        size.width = maxSize.width;
    
    if (maxSize.height > 0 && maxSize.height < size.height)
        size.height = maxSize.height;
    
    _background.contentSize = size;
    _background.anchorPoint = ccp(0.5f,0.5f);
    _background.positionType = CCPositionTypeNormalized;
    _background.position = ccp(0.5f,0.5f);
    
    self.contentSize = [self convertContentSizeFromPoints: size type:self.contentSizeType];
    
    [super layout];
}
#if __CC_PLATFORM_IOS || __CC_PLATFORM_ANDROID

- (void) touchEntered:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (!self.enabled)
    {
        return;
    }
    
    if (self.claimsUserInteraction)
    {
        [super setHitAreaExpansion:CGSizeMake(_originalHitAreaExpansion.width + kCCFatFingerExpansion, _originalHitAreaExpansion.height + kCCFatFingerExpansion)];;
    }
    self.highlighted = YES;
}

- (void) touchExited:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    self.highlighted = NO;
}

- (void) touchUpInside:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [super setHitAreaExpansion:_originalHitAreaExpansion];
    
    if (self.enabled)
    {
        [self triggerAction];
    }
    
    self.highlighted = NO;
}

- (void) touchUpOutside:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [super setHitAreaExpansion:_originalHitAreaExpansion];
    self.highlighted = NO;
}

#elif __CC_PLATFORM_MAC

- (void) mouseDownEntered:(NSEvent *)event
{
    if (!self.enabled)
    {
        return;
    }
    self.highlighted = YES;
}

- (void) mouseDownExited:(NSEvent *)event
{
    self.highlighted = NO;
}

- (void) mouseUpInside:(NSEvent *)event
{
    if (self.enabled)
    {
        [self triggerAction];
    }
    self.highlighted = NO;
}

- (void) mouseUpOutside:(NSEvent *)event
{
    self.highlighted = NO;
}

#endif

- (void) triggerAction
{
    // Handle toggle buttons
    if (self.togglesSelectedState)
    {
        self.selected = !self.selected;
    }
    
    [super triggerAction];
}

- (void) updatePropertiesForState:(CCControlState)state
{
    // Update background
    _background.color = [self backgroundColorForState:state];
    _background.opacity = [self backgroundOpacityForState:state];
    
    CCSpriteFrame* spriteFrame = [self backgroundSpriteFrameForState:state];
    if (!spriteFrame) spriteFrame = [self backgroundSpriteFrameForState:CCControlStateNormal];
    _background.spriteFrame = spriteFrame;
    
    [self needsLayout];
}

- (void) stateChanged
{
    if (self.enabled)
    {
        // Button is enabled
        if (self.highlighted)
        {
            [self updatePropertiesForState:CCControlStateHighlighted];
            
            if (_zoomWhenHighlighted)
            {
                [_background runAction:[CCActionScaleTo actionWithDuration:0.1 scaleX:_originalScaleX*1.2 scaleY:_originalScaleY*1.2]];
            }
        }
        else
        {
            if (self.selected)
            {
                [self updatePropertiesForState:CCControlStateSelected];
            }
            else
            {
                [self updatePropertiesForState:CCControlStateNormal];
            }
            
            [_background stopAllActions];
			
            if (_zoomWhenHighlighted)
            {
                _background.scaleX = _originalScaleX;
                _background.scaleY = _originalScaleY;
            }
        }
    }
    else
    {
        // Button is disabled
        [self updatePropertiesForState:CCControlStateDisabled];
    }
}

#pragma mark Properties

-(void) setOpacity:(CGFloat)opacity{
    [super setOpacity:opacity];
    
    for (CCNode* item in _children) {
        [item setOpacity:opacity];
        [item updateDisplayedOpacity:opacity];
    }
}

- (void)updateDisplayedOpacity:(CGFloat)parentOpacity
{
    _displayColor.a = parentOpacity;
 
    for (CCNode* item in _children) {
        [item setOpacity:_displayColor.a];
        [item updateDisplayedOpacity:_displayColor.a];
    }
}

- (void) setHitAreaExpansion:(CGSize)hitAreaExpansion
{
    _originalHitAreaExpansion = hitAreaExpansion;
    [super setHitAreaExpansion:hitAreaExpansion];
}

- (CGSize) hitAreaExpansion
{
    return _originalHitAreaExpansion;
}

- (void)setColor:(CCColor *)color {
}

- (void) setBackgroundColor:(CCColor*)color forState:(CCControlState)state
{
    [_backgroundColors setObject:color forKey:[NSNumber numberWithInt:state]];
    [self stateChanged];
}

- (CCColor*) backgroundColorForState:(CCControlState)state
{
    CCColor* color = [_backgroundColors objectForKey:[NSNumber numberWithInt:state]];
    if (!color) color = [CCColor whiteColor];
    return color;
}

- (void) setBackgroundOpacity:(CGFloat)opacity forState:(CCControlState)state
{
    [_backgroundOpacities setObject:[NSNumber numberWithFloat:opacity] forKey:[NSNumber numberWithInt:state]];
    [self stateChanged];
}

- (CGFloat) backgroundOpacityForState:(CCControlState)state
{
    NSNumber* val = [_backgroundOpacities objectForKey:[NSNumber numberWithInt:state]];
    if (!val) return 1;
    return [val floatValue];
}

- (void) setBackgroundSpriteFrame:(CCSpriteFrame*)spriteFrame forState:(CCControlState)state
{
    if (spriteFrame)
    {
        [_backgroundSpriteFrames setObject:spriteFrame forKey:[NSNumber numberWithInt:state]];
    }
    else
    {
        [_backgroundSpriteFrames removeObjectForKey:[NSNumber numberWithInt:state]];
    }
    [self stateChanged];
}

- (CCSpriteFrame*) backgroundSpriteFrameForState:(CCControlState)state
{
    return [_backgroundSpriteFrames objectForKey:[NSNumber numberWithInt:state]];
}

- (NSArray*) keysForwardedToLabel
{
    return @[@"fontName",
            @"fontSize",
            @"opacity",
            @"color",
            @"fontColor",
            @"outlineColor",
            @"outlineWidth",
            @"shadowColor",
            @"shadowBlurRadius",
            @"shadowOffset",
            @"shadowOffsetType",
            @"horizontalAlignment",
            @"verticalAlignment"];
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([[self keysForwardedToLabel] containsObject:key])
    {
        [self needsLayout];
        return;
    }
    [super setValue:value forKey:key];
}

- (id) valueForKey:(NSString *)key
{
    if ([[self keysForwardedToLabel] containsObject:key])
    {
    }
    return [super valueForKey:key];
}

- (void) setValue:(id)value forKey:(NSString *)key state:(CCControlState)state
{
    if ([key isEqualToString:@"backgroundOpacity"])
    {
        [self setBackgroundOpacity:[value floatValue] forState:state];
    }
    else if ([key isEqualToString:@"backgroundColor"])
    {
        [self setBackgroundColor:value forState:state];
    }
    else if ([key isEqualToString:@"backgroundSpriteFrame"])
    {
        [self setBackgroundSpriteFrame:value forState:state];
    }
}

- (id) valueForKey:(NSString *)key state:(CCControlState)state
{
    if ([key isEqualToString:@"backgroundOpacity"])
    {
        return [NSNumber numberWithFloat:[self backgroundOpacityForState:state]];
    }
    else if ([key isEqualToString:@"backgroundColor"])
    {
        return [self backgroundColorForState:state];
    }
    else if ([key isEqualToString:@"backgroundSpriteFrame"])
    {
        return [self backgroundSpriteFrameForState:state];
    }
    
    return NULL;
}

@end
