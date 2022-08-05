//
//  DialogView.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TextShouldChangeResModel.h"
#import "DialogConfig.h"

#import "ButtonsDialogElement.h"
#import "DialogResult.h"
#import "ImageDialogElement.h"
#import "SelectorDialogElement.h"
#import "TextDialogElement.h"
#import "TextFieldDialogElement.h"
#import "TextViewDialogElement.h"

NS_ASSUME_NONNULL_BEGIN

@class DialogPriorityModel;

/** 显示回调 */
typedef void (^ShowBlock)(void);

/** 消失回调（有可能还在队列中，谨慎使用） */
typedef void (^DisappearBlock)(BOOL holdInQueue);

/** 从队列移除回调 */
typedef void (^ReleaseFromQueueBlock)(void);

/** 点击按钮回调 */
typedef BOOL (^DialogResultBlock)(DialogResult *result);

/** 输入框即将输入文字，返回有NSString则表示不允许这次修改，并且在TextField/TextView下面提示NSString。传回NSString为nil或者为空字符串则表示允许修改 */
typedef TextShouldChangeResModel *_Nullable (^TextShouldChangeBlock)(id inputView, NSRange changeRange, NSString *replacementText);

/** 输入框已经输入文字，并且在TextField/TextView下面提示NSString。传回NSString为nil或者为空字符串则清空提示 */
typedef NSString *_Nullable (^TextDidChangeBlock)(id inputView);


@interface DialogView : UIView

@property (nonatomic, strong) UIViewController *boundViewController; // 绑定的控制器（只有这个控制器显示的时候才弹框）

/**
 结果回调
 */
@property (nonatomic, copy) DialogResultBlock resultBlock;

/**
 输入框即将输入文字，返回有NSString则表示不允许这次修改，并且在TextField/TextView下面提示NSString。传回NSString为nil或者为空字符串则表示允许修改
*/
@property (nonatomic, copy) TextShouldChangeBlock textShouldChangeBlock;

/**
 输入框已经输入文字，并且在TextField/TextView下面提示NSString。传回NSString为nil或者为空字符串则清空提示
*/
@property (nonatomic, copy) TextDidChangeBlock textDidChangeBlock;

/**
 是否存在优先级
 */
@property (nonatomic, assign, getter=isExistPriority) BOOL existPriority;

#pragma mark - Public Methods

/// 初始化
/// @param dialogModels 数据
/// @param animation 出场动画
/// @param position 位置
/// @param sideTap 是否可点击周边
/// @param bounce 是否弹性动画
- (instancetype)initWithDialogModels:(NSArray *)dialogModels
                           animation:(ShowAnimation)animation
                            position:(DialogPosition)position
                             sideTap:(BOOL)sideTap
                              bounce:(BOOL)bounce;

/// 初始化
/// @param customView 自定义视图
/// @param customViewHeight 自定义视图高度
/// @param animation 出场动画
/// @param position 位置
/// @param sideTap 是否可点击周边
/// @param bounce 是否弹性动画
- (instancetype)initWithCustomView:(UIView *)customView
                  customViewHeight:(CGFloat)customViewHeight
                         animation:(ShowAnimation)animation
                          position:(DialogPosition)position
                           sideTap:(BOOL)sideTap
                            bounce:(BOOL)bounce;

/// 初始化
/// @param customView 自定义视图
/// @param customViewSize 自定义视图宽高（宽度按照规范）
/// @param animation 出场动画
/// @param position 位置
/// @param sideTap 是否可点击周边
/// @param bounce 是否弹性动画
- (instancetype)initWithCustomView:(UIView *)customView
                    customViewSize:(CGSize)customViewSize
                         animation:(ShowAnimation)animation
                          position:(DialogPosition)position
                           sideTap:(BOOL)sideTap
                            bounce:(BOOL)bounce;

/** 弹出 */
- (void)show;

/** 关闭 */
- (void)close;

/** 关闭 */
- (void)closeWithHoldInQueue:(BOOL)holdInQueue;

/** 从队列中移除 */
- (void)releaseFromQueue;

/** 关闭 */
- (void)closeWithAnimation:(BOOL)animation holdInQueue:(BOOL)holdInQueue;

/// 开启键盘
- (void)becomeFirstResponder;

/// 关闭键盘
- (void)resignFirstResponder;

/** 设置是否可点击周边空白区关闭 */
- (void)sideTapEnable:(BOOL)enable;

/** 使某个按钮重新恢复点击事件 */
- (void)enableButtonAtIndex:(NSInteger)buttonIndex;

/**使某个按钮无法点击。*/
- (void)disabledButtonAtIndex:(NSInteger)buttonIndex;

/// 提醒（输入框类型的弹框）
/// @param errorTips 提醒文案
- (void)showErrorTips:(NSString *)errorTips;

/// 添加显示回调
- (void)addShowBlock:(ShowBlock)showBlock;

/// 添加消失回调
- (void)addDisappearBlock:(DisappearBlock)disappearBlock;

/// 添加从队列中移除回调
- (void)addReleaseFromQueueBlock:(ReleaseFromQueueBlock)releaseFromQueueBlock;

/// 添加从队列中移除主要回调
- (void)setUpMainReleaseFromQueueBlock:(ReleaseFromQueueBlock)mainReleaseFromQueueBlock;

/// 弹框宽度
+ (CGFloat)contentWidth;

@end

NS_ASSUME_NONNULL_END
