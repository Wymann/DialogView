//
//  TextFieldDialogElement.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "TextFieldDialogModel.h"

#import "BasicDialogElement.h"

NS_ASSUME_NONNULL_BEGIN


@interface TextFieldDialogElement : BasicDialogElement

/// 获取 textField
- (UITextField *)textField;

/// 获取ErrorLabel
- (UILabel *)errorLabel;

@end

NS_ASSUME_NONNULL_END
