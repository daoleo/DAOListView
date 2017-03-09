//
//  ViewController.m
//  DAOListViewDemo
//
//  Created by daoleo on 17/3/9.
//  Copyright © 2017年 daoleo. All rights reserved.
//

#import "ViewController.h"
#import "DAOListView.h"

@interface ViewController ()
@property (nonatomic, strong) DAOListView *leftListView;

@property (nonatomic, strong) DAOListView *rightListView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Demo";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarItemAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemAction)];
    
    
    self.leftListView = [[DAOListView alloc] initWithReferFrame:kReferFrameNavLeftItem titleArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"] selected:^(NSInteger selectIndex) {
        NSLog(@"%ld", selectIndex);
    }];
    NSArray *titleArray = @[@"帆船",@"保龄球",@"计时器",@"乒乓球",@"旗子"];
    self.rightListView = [[DAOListView alloc] initWithReferFrame:kReferFrameNavLeftItem cellCount:5 cellConfig:^(UITableViewCell *cell, NSInteger index) {
        cell.textLabel.text = titleArray[index];
        [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", 100+index]]];
    } selected:^(NSInteger selectIndex) {
        NSLog(@"select %ld", selectIndex);
    }];
}
- (void)leftBarItemAction{
    [self.leftListView show];
}
- (void)rightBarItemAction{
    [self.rightListView showWithReferFrame:kReferFrameNavRightItem];
}
- (IBAction)centerTopShowAction:(id)sender {
    [self.rightListView showWithReferFrame:kReferFrameNavLeftItem];
}

- (IBAction)showTitleAction:(UIButton *)sender {
    [[[DAOListView alloc] initWithReferFrame:sender.frame titleArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"] selected:^(NSInteger selectIndex) {
        NSLog(@"select %ld", selectIndex);
    }] show];

}
- (IBAction)showImgTitleAction:(UIButton *)sender {
    NSArray *titleArray = @[@"帆船",@"保龄球",@"计时器",@"乒乓球",@"旗子"];
    [[[DAOListView alloc] initWithReferFrame:sender.frame cellCount:5 cellConfig:^(UITableViewCell *cell, NSInteger index) {
        cell.textLabel.text = titleArray[index];
        [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", 100+index]]];
    } selected:^(NSInteger selectIndex) {
        NSLog(@"select %ld", selectIndex);
    }] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
