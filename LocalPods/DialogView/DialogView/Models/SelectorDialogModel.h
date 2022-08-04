//
//  SelectorDialogModel.h
//  TCLPlus
//
//  Created by OwenChen on 2021/1/7.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "BasicDialogModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 选择器偏好配置


@interface SelectorPreference : NSObject

/// 选中时候标题颜色
@property (nonatomic, copy) NSString *selectedTitleColor;

/// 非选中时候标题颜色
@property (nonatomic, copy) NSString *unselectedTitleColor;

/// 选中时候副标题颜色
@property (nonatomic, copy) NSString *selectedSubtitleColor;

/// 非选中时候副标题颜色
@property (nonatomic, copy) NSString *unselectedSubtitleColor;

/// 无法选中时候所有标题颜色
@property (nonatomic, copy) NSString *unenabledColor;

/// 能选择的最大个数（默认为1）
@property (nonatomic, assign) NSInteger maxSelectNum;

/// 是否点击即选中，并且直接结果回调
/// 只在maxSelectNum为1的情况下起作用
/// 为YES且maxSelectNum为1的时候右边显示的是箭头，否则显示的是选中非选中的圆点
/// 默认为YES
@property (nonatomic, assign, getter=isResultFromItemTap) BOOL resultFromItemTap;

/// 一页能显示的最多的item，超过则需要上下滑动才能显示
/// 默认为8
@property (nonatomic, assign) NSInteger maxShownItemNum;

/// 副标题能显示的最多的行数
/// 默认为3
@property (nonatomic, assign) NSInteger maxSubtitleLines;

@end

#pragma mark - 选择器选项模型


@interface SelectorDialogItem : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;

/// 副标题
@property (nonatomic, copy) NSString *subtitle;

/// 是否选中状态
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/// 是否可以被选中（NO的话置灰选项）
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

+ (SelectorDialogItem *)createItemWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle selected:(BOOL)selected enabled:(BOOL)enabled;

/// 偏好配置
@property (nonatomic, strong, readonly) SelectorPreference *preference;

- (void)setupPreference:(SelectorPreference *)preference;

@end

#pragma mark - 选择器组件模型


@interface SelectorDialogModel : BasicDialogModel

/// 偏好配置
@property (nonatomic, strong) SelectorPreference *preference;

/// 数据集合
@property (nonatomic, strong) NSArray<SelectorDialogItem *> *items;

@end

NS_ASSUME_NONNULL_END
