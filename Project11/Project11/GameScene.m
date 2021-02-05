//
//  GameScene.m
//  Project11
//
//  Created by Andrew Marmion on 04/02/2021.
//

#import "GameScene.h"
#import "NSMutableArray+Shuffling.h"

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) NSInteger score;

@property (nonatomic) SKLabelNode *editLabel;
@property (nonatomic) BOOL editingMode;

@property (nonatomic) NSMutableArray<NSString *> *balls;

@property (nonatomic) SKLabelNode *ballCountLabel;
@property (nonatomic) NSInteger ballCount;

@property (nonatomic) SKLabelNode *gameOverLabel;
@property (nonatomic) BOOL playAllowed;

@end

@implementation GameScene {

}

- (void)setBallCount:(NSInteger)ballCount
{
    _ballCount = ballCount;
    NSString *text = [@"Balls: " stringByAppendingFormat:@"%ld", (long)ballCount];
    self.ballCountLabel.text = text;
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    NSString *text = [@"Score: " stringByAppendingFormat:@"%ld", (long)score];
    self.scoreLabel.text = text;
}

- (void)setEditingMode:(BOOL)editingMode
{
    if (editingMode) {
        self.editLabel.text = @"Done";
    } else {
        self.editLabel.text = @"Edit";
    }
    _editingMode = editingMode;
}


- (void)didMoveToView:(SKView *)view {

    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
    [background setPosition:CGPointMake(512, 384)];
    [background setBlendMode:SKBlendModeReplace];
    [background setZPosition:-1];
    [self addChild:background];

    CGRect frame = [self.view frame];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
    [self.physicsWorld setContactDelegate:self];

    [self makeSlotAtPosition:CGPointMake(128, 0) isGood:YES];
    [self makeSlotAtPosition:CGPointMake(384, 0) isGood:NO];
    [self makeSlotAtPosition:CGPointMake(640, 0) isGood:YES];
    [self makeSlotAtPosition:CGPointMake(896, 0) isGood:NO];

    [self makeBouncerAtPosition:CGPointMake(0, 0)];
    [self makeBouncerAtPosition:CGPointMake(256, 0)];
    [self makeBouncerAtPosition:CGPointMake(512, 0)];
    [self makeBouncerAtPosition:CGPointMake(768, 0)];
    [self makeBouncerAtPosition:CGPointMake(1024, 0)];

    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkDuster"];
    [self.scoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    [self.scoreLabel setPosition:CGPointMake(980, 700)];
    [self addChild:self.scoreLabel];

    self.editLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkDuster"];
    [self.editLabel setPosition:CGPointMake(80, 700)];
    [self addChild:self.editLabel];

    self.ballCountLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkDuster"];
    [self.ballCountLabel setPosition:CGPointMake(512, 700)];
    [self addChild:self.ballCountLabel];

    self.score = 0;
    self.editingMode = false;
    self.ballCount = 5;
    self.playAllowed = true;

    self.balls = [[NSMutableArray alloc] initWithArray:@[@"ballRed", @"ballBlue", @"ballGreen"] copyItems:YES];

    SKSpriteNode *line = [SKSpriteNode spriteNodeWithColor:[UIColor systemBlueColor]
                                                      size:CGSizeMake(1024, 2)];
    CGPoint lineCenter = CGPointMake(512, 600);
    [line setPosition:lineCenter];
    [self addChild:line];


}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (!self.playAllowed) { return; }

    for (UITouch * touch in touches) {
        CGPoint location = [touch locationInNode:self];

        NSArray<SKNode *> *objects = [self nodesAtPoint:location];

        if ([objects containsObject:self.editLabel]) {
            self.editingMode = !self.editingMode;
        } else {
            if (self.editingMode) {
                if (location.y < 600) {
                    uint32_t randomInt = arc4random_uniform(112) + 16;

                    CGFloat red = (CGFloat)arc4random_uniform(255) / 255.0;
                    CGFloat green = (CGFloat)arc4random_uniform(255) / 255.0;
                    CGFloat blue = (CGFloat)arc4random_uniform(255) / 255.0;

                    CGSize size = CGSizeMake((CGFloat)randomInt, 16);
                    UIColor *color = [UIColor colorWithRed:red
                                                     green:green
                                                      blue:blue
                                                     alpha:1.0];

                    SKSpriteNode *box = [SKSpriteNode spriteNodeWithColor:color
                                                                     size:size];
                    CGFloat zRotation = (CGFloat)arc4random_uniform(300) / 100.0;
                    [box setZRotation:zRotation];
                    [box setPosition:location];

                    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
                    [box setPhysicsBody:physicsBody];
                    [[box physicsBody] setDynamic:NO];
                    [box setName:@"box"];
                    [self addChild:box];
                }
            } else {

                if (location.y > 600) {

                    if (self.ballCount > 0) {
                        self.ballCount -= 1;
                        [self.balls shuffle];
                        NSString *ballName = self.balls[0];

                        SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:ballName];
                        CGFloat radius = [ball size].width / 2.0;

                        SKPhysicsBody * physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
                        [ball setPhysicsBody:physicsBody];

                        uint32_t  collisionBitMask = [[ball physicsBody] collisionBitMask];
                        [[ball physicsBody] setContactTestBitMask: collisionBitMask];

                        [[ball physicsBody] setRestitution:0.4];
                        [ball setPosition:location];
                        [ball setName:@"ball"];
                        [self addChild:ball];
                    }

                }

            }
        }
    }
}

