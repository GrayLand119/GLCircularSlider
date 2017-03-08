//
//  GLCircularSlider.h
//  GLCircularSlider
//
//  Created by GrayLand on 17/3/8.
//  Copyright © 2017年 GrayLand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLCircularSlider;


typedef NS_ENUM(NSUInteger, SliderRingType) {
    SliderRingTypeDefault = 0,
    SliderRingTypeCircle
};

typedef void (^GLCircularSliderDidValueChanged)(GLCircularSlider *slider, CGFloat value);

@interface GLCircularSlider : UIView

@property (nonatomic, assign) CGFloat minValue;///< default is 0.0f
@property (nonatomic, assign) CGFloat maxValue;///< default is 100.0f
@property (nonatomic, assign, getter = currentValue) CGFloat value;///< 当前的值

@property (nonatomic, copy) GLCircularSliderDidValueChanged didValueChangedBlock;///<刻度改变回调

// Style
@property (nonatomic, assign) CGFloat ringRadius;///< 环的半径, default is 100
@property (nonatomic, assign) CGFloat ringWidth;///< 环的宽度, default is 20;
@property (nonatomic, strong) UIColor *ringBackgroundColor;///< background color
@property (nonatomic, strong) UIColor *ringFrontColor;///< frontground color

@property (nonatomic, strong) CAShapeLayer *ringBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *ringGradiantLayer;
@property (nonatomic, strong) CAShapeLayer *ringFrontLayer;

@property (nonatomic, strong) UIView *touchRingView;///<拖动环的视图



+ (UIView *)ringViewWithType:(SliderRingType)type;

- (void)setDidValueChangedBlock:(GLCircularSliderDidValueChanged)didValueChangedBlock;
/*===============================================================
                        Public Function
 ===============================================================*/

/**
 *  修改参数后重新加载页面
 */
- (void)reloadUI;

@end
