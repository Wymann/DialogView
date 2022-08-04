//
//  DialogResult.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SelectorDialogItem, DialogView;


@interface DialogResult : NSObject

@property (nonatomic, weak) DialogView *dialogView;

#pragma mark - Button Result
@property (nonatomic, assign) NSInteger buttonIndex; //点击了第几个按钮（如果为-1的话则表示点击的是空白处）
@property (nonatomic, copy) NSString *buttonTitle;   //点击的按钮标题

#pragma mark - TextFild/TextView Result
@property (nonatomic, copy) NSString *inputText; //输入框文字

#pragma mark - Selector Result
@property (nonatomic, strong) NSArray<NSNumber *> *selectedIndexs;
@property (nonatomic, strong) NSArray<SelectorDialogItem *> *selectedItems;

@end

NS_ASSUME_NONNULL_END
