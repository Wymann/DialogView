//
//  UIFont+Dialog.h
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Dialog)

+ (UIFont *)dialog_normalFontWithFontSize:(CGFloat)fontSize;

+ (UIFont *)dialog_boldFontWithFontSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
