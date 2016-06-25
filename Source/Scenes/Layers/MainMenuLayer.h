//
//  MainMenuLayer.h
//  cocos2dAndTemplate
//
//  Created by Ghislain Bernier on 5/24/11.
//  Copyright 2011 XperimentalZ Games Inc. All rights reserved.
//

#import "cocos2d.h"
#import "XZWindow.h"
#import "types.h"
#import <MessageUI/MessageUI.h>

@interface MainMenuLayer : CCNode<MFMailComposeViewControllerDelegate>
{
    CGSize winSize;
    
    CCSprite * mBack;
    
    XZWindow * mStartBut;
    XZWindow * mExtraBut;
    XZWindow * mDebugBut;
    
    CCButton * mLeaderboardBut;
    
    /***** NEWS *****/
    
    CCSprite * mExclamationSprite;
    CCLabelBMFont * mSocialLabel;
    
    CCButton * mSocialWindowPanel;
    CCSprite * mSocialWindowSprite;
    CCButton * mXZButton;
    CCButton * mFacebookButton;
    CCButton * mTwitterButton;
    CCButton * mShareButton;
    CCButton * mShareTwitterButton;
    CCButton * mShareFacebookButton;
    CCButton * mGiftButton;
    
    CCLabelBMFont *mLabelShare;
    CCLabelBMFont *mLabelNews;
    CCLabelBMFont *mLabelGift;
    
    BOOL mIsSocialWindowOpen;
}

@end