- (void)makeBouncerAtPosition:(CGPoint)position
{
    SKSpriteNode *bouncer = [SKSpriteNode spriteNodeWithImageNamed:@"bouncer"];
    [bouncer setPosition:position];
    CGFloat radius = [bouncer size].width / 2.0;

    SKPhysicsBody * physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    [bouncer setPhysicsBody:physicsBody];
    [[bouncer physicsBody] setDynamic:NO];
    [self addChild:bouncer];
}

- (void)makeSlotAtPosition:(CGPoint)position isGood:(BOOL)isGood
{
    SKSpriteNode *slotBase;
    SKSpriteNode *slotGlow;

    if (isGood) {
        slotBase = [SKSpriteNode spriteNodeWithImageNamed:@"slotBaseGood"];
        slotGlow = [SKSpriteNode spriteNodeWithImageNamed:@"slotGlowGood"];
        [slotBase setName:@"good"];
    } else {
        slotBase = [SKSpriteNode spriteNodeWithImageNamed:@"slotBaseBad"];
        slotGlow = [SKSpriteNode spriteNodeWithImageNamed:@"slotGlowBad"];
        [slotBase setName:@"bad"];
    }
    [slotBase setPosition:position];
    [slotGlow setPosition:position];

    SKAction *spin = [SKAction rotateByAngle:M_PI duration:10];
    SKAction *repeatForever = [SKAction repeatActionForever:spin];
    [slotGlow runAction:repeatForever];

    SKPhysicsBody * physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:slotBase.size];
    [slotBase setPhysicsBody: physicsBody];
    [[slotBase physicsBody] setDynamic:NO];

    [self addChild:slotBase];
    [self addChild:slotGlow];
}

- (void)collisionBetweenBall:(SKNode *)ball andObject:(SKNode *)object
{
    if ([object.name isEqual:@"good"]) {
        [self destroyBall:ball];
        self.score += 1;
        self.ballCount += 1;
    } else if ([object.name isEqual:@"bad"]) {
        [self destroyBall:ball];
        self.score -= 1;
        [self handleAllBallsGone];
    } else if ([object.name isEqual:@"box"]) {
        [self destroyBall:object];
    }
}

- (void)handleAllBallsGone
{
    if (self.ballCount <= 0) {
        self.playAllowed = false;
        self.gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkDuster"];
        [self.gameOverLabel setPosition:CGPointMake(512, 384)];
        self.gameOverLabel.text = @"Game over!";
        [self addChild:self.gameOverLabel];
    }
}

- (void)destroyBall:(SKNode *)ball
{
    SKEmitterNode *fireParticles = [SKEmitterNode nodeWithFileNamed:@"FireParticles"];
    if (fireParticles) {
        [fireParticles setPosition:ball.position];
        [self addChild:fireParticles];
    }
    [ball removeFromParent];
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;

    if (!nodeA) { return; }
    if (!nodeB) { return; }


    if ([contact.bodyA.node.name isEqual:@"ball"]) {
        [self collisionBetweenBall:nodeA andObject:nodeB];
    } else if ([contact.bodyB.node.name isEqual:@"ball"]) {
        [self collisionBetweenBall:nodeB andObject:nodeA];

    }
}
@end

