//
//  TextShouldChangeResModel.m
//  TCLPlus
//
//  Created by Liuqs on 2020/10/14.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "TextShouldChangeResModel.h"


@implementation TextShouldChangeResModel

+ (instancetype)modelWithShouldChange:(BOOL)shouldChange tipString:(NSString *)tipString {
    TextShouldChangeResModel *model = [[TextShouldChangeResModel alloc] init];
    model.shouldChange = shouldChange;
    model.tip = tipString;
    return model;
}

@end
