# GLCircularSlider

可自定义风格的支持渐变色的环状Slider

![demo](https://github.com/GrayLand119/GLCircularSlider/blob/master/glcirculardemo.gif)

## 使用方法

新建对象并添加到视图中即可, 若要修改风格, 修改后调用 **updateUI:**方法.
详情请看Demo

```objc
GLCircularSlider *slider = [[GLCircularSlider alloc] initWithFrame:self.view.bounds];

[self.view addSubview:_slider];
```


## 其他介绍

```objc
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
```
