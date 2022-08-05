//
//  DialogPattern.m
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import "DialogPattern.h"

@implementation DialogPattern

- (instancetype)init {
    self = [super init];
    if (self) {
        // 内容距离左边的距离
        self.leftGap = 24.0;

        // 内容距离右边的距离
        self.rightGap = 24.0;

        // 内容距离顶部的距离（存在 Title 的情况）
        self.topGapWithTile = 24.0;

        // 内容距离顶部的距离（不存在 Title 的情况）
        self.topGapWithoutTile = 36.0;

        // 内容距离低部按钮的距离（无按钮的话就是距离底部的距离）
        self.bottomGap = 24.0;

        // 各组件之间的垂直距离(不包括底部按钮)
        self.verticalGap = 8.0;


        // 弹框圆角值
        self.cornerRadius = 8.0;

        // DialogView 距离屏幕左右的距离
        self.dialogLeftRightMargin = 36.0;
    }
    return self;
}

@end
