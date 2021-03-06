/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 * Copyright (c) 2013-2014 Cocos2D Authors
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
 *
 *
 * File autogenerated with Xcode. Adapted for cocos2d needs.
 */

#import <Foundation/Foundation.h>
#import "CCResponderManager.h"
#import "ccMacros.h"

#import <GameplayKit/GameplayKit.h>
/**
  CCResponder is the base class for all nodes.
  It exposes the touch and mouse interface to any node, which enables user interaction.
  It is somewhat similar to [UIResponder](https://developer.apple.com/library/IOs/documentation/UIKit/Reference/UIResponder_Class/index.html).
 
  To make a responder react to user interaction, the touchesXXX / mouseXXX event must be overridden in your node subclass.
  If a class does not implement these selectors, the event will be passed on to the next node in the Cocos2D responder chain.
  To force the events to be passed to next responder, call the super implementation before returning from the event.
 
 ### Subclassing Notes
 You should not create subclasses of CCResponder. Instead subclass from CCNode if you need a plain basic node, or other node classes that best fit the purpose.
 
 @note To handle touch events, the touchBegan method must always be overridden (implemented) in your node's subclass. It may remain empty.
 Otherwise the other touch events will not be received either if touchBegan is not implemented.

 */
@interface CCResponder : NSObject

/// -----------------------------------------------------------------------
/// @name Enabling Input Events
/// -----------------------------------------------------------------------

/** Enables user interaction on a node. */
@property ( nonatomic, assign, getter = isUserInteractionEnabled ) BOOL userInteractionEnabled;

/** Enables multiple touches inside a single node. */
@property ( nonatomic, assign, getter = isMultipleTouchEnabled ) BOOL multipleTouchEnabled;

/// -----------------------------------------------------------------------
/// @name Customize Event Behavior
/// -----------------------------------------------------------------------

/** 
 *  Continues to send touch events to the node that received the initial touchBegan, even when the touch has subsequently moved outside the node.
 *
 *  If set to NO, touches will be cancelled if they move outside the node's area.
 *  And if touches begin outside the node but subsequently move onto the node, the node will receive the touchBegan event.
 */
@property (nonatomic, assign) BOOL claimsUserInteraction;

/** 
 *  All other touches will be cancelled / ignored if a node with exclusive touch is active.
 *  Only one exclusive touch node can be active at a time.
 */
@property (nonatomic, assign, getter = isExclusiveTouch) BOOL exclusiveTouch;

/**
 *  Expands (or contracts) the hit area of the node.
 *  The expansion is calculated as a margin around the sprite, in points.
 */
@property (nonatomic, assign) CGSize hitAreaExpansion;

// purposefully undocumented: CCResponder should not be instantiated by users
- (id)init;

/// -----------------------------------------------------------------------
/// @name Performing Hit Tests
/// -----------------------------------------------------------------------

/**
 *  Check if a touch is inside the node. To allow custom touch detection, override this method in your node subclass.
 *
 *  @param pos Position in scene (world) coordinates.
 *
 *  @return Returns true if the position is inside the node.
 */
- (BOOL)hitTestWithWorldPos:(CGPoint)pos;

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -
#pragma mark Touch Handling Methods
/// -----------------------------------------------------------------------
/// @name Touch Handling Methods
/// -----------------------------------------------------------------------

/**
 Called when a touch began. Behavior notes:
 
 - If a touch is dragged inside a node which does not claim user interaction, a touchBegan event will be generated.
 - If node has exclusive touch, all other ongoing touches will be cancelled.
 - If a node wants to handle any touch event, the touchBegan method must be overridden in the node subclass. Overriding just touchMoved or touchEnded does not suffice.
 - To pass the touch further down the Cocos2D responder chain, call the super implementation, ie [super touchBegan:withEvent:].
 
 @param touch    Contains the touch.
 @param event    Current event information.
 @see CCTouch, CCTouchEvent
 */
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;

/**
 *  Called whan a touch moved.
 *
 *  @param touch    Contains the touch.
 *  @param event    Current event information.
 *  @see CCTouch, CCTouchEvent
 */
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;

/**
 *  Called when a touch ended.
 *
 *  @param touch    Contains the touch.
 *  @param event    Current event information.
 *  @see CCTouch, CCTouchEvent
 */
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;

/**
 *  Called when a touch was cancelled.
 *
 *  If a touch is dragged outside a node which does not claim user interaction, touchCancelled will be called.
 *  If another node with exclusive touch is activated, touchCancelled will be called for all ongoing touches.
 *
 *  @param touch    Contains the touch.
 *  @param event    Current event information.
 *  @see CCTouch, CCTouchEvent
 */
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;

#elif __CC_PLATFORM_MAC


#pragma mark -
#pragma mark Mouse Handling Methods
/// -----------------------------------------------------------------------
/// @name Mouse Handling Methods
/// -----------------------------------------------------------------------

/**
 *  Called when left mouse button is pressed inside a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)mouseDown:(NSEvent *)theEvent;

/**
 *  Called when left mouse button is held and mouse dragged for a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)mouseDragged:(NSEvent *)theEvent;

/**
 *  Called when left mouse button is released for a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)mouseUp:(NSEvent *)theEvent;

/**
 *  Called when right mouse button is pressed inside a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)rightMouseDown:(NSEvent *)theEvent;

/**
 *  Called when right mouse button is held and mouse dragged for a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)rightMouseDragged:(NSEvent *)theEvent;

/**
 *  Called when right mouse button is released for a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)rightMouseUp:(NSEvent *)theEvent;

/**
 *  Called when middle mouse button is pressed inside a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)otherMouseDown:(NSEvent *)theEvent;

/**
 *  Called when middle mouse button is held and mouse dragged for a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)otherMouseDragged:(NSEvent *)theEvent;

/**
 *  Called when middle mouse button is released for a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)otherMouseUp:(NSEvent *)theEvent;

/**
 *  Called when scroll wheel moved while mouse cursor is inside a node with userInteractionEnabled set to YES.
 *
 *  @param theEvent The event created.
 *  @see [NSEvent](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/)
 */
- (void)scrollWheel:(NSEvent *)theEvent;

#endif

@end
