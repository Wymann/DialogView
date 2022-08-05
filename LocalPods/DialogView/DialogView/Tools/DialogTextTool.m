//
//  DialogTextTool.m
//  OWFormView
//
//  Created by Owen Chen on 2018/6/12.
//  Copyright © 2018年 Owen. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "DialogTextTool.h"

#import "UIColor+Dialog.h"
#import "UIFont+Dialog.h"

@implementation DialogTextTool

//获取单行文字宽度
+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font {
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: font}
                                         context:nil]
                          .size;
    return textSize.width;
}

//获取文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    if ([text isEqualToString:@""]) {
        return 0.0;
    } else {
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: font}
                                             context:nil]
                              .size;
        return textSize.height + 2.0;
    }
}

//获取富文本高度
+ (CGFloat)getTextHeightWithAttributedText:(NSAttributedString *)attributted Width:(CGFloat)width {
    if (width <= 0) {
        return 0.0;
    }

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    lab.attributedText = attributted;
    lab.numberOfLines = 0;

    CGSize labSize = [lab sizeThatFits:lab.bounds.size];

    return labSize.height + 5.0;
}

/// 创建富文本数据
+ (NSMutableAttributedString *)createAttributedStringWithTextContent:(NSString *)textContent
                                                       textAlignment:(NSTextAlignment)textAlignment
                                                            FontSize:(CGFloat)fontSize
                                                           lineSpace:(CGFloat)lineSpace
                                                           textColor:(UIColor *)textColor
                                                       richTextArray:(NSArray *)richTextArray {
    return [DialogTextTool createAttributedStringWithTextContent:textContent textAlignment:textAlignment FontSize:fontSize lineSpace:lineSpace
                                                       textColor:textColor
                                                   richTextArray:richTextArray
                                                       breakMode:NSLineBreakByTruncatingTail];
}

/// 创建富文本数据
+ (NSMutableAttributedString *)createAttributedStringWithTextContent:(NSString *)textContent
                                                       textAlignment:(NSTextAlignment)textAlignment
                                                            FontSize:(CGFloat)fontSize
                                                           lineSpace:(CGFloat)lineSpace
                                                           textColor:(UIColor *)textColor
                                                       richTextArray:(NSArray *)richTextArray
                                                           breakMode:(NSLineBreakMode)breakMode {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:textContent];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont dialog_normalFontWithFontSize:fontSize] range:NSMakeRange(0, textContent.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setLineBreakMode:breakMode];
    paragraphStyle.alignment = textAlignment;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textContent length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [textContent length])];
    for (NSDictionary *richDic in richTextArray) {
        NSString *richType = richDic[@"richType"];
        NSArray *rangeArray = richDic[@"range"];
        if ([[rangeArray firstObject] integerValue] + [[rangeArray lastObject] integerValue] > textContent.length) {
            continue;
        }
        if (richType.length > 0 && rangeArray.count == 2) {
            NSRange range = NSMakeRange([[rangeArray firstObject] integerValue], [[rangeArray lastObject] integerValue]);
            if ([richType isEqualToString:@"color"]) {
                NSString *textColorString = richDic[@"textColor"];
                if (textColorString.length > 0) {
                    UIColor *color = [UIColor dialog_colorWithHexString:textColorString];
                    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:range];
                } else {
                    continue;
                }
            } else if ([richType isEqualToString:@"link"]) {
                NSString *linkUrl = richDic[@"linkUrl"];
                if (linkUrl.length > 0) {
                    [attributedText addAttribute:NSLinkAttributeName value:linkUrl range:range];
                } else {
                    continue;
                }
            } else if ([richType isEqualToString:@"font"]) {
                if (richDic[@"fontSize"]) {
                    CGFloat fontSizeFloat = [richDic[@"fontSize"] floatValue];
                    UIFont *font =
                        [richDic[@"bold"] isEqualToString:@"true"] ? [UIFont dialog_boldFontWithFontSize:fontSizeFloat] : [UIFont dialog_normalFontWithFontSize:fontSizeFloat];
                    [attributedText addAttribute:NSFontAttributeName value:font range:range];
                } else {
                    continue;
                }
            }
        }
    }
    return attributedText;
}

/// 获取 textView 中富文本高度
+ (CGFloat)richTextHeightWithAttributedString:(NSAttributedString *)attributedString
                                        width:(CGFloat)width
                                     maxLines:(NSInteger)maxLines {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = maxLines;
    label.attributedText = attributedString;
    return [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
}

/// 计算文本行数
+ (NSInteger)linesOfText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    if (!text || text.length == 0) {
        return 0;
    }
    NSString *fontName = font.fontName;
    if ([fontName isEqualToString:@".SFUI-Regular"]) {
        fontName = @"TimesNewRomanPSMT";
    }

    CTFontRef myFont = CTFontCreateWithName((CFStringRef)(fontName), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, width, MAXFLOAT));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    return lines.count;
}

@end
