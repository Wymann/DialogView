//
//  Dialog+CustomView.h
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog.h"


@interface Dialog (CustomView)

#pragma mark - 自动显示弹框

/// 弹框显示自定义视图
/// @param customView 自定义视图
/// @param customViewHeight 自定义视图高度（宽度按照规范）
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithCustomView:(UIView *)customView
                        customViewHeight:(CGFloat)customViewHeight
                             resultBlock:(DialogResultBlock)resultBlock;

/// 弹框显示自定义视图
/// @param customView 自定义视图
/// @param customViewSize 自定义视图宽高
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithCustomView:(UIView *)customView
                          customViewSize:(CGSize)customViewSize
                             resultBlock:(DialogResultBlock)resultBlock;

/// 弹框显示自定义视图
/// @param customView 自定义视图
/// @param customViewSize 自定义视图宽高
/// @param showAnimation 弹出动画
/// @param position 弹出位置
/// @param bounce 是否弹性动画
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithCustomView:(UIView *)customView
                          customViewSize:(CGSize)customViewSize
                           showAnimation:(ShowAnimation)showAnimation
                                position:(DialogPosition)position
                                  bounce:(BOOL)bounce
                             resultBlock:(DialogResultBlock)resultBlock;

#pragma mark - 生成弹框，不自动显示

/// 自定义视图
/// @param customView 自定义视图
/// @param customViewHeight 自定义视图高度（宽度按照规范）
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithCustomView:(UIView *)customView
                    customViewHeight:(CGFloat)customViewHeight
                         resultBlock:(DialogResultBlock)resultBlock;

/// 自定义视图
/// @param customView 自定义视图
/// @param customViewSize 自定义视图宽高
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithCustomView:(UIView *)customView
                      customViewSize:(CGSize)customViewSize
                         resultBlock:(DialogResultBlock)resultBlock;

@end
