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
    titleArr = @[@"表图",@"饼图"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


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
        default:
            break;
    }
}
@end
