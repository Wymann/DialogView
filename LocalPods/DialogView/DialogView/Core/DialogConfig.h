//
//  DialogConfig.h
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import <Foundation/Foundation.h>

#import "DialogColor.h"
#import "DialogFont.h"
#import "DialogPattern.h"

NS_ASSUME_NONNULL_BEGIN

/**
 出现时动画

 - ShowAnimationFromTop: 从上往下
 - ShowAnimationFromLeft: 从左往右
 - ShowAnimationFromBottom: 从下往上
 - ShowAnimationFromRight: 从右往左
 - ShowAnimationFade: 渐渐显示（透明度动画）
 - ShowAnimationNone: 无动画（默认）
 */
typedef NS_ENUM(NSInteger, ShowAnimation) {
    ShowAnimationFromTop = 0,
    ShowAnimationFromLeft = 1,
    ShowAnimationFromBottom = 2,
    ShowAnimationFromRight = 3,
    ShowAnimationFade = 4,
    ShowAnimationNone = 5,
};

/**
 弹框弹出后停留状态

 - DialogPositionMiddle: 停在中间
 - DialogPositionBottom: 停在下面
 - DialogPositionTop: 停在上面
 */
typedef NS_ENUM(NSInteger, DialogPosition) {
    DialogPositionMiddle = 0,
    DialogPositionBottom = 1,
    DialogPositionTop = 2
};

@interface DialogConfig : NSObject

// 用到的颜色风格（自定义视图除外）
@property (nonatomic, strong) DialogColor *color;

// 用到的字体库（为空则选择系统字体）（自定义视图除外）
@property (nonatomic, strong) DialogFont *font;

// 用到的各个数值配置（自定义视图除外）
@property (nonatomic, strong) DialogPattern *pattern;

// 显示动画
@property (nonatomic, assign) ShowAnimation animation;

// 是否弹性动画弹出
@property (nonatomic, assign) BOOL bounce;

// 停留位置
@property (nonatomic, assign) DialogPosition position;

// 点击周边空白处是否关闭弹窗
@property (nonatomic, assign) BOOL sideTap;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
