//
//  FDLineChart.m
//  EChartDemo
//
//  Created by  Tmac on 17/3/31.
//  Copyright © 2017年 Scott Zhu. All rights reserved.
//

#import "FDLineChart.h"
#import "FDLine.h"


@interface FDLineChart()
{
    CGFloat elineW;
    CGFloat elineH;
    CGFloat xlineH;     //x轴的高度
    CGFloat xgap;       //点之间的间隔
    
    UILabel *numLab;
}
@property (nonatomic,strong) FDLine *eline;
@end

@implementation FDLineChart

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}



- (void)createView:(BOOL)animation
{
    if(_startX<=0)
        _startX = 16;
    xlineH = 22;        //下标的高度
    elineW = self.frame.size.width-_startX*2;
    elineH = self.frame.size.height - xlineH;
    if(!_eline)
    {
        _eline = [[FDLine alloc] initWithFrame:CGRectMake(_startX, 0, elineW, elineH)];
        _eline.dataArr = _dataArr;
        _eline.lineColor = _lineColor?_lineColor:[UIColor blueColor];
        _eline.lineWidth = _lineWidth>0?_lineWidth:2;
        _eline.maxValue = _maxValue;
        [self addSubview:_eline];
        
        [_eline reloadDataWithAnimation:animation];
    }
    
    //画下面的x轴
    UIView *xline = [[UIView alloc] initWithFrame:CGRectMake(0, elineH, self.frame.size.width, 1)];
    xline.backgroundColor = [UIColor grayColor];
    [self addSubview:xline];
    //默认点间的空隙
    xgap = [_eline getXGap];
    NSInteger allnum = _labArr.count;
    
    //画下标的值
    for(int i=0;i<allnum;i++)
    {
        CGFloat px = _startX + i*xgap;
        //一点
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(px, CGRectGetMaxY(xline.frame), 1, 2)];
        point.backgroundColor = [UIColor grayColor];
        [self addSubview:point];
        
        NSString *xval = [_labArr objectAtIndex:i];
        if(xval.length<=0)
            continue;
        
        //具体标示
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectZero];
        textLab.font = [UIFont systemFontOfSize:10];
        textLab.textColor = [UIColor grayColor];
        textLab.text = xval;
        [textLab sizeToFit];
        textLab.center = point.center;
        CGRect iframe = textLab.frame;
        iframe.origin.y = elineH+1;
        iframe.size.height = xlineH;
        textLab.frame = iframe;
        [self addSubview:textLab];
    }
    
}

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation
{
    for(UIView *subView in self.subviews)
        [subView removeFromSuperview];
    
    [self createView:shouldAnimation];
}

//根据点击的x得到对应的数值val
- (NSInteger)gainIndexForPoint:(CGPoint)point
{
    CGFloat x = point.x - _startX;
    NSInteger gapCount = x / xgap;
    CGFloat distanceOverGapCount = fmod(x, xgap);   //计算x/y的余数
    
    if (distanceOverGapCount >= xgap / 2.0)
    {
        return gapCount+1;
    }
    else
    {
        return gapCount;
    }
}

//点击后的视图
- (void)setNumLab:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    NSInteger index = [self gainIndexForPoint:touchLocation];
    
    CGPoint center = [_eline putDotAt:index];
    
    [numLab removeFromSuperview];
    if(!numLab)
    {
        numLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        numLab.font = [UIFont boldSystemFontOfSize:16];
    }
    numLab.alpha = 1;
    numLab.text = [NSString stringWithFormat:@"%d",[_dataArr[index] intValue]];
    [numLab sizeToFit];
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut  animations:^{
        numLab.center = CGPointMake(center.x+_startX, center.y-16);
    } completion:nil];
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        numLab.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self addSubview:numLab];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setNumLab:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setNumLab:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
