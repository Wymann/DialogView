//
//  DialogColor.m
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import "DialogColor.h"

@implementation DialogColor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.commonColor = @"#2D3132";
        self.hintColor = @"#E64C3D";
    }
    return self;
}

/// 快捷创建 DialogColor
+ (DialogColor *)dialogColorWithCommonColor:(NSString *)commonColor
                                  hintColor:(NSString *)hintColor {
    DialogColor *dialogColor = [[DialogColor alloc] init];
    dialogColor.commonColor = commonColor;
    dialogColor.hintColor = hintColor;
    return dialogColor;
}

@end
