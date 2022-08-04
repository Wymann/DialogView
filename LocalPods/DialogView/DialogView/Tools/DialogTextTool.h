//
//  DialogTextTool.h
//  OWFormView
//
//  Created by Owen Chen on 2018/6/12.
//  Copyright © 2018年 Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DialogTextTool : NSObject

/**
 获取单行文本高度

 @param text 普通单行文本
 @param font 字体
 @return 计算出的普通单行文本宽度
 */
+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font;

/**
 获取普通文字高度

 @param text 普通文本
 @param width 宽度
 @param font 字体
 @return 计算出的普通文本高度
 */
+ (CGFloat)getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

/**
 获取富文本高度

 @param attributted 需要操作的富文本
 @param width 宽度
 @return 计算出的富文本高度
 */
+ (CGFloat)getTextHeightWithAttributedText:(NSAttributedString *)attributted Width:(CGFloat)width;

/// 创建富文本数据
/// @param textContent 文本
/// @param textAlignment 字体位置
/// @param fontSize 通用字体大小
/// @param lineSpace 通用行距
/// @param textColor 通用文字颜色
/// @param richTextArray 富文本数组（部分文字格式改变）
+ (NSMutableAttributedString *)createAttributedStringWithTextContent:(NSString *)textContent
                                                       textAlignment:(NSTextAlignment)textAlignment
                                                            FontSize:(CGFloat)fontSize
                                                           lineSpace:(CGFloat)lineSpace
                                                           textColor:(UIColor *)textColor
                                                       richTextArray:(NSArray *)richTextArray;

/// 创建富文本数据
/// @param textContent 文本
/// @param textAlignment 字体位置
/// @param fontSize 通用字体大小
/// @param lineSpace 通用行距
/// @param textColor 通用文字颜色
/// @param richTextArray 富文本数组（部分文字格式改变）
/// @param breakMode 分行类型
+ (NSMutableAttributedString *)createAttributedStringWithTextContent:(NSString *)textContent
                                                       textAlignment:(NSTextAlignment)textAlignment
                                                            FontSize:(CGFloat)fontSize
                                                           lineSpace:(CGFloat)lineSpace
                                                           textColor:(UIColor *)textColor
                                                       richTextArray:(NSArray *)richTextArray
                                                           breakMode:(NSLineBreakMode)breakMode;

/// 获取 textView 中富文本高度
/// @param attributedString 富文本
/// @param width 固定宽度
/// @param maxLines 最大行数
+ (CGFloat)richTextHeightWithAttributedString:(NSAttributedString *)attributedString
                                        width:(CGFloat)width
                                     maxLines:(NSInteger)maxLines;

/// 计算文本行数
/// @param text 文本
/// @param font 字体
/// @param width 控件宽度
+ (NSInteger)linesOfText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

@end
