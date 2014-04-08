//
//  MyScene.m
//  SleepDive
//
//  Created by Xiaoqi Liu on 3/18/14.
//  Copyright (c) 2014 Xiaoqi Liu. All rights reserved.
//
#import "SKTAudio.h"
#import "MyScene.h"
#import "SKTUtils.h"
@import AVFoundation;

typedef NS_OPTIONS(uint32_t, CNPhysicsCategory) {
    CNPhysicsCategoryDiver = 1 << 0,
    CNPhysicsCategoryPortal  = 1 << 1,
    CNPhysicsCategoryFirefly = 1 << 2,
    CNPhysicsCategoryEdge = 1 << 3,
    CNPhysicsCategoryLabel = 1 << 4,
    };

@interface MyScene()<SKPhysicsContactDelegate>
@end

static const float BG_POINTS_PER_SEC = 120;

@implementation MyScene
{
    SKNode *_gameNode;
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
    self.physicsWorld.contactDelegate = self;
    [self.physicsWorld setGravity:CGVectorMake(0, 0)];
    self.physicsBody.categoryBitMask = CNPhysicsCategoryEdge;
    
 //  for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        bg.anchorPoint = CGPointZero;
    bg.position = CGPointZero;
        bg.name = @"bg";
        //bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        //   }
    _gameNode = [SKNode node];
    [self addChild:_gameNode];
    
    _currentlevel = 1;
   // [self setupLevel:_currentlevel];

    [self addDiver];
    [self addPortal];
    [self addFirefly];
   
}

-(void)setupLevel:(int)levelNum
{
    NSString *fileName = [NSString stringWithFormat:@"level%i",levelNum];
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"plist"];
    //NSDictionary *level = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [[SKTAudio sharedInstance] playBackgroundMusic:@"bgmusic.mp3"];
////    [self addPortalAtPosition:CGPointFromString(level[@"portalPosition"])];
////    [self addFireflyAtPosition:CGPointFromString(level[@"portalPosition"])];
////   
//    

}
//-(void)moveBg
//{
//    [self enumerateChildNodesWithName:@"bg" usingBlock:^(SKNode *node, BOOL *stop) {
//        SKSpriteNode *bg = (SKSpriteNode *) node;
//        CGPoint bgVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
//        
//        bg.position = CGPointMake(bg.position.x  + bgVelocity.x/60 * _currentlevel, 0);
//    }];
//}

-(void)addDiver
{
    _diverNode = [SKSpriteNode spriteNodeWithImageNamed:@"diver"];
    _diverNode.position = CGPointMake(180, 160);
    CGSize diverContactSize = CGSizeMake(140, 35);
    _diverNode.physicsBody.dynamic = YES;
    _diverNode.physicsBody.allowsRotation = NO;
    _diverNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:diverContactSize];
    _diverNode.physicsBody.categoryBitMask = CNPhysicsCategoryDiver;
    _diverNode.physicsBody.collisionBitMask = CNPhysicsCategoryPortal | CNPhysicsCategoryEdge |CNPhysicsCategoryFirefly;
    _diverNode.physicsBody.contactTestBitMask =CNPhysicsCategoryPortal | CNPhysicsCategoryEdge |CNPhysicsCategoryFirefly;
//    [_diverNode.physicsBody setCategoryBitMask:CNPhysicsCategoryDiver];
//    [_diverNode.physicsBody setCollisionBitMask:CNPhysicsCategoryEdge | CNPhysicsCategoryFirefly | CNPhysicsCategoryPortal];
    
    [_gameNode addChild:_diverNode];
}

-(void)addPortal
{   for(int i = 0; i < 10; i++){
    _portalNode = [SKSpriteNode spriteNodeWithImageNamed:@"portal"];
    _portalNode.position = CGPointMake(800+300*i, RandomFloatRange(50, 300));
    CGSize portalContactSize = CGSizeMake(10, 50);
    _portalNode.name = @"portal";
    _portalNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:portalContactSize];
    _portalNode.physicsBody.categoryBitMask = CNPhysicsCategoryPortal;
    _portalNode.physicsBody.collisionBitMask = CNPhysicsCategoryDiver;
//    [_portalNode.physicsBody setCategoryBitMask:CNPhysicsCategoryPortal];
//    [_portalNode.physicsBody setCollisionBitMask:CNPhysicsCategoryDiver|CNPhysicsCategoryEdge];
    _portalNode.physicsBody.dynamic = NO;
    [_gameNode addChild:_portalNode];}
}


-(void)addFirefly
{   for(int i = 0; i < 20; i++){
    _fireflyNode = [SKSpriteNode spriteNodeWithImageNamed:@"firefly"];
    _fireflyNode.position = CGPointMake(400+210*i, RandomFloatRange(30, 300));
    CGSize fireflyContactSize = CGSizeMake(20, 20);
    _fireflyNode.name = @"firefly";
    _fireflyNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10 center:self.position];
    _fireflyNode.physicsBody.categoryBitMask = CNPhysicsCategoryFirefly;
    _fireflyNode.physicsBody.collisionBitMask = CNPhysicsCategoryDiver;
    _fireflyNode.physicsBody.dynamic = NO;
    
    [_gameNode addChild:_fireflyNode];
}
}

