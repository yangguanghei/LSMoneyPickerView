//
//  LSMoneyPickerView.h
//  YBPickerTool
//
//  Created by 中创 on 2019/7/9.
//  Copyright © 2019 YBing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompleteBlock) (NSString * money);

@interface LSMoneyPickerView : UIPickerView

/// 展示选择器
+ (void)showPickerWithCompleteBlock:(CompleteBlock)complete;
/// 在当前控制器上展示控制器
+ (void)showPickerWithCurrentVC:(UIViewController *)vc completeBlock:(CompleteBlock)complete;

@end

NS_ASSUME_NONNULL_END
