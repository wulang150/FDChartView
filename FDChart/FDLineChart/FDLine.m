//
//  FDLine.m
//  FDChart
//
//  Created by  Tmac on 2017/7/25.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "FDLine.h"
#import "UIBezierPath+LxThroughPointsBezier.h"

@interface FDLine()
{
    
}

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@property (strong, nonatomic) UIView *dot;
@end

@implementation FDLine

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    
    return self;
}

//获得横向的点与点的间隔
- (CGFloat) getXGap
{
    if(_dataArr.count<=0)
        return 0;
    
    return CGRectGetWidth(self.bounds) / (_dataArr.count - 1);
}

//获取最大高度
- (CGFloat)gainHightest
{
    if(_maxValue>1)
        return _maxValue;
    
    if(_dataArr.count<=0)
        return 0;
    
    CGFloat max = 0;
    for(NSNumber *val in _dataArr)
    {
        CGFloat num = [val floatValue];
        if(num>max)
            max = num;
    }
    
    _maxValue = max*1.1;
    return _maxValue;
}

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation
{
    if(_dataArr.count<1)
        return;
    [_dot.layer removeAllAnimations];
    _dot = nil;
    
    if (!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
    }
    /** 1. Configure Layer*/
    _shapeLayer.zPosition = 0.0f;
    _shapeLayer.strokeColor = _lineColor.CGColor;
    _shapeLayer.lineWidth = _lineWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    _shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    /** 2. Construct the Path*/
    /** In order to leave some space for the heightest point */
    CGFloat highestPointValue = [self gainHightest];
    CGFloat horizentalGap = [self getXGap];
    
    //折线
    UIBezierPath *eLineChartPath = [UIBezierPath bezierPath];
    eLineChartPath.lineCapStyle = kCGLineCapRound;
    eLineChartPath.lineJoinStyle = kCGLineCapRound;
    eLineChartPath.miterLimit = -5.0;
    //动画初始线
    UIBezierPath *animFromPath = [UIBezierPath bezierPath];
    CGFloat firstPointValue = [_dataArr[0] floatValue];
    [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(_shapeLayer.bounds) - CGRectGetHeight(_shapeLayer.bounds) * (firstPointValue / highestPointValue))];
    [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(_shapeLayer.bounds))];
    for (NSInteger i = 1; i < _dataArr.count; i++)
    {
        //添加二次贝塞尔曲线
        CGFloat pointValue = [_dataArr[i] floatValue];
        CGFloat dx = i * horizentalGap;
        CGFloat dy = CGRectGetHeight(_shapeLayer.bounds) - CGRectGetHeight(_shapeLayer.bounds) * (pointValue / highestPointValue);
        
        //画平滑曲线
        [eLineChartPath addBezierCurveToPoint:CGPointMake(dx, dy)];
//        [eLineChartPath addLineToPoint:CGPointMake(dx, dy)];
        
        [animFromPath addLineToPoint:CGPointMake(i * horizentalGap, CGRectGetHeight(_shapeLayer.bounds))];
    }
    
    
    /** 3. Add Path to layer*/
    _shapeLayer.path = eLineChartPath.CGPath;
    
    
    /** 4. Add Animation to The Layer*/
    if (shouldAnimation)
    {
        //从底部弹出
//        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
//        [anim setRemovedOnCompletion:YES];
//        anim.fromValue = (id)animFromPath.CGPath;
//        anim.toValue = (id)eLineChartPath.CGPath;
//        anim.duration = 0.75f;
//        anim.removedOnCompletion = NO;
//        anim.fillMode = kCAFillModeForwards;
//        anim.autoreverses = NO;
//        anim.repeatCount = 0;
//        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//        [_shapeLayer addAnimation:anim forKey:@"path"];
        
        //从开始到完整
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [_shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
    else
    {
        [_shapeLayer removeAnimationForKey:@"path"];
    }
    
    
    
    [self.layer addSublayer:_shapeLayer];
}

//在折线上显示的大圆点
- (CGPoint) putDotAt:(NSInteger)index
{
    [_dot removeFromSuperview];
    CGFloat height = CGRectGetHeight(_shapeLayer.bounds);
    CGFloat dotY = height - height * ([_dataArr[index] floatValue] / _maxValue);
    CGPoint dotPosition = CGPointMake(index * [self getXGap], dotY);
    
    if (!_dot)
    {
        _dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _lineWidth * 4, _lineWidth * 4)];
        [_dot setBackgroundColor:_lineColor];
        _dot.layer.cornerRadius = _lineWidth * 2;
        [_dot setCenter:dotPosition];
    }
    _dot.alpha = 1;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut  animations:^{
        [_dot setCenter:dotPosition];
    } completion:nil];
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _dot.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    //NSLog(@"x = %.1f", _dot.frame.origin.x);
    [self addSubview:_dot];
    
    return dotPosition;
    
    //TODO: When the path changed, the dot gonna still be there
}

@end
