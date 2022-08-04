//
//  Dialog+Selector.h
//  TCLPlus
//
//  Created by OwenChen on 2021/1/7.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog.h"


@interface Dialog (Selector)

#pragma mark - 自动显示弹框

/// 显示选择器弹框
/// @param title 主标题
/// @param subtitle 副标题
/// @param items 选择器的数据源
/// @param maxSelectNum 最多选择的个数
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showSelectorDialogWithTitle:(NSString *)title
                                   subtitle:(NSString *)subtitle
                        selectorDialogItems:(NSArray<SelectorDialogItem *> *)items
                               maxSelectNum:(NSInteger)maxSelectNum
                          resultFromItemTap:(BOOL)resultFromItemTap
                                    buttons:(NSArray<NSString *> *)buttons
                                resultBlock:(DialogResultBlock)resultBlock;

#pragma mark - 生成弹框，不自动显示

/// 选择器弹框
/// @param title 主标题
/// @param subtitle 副标题
/// @param items 选择器的数据源
/// @param maxSelectNum 最多选择的个数
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)selectorDialogWithTitle:(NSString *)title
                               subtitle:(NSString *)subtitle
                    selectorDialogItems:(NSArray<SelectorDialogItem *> *)items
                           maxSelectNum:(NSInteger)maxSelectNum
                      resultFromItemTap:(BOOL)resultFromItemTap
                                buttons:(NSArray<NSString *> *)buttons
                            resultBlock:(DialogResultBlock)resultBlock;

@end
