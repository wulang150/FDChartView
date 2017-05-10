//
//  FDColumn.m
//  EChartDemo
//
//  Created by  Tmac on 17/4/19.
//  Copyright © 2017年 Scott Zhu. All rights reserved.
//

#import "FDColumn.h"

@interface FDColumn()
{
    CAGradientLayer *baseLayer;
    
    UIView *foreColorView;
    
    CAShapeLayer *foreLayer;
}
@end

@implementation FDColumn

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}
- (void)initData
{
    
    if(self.color==nil||self.color.count==0)
    {
        _color = @[[UIColor greenColor]];
        _colorRate = @[@(1.0)];
    }
    
    if(self.color.count==1)
    {
        _color = @[_color[0],_color[0]];
        _colorRate = @[@(0.3),@(0.7)];
    }
}
//重新获得试用的渐变颜色和比例
- (NSArray *)gainColorValue:(NSArray *)cArr rArr:(NSArray *)rArr
{
    NSMutableArray *rateArr = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *colorArr = [[NSMutableArray alloc] initWithCapacity:10];
    CGFloat value = 0.0f;
    for(int i=0;i<cArr.count;i++)
    {
        CGFloat val = [rArr[i] floatValue];
        value += val;
        UIColor *color = cArr[i];
        [rateArr addObject:[NSNumber numberWithFloat:value]];
        [colorArr addObject:(id)color.CGColor];
        //要取消渐变，就得多加临界点，新加的点颜色和下一个点颜色相同，才不会有渐变
        if(i!=_color.count-1)
        {
            [rateArr addObject:[NSNumber numberWithFloat:value]];
            if(i+1<cArr.count)
            {
                color = cArr[i+1];
                [colorArr addObject:(id)color.CGColor];
            }
        }
    }
    
    NSArray *valueArr = @[colorArr,rateArr];
    return valueArr;
}
- (void)createView
{
    [self initData];
    
    CAGradientLayer *grad3 = [CAGradientLayer layer];
    baseLayer = grad3;
    grad3.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

    NSArray *arr = [self gainColorValue:_color rArr:_colorRate];
    _color = [[arr objectAtIndex:0] copy];
    _colorRate = [[arr objectAtIndex:1] copy];
    grad3.locations = _colorRate;
    grad3.colors = _color;

    grad3.mask = [self gainMaskLayer:YES];

    [self.layer addSublayer:baseLayer];
}
//获得遮挡层
- (CAShapeLayer *)gainMaskLayer:(BOOL)isAction
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    //顶点
    CAShapeLayer *grad3 = [CAShapeLayer layer];
    
    grad3.frame = CGRectMake(0, 0, w, h);
    //圆角
    if (_isRadius)
    {
        UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:grad3.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight  cornerRadii:CGSizeMake(w,w)];
        
        grad3.path = cornerPath.CGPath;
    }
    else
    {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:grad3.bounds];
        grad3.path = path.CGPath;
        
    }
    
    if(isAction)
    {
    //    //改变中心点位置，默认就是在中间，这里把这个点调整到0.5（横向中间）1(竖向最低部)
    //    [grad3 setAnchorPoint:CGPointMake(0.5, 1)];
    //    //改变layer的位置，通过改变中心点
    //    [grad3 setPosition:CGPointMake(grad3.position.x, self.bounds.size.height)];
        [grad3 setPosition:CGPointMake(grad3.position.x, h)];
        [grad3 setAnchorPoint:CGPointMake(0.5, 1)];
        //加入动画
        //从下向上拉伸动画
        CABasicAnimation *animation;
        animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.duration = 0.5;
        animation.delegate= nil;
        animation.fromValue = [NSNumber numberWithFloat:0.1];
        animation.toValue = [NSNumber numberWithFloat:1];
        [grad3 addAnimation:animation forKey:@"transform.scale.y"];
    }
    
    
    return grad3;
}

- (void)drawRect:(CGRect)rect
{
//    for(UIView *view in self.subviews)
//        [view removeFromSuperview];
    
    [baseLayer removeFromSuperlayer];
    
    [self createView];
}

- (void)putForeColor:(UIColor *)color
{

    
    NSArray *arr = [self gainColorValue:@[color,color] rArr:@[@(0.3),@(0.7)]];
    baseLayer.locations = [arr objectAtIndex:1];
    baseLayer.colors = [arr objectAtIndex:0];
}

- (void)cancelForeColor
{
    baseLayer.locations = _colorRate;
    baseLayer.colors = _color;

}
@end
