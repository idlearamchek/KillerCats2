//
//  XZParticleSystem.m
//  cocos2dAndTemplate
//
//  Created by Ghislain Morrissette-Bernier on 8/20/12.
//  Copyright (c) 2012 XperimentalZ Games Inc. All rights reserved.
//

#import "XZParticleSystem.h"
#import "cocos2d.h"
#import "StatsManager.h"
#import "types.h"
#import "CCTextureCache.h"

@implementation XZParticleSmoke

-(id) init
{
    return [self initWithTotalParticles:140];
}

-(id) initWithTotalParticles:(NSUInteger) p
{
    if( (self=[super initWithTotalParticles:p]) ) {
        
        // _duration
        _duration = CCParticleSystemDurationInfinity;
        
        // Emitter mode: Gravity Mode
        self.emitterMode = CCParticleSystemModeGravity;
        
        // Gravity Mode: gravity
        self.gravity = ccp(0,0);
        
        // Gravity Mode: radial acceleration
        self.radialAccel = 0.0;
        self.radialAccelVar = 7.25;
        
        self.tangentialAccel = 0.0;
        self.tangentialAccelVar = 7.25;
        
        // Gravity Mode: speed of particles
        self.speed = 25;
        self.speedVar = 10;
        
        // _angle
        _angle = 90;
        _angleVar = 5;
                
        // emitter position
//        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        //self.position = ccp(0, 50);
        self.posVar = ccp(2, 2);
        
        // _life of particles
        _life = 2.0;
        _lifeVar = 0.5;
        
        // size, in pixels
        _startSize = 4.0f;
        _startSizeVar = 2.0f;
        _endSize = _startSize*2.5;
        
        // emits per frame
        _emissionRate = _totalParticles/_life;
        
        // color of particles
        _startColor.r = 1.0f;
        _startColor.g = 1.0f;
        _startColor.b = 1.0f;
        _startColor.a = 1.0f;
        _startColorVar.r = 0.0f;
        _startColorVar.g = 0.0f;
        _startColorVar.b = 0.0f;
        _startColorVar.a = 0.0f;
        _endColor.r = 0.7f;
        _endColor.g = 0.7f;
        _endColor.b = 0.7f;
        _endColor.a = 0.0f;
        _endColorVar.r = 0.0f;
        _endColorVar.g = 0.0f;
        _endColorVar.b = 0.0f;
        _endColorVar.a = 0.0f;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameplay.plist"];
        self.texture = [[CCTextureCache sharedTextureCache] addImage:@"particleAloneSmoke.png"];

        // additive
        self.blendAdditive = NO;
    }
    
    return self;
}
@end

@implementation XZParticleSmoke2

-(id) init
{
    return [self initWithTotalParticles:80];
}

-(id) initWithTotalParticles:(NSUInteger) p
{
    if( (self=[super initWithTotalParticles:p]) ) {
        
        // _duration
        _duration = CCParticleSystemDurationInfinity;
        
        // Emitter mode: Gravity Mode
        self.emitterMode = CCParticleSystemModeGravity;
        
        // Gravity Mode: gravity
        self.gravity = ccp(0,0);
        
        // Gravity Mode: radial acceleration
        self.radialAccel = 0.0;
        self.radialAccelVar = 7.25;
        
        self.tangentialAccel = 0.0;
        self.tangentialAccelVar = 7.25;
        
        // Gravity Mode: speed of particles
        self.speed = 25;
        self.speedVar = 10;
        
        // _angle
        _angle = 90;
        _angleVar = 5;
        
        // emitter position
        //        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        //self.position = ccp(0, 50);
        self.posVar = ccp(2, 2);
        
        // _life of particles
        _life = 2.0;
        _lifeVar = 0.5;
        
        // size, in pixels
        _startSize = 4.0f;
        _startSizeVar = 2.0f;
        _endSize = _startSize*2.5;
        
        // emits per frame
        _emissionRate = _totalParticles/_life;
        
        // color of particles
        _startColor.r = 0.25f;
        _startColor.g = 0.25f;
        _startColor.b = 0.25f;
        _startColor.a = 1.0f;
        _startColorVar.r = 0.0f;
        _startColorVar.g = 0.0f;
        _startColorVar.b = 0.0f;
        _startColorVar.a = 0.0f;
        _endColor.r = 0.25f;
        _endColor.g = 0.25f;
        _endColor.b = 0.25f;
        _endColor.a = 0.0f;
        _endColorVar.r = 0.0f;
        _endColorVar.g = 0.0f;
        _endColorVar.b = 0.0f;
        _endColorVar.a = 0.0f;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameplay.plist"];
        self.texture = [[CCTextureCache sharedTextureCache] addImage:@"particleAloneSmoke.png"];
        
        // additive
        self.blendAdditive = NO;
    }
    
    return self;
}
@end


@implementation XZParticleFire

-(id) init
{
	return [self initWithTotalParticles:10];
}


