//
//  FDPie.m
//  FDChart
//
//  Created by  Tmac on 17/4/25.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "FDPie.h"

@interface FDPie()
{
    CAShapeLayer *pieLayer;
    NSMutableArray *gradArr;
}
@property (nonatomic) CGFloat radius;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation FDPie

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        _radius = radius;
        _lineWidth = _radius/5;
        _pieColor = [UIColor redColor];
        _pieRate = 1.0;
        _duration = 2.0;
        _startRate = 0;
        gradArr = [NSMutableArray new];
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
    }
    return self;
}

- (void)createView
{
    [_bgView removeFromSuperview];
    [self.centerView removeFromSuperview];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _bgView.layer.cornerRadius = self.bounds.size.width/2;
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    
    //中间的view
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (_radius-_lineWidth)*2, (_radius-_lineWidth)*2)];
    _centerView.center = CGPointMake(_radius, _radius);
    _centerView.backgroundColor = [UIColor whiteColor];
    _centerView.layer.cornerRadius = _radius-_lineWidth;
    [self addSubview:_centerView];
    
}

//- (void)drawRect:(CGRect)rect
//{
//    [self reloadContent];
//}



- (void)reloadContent
{
    [self createView];
    [pieLayer removeFromSuperlayer];
    for(CALayer *la in gradArr)
        [la removeFromSuperlayer];
    
    [gradArr removeAllObjects];
    
//    CGFloat sPos = M_PI_2 * 3 + _startRate * M_PI * 2;
    CGFloat sPos = M_PI_2 * 3;
    UIBezierPath* circleBudgetPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                    radius: _radius - _lineWidth/2
                                                                startAngle: sPos
                                                                  endAngle: sPos+2 * M_PI * _pieRate
                                                                 clockwise:YES];
    pieLayer = [CAShapeLayer new];
    pieLayer.path = circleBudgetPath.CGPath;
    pieLayer.fillColor = [UIColor clearColor].CGColor;
    pieLayer.strokeColor = _pieColor.CGColor;
    pieLayer.lineCap = kCALineCapRound;
    pieLayer.lineWidth = _lineWidth;
    pieLayer.zPosition = 2;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = _duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pieLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    
    if(_gradColorArr.count>1)
    {
        [self doForGradLayer];
    }
    else if(_colorArr.count>1)
    {
        [self doForMulColor];
    }
    else
    {
        [self.layer addSublayer:pieLayer];
    }
    
    //偏移整个背景
    _bgView.transform = CGAffineTransformMakeRotation(M_PI*2*_startRate);

}

//多段颜色的处理
- (void)doForMulColor
{
    CGFloat sPos = 0;
//    CGFloat ePos = M_PI_2 * 3 + _startRate * M_PI * 2;
    CGFloat ePos = M_PI_2 * 3;
    for(int i=0;i<_colorArr.count;i++)
    {
        UIColor *color = _colorArr[i];
        CGFloat rate = [_colorRate[i] floatValue];
        sPos = ePos;
        ePos = sPos + rate * (2 * M_PI * _pieRate);
        UIBezierPath* circleBudgetPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                        radius: _radius
                                                                    startAngle: sPos
                                                                      endAngle: ePos
                                                                     clockwise:YES];
        [circleBudgetPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds))];
        [circleBudgetPath closePath];
        
        CAShapeLayer *shape = [CAShapeLayer new];
        shape.path = circleBudgetPath.CGPath;
        shape.fillColor = color.CGColor;
        shape.zPosition = 1;
        [_bgView.layer addSublayer:shape];
        
        [gradArr addObject:shape];
        
    }
    
    pieLayer.lineCap = kCALineCapButt;
    //Set mask
    [_bgView.layer setMask:pieLayer];
}

//渐变的处理
- (void)doForGradLayer
{
    NSArray * colors = [self gainGardColors:_gradColorArr];
    for (int i = 0; i < colors.count -1; i++) {
        CAGradientLayer * graint = [CAGradientLayer layer];
        graint.bounds = CGRectMake(0,0,CGRectGetWidth(self.bounds)/2,CGRectGetHeight(self.bounds)/2);
        NSValue * valuePoint = [[self positionArrayWithMainBounds:self.bounds] objectAtIndex:i];
        graint.position = valuePoint.CGPointValue;
        UIColor * fromColor = colors[i];
        UIColor * toColor = colors[i+1];
        NSArray *colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, toColor.CGColor, nil];
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
        graint.colors = colors;
        graint.locations = locations;
        graint.startPoint = ((NSValue *)[[self startPoints] objectAtIndex:i]).CGPointValue;
        graint.endPoint = ((NSValue *)[[self endPoints] objectAtIndex:i]).CGPointValue;
        [_bgView.layer addSublayer:graint];
        graint.zPosition = 1;
        
        [gradArr addObject:graint];
        
    }
    
    
//    CAGradientLayer * graint = [CAGradientLayer layer];
//    graint.bounds = CGRectMake(0,0,_radius+20,_lineWidth*2);
//    graint.position = CGPointMake(CGRectGetWidth(self.bounds)/4, CGRectGetHeight(self.bounds)-_lineWidth);
//    UIColor * fromColor = colors[2];
//    UIColor * toColor = colors[3];
//    NSArray *color = [NSArray arrayWithObjects:(id)fromColor.CGColor, toColor.CGColor, nil];
//    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
//    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
//    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
//    graint.colors = color;
//    graint.locations = locations;
//    graint.startPoint = CGPointMake(1, 0.5);
//    graint.endPoint = CGPointMake(0, 0.5);
//    [_bgView.layer addSublayer:graint];
//    graint.zPosition = 1;
//    
//    [gradArr addObject:graint];
    
    
    
