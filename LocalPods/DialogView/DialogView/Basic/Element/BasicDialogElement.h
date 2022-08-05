//
//  BasicDialogElement.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/17.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BasicDialogModel.h"

#import "UIColor+Dialog.h"

NS_ASSUME_NONNULL_BEGIN


@interface BasicDialogElement : UIView

/// 数据模型
@property (nonatomic, strong) BasicDialogModel *model;

/// 计算Element高度
/// @param model 数据模型
/// @param elementWidth 宽度
+ (CGFloat)elementHeightWithModel:(BasicDialogModel *)model elementWidth:(CGFloat)elementWidth;

@end

NS_ASSUME_NONNULL_END
