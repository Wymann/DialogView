//
//  TextDialogElement.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogTextTool.h"
#import "TextDialogElement.h"

static const CGFloat DefaultFontSize = 16.0;      // 默认字体大小
static const CGFloat DefaultElementHeight = 40.0; // 默认高度
static const CGFloat DefaultLineSpace = 5;        // 默认行间距


@interface TextDialogElement ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *textLabel;

@end


@implementation TextDialogElement

#pragma mark - Setter Methods
- (void)setModel:(BasicDialogModel *)model {
    [super setModel:model];

    TextDialogModel *textModel = (TextDialogModel *)self.model;

    self.textLabel.numberOfLines = textModel.maxLines;

    if (textModel.attributedTextContent.string.length > 0 || textModel.textContent.length > 0) {
        if (textModel.attributedTextContent.string.length > 0) {
            self.textLabel.attributedText = textModel.attributedTextContent;
        } else {
            CGFloat fontSize = textModel.fontSize > 0 ? textModel.fontSize : DefaultFontSize;
            CGFloat lineSpace = textModel.lineSpace > 0 ? textModel.lineSpace : DefaultLineSpace;

            NSMutableArray *richText;
            if (textModel.richText.count > 0) {
                richText = [NSMutableArray arrayWithArray:textModel.richText];
            } else {
                richText = [NSMutableArray array];
            }

            if (textModel.isBold) {
                NSArray *range = @[@(0), @(textModel.textContent.length)];
                NSDictionary *fontRich = @{
                    @"richType": @"font",
                    @"range": range,
                    @"fontSize": @(fontSize),
                    @"bold": @"true"
                };
                [richText addObject:fontRich];
            }

            NSAttributedString *attributedText = [DialogTextTool createAttributedStringWithTextContent:textModel.textContent
                                                                                         textAlignment:textModel.textAlignment
                                                                                              FontSize:fontSize
                                                                                             lineSpace:lineSpace
                                                                                             textColor:textModel.textColor
                                                                                         richTextArray:[richText copy]];
            self.textLabel.attributedText = attributedText;
        }

        CGFloat X = textModel.textEdgeInsets.left;
        CGFloat Y = textModel.textEdgeInsets.top;
        CGFloat W = CGRectGetWidth(self.frame) - textModel.textEdgeInsets.left - textModel.textEdgeInsets.right;
        CGFloat H = CGRectGetHeight(self.frame) - textModel.textEdgeInsets.top - textModel.textEdgeInsets.bottom;
        CGFloat textHeight = [DialogTextTool richTextHeightWithAttributedString:self.textLabel.attributedText
                                                                          width:W
                                                                       maxLines:textModel.maxLines];

        if (textModel.maxHeight > 0 && textModel.scrollable && textModel.maxHeight < textHeight) {
            self.scrollView.frame = CGRectMake(X, Y, W, H);
            self.scrollView.contentSize = CGSizeMake(W, textHeight);
            [self addSubview:self.scrollView];

            self.textLabel.frame = CGRectMake(0, 0, W, textHeight);
            [self.scrollView addSubview:self.textLabel];
        } else {
            self.textLabel.frame = CGRectMake(X, Y, W, H);
            [self addSubview:self.textLabel];
        }
    }
}

#pragma mark - Lazy load Methods
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

#pragma mark - Element Height
+ (CGFloat)elementHeightWithModel:(BasicDialogModel *)model elementWidth:(CGFloat)elementWidth {
    TextDialogModel *textModel = (TextDialogModel *)model;
    CGFloat width = elementWidth - textModel.textEdgeInsets.left - textModel.textEdgeInsets.right;

    CGFloat height = 0;
    if (textModel.attributedTextContent.string.length > 0) {
        height = [DialogTextTool richTextHeightWithAttributedString:textModel.attributedTextContent width:width maxLines:textModel.maxLines] + textModel.textEdgeInsets.top + textModel.textEdgeInsets.bottom;
    } else if (textModel.textContent.length > 0) {
        CGFloat fontSize = textModel.fontSize > 0 ? textModel.fontSize : DefaultFontSize;
        CGFloat lineSpace = textModel.lineSpace > 0 ? textModel.lineSpace : DefaultLineSpace;

        NSAttributedString *attributedText = [DialogTextTool createAttributedStringWithTextContent:textModel.textContent
                                                                                     textAlignment:textModel.textAlignment
                                                                                          FontSize:fontSize
                                                                                         lineSpace:lineSpace
                                                                                         textColor:textModel.textColor
                                                                                     richTextArray:textModel.richText
                                                                                         breakMode:0];
        height =
            [DialogTextTool richTextHeightWithAttributedString:attributedText width:width maxLines:textModel.maxLines] + textModel.textEdgeInsets.top + textModel.textEdgeInsets.bottom;
    } else {
        height = DefaultElementHeight;
    }

    if (textModel.maxHeight > 0 && textModel.maxHeight < height) {
        height = textModel.maxHeight;
    }

    return height;
}

@end
