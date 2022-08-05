//
//  DialogPattern.h
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialogPattern : NSObject

// 内容距离左边的距离
@property (nonatomic, assign) CGFloat leftGap;

// 内容距离右边的距离
@property (nonatomic, assign) CGFloat rightGap;

// 内容距离顶部的距离（存在 Title 的情况）
@property (nonatomic, assign) CGFloat topGapWithTile;

// 内容距离顶部的距离（不存在 Title 的情况）
@property (nonatomic, assign) CGFloat topGapWithoutTile;

// 内容距离低部按钮的距离（无按钮的话就是距离底部的距离）
@property (nonatomic, assign) CGFloat bottomGap;

// 各组件之间的垂直距离(不包括底部按钮)
@property (nonatomic, assign) CGFloat verticalGap;


// 弹框圆角值
@property (nonatomic, assign) CGFloat cornerRadius;

// DialogView 距离屏幕左右的距离
@property (nonatomic, assign) CGFloat dialogLeftRightMargin;

@end

NS_ASSUME_NONNULL_END
