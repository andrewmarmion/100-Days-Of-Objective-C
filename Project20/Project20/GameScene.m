//
//  GameScene.m
//  Project20
//
//  Created by Andrew Marmion on 17/03/2021.
//

#import "GameScene.h"
@interface GameScene()

@property (nonatomic) NSTimer *gameTimer;
@property (nonatomic) NSInteger score;

@property (nonatomic) NSMutableArray<SKNode *> *fireworks;
@property (nonatomic) SKLabelNode *scoreLabel;

@end

@implementation GameScene {
    CGFloat leftEdge;
    CGFloat bottomEdge;
    CGFloat rightEdge;

}

- (void)didMoveToView:(SKView *)view {
    leftEdge = 22;
    bottomEdge = -22;
    rightEdge = 1024 + 22;

    self.fireworks = [[NSMutableArray alloc] init];

    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"background"];
    [background setPosition:CGPointMake(512, 384)];
    [background setBlendMode:SKBlendModeReplace];
    [background setZPosition:-1];
    [self addChild:background];

//    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:6
//                                                      target:self
//                                                    selector:@selector(launchFireworks)
//                                                    userInfo:nil
//                                                     repeats:YES];

    [self launchFireworks];

    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkDuster"];
    [self.scoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    [self.scoreLabel setPosition:CGPointMake(980, 700)];
    [self addChild:self.scoreLabel];
    self.score = 0;
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    NSString *text = [@"Score: " stringByAppendingFormat:@"%ld", (long)score];
    self.scoreLabel.text = text;
}

- (void)createFireworkWithMovement:(CGFloat)xMovement x:(int)x y:(int)y
{
    SKNode *node = [[SKNode alloc] init];
    node.position = CGPointMake(x, y);

    SKSpriteNode *firework = [[SKSpriteNode alloc] initWithImageNamed:@"rocket"];
    firework.colorBlendFactor = 1;
    firework.name = @"firework";
    [node addChild:firework];

    uint32_t randomInt = arc4random_uniform(3);

    if (randomInt == 0) {
        firework.color = [UIColor cyanColor];
    } else if (randomInt == 1) {
        firework.color = [UIColor greenColor];
    } else {
        firework.color = [UIColor redColor];
    }

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(xMovement, 1000)];

    SKAction *move = [SKAction followPath:path.CGPath
                                 asOffset:YES
                             orientToPath:YES
                                    speed:50];
    [node runAction:move];

    SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"fuse"];
    if (emitter) {
        emitter.position = CGPointMake(0, -22);
        [node addChild:emitter];
    }

    [self.fireworks addObject:node];

    [self addChild:node];
}

- (void)launchFireworks
{
    CGFloat movementAmount = 1800;
    uint32_t randomInt = arc4random_uniform(4);

    if (randomInt == 0) {

        [self createFireworkWithMovement:0 x:512 y:bottomEdge];
        [self createFireworkWithMovement:0 x:512 - 200 y:bottomEdge];
        [self createFireworkWithMovement:0 x:512 - 100 y:bottomEdge];
        [self createFireworkWithMovement:0 x:512 + 100 y:bottomEdge];
        [self createFireworkWithMovement:0 x:512 + 200 y:bottomEdge];

    } else if (randomInt == 1) {

        [self createFireworkWithMovement:0 x:512 y:bottomEdge];
        [self createFireworkWithMovement:-200 x:512 - 200 y:bottomEdge];
        [self createFireworkWithMovement:-100 x:512 - 100 y:bottomEdge];
        [self createFireworkWithMovement:100 x:512 + 100 y:bottomEdge];
        [self createFireworkWithMovement:200 x:512 + 100 y:bottomEdge];

    } else if (randomInt == 2) {

        [self createFireworkWithMovement:movementAmount x:leftEdge y:bottomEdge + 400];
        [self createFireworkWithMovement:movementAmount x:leftEdge y:bottomEdge + 300];
        [self createFireworkWithMovement:movementAmount x:leftEdge y:bottomEdge + 200];
        [self createFireworkWithMovement:movementAmount x:leftEdge y:bottomEdge + 100];
        [self createFireworkWithMovement:movementAmount x:leftEdge y:bottomEdge];

    } else if (randomInt == 3) {

        [self createFireworkWithMovement:-movementAmount x:rightEdge y:bottomEdge + 400];
        [self createFireworkWithMovement:-movementAmount x:rightEdge y:bottomEdge + 300];
        [self createFireworkWithMovement:-movementAmount x:rightEdge y:bottomEdge + 200];
        [self createFireworkWithMovement:-movementAmount x:rightEdge y:bottomEdge + 100];
        [self createFireworkWithMovement:-movementAmount x:rightEdge y:bottomEdge];

    }
}


- (void)checkTouches:(NSSet<UITouch *> *)touches
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];

        NSArray<SKNode *> *nodesAtPoint = [self nodesAtPoint:location];

        for (SKNode *node in nodesAtPoint) {
            SKSpriteNode *spriteNode = (SKSpriteNode *)node;
            if (spriteNode) {
                if ([spriteNode.name isEqual:@"firework"]) {
                    for (SKNode *parent in self.fireworks) {
                        if (parent.children.count >= 1) {
                            SKSpriteNode *firework = (SKSpriteNode *)parent.children[0];
                            if (firework) {
                                if ([firework.name isEqual:@"selected"] && ![firework.color isEqual:spriteNode.color]) {
                                    firework.name = @"firework";
                                    firework.colorBlendFactor = 1;
                                }
                            }
                        }
                    }

                    [spriteNode setName:@"selected"];
                    [spriteNode setColorBlendFactor:0];
                }

            }
        }

    }
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self checkTouches:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self checkTouches:touches];
}

- (void)update:(NSTimeInterval)currentTime
{
    for (int i = ((int)self.fireworks.count - 1); i > -1; i--)
    {
        SKNode *firework = self.fireworks[i];
        if (firework.position.y > 900) {
            [self.fireworks removeObjectAtIndex:i];
            [firework removeFromParent];
        }
    }
}

- (void)explodeFirework:(SKNode *)firework
{
    SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"explode"];
    if (emitter) {
        [emitter setPosition:firework.position];
        [self addChild:emitter];

        SKAction *wait = [SKAction waitForDuration:5];

        [emitter runAction:wait completion:^{
            [emitter removeFromParent];
        }];
    }

    [firework removeFromParent];
}

- (void)explodeFireworks
{
    int numExploded = 0;

    for (int i = ((int)self.fireworks.count - 1); i > -1; i--) {
        SKNode * fireworkContainer = self.fireworks[i];
        if (fireworkContainer.children.count >= 1) {
            SKSpriteNode *firework = (SKSpriteNode *)fireworkContainer.children[0];
            if (firework) {
                if ([firework.name isEqual:@"selected"]) {
                    [self explodeFirework:fireworkContainer];
                    [self.fireworks removeObjectAtIndex:i];
                    numExploded += 1;
                }
            }
        }
    }

    if (numExploded == 1) {
        self.score += 200;
    }

    if (numExploded == 2) {
        self.score += 500;
    }

    if (numExploded == 3) {
        self.score += 1500;
    }

    if (numExploded == 4) {
        self.score += 2500;
    }

    if (numExploded == 5) {
        self.score += 4000;
    }
}
@end
