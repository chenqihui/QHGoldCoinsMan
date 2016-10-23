//
//  QHGoldCoinsView.m
//  QHGoldCoinsDemo
//
//  Created by chen on 16/10/17.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHGoldCoinsView.h"

#import "QHUtil.h"

#import "QHCoinView.h"
#import "QHFireworkView.h"

@interface QHGoldCoinsView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation QHGoldCoinsView

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - init

+ (QHGoldCoinsView *)createGoldCoinsViewToSuperView:(UIView *)superView delegate:(id)delegate {
    QHGoldCoinsView *view = [[[NSBundle mainBundle] loadNibNamed:@"QHGoldCoinsView" owner:nil options:nil] firstObject];
    [superView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(view);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[view]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    [view setup];
    return view;
}

#pragma mark - Private

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    [self p_addGoldCoins];
}

- (void)p_addGoldCoins {
    
    __block CGFloat timeDurationSum = 0;
    CGFloat coinCount = 40;
    CGFloat maxWidth = 160;
    CGFloat minWidth = 120;
    
    //设定滑动的总时间，可根据高度计算或者动态调控
    CGFloat timeSum = 10.0;
    //设置每个间隔时间
    CGFloat timeEveryStartDuration = timeSum/coinCount;
    //设置最大的滑动时间
    CGFloat timeEverySum = 4;
    
    //计算出每个开始滑动的时间
    CGFloat timeStartDuration = 0;
    //计算出每个滑动的使用时间
    CGFloat timeEvery = 0;
    //计算滑动时间中使用最长的时间做为最终的总滑动时间
    CGFloat timeTrueSum = timeSum;
    
    for (int i = 1; i <= coinCount; i++) {
        //使用最大和最小随机计算块的大小
        CGFloat imageWidth = 30 * [QHUtil getRandomNumber:minWidth to:maxWidth]*0.01;
        //随机y轴位置
        CGRect frame = CGRectMake([QHUtil getRandomNumber:0 to:[UIScreen mainScreen].bounds.size.width - imageWidth], -imageWidth, imageWidth, imageWidth);
        QHCoinView *coinView = [[QHCoinView alloc] initWithFrame:frame];
        [self.contentView addSubview:coinView];
        
        //根据块的大小计算出需要的时间
        timeEvery = imageWidth/(30*maxWidth*0.01)*timeEverySum;
        
        timeDurationSum = timeEveryStartDuration * i;
        //开始的间隔时间前后半个间隔时间的随机偏移
        CGFloat timeRamdomDuration = timeEveryStartDuration*0.5*([QHUtil getRandomNumber:0 to:1] == 1 ? 1 : -1);
        timeStartDuration = timeDurationSum + timeRamdomDuration;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeStartDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self p_startAnimationCoins:coinView duration:timeEvery];
        });
        
        //最大的动画时间：起始时间加滑动时间
        timeTrueSum = MAX(timeStartDuration + timeEvery, timeTrueSum);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeTrueSum * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)p_startAnimationCoins:(UIView<CAAnimationDelegate> *)coinView duration:(CGFloat)timeDuration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint:coinView.layer.position];
    CGPoint toPoint = coinView.layer.position;
    toPoint.y = [UIScreen mainScreen].bounds.size.height + coinView.frame.size.height;
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.duration = timeDuration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = coinView;
    [coinView.layer addAnimation:animation forKey:@"position"];
}

#pragma mark - Action

- (IBAction)coinTapAction:(id)sender {
    CALayer *tappedLayer;
    id layerDelegate = nil;
    UITapGestureRecognizer *theTapper = (UITapGestureRecognizer *)sender;
    CGPoint touchPoint = [theTapper locationInView: self];
    touchPoint = CGPointMake(touchPoint.x, touchPoint.y + 15);
    tappedLayer = [self.contentView.layer.presentationLayer hitTest:touchPoint];
    layerDelegate = [tappedLayer delegate];
    if ([layerDelegate isKindOfClass:[QHCoinView class]]) {
        QHCoinView *coinView = (QHCoinView *)layerDelegate;
        CGRect frame = ((CALayer *)coinView.layer.presentationLayer).frame;
        [coinView.layer removeAllAnimations];
        [coinView removeFromSuperview];
        
        //爆炸动画可自行更换
        QHFireworkView *fireworkV = [[QHFireworkView alloc] init];
        [self.contentView addSubview:fireworkV];
        [fireworkV fireworkAction:CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2)];
    }
}

- (IBAction)endGoldCoinsAction:(id)sender {
    NSArray *coinsArr = [self.contentView subviews];
    for (UIView *coinView in coinsArr) {
        [coinView.layer removeAllAnimations];
        [coinView removeFromSuperview];
    }
    [self.contentView removeFromSuperview];
    [self removeFromSuperview];
}

@end
