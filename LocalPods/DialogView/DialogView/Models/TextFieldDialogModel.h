//
//  TextFieldDialogModel.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "BasicDialogModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TextFieldDialogModel : BasicDialogModel

/// 文本位置
@property (nonatomic, assign) NSTextAlignment textAlignment;
/// 初始文本内容
@property (nonatomic, copy) NSString *textContent;
/// 占位文本内容
@property (nonatomic, copy) NSString *placeHolderContent;
/// 文本大小
@property (nonatomic, assign) CGFloat fontSize;
/// 文本颜色
@property (nonatomic, copy) NSString *textColor;
/// 文本输入框四周边距
@property (nonatomic, assign) UIEdgeInsets textFieldEdgeInsets;
/// 键盘类型
@property (nonatomic, assign) UIKeyboardType keyboardType;
/// 会影响光标等颜色
@property (nonatomic, copy) NSString *tintColor;

@end

NS_ASSUME_NONNULL_END
