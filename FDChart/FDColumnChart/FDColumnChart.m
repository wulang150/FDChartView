//
//  FDColumnChart.m
//  EChartDemo
//
//  Created by  Tmac on 17/4/19.
//  Copyright © 2017年 Scott Zhu. All rights reserved.
//

#import "FDColumnChart.h"

@interface FDColumnChart()
{
    
    NSMutableArray *columnArr;
    
    FDColumn *selectedColumn;       //选中的col
    
    CGFloat bottomH;            //整个底部的高度
    
    CGFloat fontSize;           //标签字体大小
    
    CGFloat eachW;              //标签的间隔
}
@end

@implementation FDColumnChart

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        _startX = 14;
        //整个底部的高度
        bottomH = self.frame.size.height/7;
        //标签字体大小
        fontSize = bottomH *2/5;
        _mode = Default_Model;
        columnArr = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@-%s",[self class],__FUNCTION__);
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    NSLog(@"%@-%s",[self class],__FUNCTION__);
}

- (void)drawRect:(CGRect)rect
{
    [self reloadData];
}

//画下标
- (void)drawBottomLine
{
    CGFloat height = self.frame.size.height;
    NSInteger num = _labArr.count;
    if(num<=1)
        return;
    eachW = (self.frame.size.width - _startX*2)/(num-1);
    //画底部的标线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, height-bottomH, self.bounds.size.width, 1)];
    bottomLine.backgroundColor = [UIColor blackColor];
    [self addSubview:bottomLine];
    
    for(int i=0;i<num;i++)
    {
        NSString *lab = [_labArr objectAtIndex:i];
        CGFloat x = _startX + eachW*i;
        //底部的小点
        UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(bottomLine.frame), 1, 2)];
        gapView.backgroundColor = [UIColor grayColor];
        [self addSubview:gapView];
        
        //底部的标签
        UILabel *labView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, bottomH)];
        labView.textAlignment = NSTextAlignmentCenter;
        labView.textColor = [UIColor grayColor];
        labView.font = [UIFont systemFontOfSize:fontSize];
        labView.text = lab;
        [labView sizeToFit];
        labView.center = CGPointMake(gapView.center.x, CGRectGetMinY(bottomLine.frame)+bottomH/2);
        [self addSubview:labView];
        
    }
}
//画普通柱子
- (void)drawDefaultChart
{
    CGFloat height = self.frame.size.height;
    NSInteger num = _dataArr.count;
    if(num<=0)
        return;

    //每个柱子的宽度，0.8剩余0.2是空隙
    CGFloat trueW = eachW *0.8;
    if(trueW/2>_startX)
        trueW = _startX*2;
    
    [columnArr removeAllObjects];
    
    for(int i=0;i<num;i++)
    {
        FDChartModel *model = [_dataArr objectAtIndex:i];
        CGFloat x = _startX + eachW*i - trueW/2;
        //画柱子
        CGFloat maxValue = [self gainMaxValue];
        CGFloat colH = model.value/maxValue*(height-bottomH);
        FDColumn *column = [[FDColumn alloc] initWithFrame:CGRectMake(x, height-colH-bottomH, trueW, colH)];
        column.color = model.color;
        column.colorRate = model.colorRate;
        column.index = i;
        column.isRadius = YES;
        [self addSubview:column];
        
        [columnArr addObject:column];
        
    }
}

//画合并柱子
- (void)drawMergeChart
{
    CGFloat height = self.frame.size.height;
    NSInteger num = _dataArr.count;
    if(num<=0)
        return;

    [columnArr removeAllObjects];

    for(int i=0;i<num;i++)
    {
        FDChartModel *model = [_dataArr objectAtIndex:i];
        if(model.length<=1)
            continue;
        CGFloat x = _startX + eachW*model.startPos;
        CGFloat width = eachW * (model.length-1);
        //画柱子
        CGFloat maxValue = [self gainMaxValue];
        CGFloat colH = model.value/maxValue*(height-bottomH);
        FDColumn *column = [[FDColumn alloc] initWithFrame:CGRectMake(x, height-colH-bottomH, width, colH)];
        column.color = model.color;
        column.colorRate = model.colorRate;
        column.index = i;
        [self addSubview:column];
        
        [columnArr addObject:column];
        
    }
    
}

- (void)reloadData
{
    for(UIView *view in self.subviews)
        [view removeFromSuperview];
    
    [self createView];
}



- (void)createView
{
    [self drawBottomLine];
    
    if(_mode == Merge_Model)
        [self drawMergeChart];
    else
        [self drawDefaultChart];
    
}

- (CGFloat)gainMaxValue
{
    CGFloat max = 0;
    if(_maxValue>1)
        return _maxValue;
    
    for(FDChartModel *model in _dataArr)
    {
        if(model.value>max)
            max = model.value;
    }
    
    //不让柱子画到顶部
    max = max*1.1;
    
    return max;
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if (columnArr.count==0) return;
//    
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint touchLocation = [touch locationInView:self];
//    for (FDColumn *view in columnArr)
//    {
//        if(CGRectContainsPoint(view.frame, touchLocation))
//        {
//            selectedColumn = view;
//            if([self.delegate respondsToSelector:@selector(fdColumnChart:fingerDidEnterColumn:index:)])
//            {
//                [_delegate fdColumnChart:self fingerDidEnterColumn:view index:view.index];
//            }
//            return;
//        }
//    }
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (columnArr.count==0) return;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    for (FDColumn *view in columnArr)
    {
        if(CGRectContainsPoint(view.frame, touchLocation))
        {
            if([self.delegate respondsToSelector:@selector(fdColumnChart:fingerDidLeaveColumn:index:)])
            {
                [_delegate fdColumnChart:self fingerDidLeaveColumn:view index:view.index];
            }
            selectedColumn = nil;
            break;
        }
    }
    
    if(selectedColumn)
    {
        if([self.delegate respondsToSelector:@selector(fdColumnChart:fingerDidLeaveColumn:index:)])
        {
            [_delegate fdColumnChart:self fingerDidLeaveColumn:selectedColumn index:selectedColumn.index];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (columnArr.count==0) return;
    
    UITouch *touch = [[event allTouches] anyObject];

    CGPoint touchLocation = [touch locationInView:self];
    
    if (nil == selectedColumn)
    {
        for (FDColumn *view in columnArr)
        {
            if(CGRectContainsPoint(view.frame, touchLocation) )
            {
                
                if([self.delegate respondsToSelector:@selector(fdColumnChart:fingerDidEnterColumn:index:)])
                {
                    [_delegate fdColumnChart:self fingerDidEnterColumn:view index:view.index];
                }
                selectedColumn = view;
                return ;
            }
        }
    }
    if (selectedColumn && !CGRectContainsPoint(selectedColumn.frame, touchLocation))
    {
        if([self.delegate respondsToSelector:@selector(fdColumnChart:fingerDidLeaveColumn:index:)])
        {
            [_delegate fdColumnChart:self fingerDidLeaveColumn:selectedColumn index:selectedColumn.index];
        }
        selectedColumn = nil;
    }
}


@end
