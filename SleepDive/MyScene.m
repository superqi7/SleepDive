//
//  MyScene.m
//  SleepDive
//
//  Created by Xiaoqi Liu on 3/18/14.
//  Copyright (c) 2014 Xiaoqi Liu. All rights reserved.
//

#import "MyScene.h"
static const float DIVER_MOVE_POINTS_PER_SEC = 120.0;
static const float BG_POINTS_PER_SEC = 120;

@implementation MyScene
{
    SKSpriteNode *_diverNode;
    SKSpriteNode *_portalNode;
    SKSpriteNode *_fireflyNode;
    int _currentlevel;
    CGPoint _velocity;
    NSTimeInterval _dt;
    NSTimeInterval _lastUpdateTime;
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
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundtest"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(i*bg.size.width, 0);
        bg.name = @"bg";
        //bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
    }
    
    [self addDiver];
    [self addPortal];
}

-(void)moveBg
{
    [self enumerateChildNodesWithName:@"bg" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *bg = (SKSpriteNode *) node;
        CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
        
        bg.position = CGPointMake(bg.position.x  + bgVelocity.x/60 * _currentlevel, 0);
    }];
}

-(void)movePortal

{
    [self enumerateChildNodesWithName:@"portal" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *portal= (SKSpriteNode *) node;
        CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
        
        portal.position = CGPointMake(portal.position.x  + bgVelocity.x/60* _currentlevel, 0);
    }];
}
-(void)addDiver
{
    _diverNode = [SKSpriteNode spriteNodeWithImageNamed:@"diver"];
    _diverNode.position = CGPointMake(180, 160);
    CGSize diverContactSize = CGSizeMake(160, 85);
    _diverNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:diverContactSize];
    _diverNode.physicsBody.dynamic = NO;
    
    [self addChild:_diverNode];
}



-(void)addPortal
{
    _portalNode = [SKSpriteNode spriteNodeWithImageNamed:@"portal"];
    _portalNode.position = CGPointMake(300, 260);
    CGSize contactSize = CGSizeMake(30, 60);
    _portalNode.name = @"portal";
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
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveDiver:touchLocation];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveDiver:touchLocation];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveDiver:touchLocation];

}

-(void)update:(CFTimeInterval)currentTime
{   if (_lastUpdateTime){
    _dt = currentTime - _lastUpdateTime;
}else{
    _dt = 0;
}
    _lastUpdateTime = currentTime;
    
    _currentlevel = 2;
    _diverNode.position = CGPointMake(_diverNode.position.x+2*_currentlevel, _diverNode.position.y);
    [self moveSprite: _diverNode velocity:_velocity];
    [self moveBg];
    [self movePortal];
}

-(void)moveDiver:(CGPoint)location
{   CGPoint offset;
    if (location.x - _diverNode.position.x < 0)
    {offset = CGPointMake(0, location.y - _diverNode.position.y);
    }
    else{
        offset = CGPointMake(location.x - _diverNode.position.x, location.y - _diverNode.position.y);
    }
//    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
//    CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
    
    _velocity = CGPointMake(0, offset.y);
}

-(void)moveSprite:(SKSpriteNode *)sprite velocity:(CGPoint)velocity
{
   CGPoint amountToMove = CGPointMake(0, velocity.y * _dt);
    
    sprite.position = CGPointMake(180, sprite.position.y +amountToMove.y);
}
@end
