//
//  GameOverScene.m
//  ZombieConga
//
//  Created by Jonathan Taylor on 15/09/2014.
//  Copyright (c) 2014 Jonathan Taylor. All rights reserved.
//

#import "GameOverScene.h"
#import "MainMenuScene.h"
#import "MathUtils.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)size won:(BOOL)won
{
    if (self = [super initWithSize:size]) {
        
        NSString* imageFileName = (won) ? @"YouWin.png" : @"YouLose.png";
        NSString* soundFileName = (won) ? @"win.wav" : @"lose.wav";
        
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                             [SKAction playSoundFileNamed:soundFileName waitForCompletion:NO]]]];
        
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:imageFileName];
        bg.position = CGSizeGetMidPoint(self.size);
        [self addChild:bg];
        
        SKAction* wait = [SKAction waitForDuration:3.0];
        SKAction* block = [SKAction runBlock:^{
            SKScene* scene = [[MainMenuScene alloc] initWithSize:self.size];
            SKTransition* transition = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene:scene transition:transition];
        }];
        
        [self runAction:[SKAction sequence:@[wait, block]]];
    }
    
    return self;
}

@end
