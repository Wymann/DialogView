//
//  Dialog+NetImage.h
//  TCLPlus
//
//  Created by Wymann Chan on 2021/6/16.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog.h"

#import "Dialog+LocalImage.h"


@interface Dialog (NetImage)

#pragma mark - 自动显示弹框

/// 显示图片在顶部的弹框
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param title 标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithImageUrl:(NSString *)imageUrl
                             imageType:(DialogImageType)imageType
                             imageSize:(CGSize)imageSize
                           placeholder:(UIImage *)placeholder
                            errorImage:(UIImage *)errorImage
                                 title:(NSString *)title
                              subtitle:(NSString *)subtitle
                               buttons:(NSArray<NSString *> *)buttons
                           resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在顶部的弹框（可自定义弹按钮颜色）
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param title 标题
/// @param subtitle 副标题
/// @param maxSubLines 副标题最大行数
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithImageUrl:(NSString *)imageUrl
                             imageType:(DialogImageType)imageType
                             imageSize:(CGSize)imageSize
                           placeholder:(UIImage *)placeholder
                            errorImage:(UIImage *)errorImage
                                 title:(NSString *)title
                              subtitle:(NSString *)subtitle
                           maxSubLines:(NSInteger)maxSubLines
                               buttons:(NSArray<NSString *> *)buttons
                          buttonColors:(NSArray<NSString *> *)buttonColors
                           resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在顶部的弹框（可自定义弹按钮颜色；带时间文字）
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param title 标题
/// @param timeText 时间文字
/// @param subtitle 副标题
/// @param maxSubLines 副标题最大行数
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithImageUrl:(NSString *)imageUrl
                             imageType:(DialogImageType)imageType
                             imageSize:(CGSize)imageSize
                           placeholder:(UIImage *)placeholder
                            errorImage:(UIImage *)errorImage
                                 title:(NSString *)title
                              timeText:(NSString *)timeText
                              subtitle:(NSString *)subtitle
                           maxSubLines:(NSInteger)maxSubLines
                               buttons:(NSArray<NSString *> *)buttons
                          buttonColors:(NSArray<NSString *> *)buttonColors
                           resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在顶部的弹框（副标题是富文本）
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param title 标题
/// @param attributedSubtitle 副标题富文本
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithImageUrl:(NSString *)imageUrl
                             imageType:(DialogImageType)imageType
                             imageSize:(CGSize)imageSize
                           placeholder:(UIImage *)placeholder
                            errorImage:(UIImage *)errorImage
                                 title:(NSString *)title
                    attributedSubtitle:(NSAttributedString *)attributedSubtitle
                               buttons:(NSArray<NSString *> *)buttons
                           resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在标题下面的弹框
/// @param title 标题
/// @param subtitle 副标题
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                           imageUrl:(NSString *)imageUrl
                          imageType:(DialogImageType)imageType
                          imageSize:(CGSize)imageSize
                        placeholder:(UIImage *)placeholder
                         errorImage:(UIImage *)errorImage
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock;

#pragma mark - 生成弹框，不自动显示

/// 图片在顶部的弹框
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param title 标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle
                           buttons:(NSArray<NSString *> *)buttons
                       resultBlock:(DialogResultBlock)resultBlock;

/// 图片在顶部的弹框（可自定义弹按钮颜色）
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param title 标题
/// @param subtitle 副标题
/// @param maxSubLines 副标题最大行数
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle
                       maxSubLines:(NSInteger)maxSubLines
                           buttons:(NSArray<NSString *> *)buttons
                      buttonColors:(NSArray<NSString *> *)buttonColors
                       resultBlock:(DialogResultBlock)resultBlock;

/// 图片在顶部的弹框（可自定义弹按钮颜色；带时间文字）
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param title 标题
/// @param timeText 时间文字
/// @param subtitle 副标题
/// @param maxSubLines 副标题最大行数
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                          timeText:(NSString *)timeText
                          subtitle:(NSString *)subtitle
                       maxSubLines:(NSInteger)maxSubLines
                           buttons:(NSArray<NSString *> *)buttons
                      buttonColors:(NSArray<NSString *> *)buttonColors
                       resultBlock:(DialogResultBlock)resultBlock;

/// 图片在顶部的弹框（副标题是富文本）
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param title 标题
/// @param attributedSubtitle 副标题富文本
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                attributedSubtitle:(NSAttributedString *)attributedSubtitle
                           buttons:(NSArray<NSString *> *)buttons
                       resultBlock:(DialogResultBlock)resultBlock;

/// 图片在标题下面的弹框
/// @param title 标题
/// @param subtitle 副标题
/// @param imageUrl 图片地址
/// @param imageType 图片类型
/// @param imageSize 图片尺寸（主要用于计算宽高比）
/// @param placeholder 占位图
/// @param errorImage 加载失败图
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                       imageUrl:(NSString *)imageUrl
                      imageType:(DialogImageType)imageType
                      imageSize:(CGSize)imageSize
                    placeholder:(UIImage *)placeholder
                     errorImage:(UIImage *)errorImage
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock;

@end
