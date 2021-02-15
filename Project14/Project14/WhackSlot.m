//
//  WhackSlot.m
//  Project14
//
//  Created by Andrew Marmion on 14/02/2021.
//

#import "WhackSlot.h"

@interface WhackSlot ()



@end

@implementation WhackSlot

- (void)configureAtPosition:(CGPoint)position
{

    self.isVisible = NO;
    self.isHit = NO;

    self.position = position;

    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"whackHole"];
    [self addChild:sprite];

    SKCropNode *cropNode = [[SKCropNode alloc] init];
    [cropNode setPosition:CGPointMake(0, 15)];
    [cropNode setZPosition:1];
    SKSpriteNode *whackMask = [SKSpriteNode spriteNodeWithImageNamed:@"whackMask"];
    [cropNode setMaskNode:whackMask];

    self.charNode = [SKSpriteNode spriteNodeWithImageNamed:@"penguinGood"];
    [self.charNode setPosition:CGPointMake(0, -90)];
    [self.charNode setName:@"character"];
    [cropNode addChild:self.charNode];

    [self addChild:cropNode];
}

- (void)showWithHideTime:(double)hideTime
{
    if (self.isVisible) { return; }

    SKAction *action = [SKAction moveByX:0 y:80 duration:0.05];
    [self.charNode runAction:action];
    self.isVisible = YES;
    self.isHit = NO;
    [self.charNode setXScale:1];
    [self.charNode setYScale:1];

    uint32_t randomInt = arc4random_uniform(2);
    if (randomInt == 0) {
        [self.charNode setTexture:[SKTexture textureWithImageNamed:@"penguinGood"]];
        [self.charNode setName:@"charFriend"];
    } else {
        [self.charNode setTexture:[SKTexture textureWithImageNamed:@"penguinEvil"]];
        [self.charNode setName:@"charEnemy"];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.5 * hideTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)hide
{
    if (!self.isVisible) { return; }

    SKAction *action = [SKAction moveByX:0 y:-80 duration:0.05];
    [self.charNode runAction:action];


    self.isVisible = NO;
}

- (void)hit
{
    self.isHit = YES;
    SKAction *delay = [SKAction waitForDuration:0.25];
    SKAction *hide = [SKAction moveByX:0 y:-80 duration:0.5];
    SKAction *notVisible = [SKAction runBlock:^{
        self.isVisible = false;
    }];

    SKAction *sequence = [SKAction sequence:@[delay, hide, notVisible]];
    [self.charNode runAction:sequence];
}

@end
