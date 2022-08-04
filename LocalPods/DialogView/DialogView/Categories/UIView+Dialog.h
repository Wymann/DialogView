//
//  UIView+Dialog.h
//  TlifeApp
//
//  Created by Wymann Chan on 2021/12/15.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView (Dialog)

/// 设置圆角
/// @param cornerRadius 圆角半径
/// @param borderWidth 边宽
/// @param borderColor 边颜色
/// @param corners 角
- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners;

@end

NS_ASSUME_NONNULL_END
