//
//  ButtonsDialogElement.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "ButtonsDialogModel.h"

#import "BasicDialogElement.h"

NS_ASSUME_NONNULL_BEGIN
/** 点击按钮回调 */
typedef void (^ButtonBlock)(NSInteger buttonIndex);


@interface ButtonsDialogElement : BasicDialogElement

@property (nonatomic, copy) ButtonBlock clickBlock;

/** 使某个按钮重新恢复点击事件 */
- (void)enableButtonAtIndex:(NSInteger)buttonIndex;

/**使某个按钮无法点击。*/
- (void)disabledButtonAtIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END
