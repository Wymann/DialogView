//
//  TextViewDialogElement.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/19.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "TextViewDialogModel.h"

#import "BasicDialogElement.h"

NS_ASSUME_NONNULL_BEGIN


@interface TextViewDialogElement : BasicDialogElement

- (UITextView *)textView;

/// 获取ErrorLabel
- (UILabel *)errorLabel;

- (UILabel *)maxLengthLabel;

- (NSInteger)textViewMaxLength;

@end

NS_ASSUME_NONNULL_END
