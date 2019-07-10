//
//  ViewController.m
//  LSMoneyPickerView
//
//  Created by 中创 on 2019/7/10.
//  Copyright © 2019 中创慧谷. All rights reserved.
//

#import "ViewController.h"
#import "LSMoneyPickerView.h"
@interface ViewController ()
@property (nonatomic, strong) UILabel * lbl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"展示" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * lbl = [UILabel new];
    [self.view addSubview:lbl];
    lbl.frame = CGRectMake(100, 210, 200, 30);
    lbl.text = @"显示金额：";
    lbl.backgroundColor = [UIColor redColor];
    _lbl = lbl;
}
- (void)clickBtn{
    [LSMoneyPickerView showPickerWithCompleteBlock:^(NSString * _Nonnull money) {
        NSLog(@"%@", money);
        self.lbl.text = [NSString stringWithFormat:@"显示金额：%lu", money.integerValue];
    }];
}


@end
