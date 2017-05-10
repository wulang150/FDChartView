//
//  FDPie.h
//  FDChart
//
//  Created by  Tmac on 17/4/25.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDPie : UIView

//中间空出来的view
@property (nonatomic,strong) UIView *centerView;

@property (nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *pieColor;
@property (nonatomic) CGFloat pieRate;      //1为一圈，默认为1
@property (nonatomic) CGFloat duration;      //动画时间，秒，默认为2秒
@property (nonatomic) CGFloat startRate;    //开始的位置，默认12点位置，如果想3点为起点，为1/4

//等分渐变的颜色 2、3、5点
@property (nonatomic,strong) NSArray *gradColorArr; //渐变颜色点颜色
//非渐变多颜色圆圈
@property(nonatomic,strong) NSArray *colorArr;         //多种颜色
@property(nonatomic,strong) NSArray *colorRate;     //每种颜色的比例，总数是1
//初始化方法
- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius;

- (void)reloadContent;
@end
