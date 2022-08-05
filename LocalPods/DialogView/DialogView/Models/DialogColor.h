//
//  DialogColor.h
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialogColor : NSObject

// 十六进制 普通颜色
@property (nonatomic, copy) NSString *commonColor;

// 十六进制 提示颜色（强调按钮、输入框 hintColor）
@property (nonatomic, copy) NSString *hintColor;

/// 快捷创建 DialogColor
/// @param commonColor 十六进制 普通颜色
/// @param hintColor 十六进制 提示颜色（强调按钮、输入框 hintColor）
+ (DialogColor *)dialogColorWithCommonColor:(NSString *)commonColor
                                  hintColor:(NSString *)hintColor;

@end

NS_ASSUME_NONNULL_END
