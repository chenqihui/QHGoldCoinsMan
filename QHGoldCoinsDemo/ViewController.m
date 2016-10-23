//
//  ViewController.m
//  QHGoldCoinsDemo
//
//  Created by chen on 16/10/17.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "ViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#import "QHGoldCoinsView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)goGoldCoinsAction:(id)sender {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    QHGoldCoinsView *goldCoinsView = [QHGoldCoinsView createGoldCoinsViewToSuperView:self.view delegate:self];
    goldCoinsView.backgroundColor = [UIColor colorWithRed:0.09 green:0.13 blue:0.18 alpha:1.0];
}

@end
