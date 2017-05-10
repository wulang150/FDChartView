//
//  FDColumn.h
//  EChartDemo
//
//  Created by  Tmac on 17/4/19.
//  Copyright © 2017年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDColumn : UIView

@property(nonatomic,strong) NSArray *color;         //多种颜色，由上往下
@property(nonatomic,strong) NSArray *colorRate;     //每种颜色的比例，总数是1

@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) BOOL isRadius;          //是否圆角

- (void)putForeColor:(UIColor *)color;      //设置前景颜色，用于选中后的颜色更改
- (void)cancelForeColor;                    //取消前景色
@end
