//
//  LSMoneyPickerView.m
//  YBPickerTool
//
//  Created by 中创 on 2019/7/9.
//  Copyright © 2019 YBing. All rights reserved.
//

#import "LSMoneyPickerView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kPickerViewH 300
/**
 金钱选择器
 */

@interface LSMoneyPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
/// 背景图
@property (nonatomic, strong) UIView *bgView;
/// 工具条
@property (nonatomic, strong) UIView *toolBar;
/// 标题视图
@property (nonatomic, strong) UIView * titleView;
/// 点击完成回调block
@property (nonatomic, copy) CompleteBlock didSelectBlock;
/// 数据源
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *datas;
///  该字典的键是列  值是行
@property (nonatomic, strong) NSMutableDictionary * mutableDic;
/// 显示的标题
@property (nonatomic, strong) NSArray * titles;
/// 传入的当前控制器
@property (nonatomic, strong) UIViewController * currentVC;

@end

@implementation LSMoneyPickerView


+ (void)showPickerWithCurrentVC:(UIViewController *)vc completeBlock:(CompleteBlock)complete{
    LSMoneyPickerView *pickerView = [[LSMoneyPickerView alloc] initWithFrame:CGRectMake(0, kScreenH-kPickerViewH, kScreenW, kPickerViewH)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = pickerView;
    pickerView.dataSource = pickerView;
    pickerView.didSelectBlock = complete;
    pickerView.currentVC = vc;
    [pickerView show];
}
+ (void)showPickerWithCompleteBlock:(CompleteBlock)complete{
    LSMoneyPickerView *pickerView = [[LSMoneyPickerView alloc] initWithFrame:CGRectMake(0, kScreenH-kPickerViewH, kScreenW, kPickerViewH)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = pickerView;
    pickerView.dataSource = pickerView;
    pickerView.didSelectBlock = complete;
    [pickerView show];
}
/// 展示该选择器
- (void)show{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (self.currentVC != nil) {
        [self.currentVC.view addSubview:self.bgView];
        return;
    }else{
        [window addSubview:self.bgView];
    }
}
/// 点击完成按钮
- (void)finishClick{
    NSArray * allKeys = [[self.mutableDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString * mutableStr = [NSMutableString string];
    for (NSInteger i = 0; i < allKeys.count; i ++) {
        NSString * key = allKeys[i];
        NSArray * array = self.datas[key.integerValue];
        NSString * value = self.mutableDic[key];
        NSString * string = array[value.integerValue];
        [mutableStr appendString:string];
    }
    if (self.didSelectBlock) {
        self.didSelectBlock(mutableStr);
    }
    [self close];
}
/// 点击取消按钮
- (void)close{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    return;
}

#pragma mark --- UIPickerViewDataSource
// 返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.datas.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.datas[component].count;
}

#pragma mark --- UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.datas[component][row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString * line = [NSString stringWithFormat:@"%lu", component];
    NSString * rw = [NSString stringWithFormat:@"%lu", row];
    self.mutableDic[line] = rw;
}


#pragma mark --- 懒加载
/// 背景图
- (UIView *)bgView{
    if (_bgView==nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_bgView addGestureRecognizer:tap];
        [_bgView addSubview:self];
        [_bgView addSubview:self.toolBar];
        if (self.titles.count > 0) {
            [_bgView addSubview:self.titleView];
        }
    }
    return _bgView;
}
/// 显示标题(个十百千万)
- (UIView *)titleView{
    if (_titleView == nil) {
        CGFloat titleViewY = CGRectGetMaxY(self.toolBar.frame);
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, titleViewY, kScreenW, 34)];
        NSArray * titleArr = self.titles;
        CGFloat titleW = kScreenW / titleArr.count;
        for (NSInteger i = 0; i < titleArr.count; i ++) {
            UILabel * titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(titleW*i, 34, titleW, 34)];
            [_titleView addSubview:titleLbl];
            titleLbl.text = titleArr[i];
            titleLbl.textAlignment = NSTextAlignmentCenter;
        }
    }
    return _titleView;
}
/// 显示取消、完成按钮
- (UIView *)toolBar{
    if (_toolBar==nil) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-self.bounds.size.height-34, kScreenW, 34)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        finishBtn.frame = CGRectMake(kScreenW-60, 0, 60, _toolBar.bounds.size.height);
        [finishBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [finishBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:finishBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 0, 60, _toolBar.bounds.size.height);
        [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:cancelBtn];
        
    }
    return _toolBar;
}
- (NSArray<NSArray<NSString *> *> *)datas{
    if (_datas == nil) {
        NSMutableArray * numArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i ++) {
            [numArr addObject:[NSString stringWithFormat:@"%lu", i]];
        }
        NSMutableArray * dataArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i ++) {
            [dataArr addObject:numArr];
        }
        _datas = [NSArray arrayWithArray:dataArr];
    }
    return _datas;
}
- (NSMutableDictionary *)mutableDic{
    if (_mutableDic == nil) {
        _mutableDic = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < self.datas.count; i ++) {
            NSString * key = [NSString stringWithFormat:@"%lu", i];
            _mutableDic[key] = @"0";
        }
    }
    return _mutableDic;
}
- (NSArray *)titles{
    if (_titles == nil) {
        NSArray * arr = @[@"万", @"千", @"百", @"十", @"个"];
        _titles = [NSArray arrayWithArray:arr];
    }
    return _titles;
}
- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}
@end
