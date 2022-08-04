//
//  ButtonsDialogModel.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "BasicDialogModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DialogButtonsLayoutType) {
    DialogButtonsLayoutHorizontal = 0,
    DialogButtonsLayoutVertical = 1,
};


@interface ButtonsDialogModel : BasicDialogModel

/// 按钮标题
@property (nonatomic, strong) NSArray<NSString *> *buttonTitles;
/// 文本颜色数组
@property (nonatomic, strong) NSArray<NSString *> *textColors;
/// 文本大小
@property (nonatomic, assign) CGFloat fontSize;
/// 文本是否加粗
@property (nonatomic, assign) BOOL bold;
/// 按钮布局样式
@property (nonatomic, assign) DialogButtonsLayoutType layoutType;

@end

NS_ASSUME_NONNULL_END