-(void)movePortal

{
    [_gameNode enumerateChildNodesWithName:@"portal" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *portal= (SKSpriteNode *) node;
        CGPoint portalVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
        
        portal.position = CGPointMake(portal.position.x + portalVelocity.x/120* _currentlevel, portal.position.y);
    }];
}

-(void)moveFirefly

{
    [_gameNode enumerateChildNodesWithName:@"firefly" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *firefly= (SKSpriteNode *) node;
      
        CGPoint fireflyVelocity = CGPointMake(-BG_POINTS_PER_SEC, 0);
        
        firefly.position = CGPointMake(firefly.position.x + fireflyVelocity.x/120* _currentlevel, firefly.position.y );
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
//    [self.physicsWorld enumerateBodiesAtPoint:touchLocation usingBlock:^(SKPhysicsBody *body, BOOL *stop) {
//        if (body.categoryBitMask == CNPhysicsCategoryPortal) {
//            
//            }
//            [body.node removeFromParent];
//            *stop = YES;}];

    if (touchLocation.y > self.frame.size.height/2) {
         [_diverNode.physicsBody applyImpulse:CGVectorMake(0, 20)];
    }
   else if (touchLocation.y < self.frame.size.height/2) {
        [_diverNode.physicsBody applyImpulse:CGVectorMake(0, -20)];
    }
   
   // [self moveDiver:touchLocation];
}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInNode:self];
//  //  [self moveDiver:touchLocation];
//
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInNode:self];
//    
//    
////    [self moveDiver:touchLocation];
//
//}

-(void)update:(CFTimeInterval)currentTime
{   if (_lastUpdateTime){
    _dt = currentTime - _lastUpdateTime;
}else{
    _dt = 0;
}
    _lastUpdateTime = currentTime;
    
    _currentlevel = 2;
    _diverNode.position = CGPointMake(_diverNode.position.x, _diverNode.position.y);
    [self moveSprite: _diverNode velocity:_velocity];
    
  //  [self moveBg];
    [self movePortal];
    [self moveFirefly];
    
    [[SKTAudio sharedInstance] playBackgroundMusic:@"bgMusic.mp3"];
}

//-(void)moveDiver:(CGPoint)location
//{   CGPoint offset;
//    if (location.x - _diverNode.position.x < 0)
//    {offset = CGPointMake(0, location.y - _diverNode.position.y);
//    }
//    else{
//        offset = CGPointMake(location.x - _diverNode.position.x, location.y - _diverNode.position.y);
//    }
////    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
////    CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
//    
//    _velocity = CGPointMake(0, offset.y);
//  
//}

-(void)moveSprite:(SKSpriteNode *)sprite velocity:(CGPoint)velocity
{
   CGPoint amountToMove = CGPointMake(0, velocity.y * _dt);
    
    sprite.position = CGPointMake(180, sprite.position.y +amountToMove.y);
   }

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contact");
    uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
   
    if (collision == (CNPhysicsCategoryDiver | CNPhysicsCategoryPortal)) {
       [self lose];
      //  [contact.bodyB.node removeFromParent];
      // [contact.bodyA.node removeFromParent];
    }
    if (collision == (CNPhysicsCategoryDiver | CNPhysicsCategoryFirefly)) {
        NSLog(@"colloct");
        [contact.bodyB.node removeFromParent];
         SKNode *diver = (contact.bodyA.categoryBitMask == CNPhysicsCategoryDiver)?(SKNode*)contact.bodyA.node:(SKNode*)contact.bodyB.node;
        if (diver.userData==nil) {
            diver.userData = [@{@"Count":@0} mutableCopy];
        }
        
        int newCount = [diver.userData[@"Count"] intValue]+1;
        NSLog(@"count: %i", newCount);
        if (newCount==10) {
            [diver removeFromParent];
            [self win];
            NSLog(@"you win");
            
        } else {
            diver.userData = [@{@"Count":@(newCount)} mutableCopy];
        }
    }
  
    
}
-(void)lose
{if(_currentlevel>1){
    _currentlevel--;
}  [_gameNode removeAllChildren];
    [self inGameMessage:@"Try again ..."];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:5.0]]]];

}

-(void)win{
    [_gameNode removeAllChildren];
        [self inGameMessage:@"Good job!"];
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:5.0]]]];

}
-(void)inGameMessage:(NSString*)text
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Regular"];
    label.text = text;
    label.fontSize = 64.0;
    label.color = [SKColor yellowColor];
    
    label.position = CGPointMake(self.frame.size.width/2, self.frame.size.height -100);
    
    label.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
    label.physicsBody.collisionBitMask = CNPhysicsCategoryEdge;
    label.physicsBody.categoryBitMask = CNPhysicsCategoryLabel;
    label.physicsBody.contactTestBitMask = CNPhysicsCategoryEdge;
    label.physicsBody.restitution = 0.7;
    
    [_gameNode addChild:label];
    
    //    [label runAction:[SKAction sequence:@[[SKAction waitForDuration:3.0],[SKAction removeFromParent]]]];
}


@end
