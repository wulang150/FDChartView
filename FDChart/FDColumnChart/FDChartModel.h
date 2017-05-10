//
//  FDChartModel.h
//  EChartDemo
//
//  Created by  Tmac on 17/4/19.
//  Copyright © 2017年 Scott Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDChartModel : NSObject

@property (nonatomic) float value;

@property(nonatomic,strong) NSArray *color;         //多种颜色，由上往下
@property(nonatomic,strong) NSArray *colorRate;     //每种颜色的比例，总数是1

//////////////////合并模式
@property(nonatomic,assign) NSInteger startPos;     //开始的位置，以x轴的点为基准，第一个点为0
@property(nonatomic,assign) NSInteger length;       //包含的总点数
@end
