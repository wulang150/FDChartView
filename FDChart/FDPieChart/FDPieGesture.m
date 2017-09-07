//
//  FDPieGesture.m
//  FDChart
//
//  Created by  Tmac on 2017/7/18.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "FDPieGesture.h"


@interface FDPieGesture()
{
   
}
@end

@implementation FDPieGesture

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initData];
    }
    
    return self;
}

- (void)initData
{
    self.minValue = 0;
    self.maxValue = 50;
    self.radius = self.bounds.size.height/2;
}

- (void)createView
{

    [self addSubview:self.ciclePie];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappened:)];
    panGestureRecognizer.maximumNumberOfTouches = panGestureRecognizer.minimumNumberOfTouches;
    [self addGestureRecognizer:panGestureRecognizer];
}

- (FDPie *)ciclePie
{
    if(!_ciclePie)
    {
        _ciclePie = [[FDPie alloc] initWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:_radius];
        _ciclePie.pieRate = 0;
        [_ciclePie reloadContent:NO];
    }
    
    return _ciclePie;
}

- (void)show
{
    [self createView];
}

float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, float sourceIntervalMinimum, float sourceIntervalMaximum, float destinationIntervalMinimum, float destinationIntervalMaximum) {
    float a, b, destinationValue;
    //每一度对应的值
    a = (destinationIntervalMaximum - destinationIntervalMinimum) / (sourceIntervalMaximum - sourceIntervalMinimum);
    b = destinationIntervalMaximum - a*sourceIntervalMaximum;
    
    destinationValue = a*sourceValue + b;
    
    return destinationValue;
}

CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2) {
    CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
    CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
    
    CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
    
    return angle;
}

#pragma mark - UIGestureRecognizer management methods
- (void)panGestureHappened:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
    CGPoint tapLocation = [panGestureRecognizer locationInView:self];
    
    CGPoint middlePoint;
    middlePoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    middlePoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    //屏蔽掉园内滑动手势
    if (pow(tapLocation.x - middlePoint.x, 2) + pow(tapLocation.y - middlePoint.y, 2) <= pow(_radius*4/5, 2))
    {
        return;
    }
    switch (panGestureRecognizer.state)
    {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            CGPoint sliderStartPoint = CGPointMake(sliderCenter.x, sliderCenter.y - _radius);
            CGFloat angle = angleBetweenThreePoints(sliderCenter, sliderStartPoint, tapLocation);
            if (angle < 0)
            {
                angle = -angle;
            }
            else if(angle<2*M_PI)
            {
                angle = 2*M_PI - angle;
            }

            float value = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minValue, self.maxValue);
            
            if(value>0)
            {
                _ciclePie.pieRate = (value -_minValue)/(_maxValue - _minValue);
                [_ciclePie reloadContent:NO];
            }
            
            if([self.delegate respondsToSelector:@selector(valueOfPieGesture:value:)])
            {
                [self.delegate valueOfPieGesture:self value:value];
            }
            break;
        }
        default:
            break;
    }
}


@end
