//
//  FDLineChart.h
//  EChartDemo
//
//  Created by  Tmac on 17/3/31.
//  Copyright © 2017年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FDLineChart : UIView

@property(nonatomic) NSArray *dataArr;       //数据源
@property(nonatomic) NSArray *labArr;       //下标Arr

@property (nonatomic) NSInteger lineWidth;

@property (strong, nonatomic) UIColor *lineColor;

@property (nonatomic) CGFloat startX;        //画第一个点的位置，这个会影响每点间的宽度，默认为16

@property (nonatomic) CGFloat maxValue;

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation;
@end
