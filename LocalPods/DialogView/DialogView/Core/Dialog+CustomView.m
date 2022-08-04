//
//  Dialog+CustomView.m
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog+CustomView.h"


@implementation Dialog (CustomView)

/// 弹框显示自定义视图
+ (DialogView *)showDialogWithCustomView:(UIView *)customView
                        customViewHeight:(CGFloat)customViewHeight
                             resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [[DialogView alloc] initWithCustomView:customView customViewHeight:customViewHeight animation:[Dialog sharedInstance].animationType
                                                     position:DialogPositionMiddle
                                                      sideTap:YES
                                                       bounce:YES];
    view.resultBlock = resultBlock;
    [self addDialogView:view];

    return view;
}

/// 弹框显示自定义视图
+ (DialogView *)showDialogWithCustomView:(UIView *)customView
                          customViewSize:(CGSize)customViewSize
                             resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [[DialogView alloc] initWithCustomView:customView customViewSize:customViewSize animation:[Dialog sharedInstance].animationType
                                                     position:DialogPositionMiddle
                                                      sideTap:YES
                                                       bounce:YES];
    view.resultBlock = resultBlock;
    [self addDialogView:view];

    return view;
}

/// 弹框显示自定义视图
+ (DialogView *)showDialogWithCustomView:(UIView *)customView
                          customViewSize:(CGSize)customViewSize
                           showAnimation:(ShowAnimation)showAnimation
                                position:(DialogPosition)position
                                  bounce:(BOOL)bounce
                             resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [[DialogView alloc] initWithCustomView:customView customViewSize:customViewSize animation:showAnimation position:position sideTap:YES
                                                       bounce:bounce];
    view.resultBlock = resultBlock;
    [self addDialogView:view];

    return view;
}

/// 自定义视图
+ (DialogView *)dialogWithCustomView:(UIView *)customView
                    customViewHeight:(CGFloat)customViewHeight
                         resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [[DialogView alloc] initWithCustomView:customView customViewHeight:customViewHeight animation:[Dialog sharedInstance].animationType
                                                     position:DialogPositionMiddle
                                                      sideTap:YES
                                                       bounce:YES];
    view.resultBlock = resultBlock;
    return view;
}

/// 自定义视图
+ (DialogView *)dialogWithCustomView:(UIView *)customView
                      customViewSize:(CGSize)customViewSize
                         resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [[DialogView alloc] initWithCustomView:customView customViewSize:customViewSize animation:[Dialog sharedInstance].animationType
                                                     position:DialogPositionMiddle
                                                      sideTap:YES
                                                       bounce:YES];
    view.resultBlock = resultBlock;
    return view;
}

@end
