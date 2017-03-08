//
//  GLCircularSlider.m
//  GLCircularSlider
//
//  Created by GrayLand on 17/3/8.
//  Copyright © 2017年 GrayLand. All rights reserved.
//

#import "GLCircularSlider.h"

@interface GLCircularSlider ()

@property (nonatomic, assign) CGFloat angle;///<设置角度

@property (nonatomic, assign) CGAffineTransform originTransform;

@property (nonatomic, assign) BOOL isDrag;

@end

@implementation GLCircularSlider

#pragma mark - Inherit
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initStyleParam];
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private

- (void)initStyleParam {
    
    _isDrag     = NO;
    _ringWidth  = 20;
    _ringRadius = 100;
    _minValue   = 0;
    _maxValue   = 100;
    
    _ringBackgroundColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    _ringFrontColor      = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
}

- (void)setupViews {

    UIBezierPath *ringPath = [self genRingPathWithRadius:_ringRadius];
    
    _ringBackgroundLayer = [CAShapeLayer layer];
    _ringBackgroundLayer.path    = ringPath.CGPath;
    _ringBackgroundLayer.lineCap = kCALineCapRound;
    
    _ringFrontLayer = [CAShapeLayer layer];
    _ringFrontLayer.path      = ringPath.CGPath;
    _ringFrontLayer.lineCap   = kCALineCapRound;

    // gradient
    _ringGradiantLayer = [CAShapeLayer layer];
    
    CAGradientLayer *gy1 = [CAGradientLayer layer];
    gy1.frame = CGRectMake(self.bounds.size.width/2 - _ringWidth,
                           self.bounds.size.height/2 - _ringRadius - _ringWidth,
                           _ringRadius + _ringWidth * 2,
                           _ringRadius * 2 + _ringWidth * 2);
    [gy1 setColors:@[(id)[UIColor greenColor].CGColor, (id)[UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000].CGColor]];
    [gy1 setLocations:@[@0.1, @0.9]];
    [gy1 setStartPoint:CGPointMake(0.5, 0)];
    [gy1 setEndPoint:CGPointMake(0.5, 1)];
    
    CAGradientLayer *gy2 = [CAGradientLayer layer];
    gy2.frame = CGRectMake(self.bounds.size.width/2 - _ringRadius - 40,
                           self.bounds.size.height/2 - _ringRadius - _ringWidth,
                           _ringRadius +_ringWidth,
                           _ringRadius * 2 +40);
    [gy2 setColors:@[(id)[UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000].CGColor, (id)[UIColor redColor].CGColor]];
    [gy2 setLocations:@[@0.1,@0.9]];
    [gy2 setStartPoint:CGPointMake(0.5, 1)];
    [gy2 setEndPoint:CGPointMake(.5, 0)];
    
    _ringGradiantLayer = [CAShapeLayer layer];
    _ringGradiantLayer.lineWidth   = _ringWidth;
    _ringGradiantLayer.path        = ringPath.CGPath;
    _ringGradiantLayer.strokeColor = [UIColor grayColor].CGColor;
    _ringGradiantLayer.fillColor   = [UIColor clearColor].CGColor;
    _ringGradiantLayer.lineCap     = kCALineCapRound;
    [_ringGradiantLayer addSublayer:gy1];
    [_ringGradiantLayer addSublayer:gy2];
    
    
    [self.layer addSublayer:_ringBackgroundLayer];
    [self.layer addSublayer:_ringGradiantLayer];
    [self.layer addSublayer:_ringFrontLayer];
    
    _ringGradiantLayer.mask = _ringFrontLayer;
    
    // 滑动按钮
    _touchRingView = [[self class] ringViewWithType:SliderRingTypeDefault];
    [self addSubview:_touchRingView];
    
    self.angle = 0;
}

- (UIBezierPath *)genRingPathWithRadius:(CGFloat)radius {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:self.center radius:radius startAngle:-M_PI/2 endAngle:-M_PI/2 + M_PI * 2 clockwise:YES];
    
    return path;
}

#pragma mark - Setter

- (void)setTouchRingView:(UIView *)touchRingView {
    
    if (_touchRingView) {
        [_touchRingView removeFromSuperview];
        _touchRingView = touchRingView;
        [self addSubview:_touchRingView];
        
        self.angle = _angle;
    }
}

- (void)setAngle:(CGFloat)angle {
    
    _angle = angle;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _ringFrontLayer.strokeEnd = _angle / 360.0f;
    [CATransaction commit];
    _touchRingView.center    = [self positionWithAngle:_angle];
    _touchRingView.transform = CGAffineTransformMakeRotation(_angle / 180.0f * M_PI);
}

#pragma mark - Public 

- (CGFloat)currentValue {
    
    return _value;
}

- (void)reloadUI {
    
    // _ringBackgroundLayer
    _ringBackgroundLayer.lineWidth   = _ringWidth;
    _ringBackgroundLayer.strokeColor = _ringBackgroundColor.CGColor;
    _ringBackgroundLayer.fillColor   = [UIColor clearColor].CGColor;
    
    // _ringFrontLayer
    _ringFrontLayer.lineWidth   = _ringWidth;
    _ringFrontLayer.strokeColor = _ringFrontColor.CGColor;
    _ringFrontLayer.fillColor   = [UIColor clearColor].CGColor;
    
    
}

