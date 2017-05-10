//
//  FDColumnViewController.m
//  FDChart
//
//  Created by  Tmac on 17/4/24.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "FDColumnViewController.h"
#import "FDColumnChart.h"

extern CGFloat Width;
extern CGFloat Height;

@interface FDColumnViewController ()
<FDColumnChartDelegate>
{
    NSMutableArray *modelArr;
    FDColumnChart *chart;
}
@end

@implementation FDColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self testFdChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testFdChart
{
    //    FDColumn *column = [[FDColumn alloc] initWithFrame:CGRectMake(100, 100, 20, 100)];
    ////    column.layer.borderWidth = 1;
    ////    column.color = @[[UIColor redColor]];
    ////    column.colorRate = @[@(0.8)];
    //    [self.view addSubview:column];
    NSMutableArray *labArr = [NSMutableArray new];
    modelArr = [NSMutableArray new];
    NSArray *labVal = @[@"00:00",@"06:00",@"12:00",@"18:00",@"00:00"];
    
    for(int i = 0;i<=24;i++)
    {
        NSString *lab = [NSString stringWithFormat:@"%02d:00",i];
        if(i==24)
            lab = @"00:00";
        
        if([labVal containsObject:lab])
            [labArr addObject:lab];
        else
            [labArr addObject:@""];
    }
    
    //默认模式数据源
    for(int i = 0;i<=24;i++)
    {
        FDChartModel *model = [[FDChartModel alloc] init];


        //添加不同颜色
        if(i>10&&i<13)
            model.color = @[[UIColor redColor]];

        if(i==18)
        {
            model.color = @[[UIColor yellowColor],[UIColor blueColor]];
            model.colorRate = @[@(0.4),@(0.6)];
        }

        CGFloat value = arc4random() % 100;
        model.value = value;

        [modelArr addObject:model];
    }
    //合并模式数据源
//    for(int i = 0;i<=3;i++)
//    {
//        FDChartModel *model = [[FDChartModel alloc] init];
//        
//        CGFloat value = arc4random() % 100;
//        model.value = value;
//        if(i==0)
//        {
//            model.startPos = 6;
//            model.length = 5;
//            model.color = @[[UIColor redColor]];
//        }
//        if(i==1)
//        {
//            model.startPos = 12;
//            model.length = 5;
//            model.color = @[[UIColor yellowColor]];
//        }
//        if(i==2)
//        {
//            model.startPos = 16;
//            model.length = 5;
//            model.color = @[[UIColor greenColor]];
//        }
//        [modelArr addObject:model];
//    }
    
    chart = [[FDColumnChart alloc] initWithFrame:CGRectMake(0, 140, self.view.bounds.size.width, 200)];
    chart.startX = 20;
    chart.dataArr = modelArr;
    chart.labArr = labArr;
    chart.delegate = self;
//    chart.mode = Merge_Model;
    [self.view addSubview:chart];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, CGRectGetMaxY(chart.frame), 100, 30);
    [btn setTitle:@"reload" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (void)btnAction:(UIButton *)sender
{
    [chart reloadData];
}

- (void)fdColumnChart:(FDColumnChart *)fdColumnChart fingerDidEnterColumn:(FDColumn *)eColumn index:(NSInteger)index
{
    FDChartModel *model = [modelArr objectAtIndex:index];
    NSLog(@"enter value = %.1f",model.value);
    
    [eColumn putForeColor:[UIColor grayColor]];
}

- (void)fdColumnChart:(FDColumnChart *)fdColumnChart fingerDidLeaveColumn:(FDColumn *)eColumn index:(NSInteger)index
{
    FDChartModel *model = [modelArr objectAtIndex:index];
    NSLog(@"leave value = %.1f",model.value);
    
    [eColumn cancelForeColor];
}

@end