-(id) initWithTotalParticles:(NSUInteger)p
{
	if( (self=[super initWithTotalParticles:p]) ) {
		// duration
		_duration = -1;//0.04f;
		
		self.emitterMode = CCParticleSystemModeGravity;
        
		// Gravity Mode: gravity
		self.gravity = ccp(0,0);
		
		// Gravity Mode: speed of particles
		self.speed = 0;
		self.speedVar = 0;
		
		// Gravity Mode: radial
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 0;

        _particlePositionType = CCParticleSystemPositionTypeFree;
        
		// angle
//		_angle = 270;
		_angleVar = 10;
        
		// emitter position
//        CGSize winSize =  [CCDirector sharedDirector].viewSize;
//		self.position = ccp(winSize.width/2, winSize.height/2);
        self.position = ccp(0,0);
		_posVar = ccp(10,10);
		
		// life of particles
		_life = 0.4f;
		_lifeVar = 0.2f;
		
		// size, in pixels
		_startSize = 6.0f;
		_startSizeVar = 3.0f;
		_endSize = _startSize/2;
        
		// emits per second
		_emissionRate = _totalParticles/2.0f;

		// color of particles
        _startColor.r = 1.0f;
        _startColor.g = 1.0f;
        _startColor.b = 0.0f;
        _startColor.a = 1.0f;

//		// color of particles
//        _startColor.r = 1.0f;
//        _startColor.g = 0.5f;
//        _startColor.b = 0.0f;
//        _startColor.a = 1.0f;
//        
		_startColorVar.r = 0.0f;
		_startColorVar.g = 0.0f;
		_startColorVar.b = 1.0f;
		_startColorVar.a = 0.0f;
//		_endColorVar.r = 0.0f;
//		_endColorVar.g = 0.0f;
//		_endColorVar.b = 0.0f;
//		_endColorVar.a = 0.0f;
//        
        _endColor.r = 0.6f;
		_endColor.g = 0;
		_endColor.b = 0;
		_endColor.a = 0.3f;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameplay.plist"];
        
//        CCSpriteFrame * particuleFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"particleAlone.png"];
//        CCTexture * tex = nil;
//        
//        if(particuleFrame){
//            tex = particuleFrame.texture;
//            [self setTexture:tex withRect:particuleFrame.rect];
//        }
//        else{
//            CCSprite * spi = [CCSprite spriteWithImageNamed:@"particleAlone.png"];
//            tex = spi.texture;
//            [self setTexture:tex];
//        }
//        
        
        self.texture = [[CCTextureCache sharedTextureCache] addImage:@"particleAlone.png"];

		// additive
		self.blendAdditive = YES;
	}
	
	return self;
}

@end
@implementation XZParticleHp

-(id) init
{
    return [self initWithTotalParticles:80];
}

-(id) initWithTotalParticles:(NSUInteger) p
{
    if( (self=[super initWithTotalParticles:p]) ) {
        
        // _duration
        _duration = CCParticleSystemDurationInfinity;
        
        // Emitter mode: Gravity Mode
        self.emitterMode = CCParticleSystemModeGravity;
        
        // Gravity Mode: gravity
        self.gravity = ccp(0,0);
        
        // Gravity Mode: radial acceleration
        self.radialAccel = 0.0;
        self.radialAccelVar = 7.25;
        
        self.tangentialAccel = 0.0;
        self.tangentialAccelVar = 7.25;
        
        // Gravity Mode: speed of particles
        self.speed = 25;
        self.speedVar = 10;
        
        // _angle
        _angle = 90;
        _angleVar = 5;
        
        // emitter position
        //        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        //self.position = ccp(0, 50);
        self.posVar = ccp(2, 2);
        
        // _life of particles
        _life = 2.0;
        _lifeVar = 0.5;
        
        // size, in pixels
        _startSize = 6.0f;
        _startSizeVar = 3.0f;
        _endSize = _startSize*2.5;
        
        // emits per frame
        _emissionRate = _totalParticles/_life;
        
        // color of particles
        _startColor.r = 1.0f;
        _startColor.g = 1.0f;
        _startColor.b = 1.0f;
        _startColor.a = 1.0f;
        _startColorVar.r = 0.0f;
        _startColorVar.g = 0.0f;
        _startColorVar.b = 0.0f;
        _startColorVar.a = 0.0f;
        _endColor.r = 0.7f;
        _endColor.g = 0.7f;
        _endColor.b = 0.7f;
        _endColor.a = 0.0f;
        _endColorVar.r = 0.0f;
        _endColorVar.g = 0.0f;
        _endColorVar.b = 0.0f;
        _endColorVar.a = 0.0f;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameplay.plist"];
        self.texture = [[CCTextureCache sharedTextureCache] addImage:@"particleHP.png"];
        
        // additive
        self.blendAdditive = NO;
    }
    
    return self;
}
@end

