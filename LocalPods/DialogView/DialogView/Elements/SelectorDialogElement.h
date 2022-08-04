//
//  SelectorDialogElement.h
//  TCLPlus
//
//  Created by OwenChen on 2021/1/7.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "SelectorDialogModel.h"

#import "BasicDialogElement.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ResultFromItemTapBlock)(NSArray<SelectorDialogItem *> *selectedItems, NSArray<NSNumber *> *selectedIndexs);


@interface SelectorCell : UITableViewCell

@property (nonatomic, strong) SelectorDialogItem *item;

- (void)enableUnderlineShown:(BOOL)shown;

@end


@interface SelectorDialogElement : BasicDialogElement

@property (nonatomic, copy) ResultFromItemTapBlock resultBlock;

@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *selectedIndexs;
@property (nonatomic, strong, readonly) NSMutableArray<SelectorDialogItem *> *selectedItems;

@end

NS_ASSUME_NONNULL_END
