//
//
//  Created by Sergey Tikhonov http://haqu.net
//  Released under the MIT License
//

#import "Sky.h"
#import "Tools3.h"

@implementation Sky

-(id) init{
    [Sky loadAnimations];
    
    self = [super init];
    
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];

    mScreenW = screenSize.width;
    mScreenH = screenSize.height;

    mSprite = [CCSprite spriteWithImageNamed:@"bg.png"];
    mSprite.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:mSprite];

    mStarTimer = 1;
    
    return self;
}

-(void) showStarAt:(CGPoint) pt :(NSString*) starAnim{
    CCSprite * star = [CCSprite emptySprite];
    
    star.position = pt;
    
    CCAction * starAction = [CCActionSequence actions:[[CCActionAnimate alloc] initWithAnimation:[[CCAnimationCache sharedAnimationCache] animationByName:starAnim]],
                 [CCActionCallBlock actionWithBlock:^(){
        [star removeFromParent];
    }], nil];


    [self addChild:star];
    [star runAction:starAction];
}


-(void) updateManual:(CCTime)dt{
    mStarTimer -= dt;
    
    if(mStarTimer <= 0){
        mStarTimer = [Tools frandWithRange:0.03 :0.5];
        
        int randStar = rand() % 3;
        NSString * starAnim = STAR_SMALL_ANIM;
        
        if (randStar == 0)
            starAnim = STAR_MED_ANIM;
        else if (randStar == 1)
            starAnim = STAR_LARGE_ANIM;
        
        int ra = rand()%100;
        if (ra < 18){
            [self showStarAt:ccp([Tools frandWithRange:0 :mScreenW/4], [Tools frandWithRange:0 :mScreenH]) :starAnim];
        }
        else if (ra < 36){
            [self showStarAt:ccp([Tools frandWithRange:3*mScreenW/4 :mScreenW], [Tools frandWithRange:0 :mScreenH]) :starAnim];
        }
        else if (ra < 54){
           [self showStarAt:ccp([Tools frandWithRange:0 :mScreenW], [Tools frandWithRange:0 :mScreenH/4]) :starAnim];
        }
        else if (ra < 70){
            [self showStarAt:ccp([Tools frandWithRange:0 :mScreenW], [Tools frandWithRange:3*mScreenH/4 :mScreenH]) :starAnim];
        }
        else{
           [self showStarAt:ccp([Tools frandWithRange:0 :mScreenW], [Tools frandWithRange:0 :mScreenH]) :starAnim];
        }
    }
}

+(void) loadAnimations{
    if(![[CCAnimationCache sharedAnimationCache] animationByName:STAR_SMALL_ANIM]){
        NSMutableArray * frames = [NSMutableArray array];
                
        /*************** STAR_SMALL_ANIM *******************/
        
        for (int i = 0; i <= 3; i++) {
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star_small_animation_fr0%d.png", i]]];
        }
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[[CCAnimation alloc] initWithSpriteFrames:frames delay:0.12f] name:STAR_SMALL_ANIM];
        
        [frames removeAllObjects];
        
        /*************** STAR_MED_ANIM *******************/

        for (int i = 0; i <= 5; i++) {
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star_medium_animation_fr0%d.png", i]]];
        }
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[[CCAnimation alloc] initWithSpriteFrames:frames delay:0.12f] name:STAR_MED_ANIM];
        
        [frames removeAllObjects];
        
        /*************** STAR_LARGE_ANIM *******************/

        for (int i = 0; i <= 7; i++) {
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"star_large_animation_fr0%d.png", i]]];
        }
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[[CCAnimation alloc] initWithSpriteFrames:frames delay:0.12f] name:STAR_LARGE_ANIM];
        
        [frames removeAllObjects];
    }
}


@end
