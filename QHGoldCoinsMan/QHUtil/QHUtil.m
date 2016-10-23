//
//  QHUtil.m
//  QHGoldCoinsDemo
//
//  Created by chen on 16/10/17.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "QHUtil.h"

@implementation QHUtil

+ (int)getRandomNumber:(int)from to:(int)to {
    if (from > to) {
        int temp = from;
        from = to;
        to = temp;
    }
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
