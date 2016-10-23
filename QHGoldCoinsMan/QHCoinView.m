//
//  QHCoinView.m
//  QHGoldCoinsDemo
//
//  Created by chen on 16/10/17.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHCoinView.h"

@implementation QHCoinView

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Private

- (void)setup {
    self.backgroundColor = [UIColor colorWithRed:199/255.f green:124/255.f blue:72/255.f alpha:1];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.userInteractionEnabled = YES;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == YES) {
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
    }
}

@end
