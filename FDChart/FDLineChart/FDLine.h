//
//  FDLine.h
//  FDChart
//
//  Created by  Tmac on 2017/7/25.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDLine : UIView

@property (nonatomic) NSInteger lineWidth;

@property (strong, nonatomic) UIColor *lineColor;

@property (nonatomic) CGFloat maxValue;

@property (nonatomic,strong) NSArray *dataArr;      //数据源

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation;

//返回对应的center point
- (CGPoint)putDotAt:(NSInteger)index;
//获得横向的点与点的间隔
- (CGFloat)getXGap;
@end
