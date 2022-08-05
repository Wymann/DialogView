//
//  BasicDialogElement.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/17.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "BasicDialogElement.h"


@implementation BasicDialogElement

- (void)setModel:(BasicDialogModel *)model {
    _model = model;

    NSString *bgColor = _model.bgColor.length > 0 ? _model.bgColor : @"#FFFFFF";
    self.backgroundColor = [UIColor dialog_colorWithHexString:bgColor];
    self.layer.cornerRadius = _model.cornerRadius;
    self.clipsToBounds = YES;
}

// 需要子类重写
+ (CGFloat)elementHeightWithModel:(BasicDialogModel *)model elementWidth:(CGFloat)elementWidth {
    return 0;
}

@end
