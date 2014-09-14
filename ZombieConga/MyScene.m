//
//  MyScene.m
//  ZombieConga
//
//  Created by Jonathan Taylor on 13/09/2014.
//  Copyright (c) 2014 Jonathan Taylor. All rights reserved.
//

#import "MyScene.h"
#import "MathUtils.h"

static const CGFloat ZOMBIE_MOVE_POINTS_PER_SEC = 120.0f;
static const CGFloat ZOMBIE_ROTATE_RADIANS_PER_SEC = 4 * M_PI;

@implementation MyScene
{
    SKSpriteNode* _zombie;
    SKAction* _zombieAnimation;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
    CGPoint _lastTouchLocation;
    SKAction* _catCollisionSound;
    SKAction* _enemyCollisionSound;
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor whiteColor];
        
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        bg.position = CGRectGetMidPoint(self.frame);
        [self addChild:bg];
        
        _zombie = [SKSpriteNode spriteNodeWithImageNamed:@"zombie1"];
        _zombie.position = CGPointMake(100.0f, 100.0f);
        [self addChild:_zombie];
        
        NSMutableArray* textures = [NSMutableArray arrayWithCapacity:10];
        
        for (int i = 1; i < 4; i++) {
            NSString* textureName = [NSString stringWithFormat:@"zombie%d", i];
            SKTexture* texture = [SKTexture textureWithImageNamed:textureName];
            [textures addObject:texture];
        }
        
        for (int i = 4; i > 1; i--) {
            NSString* textureName = [NSString stringWithFormat:@"zombie%d", i];
            SKTexture* texture = [SKTexture textureWithImageNamed:textureName];
            [textures addObject:texture];
        }
        
        _zombieAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1f];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(spawnEnemy) onTarget:self],
                                                                           [SKAction waitForDuration:2.0]]]]];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(spawnCat) onTarget:self],
                                                                           [SKAction waitForDuration:1.0]]]]];
        
        _catCollisionSound = [SKAction playSoundFileNamed:@"hitCat.wav" waitForCompletion:NO];
        _enemyCollisionSound = [SKAction playSoundFileNamed:@"hitCatLady.wav" waitForCompletion:NO];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)currentTime
{
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    }
    else {
        _dt = 0.0;
    }
    
    _lastUpdateTime = currentTime;
    
    CGFloat distance = CGPointLength(CGPointSubtract(_zombie.position, _lastTouchLocation));
    
    if (distance <= ZOMBIE_MOVE_POINTS_PER_SEC * _dt) {
        _zombie.position = _lastTouchLocation;
        _velocity = CGPointZero;
        [self stopZombieAnimation];
    }
    else {
        [self moveSprite:_zombie velocity:_velocity];
        [self rotateSprite:_zombie toFace:_velocity rotateRadiansPerSec:ZOMBIE_ROTATE_RADIANS_PER_SEC];
        [self boundsCheckZombie];
    }
}

- (void)didEvaluateActions
{
    [self checkCollisions];
}

- (void)spawnEnemy
{
    SKSpriteNode* enemy = [SKSpriteNode spriteNodeWithImageNamed:@"enemy"];
    enemy.position = CGPointMake(self.size.width + enemy.size.width/2,
                                 ScalarRandomRange(enemy.size.height/2, self.size.height - enemy.size.height/2));
    enemy.name = @"enemy";
    [self addChild:enemy];
    SKAction* actionMove = [SKAction moveToX:-enemy.size.width/2 duration:2.0];
    SKAction* actionRemove = [SKAction removeFromParent];
    [enemy runAction:[SKAction sequence:@[actionMove, actionRemove]]];
}

- (void)spawnCat
{
    SKSpriteNode* cat = [SKSpriteNode spriteNodeWithImageNamed:@"cat"];
    cat.position = CGPointMake(ScalarRandomRange(0.0f, self.size.width),
                               ScalarRandomRange(0.0f, self.size.height));
    cat.xScale = 0.0f;
    cat.yScale = 0.0f;
    cat.zRotation = -M_PI / 16.0;
    cat.name = @"cat";
    [self addChild:cat];
    
    SKAction* appear = [SKAction scaleTo:1.0f duration:0.5];
    SKAction* disappear = [SKAction scaleTo:0.0f duration:0.5];
    SKAction* remove = [SKAction removeFromParent];
    
    SKAction* leftWiggle = [SKAction rotateByAngle:M_PI / 8.0 duration:0.5];
    SKAction* rightWiggle = [leftWiggle reversedAction];
    SKAction* fullWiggle = [SKAction sequence:@[leftWiggle, rightWiggle]];
    
    SKAction* scaleUp = [SKAction scaleBy:1.2f duration:0.25];
    SKAction* scaleDown = [scaleUp reversedAction];
    SKAction* fullScale = [SKAction sequence:@[scaleUp, scaleDown, scaleUp, scaleDown]];
    
    SKAction* group = [SKAction group:@[fullScale, fullWiggle]];
    SKAction* groupWait = [SKAction repeatAction:group count:10];
    
    [cat runAction:[SKAction sequence:@[appear, groupWait, disappear, remove]]];
}

- (void)moveSprite:(SKSpriteNode*)sprite velocity:(CGPoint)velocity
{
    CGPoint amountToMove = CGPointMultiplyScalar(velocity, _dt);
    sprite.position = CGPointAdd(sprite.position, amountToMove);
}

- (void)startZombieAnimation
{
    if (![_zombie actionForKey:@"animation"]) {
        [_zombie runAction:[SKAction repeatActionForever:_zombieAnimation] withKey:@"animation"];
    }
}

- (void)stopZombieAnimation
{
    [_zombie removeActionForKey:@"animation"];
}

- (void)moveZomebieToward:(CGPoint)location
{
    CGPoint offset = CGPointSubtract(location, _zombie.position);
    CGPoint direction = CGPointNormalise(offset);
    _velocity = CGPointMultiplyScalar(direction, ZOMBIE_MOVE_POINTS_PER_SEC);
    [self startZombieAnimation];
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

- (void)checkCollisions
{
    [self enumerateChildNodesWithName:@"cat" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode* cat = (SKSpriteNode*)node;
        if (CGRectIntersectsRect(cat.frame, _zombie.frame)) {
            [cat removeFromParent];
            [self runAction:_catCollisionSound];
        }
    }];
    
    [self enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode* enemy = (SKSpriteNode*)node;
        CGRect smallerFrame = CGRectInset(enemy.frame, 20.0f, 20.0f);
        if (CGRectIntersectsRect(smallerFrame, _zombie.frame)) {
            [enemy removeFromParent];
            [self runAction:_enemyCollisionSound];
        }
    }];
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
