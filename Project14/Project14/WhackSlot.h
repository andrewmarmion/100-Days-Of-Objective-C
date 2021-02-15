//
//  WhackSlot.h
//  Project14
//
//  Created by Andrew Marmion on 14/02/2021.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WhackSlot : SKNode

@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL isHit;
@property (nonatomic) SKSpriteNode *charNode;

- (void)configureAtPosition:(CGPoint)position;
- (void)showWithHideTime:(double)hideTime;
- (void)hit;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
