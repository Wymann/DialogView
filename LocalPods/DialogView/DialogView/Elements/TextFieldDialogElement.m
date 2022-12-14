//
//  TextFieldDialogElement.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "TextFieldDialogElement.h"

#import "UIFont+Dialog.h"

static const CGFloat DefaultFontSize = 14.0;      // 默认字体大小
static const CGFloat DefaultElementHeight = 68.0; // 默认高度
static const CGFloat ErrorLabelHeight = 24.0;


@interface TextFieldDialogElement ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *errorLabel;

@end


@implementation TextFieldDialogElement

#pragma mark - Setter Methods
- (void)setModel:(BasicDialogModel *)model {
    [super setModel:model];

    TextFieldDialogModel *textFieldModel = (TextFieldDialogModel *)self.model;

    CGFloat X = textFieldModel.textFieldEdgeInsets.left;
    CGFloat Y = textFieldModel.textFieldEdgeInsets.top;
    CGFloat W = CGRectGetWidth(self.frame) - textFieldModel.textFieldEdgeInsets.left - textFieldModel.textFieldEdgeInsets.right;
    CGFloat H = CGRectGetHeight(self.frame) - textFieldModel.textFieldEdgeInsets.top - textFieldModel.textFieldEdgeInsets.bottom - ErrorLabelHeight;
    self.textField.frame = CGRectMake(X, Y, W, H);
    [self addSubview:self.textField];

    CGFloat fontSize = textFieldModel.fontSize > 0 ? textFieldModel.fontSize : DefaultFontSize;

    if (textFieldModel.placeHolderContent.length > 0) {
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:textFieldModel.placeHolderContent];
        [attributedPlaceholder addAttribute:NSFontAttributeName
                                      value:[UIFont dialog_normalFontWithFontSize:fontSize]
                                      range:NSMakeRange(0, textFieldModel.placeHolderContent.length)];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName
                                      value:[textFieldModel.textColor colorWithAlphaComponent:0.4]
                                      range:NSMakeRange(0, textFieldModel.placeHolderContent.length)];
        self.textField.attributedPlaceholder = attributedPlaceholder;
    }

    self.textField.textColor = textFieldModel.textColor;
    self.textField.text = textFieldModel.textContent;
    self.textField.textAlignment = textFieldModel.textAlignment;
    self.textField.font = [UIFont dialog_normalFontWithFontSize:fontSize];
    self.textField.keyboardType = textFieldModel.keyboardType;
    self.textField.tintColor = textFieldModel.tintColor;

    self.errorLabel.frame = CGRectMake(X, CGRectGetMaxY(self.textField.frame), W, ErrorLabelHeight);
    [self addSubview:self.errorLabel];
}

#pragma mark - Lazy load Methods
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.layer.cornerRadius = 4.0;
        _textField.backgroundColor = [UIColor dialog_colorWithHexString:@"#ECECEC"];
        UIView *leftView = [[UIView alloc] init];
        CGRect frame;
        frame.size.width = 10;
        leftView.frame = frame;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = leftView;
    }
    return _textField;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textColor = [UIColor dialog_colorWithHexString:@"#FF4747"];
        _errorLabel.font = [UIFont dialog_normalFontWithFontSize:12];
    }
    return _errorLabel;
}

#pragma mark - Element Height
+ (CGFloat)elementHeightWithModel:(BasicDialogModel *)model elementWidth:(CGFloat)elementWidth {
    return DefaultElementHeight;
}

@end
