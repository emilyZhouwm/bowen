//
//  ViewController.m
//  bowen
//
//  Created by zwm on 2018/7/30.
//  Copyright © 2018年 enhance. All rights reserved.
//

#import "ViewController.h"
#import "EHWaveView.h"
#import <CoreMotion/CoreMotion.h>

#ifndef HexRGB
#define HexRGB(rgbValue) [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xFF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha: 1.0]
#endif

@interface ViewController ()

@property (nonatomic, weak) EHWaveView *waterWaveView;
@property (nonatomic, strong) CMMotionManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w * 510.0f / 750.0f;
    CGFloat boW = h * 450.0f / 510.0f;
    
    CGRect waveFrame = CGRectMake((w - boW) / 2, 44 + (h - boW) / 2, boW, boW);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = waveFrame;
    gradientLayer.colors = @[(id)HexRGB(0xB05DDC).CGColor, (id)HexRGB(0x7035EE).CGColor];
    [self.view.layer addSublayer:gradientLayer];
    
    EHWaveView *waterWaveView = [[EHWaveView alloc] initWithFrame:waveFrame];
    [self.view addSubview:waterWaveView];
    _waterWaveView = waterWaveView;
    _waterWaveView.layer.cornerRadius = MIN(CGRectGetHeight(_waterWaveView.frame)/2, CGRectGetWidth(_waterWaveView.frame)/2);

    UIImageView *upView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, w, h)];
    [self.view addSubview:upView];
    [upView setImage:[UIImage imageNamed:@"bowen_up"]];

    _waterWaveView.percent = 0.4;
    [_waterWaveView startWave];

    _manager = [[CMMotionManager alloc] init];
    __weak typeof(self) weakSelf = self;
    if (_manager.deviceMotionAvailable) {
        _manager.deviceMotionUpdateInterval = 0.01f;
        [_manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                       withHandler:^(CMDeviceMotion *data, NSError *error) {
                                           if (data.gravity.z <= -0.99) {
                                               // 假如没有这里，手机放平时会疯狂
                                               weakSelf.waterWaveView.transform = CGAffineTransformMakeRotation(0.0);
                                           }
                                           else {
                                               double rotation = atan2(data.gravity.x, data.gravity.y) - M_PI;
                                               weakSelf.waterWaveView.transform = CGAffineTransformMakeRotation(rotation);
                                           }
                                       }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
