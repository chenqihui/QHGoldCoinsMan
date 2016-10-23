//
//  QHFireworkView.m
//  QHGoldCoinsDemo
//
//  Created by chen on 16/10/17.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHFireworkView.h"

#import "QHUtil.h"

@interface QHFireworkView ()

@property (nonatomic, strong) NSArray *colorsArr;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat size;
@property (nonatomic) CGFloat duration;
@property (nonatomic) NSInteger numberOfParticle;

@end

@implementation QHFireworkView

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    
    self.colorsArr = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.colorsArr = @[[UIColor colorWithRed:1 green:0.2 blue:0.29 alpha:1],
                       [UIColor colorWithRed:0.19 green:1.00 blue:0.65 alpha:1],
                       [UIColor colorWithRed:0.13 green:0.43 blue:1.00 alpha:1],
                       [UIColor colorWithRed:1 green:1 blue:0.60 alpha:1]];
    self.radius = 20.0;
    self.size = 140.0;
    self.duration = 0.5;
    self.numberOfParticle = 40;
}

#pragma mark - Action

- (void)fireworkAction:(CGPoint)center {
    for (int i = 0; i < self.numberOfParticle; i++) {
        [self.layer addSublayer:[self createCirle:center]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (CAShapeLayer *)createCirle:(CGPoint)center {
    
    CGFloat destinationX = center.x + [QHUtil getRandomNumber:0 to:self.size / 2]*([QHUtil getRandomNumber:0 to:1] == 1 ? 1 : -1);
    CGFloat destinationY = center.y + [QHUtil getRandomNumber:0 to:self.size / 2]*([QHUtil getRandomNumber:0 to:1] == 1 ? 1 : -1);
    
    CAShapeLayer *layer = [CAShapeLayer new];
    CGFloat currentRadius = ((CGFloat)[QHUtil getRandomNumber:self.radius * 0.8 to:self.radius * 1.2]) + [QHUtil getRandomNumber:self.radius * 0.8 to:self.radius * 1.2] * 0.01;
    UIBezierPath *cirlePath = [UIBezierPath bezierPathWithArcCenter:center radius:currentRadius startAngle:0 endAngle:((CGFloat)M_PI * 2) clockwise:YES];
    
    layer.path = cirlePath.CGPath;
    layer.fillColor = ((UIColor *)self.colorsArr[[QHUtil getRandomNumber:0 to:(int)(self.colorsArr.count - 1)]]).CGColor;
    
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"position.x"];
    anim1.toValue = [NSNumber numberWithFloat:destinationX];
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    anim2.toValue = [NSNumber numberWithFloat:destinationY];
    
    CABasicAnimation *anim3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim3.toValue = [NSNumber numberWithFloat:0.02];
    
    CAAnimationGroup *groupAnim = [CAAnimationGroup new];
    groupAnim.duration = self.duration;
    groupAnim.animations = @[anim1, anim2, anim3];
    groupAnim.removedOnCompletion = false;
    groupAnim.fillMode = kCAFillModeForwards;
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [CATransaction setCompletionBlock:^{
        [layer removeFromSuperlayer];
    }];
    
    [layer addAnimation:groupAnim forKey:nil];
    
    return layer;
}

@end
