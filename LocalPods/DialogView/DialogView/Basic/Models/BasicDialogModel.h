//
//  BasicDialogModel.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BasicDialogModel : NSObject

/// 上下左右边距
@property (nonatomic, assign) UIEdgeInsets margin;
/// 背景色
@property (nonatomic, copy) NSString *bgColor;
/// 圆角
@property (nonatomic, assign) CGFloat cornerRadius;
/// 组件类名
@property (nonatomic, copy) NSString *elementClassName;

@end

NS_ASSUME_NONNULL_END
