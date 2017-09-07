//
//  ViewController.m
//  FDChart
//
//  Created by  Tmac on 17/4/24.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "ViewController.h"
#import "FDColumnViewController.h"
#import "FDPieViewController.h"
#import "FDLineViewController.h"

extern CGFloat Width;
extern CGFloat Height;

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArr;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView
{
    titleArr = @[@"表图",@"饼图",@"曲线图"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    _tableView.alwaysBounceVertical = YES;
////    
////    UIEdgeInsets inset = _tableView.contentInset;
////    inset.top = 100;
////    _tableView.contentInset = inset;
//////
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 80)];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.text = @"sdfsdfdsfds";
//    lab.textColor = [UIColor blueColor];
////    [_tableView addSubview:lab];
//    [_tableView insertSubview:lab atIndex:0];
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    
////    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//    float offset=scrollView.contentOffset.y;
//    float contentHeight=scrollView.contentSize.height;
//    float sub=contentHeight-offset;
//    if ((scrollView.bounds.size.height-sub)>20) {//如果上拉距离超过20p，则加载更多数据
//        //[self loadMoreData];//此处在view底部加载更多数据
//        NSLog(@"刷新....");
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    
    cell.textLabel.text = titleArr[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            FDColumnViewController *rc = [FDColumnViewController new];
            [self.navigationController pushViewController:rc animated:YES];
            break;
        }
        case 1:
        {
            FDPieViewController *rc = [FDPieViewController new];
            [self.navigationController pushViewController:rc animated:YES];
            break;
        }
        case 2:
        {
            FDLineViewController *rc = [FDLineViewController new];
            [self.navigationController pushViewController:rc animated:YES];
            break;
        }
        default:
            break;
    }
}
@end
