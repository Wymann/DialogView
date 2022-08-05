//
//  TextDialogModel.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "BasicDialogModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TextDialogModel : BasicDialogModel

/// 文本位置
@property (nonatomic, assign) NSTextAlignment textAlignment;
/// 文本内容
@property (nonatomic, copy) NSString *textContent;
/// 文本内容（富文本）
@property (nonatomic, strong) NSAttributedString *attributedTextContent;
/// 文本大小
@property (nonatomic, assign) CGFloat fontSize;
/// 行间距
@property (nonatomic, assign) CGFloat lineSpace;
/// 文本颜色
@property (nonatomic, strong) UIColor *textColor;
/// 富文本数组
@property (nonatomic, strong) NSArray *richText;
/// 文本四周边距
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;

/// 文本最大行数（设置为大于0后生效）
@property (nonatomic, assign) CGFloat maxLines;

/// 文本最大高度（设置为大于0后生效）
@property (nonatomic, assign) CGFloat maxHeight;
/// 文本超过最大高度后可滚动（只在maxHeight大于0的情况下scrollable判断生效）
@property (nonatomic, assign) BOOL scrollable;
/// 是否加粗
@property (nonatomic, assign, getter=isBold) BOOL bold;

@end

NS_ASSUME_NONNULL_END
