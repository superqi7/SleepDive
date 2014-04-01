//
//  MyScene.m
//  SleepDive
//
//  Created by Xiaoqi Liu on 3/18/14.
//  Copyright (c) 2014 Xiaoqi Liu. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    SKSpriteNode *_diverNode;
    SKSpriteNode *_portalNode;
    SKSpriteNode *_fireflyNode;
}


-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self initializeScene];
    }
    return self;
}

-(void)initializeScene
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    bg.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:bg];
    [self addDiver];
    [self addPortal];
}

-(void)addDiver
{
    _diverNode = [SKSpriteNode spriteNodeWithImageNamed:@"diver"];
    _diverNode.position = CGPointMake(100, 160);
    CGSize diverContactSize = CGSizeMake(160, 85);
    _diverNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:diverContactSize];
    _diverNode.physicsBody.dynamic = YES;
    
    [self addChild:_diverNode];
}

-(void)addPortal
{
    _portalNode = [SKSpriteNode spriteNodeWithImageNamed:@"portal"];
    _portalNode.position = CGPointMake(300, 260);
    CGSize contactSize = CGSizeMake(30, 60);
    _portalNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:contactSize];
    _portalNode.physicsBody.dynamic = NO;
    [self addChild:_portalNode];
}

-(void)addFireflies
{
    _fireflyNode = [SKSpriteNode spriteNodeWithImageNamed:@"firefly"];
    _fireflyNode.position = CGPointMake(300, 260);
    CGSize contactSize = CGSizeMake(30, 60);
    _fireflyNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:contactSize];
    _fireflyNode.physicsBody.dynamic = NO;
    [self addChild:_fireflyNode];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
