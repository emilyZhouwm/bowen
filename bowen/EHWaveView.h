//
//  EHWaveView.h
//  bowen
//
//  Created by zwm on 2018/7/30.
//  Copyright © 2018年 enhance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHWaveView : UIView

@property (nonatomic, assign)   CGFloat percent;            // 百分比

- (void)startWave;
- (void)stopWave;
- (void)reset;

@end
