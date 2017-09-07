//
//  FDLineViewController.m
//  FDChart
//
//  Created by  Tmac on 2017/7/25.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "FDLineViewController.h"
#import "FDLineChart.h"

@interface FDLineViewController ()
{
    NSMutableArray *mulData;
    NSMutableArray *mulLab;
}
@end

@implementation FDLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self creatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    mulData = [NSMutableArray new];
    mulLab = [NSMutableArray new];
    
    for(int i=0;i<25;i++)
    {
        CGFloat num = arc4random()%100;
        
        [mulData addObject:@(num)];
    }
    
    for(int i=0;i<25;i++)
    {
        if(i%6==0)
            [mulLab addObject:[NSString stringWithFormat:@"%02d:00",i]];
        else
            [mulLab addObject:@""];
    }
}
- (void)creatView
{
    self.view.backgroundColor = [UIColor whiteColor];
    FDLineChart *lineChart = [[FDLineChart alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 240)];
    lineChart.lineWidth = 3;
    lineChart.lineColor = [UIColor redColor];
    lineChart.dataArr = mulData;
    lineChart.labArr = mulLab;
    [self.view addSubview:lineChart];
    
    [lineChart reloadDataWithAnimation:YES];
}

@end
