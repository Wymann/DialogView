//
//  UIColor+Dialog.h
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Dialog)

/**
 通过Hex值取颜色

 @param hexString 颜色十六进制字符串
 @return 颜色
 */
+ (UIColor *)dialog_colorWithHexString:(NSString *)hexString;

/**
 通过Hex值取颜色

 @param hexString 颜色十六进制字符串
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)dialog_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/// Dialog 普通颜色
+ (UIColor *)dialog_normalColor;

/// Dialog 普通颜色
/// @param alpha 透明度
+ (UIColor *)dialog_normalColorWithAlpha:(CGFloat)alpha;

/// Dialog 提示颜色（强调按钮、输入框 hintColor）
+ (UIColor *)dialog_hintColor;

@end

NS_ASSUME_NONNULL_END
