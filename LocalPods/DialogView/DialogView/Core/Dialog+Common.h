//
//  Dialog+Common.h
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog.h"


@interface Dialog (Common)

#pragma mark - 自动显示弹框

/// 显示普通标题和副标题
/// @param title 主标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock;

/// 显示普通标题和副标题（可定义按钮布局）
/// @param title 主标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param buttonsLayoutType 按钮布局
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                            buttons:(NSArray<NSString *> *)buttons
                  buttonsLayoutType:(DialogButtonsLayoutType)buttonsLayoutType
                        resultBlock:(DialogResultBlock)resultBlock;

/// 显示普通标题和副标题（副标题是富文本）
/// @param title 主标题
/// @param attributedSubtitle 富文本副标题
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                 attributedSubtitle:(NSAttributedString *)attributedSubtitle
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock;

#pragma mark - 生成弹框，不自动显示

/// 普通标题和副标题
/// @param title 主标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock;

/// 普通标题和副标题（可定义按钮布局）
/// @param title 主标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param buttonsLayoutType 按钮布局
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                        buttons:(NSArray<NSString *> *)buttons
              buttonsLayoutType:(DialogButtonsLayoutType)buttonsLayoutType
                    resultBlock:(DialogResultBlock)resultBlock;

/// 普通标题和副标题（副标题是富文本）
/// @param title 主标题
/// @param attributedSubtitle 富文本副标题
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
             attributedSubtitle:(NSAttributedString *)attributedSubtitle
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock;

@end