- (CGPoint)positionWithAngle:(CGFloat)angle {
    
    CGPoint circleCenter = self.center;
    
    NSUInteger quadrant = 0;
    
    CGFloat rad, dX, dY;
    
    if (angle > 360) {
        angle = angle - ((int)(angle/360.0f)) * 360.0;
    }
    if (angle == 0 || angle == 360) {
        dX = 0;
        dY = -_ringRadius;
    }else if (angle == 90) {
        dX = _ringRadius;
        dY = 0;
    }else if (angle == 180) {
        dX = 0;
        dY = _ringRadius;
    }else if (angle == 270) {
        dX = -_ringRadius;
        dY = 0;
    }else {
        dX = 0;
        dY = 0;
    }
    
    if (angle > 0 && angle < 90) {
        quadrant = 1;
    }else if (angle > 90 && angle < 180) {
        quadrant = 2;
    }else if (angle > 180 && angle < 270) {
        quadrant = 3;
    }else if (angle > 270 && angle < 360){
        quadrant = 4;
    }
    
    if (quadrant == 0) {
        return CGPointMake(circleCenter.x + dX, circleCenter.y + dY);
    }
    
    CGPoint center;
    
    rad = angle / 180.0 * M_PI;
    
    dX  = _ringRadius * sin(rad);
    dY  = _ringRadius * cos(rad);
    
    center = CGPointMake(circleCenter.x + dX, circleCenter.y - dY);
    
    return center;
}

#pragma mark - UIResponder Inherit

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [[[touches allObjects] firstObject] locationInView:self];

    BOOL bInside = CGRectContainsPoint(CGRectMake(_touchRingView.frame.origin.x,
                                                  _touchRingView.frame.origin.y,
                                                  _touchRingView.bounds.size.width,
                                                  _touchRingView.bounds.size.height), touchPoint);
    
    _isDrag = bInside;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!_isDrag) {
        return;
    }
    
    CGPoint test = [[[touches allObjects] firstObject] locationInView:self];
    
    CGFloat x1 = test.x - self.center.x;
    CGFloat x2 = 0;
    CGFloat y1 = test.y - self.center.y;
    CGFloat y2 = -_ringRadius;
    
    CGFloat rad = acos((x1 * x2 + y1 * y2) /
                         (sqrt(x1 * x1 + y1 * y1) * sqrt(x2 * x2 + y2 * y2)));

    CGFloat angle = rad / M_PI * 180.0f;
    
    if (x1 < 0) {
        angle = 360.0 - angle;
    }
    
    self.angle = angle;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    _isDrag = NO;
    
    _value = _angle/360.0f * self.maxValue;
    if (_didValueChangedBlock) {
        _didValueChangedBlock(self, _value);
    }
}

+ (UIView *)ringViewWithType:(SliderRingType)type {
    
    UIView *view;
    
    switch (type) {
        case SliderRingTypeDefault:
        {
            CGFloat width  = 50;
            CGFloat height = 35;
            
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            view.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            UIBezierPath *path      = [UIBezierPath bezierPath];
            
            // draw button
            [path moveToPoint:CGPointMake(0, 10)];
            [path addQuadCurveToPoint:CGPointMake(10, 0) controlPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(43, 0)];
            [path addLineToPoint:CGPointMake(width, height/2)];
            [path addLineToPoint:CGPointMake(43, height)];
            [path addLineToPoint:CGPointMake(10, height)];
            [path addQuadCurveToPoint:CGPointMake(0, height-10) controlPoint:CGPointMake(0, height)];
            [path closePath];
            
            maskLayer.path = path.CGPath;
            
            view.layer.mask = maskLayer;
        }break;
            
        case SliderRingTypeCircle:
        {
            CGFloat r = 45;
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, r, r)];
            view.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            UIBezierPath *path      = [UIBezierPath bezierPath];
            
            // draw button
            [path addArcWithCenter:CGPointMake(r/2.0f, r/2.0f) radius:(r/2.0 -2.0) startAngle:-M_PI/2 endAngle:-M_PI/2 + M_PI * 2 clockwise:YES];
            
            maskLayer.path = path.CGPath;
    
            view.layer.mask = maskLayer;
            
        }break;
            
        default:
            break;
    }
    
    return view;
}

//- (void)setupTouchRingView {
//    
//    CGFloat width  = 50;
//    CGFloat height = 35;
//    
//    _touchRingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    _touchRingView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
////    _touchRingView.userInteractionEnabled = YES;
//    
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    UIBezierPath *path      = [UIBezierPath bezierPath];
//    
//    // draw button
//    [path moveToPoint:CGPointMake(0, 10)];
//    [path addQuadCurveToPoint:CGPointMake(10, 0) controlPoint:CGPointMake(0, 0)];
//    [path addLineToPoint:CGPointMake(43, 0)];
//    [path addLineToPoint:CGPointMake(width, height/2)];
//    [path addLineToPoint:CGPointMake(43, height)];
//    [path addLineToPoint:CGPointMake(10, height)];
//    [path addQuadCurveToPoint:CGPointMake(0, height-10) controlPoint:CGPointMake(0, height)];
//    [path closePath];
//    
//    maskLayer.path = path.CGPath;
//    
//    _touchRingView.layer.mask = maskLayer;
//    
//    [self addSubview:_touchRingView];
//}




@end
