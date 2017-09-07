//
//  FDPieViewController.m
//  FDChart
//
//  Created by  Tmac on 17/4/25.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "FDPieViewController.h"
#import "FDPie.h"
#import "FDPieChart.h"
#import "FDPieGesture.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

extern CGFloat Width;
extern CGFloat Height;

@interface FDPieViewController ()
<FDPieGestureDelegate>

@end

@implementation FDPieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView
{
//    FDPie *pie = [[FDPie alloc] initWithCenter:CGPointMake(Width/2, Height/2) radius:100];
////    pie.layer.borderWidth = 1;
//    pie.lineWidth = 10;
//    pie.gradColorArr = @[RGB(126, 255, 148),RGB(254, 155, 101),[UIColor redColor]];
////    pie.colorArr = @[[UIColor grayColor],[UIColor blueColor],[UIColor redColor]];
////    pie.colorRate = @[@(0.2),@(0.4),@(0.4)];
////    pie.startRate = 0.2;
//    [self.view addSubview:pie];
//    [pie reloadContent:NO];
//    
//    //中间的view
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//    lab.center = CGPointMake(pie.centerView.bounds.size.width/2, pie.centerView.bounds.size.height/2);
//    lab.textColor = [UIColor blackColor];
//    lab.text = @"圆图";
//    lab.textAlignment = NSTextAlignmentCenter;
////    pie.centerView.backgroundColor = [UIColor brownColor];
//    [pie.centerView addSubview:lab];
    
    FDPieGesture *gesPie = [[FDPieGesture alloc] initWithFrame:CGRectMake((Width-200)/2, (Height-200)/2, 200, 200)];
    gesPie.ciclePie.centerView.layer.borderWidth = 1;
    gesPie.delegate = self;
    gesPie.maxValue = 100;
    [self.view addSubview:gesPie];
    [gesPie show];
    

}

- (void)valueOfPieGesture:(FDPieGesture *)pieGesture value:(CGFloat)value
{
    NSLog(@"value = %f",value);
}

@end
