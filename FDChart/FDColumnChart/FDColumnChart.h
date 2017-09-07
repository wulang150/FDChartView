//
//  FDColumnChart.h
//  EChartDemo
//
//  Created by  Tmac on 17/4/19.
//  Copyright © 2017年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDChartModel.h"
#import "FDColumn.h"

typedef NS_ENUM(NSUInteger, modelType) {
    Default_Model,      //默认模式，一般的柱状图
    Merge_Model        //合并模式，一般是开始点到结束点的柱子
};

@class FDColumnChart;

@protocol FDColumnChartDelegate <NSObject>

@optional


- (void)fdColumnChart:(FDColumnChart *)fdColumnChart fingerDidEnterColumn:(FDColumn *)eColumn index:(NSInteger)index;

- (void)fdColumnChart:(FDColumnChart *)fdColumnChart fingerDidLeaveColumn:(FDColumn *)eColumn index:(NSInteger)index;

@end

@interface FDColumnChart : UIView

@property (nonatomic,assign) CGFloat startX;        //画第一个点的位置，这个会影响柱子的宽度，默认为12
@property (nonatomic,strong) NSArray *dataArr;      //数据源
@property (nonatomic,strong) NSArray *labArr;       //所有下标数组
@property (nonatomic,assign) CGFloat maxValue;     //获取最大值，每个model的value以这个为基准画高，默认为数据源最大值*1.1
@property (nonatomic,assign) int mode;      //模式，默认模式
@property (weak, nonatomic) id <FDColumnChartDelegate> delegate;

- (void)reloadData;

//- (CGFloat)gainMaxValue;
@end
