//
//  GameScene.m
//  Project14
//
//  Created by Andrew Marmion on 14/02/2021.
//

#import "GameScene.h"
#import "WhackSlot.h"
#import "NSMutableArray+Shuffling.h"

@interface GameScene () ///<SKPhysicsContactDelegate>

@property (nonatomic) NSMutableArray<WhackSlot *> *slots;
@property (nonatomic) SKLabelNode *gameScore;
@property (nonatomic) NSInteger score;
@property (nonatomic) double popUpTime;
@property (nonatomic) int numRounds;

@end

@implementation GameScene
{

}

- (void)setScore:(NSInteger)score
{
    _score = score;
    if (self.gameScore) {
        [self.gameScore setText:[@"" stringByAppendingFormat:@"Score: %ld", (long)score]];
    }
}

- (void)didMoveToView:(SKView *)view {

    self.slots = [[NSMutableArray alloc] init];
    self.popUpTime = 0.85;
    self.numRounds = 0;

    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"whackBackground"];
    [background setPosition:CGPointMake(512, 384)];
    [background setBlendMode:SKBlendModeReplace];
    [background setZPosition:-1];
    [self addChild:background];

    self.gameScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [self.gameScore setText:@"Score: 0"];
    [self.gameScore setPosition:CGPointMake(8, 8)];
    [self.gameScore setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [self.gameScore setFontSize:48];
    [self addChild:self.gameScore];


    for (int i = 0; i < 5; i++) { [self createSlotAtPosition:CGPointMake(100 + (i * 170), 410)]; }
    for (int i = 0; i < 4; i++) { [self createSlotAtPosition:CGPointMake(180 + (i * 170), 320)]; }
    for (int i = 0; i < 5; i++) { [self createSlotAtPosition:CGPointMake(100 + (i * 170), 230)]; }
    for (int i = 0; i < 4; i++) { [self createSlotAtPosition:CGPointMake(180 + (i * 170), 140)]; }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self createEnemy];
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch *touch in touches) {

        CGPoint location = [touch locationInNode:self];
        NSArray<SKNode *> *nodes = [self nodesAtPoint:location];
        for (SKNode *node in nodes) {

            WhackSlot *slot = (WhackSlot *)[[node parent] parent];
            if (slot) {


                if ([node.name isEqual:@"charFriend"]) {
                    if (!slot.isVisible) { continue; }
                    if (slot.isHit) { continue; }
                    [slot hit];
                    self.score -= 5;

                    SKAction *playSound = [SKAction playSoundFileNamed:@"whackBad.caf" waitForCompletion:NO];
                    [self runAction:playSound];


                } else if ([node.name isEqual:@"charEnemy"]) {
                    if (!slot.isVisible) { continue; }
                    if (slot.isHit) { continue; }
                    [slot hit];

                    [[slot charNode] setXScale:0.85];
                    [[slot charNode] setYScale:0.85];

                    self.score += 1;

                    SKAction *playSound = [SKAction playSoundFileNamed:@"whack.caf" waitForCompletion:NO];
                    [self runAction:playSound];
                }
            }
        }
    }
}

- (void)createSlotAtPosition:(CGPoint)position
{
    WhackSlot *slot = [[WhackSlot alloc] init];
    [slot configureAtPosition:position];
    [self addChild:slot];
    [self.slots addObject:slot];
}

- (void)createEnemy
{
    self.numRounds += 1;

    if (self.numRounds >= 30) {
        for (WhackSlot *slot in self.slots) {
            [slot hide];
        }

        SKSpriteNode *gameOver = [SKSpriteNode spriteNodeWithImageNamed:@"gameOver"];
        [gameOver setPosition:CGPointMake(512, 384)];
        [gameOver setZPosition:1];
        [self addChild:gameOver];
        return;
    }

    self.popUpTime *= 0.991;
    [self.slots shuffle];
    [self.slots[0] showWithHideTime:self.popUpTime];

    if (arc4random_uniform(12) > 4) { [self.slots[1] showWithHideTime:self.popUpTime]; }
    if (arc4random_uniform(12) > 8) { [self.slots[2] showWithHideTime:self.popUpTime]; }
    if (arc4random_uniform(12) > 10) { [self.slots[3] showWithHideTime:self.popUpTime]; }
    if (arc4random_uniform(12) > 11) { [self.slots[4] showWithHideTime:self.popUpTime]; }


    double minDelay = self.popUpTime / 2.0;
    double maxDelay = self.popUpTime * 2.0;
    double delay = minDelay + arc4random_uniform(maxDelay - minDelay + 1);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self createEnemy];
    });
}


@end
