//
//  DialogFont.m
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import "DialogFont.h"

@implementation DialogFont

- (instancetype)init {
    self = [super init];
    if (self) {
        self.normalFontName = @"";
        self.boldFontName = @"";
    }
    return self;
}

/// 快捷创建 DialogFont
+ (DialogFont *)dialogFontWithNormalFontName:(NSString *)normalFontName
                                BoldFontName:(NSString *)boldFontName {
    DialogFont *dialogFont = [[DialogFont alloc] init];
    dialogFont.normalFontName = normalFontName;
    dialogFont.boldFontName = boldFontName;
    return dialogFont;
}

@end
