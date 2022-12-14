//
//  TextViewDialogElement.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "TextViewDialogElement.h"

#import "UITextView+Dialog.h"
#import "UIView+Dialog.h"
#import "UIFont+Dialog.h"

#define DialogPlaceHolderColor @"#888888"          // 占位文字颜色
static const CGFloat DefaultFontSize = 14.0;       // 默认字体大小
static const CGFloat DefaultElementHeight = 144.0; // 默认高度
static const CGFloat ErrorLabelHeight = 24.0;
static const CGFloat MaxLengthLabelHeight = 22.0;
static const CGFloat MaxLengthLabelBottomGap = 12.0;


@interface TextViewDialogElement ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *maxLengthLabel;

@end


@implementation TextViewDialogElement

#pragma mark - Setter Methods
- (void)setModel:(BasicDialogModel *)model {
    [super setModel:model];

    TextViewDialogModel *textViewModel = (TextViewDialogModel *)self.model;

    CGFloat X = textViewModel.textViewEdgeInsets.left;
    CGFloat Y = textViewModel.textViewEdgeInsets.top;
    CGFloat W = CGRectGetWidth(self.frame) - textViewModel.textViewEdgeInsets.left - textViewModel.textViewEdgeInsets.right;
    CGFloat H = CGRectGetHeight(self.frame) - textViewModel.textViewEdgeInsets.top - textViewModel.textViewEdgeInsets.bottom - ErrorLabelHeight;
    self.textView.frame = CGRectMake(X, Y, W, H);
    [self addSubview:self.textView];

    CGFloat fontSize = textViewModel.fontSize > 0 ? textViewModel.fontSize : DefaultFontSize;

    self.textView.textColor = textViewModel.textColor;
    self.textView.placeholder = textViewModel.placeHolderContent;
    self.textView.placeholderColor = [UIColor dialog_colorWithHexString:DialogPlaceHolderColor];
    self.textView.text = textViewModel.textContent;
    self.textView.textAlignment = textViewModel.textAlignment;
    self.textView.font = [UIFont dialog_normalFontWithFontSize:fontSize];
    self.textView.keyboardType = textViewModel.keyboardType;
    if (textViewModel.maxTextLength > 0) {
        self.textView.contentInset = UIEdgeInsetsMake(5, 5, MaxLengthLabelHeight + MaxLengthLabelBottomGap + 5, 5);
        self.textView.placeholderTextView.contentInset = UIEdgeInsetsMake(5, 5, MaxLengthLabelHeight + MaxLengthLabelBottomGap + 5, 5);
    } else {
        self.textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.textView.placeholderTextView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    self.textView.tintColor = textViewModel.tintColor;
    self.textView.editable = textViewModel.editable;

    self.errorLabel.frame = CGRectMake(X, CGRectGetMaxY(self.textView.frame), W, ErrorLabelHeight);
    [self addSubview:self.errorLabel];

    if (textViewModel.maxTextLength > 0) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame) - MaxLengthLabelHeight - MaxLengthLabelBottomGap,
                                                                    CGRectGetWidth(self.textView.frame), MaxLengthLabelHeight + MaxLengthLabelBottomGap + 1)];
        backView.backgroundColor = self.textView.backgroundColor;
        [self addSubview:backView];
        [backView setBorderWithCornerRadius:4.0 borderWidth:0 borderColor:backView.backgroundColor type:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        self.maxLengthLabel.frame = CGRectMake(16.0, 0, CGRectGetWidth(backView.frame) - 32.0, MaxLengthLabelHeight);
        [backView addSubview:self.maxLengthLabel];
        self.maxLengthLabel.text = [NSString stringWithFormat:@"%ld/%ld", textViewModel.textContent.length, textViewModel.maxTextLength];
    }
}

#pragma mark - Lazy load Methods
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.layer.cornerRadius = 4.0;
        _textView.backgroundColor = [UIColor dialog_colorWithHexString:@"#F4F5F7"];
    }
    return _textView;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textColor = [UIColor dialog_colorWithHexString:@"#FF4747"];
        _errorLabel.font = [UIFont dialog_normalFontWithFontSize:12];
    }
    return _errorLabel;
}

- (UILabel *)maxLengthLabel {
    if (!_maxLengthLabel) {
        _maxLengthLabel = [[UILabel alloc] init];
        _maxLengthLabel.textColor = [UIColor dialog_normalColorWithAlpha:0.4];
        _maxLengthLabel.font = [UIFont dialog_normalFontWithFontSize:14];
        _maxLengthLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxLengthLabel;
}

- (NSInteger)textViewMaxLength {
    TextViewDialogModel *textViewModel = (TextViewDialogModel *)self.model;
    return textViewModel.maxTextLength;
}

#pragma mark - Element Height
+ (CGFloat)elementHeightWithModel:(BasicDialogModel *)model elementWidth:(CGFloat)elementWidth {
    return DefaultElementHeight;
}

@end
