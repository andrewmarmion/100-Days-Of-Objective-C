//
//  GameScene.m
//  Project17
//
//  Created by Andrew Marmion on 18/02/2021.
//

#import "GameScene.h"
#import "NSArray+Random.h"

@interface GameScene() <SKPhysicsContactDelegate>

@property (nonatomic) int score;

@end

@implementation GameScene {
//    SKShapeNode *_spinnyNode;
//    SKLabelNode *_label;

    SKEmitterNode *starfield;
    SKSpriteNode *player;
    SKLabelNode *scoreLabel;
    NSArray<NSString *> *possibleEnemies;
    BOOL isGameOver;
    NSTimer *gameTimer;
    int enemyCount;
    NSTimeInterval spawnInterval;
}

- (void)setScore:(int)score
{
    _score = score;
    if (scoreLabel) {
        [scoreLabel setText:[@"Score: " stringByAppendingFormat:@"%d", score]];
    }
}

- (void)didMoveToView:(SKView *)view {

    [self setBackgroundColor:[UIColor blackColor]];
    possibleEnemies = @[@"ball", @"hammer", @"tv"];
    isGameOver = NO;
    enemyCount = 0;
    spawnInterval = 1;

    gameTimer = [NSTimer scheduledTimerWithTimeInterval:spawnInterval
                                                 target:self
                                               selector:@selector(createEnemy)
                                               userInfo:NULL
                                                repeats:YES];

    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;

    starfield = [SKEmitterNode nodeWithFileNamed:@"starfield"];
    [starfield setPosition:CGPointMake(width, height / 2)];
    [starfield advanceSimulationTime:10];

    [self addChild:starfield];
    [starfield setZPosition:-1];

    player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    [player setName:@"player"];
    [player setPosition:CGPointMake(100, height / 2)];
    [player setPhysicsBody:[SKPhysicsBody bodyWithTexture:player.texture size:player.size]];
    [[player physicsBody] setContactTestBitMask:1];
    [self addChild:player];

    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [scoreLabel setPosition:CGPointMake(16, 16)];
    [scoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [scoreLabel setZPosition:-1];
    [self addChild:scoreLabel];

    self.score = 0;

    [self.physicsWorld setGravity:CGVectorMake(0, 0)];
    [self.physicsWorld setContactDelegate:self];
}



-(void)update:(CFTimeInterval)currentTime {
    for (SKNode *node in self.children) {
        if (node.position.x < -300) {
            [node removeFromParent];
        }

        if (!isGameOver) {
            self.score += 1;
        }
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKEmitterNode *explosion = [SKEmitterNode nodeWithFileNamed:@"explosion"];
    explosion.position = player.position;
    [self addChild:explosion];


    [player removeFromParent];

    isGameOver = YES;

    [starfield setPaused:YES];

    for (SKNode *node in self.children) {
        if ([node.name isEqual:@"enemy"]) {
            [node removeFromParent];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];

        SKNode *node = [self nodeAtPoint:location];

        if ([node.name isEqual:@"player"]) {
            if (location.y < 100) {
                location.y = 100;
            } else if (location.y > 668) {
                location.y = 668;
            }

            player.position = location;
        }

    }
}

- (void)createEnemy
{

    if (isGameOver) {
        [gameTimer invalidate];
        return;
    }

    NSString *enemy = [possibleEnemies randomObject];
    if (!enemy) { return; }

    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:enemy];
    [sprite setName:@"enemy"];
    CGFloat height = self.view.frame.size.height;
    uint32_t y = arc4random_uniform(height * 1.1) + 50;
    [sprite setPosition:CGPointMake(1200, (CGFloat)y)];
    [self addChild:sprite];

    [sprite setPhysicsBody:[SKPhysicsBody bodyWithTexture:sprite.texture size:sprite.size]];
    [sprite.physicsBody setContactTestBitMask:1];
    [sprite.physicsBody setVelocity:CGVectorMake(-500, 0)];
    [sprite.physicsBody setAngularVelocity:5];
    [sprite.physicsBody setLinearDamping:0];
    [sprite.physicsBody setAngularDamping:0];

    enemyCount += 1;

    if (enemyCount > 19 && enemyCount % 20 == 0) {
        [gameTimer invalidate];
        spawnInterval -= 0.1;
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:spawnInterval
                                                     target:self
                                                   selector:@selector(createEnemy)
                                                   userInfo:NULL
                                                    repeats:YES];
    }
}

@end
