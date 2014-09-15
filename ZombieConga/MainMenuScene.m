//
//  MainMenuScene.m
//  ZombieConga
//
//  Created by Jonathan Taylor on 15/09/2014.
//  Copyright (c) 2014 Jonathan Taylor. All rights reserved.
//

#import "MainMenuScene.h"
#import "MyScene.h"
#import "MathUtils.h"

@implementation MainMenuScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"MainMenu.png"];
        bg.position = CGSizeGetMidPoint(self.size);
        [self addChild:bg];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    SKScene* scene = [[MyScene alloc] initWithSize:self.size];
    SKTransition* transition = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:scene transition:transition];
}

@end