//    if([pieLayer.lineCap isEqualToString:kCALineCapRound])
//    {
//        UIColor *first = colors[0];
//        //补一个半圈
//        CALayer *circleView = [CALayer new];
//        circleView.frame = CGRectMake(CGRectGetMidX(self.bounds)-_lineWidth/2, 0, _lineWidth, _lineWidth);
//        circleView.backgroundColor = first.CGColor;
//        circleView.cornerRadius = _lineWidth/2;
//        circleView.zPosition = 1;
//        if(_pieRate>0)
//            [self.layer addSublayer:circleView];
//    }
    
    pieLayer.lineCap = kCALineCapButt;
    //Set mask
    [_bgView.layer setMask:pieLayer];
}

- (NSArray *)gainGardColors:(NSArray *)colors
{
    NSMutableArray *mulColor = [NSMutableArray new];
    if(colors.count==2)
        [mulColor addObjectsFromArray:[self graintFromColor:colors[0] ToColor:colors[1] Count:4]];
    if(colors.count>=3&&colors.count<=4)
    {
        NSArray *arr = [self graintFromColor:colors[0] ToColor:colors[1] Count:2];
        [mulColor addObjectsFromArray:arr];
        arr = [self graintFromColor:colors[1] ToColor:colors[2] Count:2];
        [mulColor addObject:arr[1]];
        [mulColor addObject:arr[2]];
        return mulColor;
    }
    if(colors.count>=5)
    {
        for(int i=0;i<5;i++)
            [mulColor addObject:colors[i]];
    }
    return mulColor;
}

//以下为等分为4分的情况
-(NSArray *)positionArrayWithMainBounds:(CGRect)bounds{
    CGPoint first = CGPointMake(CGRectGetWidth(bounds)/4 *3, CGRectGetHeight(bounds)/4 *1);
    CGPoint second = CGPointMake(CGRectGetWidth(bounds)/4 *3, CGRectGetHeight(bounds)/4 *3);
    CGPoint thrid = CGPointMake(CGRectGetWidth(bounds)/4 *1, CGRectGetHeight(bounds)/4 *3);
    CGPoint fourth = CGPointMake(CGRectGetWidth(bounds)/4 *1, CGRectGetHeight(bounds)/4 *1);
    return @[[NSValue valueWithCGPoint:first],
             [NSValue valueWithCGPoint:second],
             [NSValue valueWithCGPoint:thrid],
             [NSValue valueWithCGPoint:fourth]];
}
-(NSArray *)startPoints{
//    return @[[NSValue valueWithCGPoint:CGPointMake(0,0)],
//             [NSValue valueWithCGPoint:CGPointMake(1,0)],
//             [NSValue valueWithCGPoint:CGPointMake(1,1)],
//             [NSValue valueWithCGPoint:CGPointMake(0,1)]];
    
    return @[[NSValue valueWithCGPoint:CGPointMake(0.5,0)],
             [NSValue valueWithCGPoint:CGPointMake(0.5,0)],
             [NSValue valueWithCGPoint:CGPointMake(0.5,1)],
             [NSValue valueWithCGPoint:CGPointMake(0.5,1)]];
    
}
-(NSArray *)endPoints{
//    return @[[NSValue valueWithCGPoint:CGPointMake(1,1)],
//             [NSValue valueWithCGPoint:CGPointMake(0,1)],
//             [NSValue valueWithCGPoint:CGPointMake(0,0)],
//             [NSValue valueWithCGPoint:CGPointMake(1,0)]];
    
    return @[[NSValue valueWithCGPoint:CGPointMake(0.5,1)],
             [NSValue valueWithCGPoint:CGPointMake(0.5,1)],
             [NSValue valueWithCGPoint:CGPointMake(0.5,0)],
             [NSValue valueWithCGPoint:CGPointMake(0.5,0)]];
}
//渐变方法，count等分几分，得到几等分每一点的颜色
-(NSArray *)graintFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor Count:(NSInteger)count{
    CGFloat fromR = 0.0,fromG = 0.0,fromB = 0.0,fromAlpha = 0.0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromAlpha];
    CGFloat toR = 0.0,toG = 0.0,toB = 0.0,toAlpha = 0.0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toAlpha];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (int i = 0; i <= count; i++) {
        CGFloat oneR = fromR + (toR - fromR)/count * i;
        CGFloat oneG = fromG + (toG - fromG)/count * i;
        CGFloat oneB = fromB + (toB - fromB)/count * i;
        CGFloat oneAlpha = fromAlpha + (toAlpha - fromAlpha)/count * i;
        UIColor * onecolor = [UIColor colorWithRed:oneR green:oneG blue:oneB alpha:oneAlpha];
        [result addObject:onecolor];
    }
    return result;
}
-(UIColor *)midColorWithFromColor:(UIColor *)fromColor ToColor:(UIColor*)toColor Progress:(CGFloat)progress{
    CGFloat fromR = 0.0,fromG = 0.0,fromB = 0.0,fromAlpha = 0.0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromAlpha];
    CGFloat toR = 0.0,toG = 0.0,toB = 0.0,toAlpha = 0.0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toAlpha];
    CGFloat oneR = fromR + (toR - fromR) * progress;
    CGFloat oneG = fromG + (toG - fromG) * progress;
    CGFloat oneB = fromB + (toB - fromB) * progress;
    CGFloat oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    UIColor * onecolor = [UIColor colorWithRed:oneR green:oneG blue:oneB alpha:oneAlpha];
    return onecolor;
}
@end
