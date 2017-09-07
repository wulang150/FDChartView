//
//  FDPieGesture.h
//  FDChart
//
//  Created by  Tmac on 2017/7/18.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPie.h"

@class FDPieGesture;

@protocol FDPieGestureDelegate <NSObject>

- (void)valueOfPieGesture:(FDPieGesture *)pieGesture value:(CGFloat)value;

@end

@interface FDPieGesture : UIView

@property(nonatomic) FDPie *ciclePie;

@property(nonatomic) CGFloat minValue;
@property(nonatomic) CGFloat maxValue;

@property(nonatomic) CGFloat radius;        //圆的半径

@property(nonatomic,weak) id<FDPieGestureDelegate> delegate;
- (void)show;
@end
