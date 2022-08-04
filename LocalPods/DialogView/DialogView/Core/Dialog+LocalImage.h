//
//  Dialog+ImageText.h
//  TCLPlus
//
//  Created by Wymann Chan on 2021/6/10.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog.h"

typedef NS_ENUM(NSInteger, DialogImageType) {
    DialogImageTypeCommon = 0, // 普通类型（距离 DialogView 边距为16）
    DialogImageTypeLarge = 1,  // 大图类型（距离 DialogView 边距为0）
    DialogImageTypeSmall = 2,  // 小图类型（水平居中且宽为100的icon）
    DialogImageTypeTiny = 3,   // 大图类型（水平居中且宽为50的icon）
};


@interface Dialog (LocalImage)

#pragma mark - 自动显示弹框

/// 显示图片在顶部的弹框
/// @param image 图片
/// @param imageType 图片类型
/// @param title 标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithImage:(UIImage *)image
                          imageType:(DialogImageType)imageType
                              title:(NSString *)title
                           subtitle:(NSString *)subtitle
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在顶部的弹框（可自定义弹按钮颜色）
/// @param image 图片
/// @param imageType 图片类型
/// @param title 标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithImage:(UIImage *)image
                          imageType:(DialogImageType)imageType
                              title:(NSString *)title
                           subtitle:(NSString *)subtitle
                            buttons:(NSArray<NSString *> *)buttons
                       buttonColors:(NSArray<NSString *> *)buttonColors
                        resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在顶部的弹框（副标题是富文本）
/// @param image 图片
/// @param imageType 图片类型
/// @param title 标题
/// @param attributedSubtitle 副标题富文本
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithImage:(UIImage *)image
                          imageType:(DialogImageType)imageType
                              title:(NSString *)title
                 attributedSubtitle:(NSAttributedString *)attributedSubtitle
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在标题下面的弹框
/// @param title 标题
/// @param subtitle 副标题
/// @param image 图片
/// @param imageType 图片类型
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                              image:(UIImage *)image
                          imageType:(DialogImageType)imageType
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在标题下面的弹框
/// @param title 标题
/// @param subtitle 副标题
/// @param image 图片
/// @param imageType 图片类型
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                              image:(UIImage *)image
                  imageCornerRadius:(CGFloat)imageCornerRadius
                          imageType:(DialogImageType)imageType
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock;

/// 显示图片在标题下面的弹框（图片大小自定义）
/// @param title 标题
/// @param subtitle 副标题
/// @param image 图片
/// @param customImageSize 图片大小
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                              image:(UIImage *)image
                    customImageSize:(CGSize)customImageSize
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock;

#pragma mark - 生成弹框，不自动显示

/// 图片在顶部的弹框
/// @param image 图片
/// @param imageType 图片类型
/// @param title 标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithImage:(UIImage *)image
                      imageType:(DialogImageType)imageType
                          title:(NSString *)title
                       subtitle:(NSString *)subtitle
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock;

/// 图片在顶部的弹框（可自定义弹按钮颜色）
/// @param image 图片
/// @param imageType 图片类型
/// @param title 标题
/// @param subtitle 副标题
/// @param buttons 按钮标题
/// @param buttonColors 按钮标题颜色
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithImage:(UIImage *)image
                      imageType:(DialogImageType)imageType
                          title:(NSString *)title
                       subtitle:(NSString *)subtitle
                        buttons:(NSArray<NSString *> *)buttons
                   buttonColors:(NSArray<NSString *> *)buttonColors
                    resultBlock:(DialogResultBlock)resultBlock;

/// 图片在顶部的弹框（副标题是富文本）
/// @param image 图片
/// @param imageType 图片类型
/// @param title 标题
/// @param attributedSubtitle 副标题富文本
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithImage:(UIImage *)image
                      imageType:(DialogImageType)imageType
                          title:(NSString *)title
             attributedSubtitle:(NSAttributedString *)attributedSubtitle
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock;

/// 图片在标题下面的弹框
/// @param title 标题
/// @param subtitle 副标题
/// @param image 图片
/// @param imageType 图片类型
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                          image:(UIImage *)image
                      imageType:(DialogImageType)imageType
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock;

/// 图片在标题下面的弹框
/// @param title 标题
/// @param subtitle 副标题
/// @param image 图片
/// @param imageType 图片类型
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                          image:(UIImage *)image
              imageCornerRadius:(CGFloat)imageCornerRadius
                      imageType:(DialogImageType)imageType
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock;

/// 图片在标题下面的弹框（图片大小自定义）
/// @param title 标题
/// @param subtitle 副标题
/// @param image 图片
/// @param customImageSize 图片大小
/// @param buttons 按钮标题
/// @param resultBlock 结果回调
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                          image:(UIImage *)image
                customImageSize:(CGSize)customImageSize
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock;

@end
