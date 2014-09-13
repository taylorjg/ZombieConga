//
//  MyScene.m
//  ZombieConga
//
//  Created by Jonathan Taylor on 13/09/2014.
//  Copyright (c) 2014 Jonathan Taylor. All rights reserved.
//

#import "MyScene.h"
#import "MathUtils.h"

static const CGFloat ZOMBIE_MOVE_POINTS_PER_SEC = 120.0;
static const CGFloat ZOMBIE_ROTATE_RADIANS_PER_SEC = 4 * M_PI;

@implementation MyScene
{
    SKSpriteNode* _zombie;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
    CGPoint _lastTouchLocation;
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor whiteColor];
        
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        bg.position = CGRectGetMidPoint(self.frame);
        [self addChild:bg];
        
        _zombie = [SKSpriteNode spriteNodeWithImageNamed:@"zombie1"];
        _zombie.position = CGPointMake(100, 100);
        [self addChild:_zombie];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)currentTime
{
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    }
    else {
        _dt = 0;
    }
    
    _lastUpdateTime = currentTime;
    
    CGFloat distance = CGPointLength(CGPointSubtract(_zombie.position, _lastTouchLocation));
    
    if (distance <= ZOMBIE_MOVE_POINTS_PER_SEC * _dt) {
        _zombie.position = _lastTouchLocation;
        _velocity = CGPointZero;
    }
    else {
        [self moveSprite:_zombie velocity:_velocity];
        [self rotateSprite:_zombie toFace:_velocity rotateRadiansPerSec:ZOMBIE_ROTATE_RADIANS_PER_SEC];
        [self boundsCheckZombie];
    }
}

- (void)moveSprite:(SKSpriteNode*)sprite velocity:(CGPoint)velocity
{
    CGPoint amountToMove = CGPointMultiplyScalar(velocity, _dt);
    sprite.position = CGPointAdd(sprite.position, amountToMove);
}

- (void)moveZomebieToward:(CGPoint)location
{
    CGPoint offset = CGPointSubtract(location, _zombie.position);
    CGPoint direction = CGPointNormalise(offset);
    _velocity = CGPointMultiplyScalar(direction, ZOMBIE_MOVE_POINTS_PER_SEC);
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self touchesCommon:touches];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self touchesCommon:touches];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self touchesCommon:touches];
}

- (void)touchesCommon:(NSSet*)touches
{
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    _lastTouchLocation = touchLocation;
    [self moveZomebieToward:touchLocation];
}

- (void)boundsCheckZombie
{
    CGPoint newPosition = _zombie.position;
    CGPoint newVelocity = _velocity;
    
    CGPoint bottomLeft = CGPointZero;
    CGPoint topRight = CGPointFromSize(self.size);
    
    if (newPosition.x <= bottomLeft.x) {
        newPosition.x = bottomLeft.x;
        newVelocity.x = -newVelocity.x;
    }
    
    if (newPosition.x >= topRight.x) {
        newPosition.x = topRight.x;
        newVelocity.x = -newVelocity.x;
    }
    
    if (newPosition.y <= bottomLeft.y) {
        newPosition.y = bottomLeft.y;
        newVelocity.y = -newVelocity.y;
    }
    
    if (newPosition.y >= topRight.y) {
        newPosition.y = topRight.y;
        newVelocity.y = -newVelocity.y;
    }
    
    _zombie.position = newPosition;
    _velocity = newVelocity;
}

- (void)rotateSprite:(SKSpriteNode*)sprite toFace:(CGPoint)direction rotateRadiansPerSec:(CGFloat)rotateRadiansPerSec
{
    CGFloat shortest = ScalarShortestAngleBetween(_zombie.zRotation, CGPointToAngle(direction));
    CGFloat amountToRotate = rotateRadiansPerSec * _dt;
    if (fabsf(shortest) < amountToRotate) {
        amountToRotate = fabsf(shortest);
    }
    sprite.zRotation += ScalarSign(shortest) * amountToRotate;
}

@end
