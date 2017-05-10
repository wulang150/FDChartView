//
//  FDPieChart.m
//  FDChart
//
//  Created by  Tmac on 17/4/25.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "FDPieChart.h"
#import "FDPie.h"

@implementation FDPieChart

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = MIN(frame.size.width, frame.size.height)/2;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    for(UIView *view in self.subviews)
        [view removeFromSuperview];
    
    CGFloat sum = _value1 + _value2 + _value3;
    CGFloat rate1 = _value1/sum;
    CGFloat rate2 = _value2/sum;
    CGFloat rate3 = _value3/sum;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    FDPie *pie1 = [[FDPie alloc] initWithCenter:CGPointMake(width/2, height/2) radius:MIN(width/2, height/2)];
    pie1.pieColor = [UIColor yellowColor];
    pie1.pieRate = rate1;
    
    FDPie *pie2 = [[FDPie alloc] initWithCenter:CGPointMake(width/2, height/2) radius:MIN(width/2, height/2)];
    pie2.pieColor = [UIColor greenColor];
    pie2.pieRate = rate2;
    pie2.startRate = rate1;
    
    FDPie *pie3 = [[FDPie alloc] initWithCenter:CGPointMake(width/2, height/2) radius:MIN(width/2, height/2)];
    pie3.pieColor = [UIColor blueColor];
    pie3.pieRate = rate3;
    pie3.startRate = rate2+rate1;
    
    CGFloat st1 = 2*rate1;
    CGFloat st2 = 2*rate2;
    CGFloat st3 = 2*rate3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        pie1.duration = st1;
        [self addSubview:pie1];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, st1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        pie2.duration = st2;
        [self addSubview:pie2];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (st1+st2) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        pie3.duration = st3;
        [self addSubview:pie3];
        
    });
    
    
}

@end
