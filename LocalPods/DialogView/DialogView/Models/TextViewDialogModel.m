//
//  TextViewDialogModel.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/19.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "TextViewDialogModel.h"


@implementation TextViewDialogModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.editable = YES;
    }
    return self;
}

@end
