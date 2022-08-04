//
//  Dialog+SpecialColors.h
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog.h"


@interface Dialog (SpecialColors)

#pragma mark - 自动显示弹框

/// 显示普通标题和副标题（颜色自定义）
/// @param title 主标题
/// @param titleColor 主标题颜色
/// @param subtitle 副标题
/// @param subtitleColor 副标题颜色
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                         titleColor:(NSString *)titleColor
                           subtitle:(NSString *)subtitle
                      subtitleColor:(NSString *)subtitleColor
                            buttons:(NSArray<NSString *> *)buttons
                       buttonColors:(NSArray<NSString *> *)buttonColors
                        resultBlock:(DialogResultBlock)resultBlock;

/// 显示普通标题和副标题（颜色自定义，副标题为富文本）
/// @param title 主标题
/// @param titleColor 主标题颜色
/// @param attributedSubtitle 富文本副标题
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                         titleColor:(NSString *)titleColor
                 attributedSubtitle:(NSAttributedString *)attributedSubtitle
                            buttons:(NSArray<NSString *> *)buttons
                       buttonColors:(NSArray<NSString *> *)buttonColors
                        resultBlock:(DialogResultBlock)resultBlock;

#pragma mark - 生成弹框，不自动显示

/// 普通标题和副标题（颜色自定义）
/// @param title 主标题
/// @param titleColor 主标题颜色
/// @param subtitle 副标题
/// @param subtitleColor 副标题颜色
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
                     titleColor:(NSString *)titleColor
                       subtitle:(NSString *)subtitle
                  subtitleColor:(NSString *)subtitleColor
                        buttons:(NSArray<NSString *> *)buttons
                   buttonColors:(NSArray<NSString *> *)buttonColors
                    resultBlock:(DialogResultBlock)resultBlock;

/// 普通标题和副标题（颜色自定义，副标题为富文本）
/// @param title 主标题
/// @param titleColor 主标题颜色
/// @param attributedSubtitle 富文本副标题
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
                     titleColor:(NSString *)titleColor
             attributedSubtitle:(NSAttributedString *)attributedSubtitle
                        buttons:(NSArray<NSString *> *)buttons
                   buttonColors:(NSArray<NSString *> *)buttonColors
                    resultBlock:(DialogResultBlock)resultBlock;

@end
