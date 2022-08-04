//
//  SelectorDialogModel.m
//  TCLPlus
//
//  Created by OwenChen on 2021/1/7.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "SelectorDialogModel.h"


@implementation SelectorPreference

- (instancetype)init {
    self = [super init];
    if (self) {
        /// 选中时候标题颜色
        self.selectedTitleColor = @"#2D3132";

        /// 非选中时候标题颜色
        self.unselectedTitleColor = @"#2D3132";

        /// 选中时候副标题颜色
        self.selectedSubtitleColor = @"#662D3132";

        /// 非选中时候副标题颜色
        self.unselectedSubtitleColor = @"#662D3132";

        /// 无法选中时候所有标题颜色
        self.unenabledColor = @"#1A2D3132";

        self.maxSelectNum = 1; //默认为1

        self.resultFromItemTap = YES;

        self.maxShownItemNum = 8;

        self.maxSubtitleLines = 3;
    }
    return self;
}

@end


@interface SelectorDialogItem ()

/// 偏好配置
@property (nonatomic, strong) SelectorPreference *preference;

@end


@implementation SelectorDialogItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enabled = YES; //默认可选中
        self.selected = NO; //默认不是被选中状态
    }
    return self;
}

+ (SelectorDialogItem *)createItemWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle selected:(BOOL)selected enabled:(BOOL)enabled {
    SelectorDialogItem *item = [[SelectorDialogItem alloc] init];
    item.title = title;
    item.subtitle = subtitle;
    item.selected = selected;
    item.enabled = enabled;
    return item;
}

- (void)setupPreference:(SelectorPreference *)preference {
    _preference = preference;
}

@end


@implementation SelectorDialogModel

- (void)setItems:(NSArray<SelectorDialogItem *> *)items {
    _items = items;

    if (self.preference) {
        [self setupSelectorDialogItemPreference];
    }
}

- (void)setPreference:(SelectorPreference *)preference {
    _preference = preference;

    if (![self.items firstObject].preference) {
        [self setupSelectorDialogItemPreference];
    }
}

- (void)setupSelectorDialogItemPreference {
    for (SelectorDialogItem *item in self.items) {
        item.preference = self.preference;
    }
}

@end
