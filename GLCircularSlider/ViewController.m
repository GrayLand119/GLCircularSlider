//
//  ViewController.m
//  GLCircularSlider
//
//  Created by GrayLand on 17/3/6.
//  Copyright © 2017年 GrayLand. All rights reserved.
//

#import "ViewController.h"
#import "GLCircularSlider.h"

@interface ViewController ()

@property (nonatomic, strong) GLCircularSlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    label.font = [UIFont systemFontOfSize:26];
    label.textColor = [UIColor blackColor];
    
    _slider = [[GLCircularSlider alloc] initWithFrame:self.view.bounds];
    
    // 使用自带的风格拖动环 ,默认使用
//    _slider.touchRingView = [GLCircularSlider ringViewWithType:SliderRingTypeDefault];
    
    // 自定义拖动环
//    UIView *ringView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    ringView.backgroundColor = [UIColor greenColor];
//    _slider.touchRingView = ringView;

    // 值改变回调
    [_slider setDidValueChangedBlock:^(GLCircularSlider *slider, CGFloat value) {
        
        label.text = [NSString stringWithFormat:@"%.2f", value];
    }];
    
    [_slider reloadUI];
    
    [self.view addSubview:_slider];
    [self.view addSubview:label];
}

@end
