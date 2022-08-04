//
//  SelectorDialogElement.m
//  TCLPlus
//
//  Created by OwenChen on 2021/1/7.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogTextTool.h"
#import "SelectorDialogElement.h"

#import "UIFont+TCLHUI.h"

static const CGFloat minimalCellHeight = 48.0;

static const CGFloat LeftGap = 24.0;
static const CGFloat RightGap = 24.0;
static const CGFloat TopGap = 10.0;
static const CGFloat BottomGap = 10.0;
static const CGFloat ArrowImageWidth = 14.0;
static const CGFloat DotImageWidth = 22.0;
static const CGFloat HGap = 16.0;


@interface SelectorCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIImageView *selectView;
@property (nonatomic, strong) UIView *underline;

@end


@implementation SelectorCell

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat ImageWidth;

    if (self.item.preference.maxSelectNum == 1 && self.item.preference.resultFromItemTap) {
        ImageWidth = ArrowImageWidth;
    } else {
        ImageWidth = DotImageWidth;
    }

    CGFloat titleLabWidth;
    CGFloat subtitleLabWidth;

    if (self.item.subtitle.length > 0) {
        CGFloat totalTitleWidth = CGRectGetWidth(self.contentView.frame) - LeftGap - HGap * 2 - RightGap - ImageWidth;
        titleLabWidth = totalTitleWidth / 2;
        subtitleLabWidth = totalTitleWidth - titleLabWidth;
    } else {
        titleLabWidth = CGRectGetWidth(self.contentView.frame) - LeftGap - HGap - RightGap - ImageWidth;
        subtitleLabWidth = 0;
    }

    // titlelabel
    self.titleLab.text = self.item.title;
    self.titleLab.frame = CGRectMake(LeftGap, TopGap, titleLabWidth, CGRectGetHeight(self.contentView.frame) - TopGap - BottomGap);
    [self.contentView addSubview:self.titleLab];

    // subtitlelabel
    self.subtitleLab.text = self.item.subtitle;
    self.subtitleLab.frame =
        CGRectMake(CGRectGetMaxX(self.titleLab.frame) + HGap, TopGap, subtitleLabWidth, CGRectGetHeight(self.contentView.frame) - TopGap - BottomGap);
    [self.contentView addSubview:self.subtitleLab];

    // color
    NSString *titleColor = @"#000000";
    NSString *subtitleColor = @"#666666";
    if (self.item.isEnabled) {
        if (self.item.isSelected) {
            titleColor = self.item.preference.selectedTitleColor;
            subtitleColor = self.item.preference.selectedSubtitleColor;
        } else {
            titleColor = self.item.preference.unselectedTitleColor;
            subtitleColor = self.item.preference.unselectedSubtitleColor;
        }
    } else {
        titleColor = self.item.preference.unenabledColor;
        subtitleColor = self.item.preference.unenabledColor;
    }
    self.titleLab.textColor = [UIColor tclh_colorWithHexString:titleColor];
    self.subtitleLab.textColor = [UIColor tclh_colorWithHexString:subtitleColor];

    // arrowView & selectView
    UIImageView *rightImageView;
    CGRect imageViewFrame = CGRectMake(CGRectGetWidth(self.contentView.frame) - RightGap - ImageWidth,
                                       (CGRectGetHeight(self.contentView.frame) - ImageWidth) / 2, ImageWidth, ImageWidth);
    if (self.item.preference.maxSelectNum == 1 && self.item.preference.resultFromItemTap) {
        self.arrowView.frame = imageViewFrame;
        [self.contentView addSubview:self.arrowView];

        rightImageView = self.arrowView;
    } else {
        self.selectView.frame = imageViewFrame;
        [self.contentView addSubview:self.selectView];

        self.selectView.highlighted = self.item.isSelected;

        rightImageView = self.selectView;
    }
    rightImageView.hidden = !self.item.isEnabled;

    // underline
    self.underline.backgroundColor = [UIColor tclh_colorWithHexString:@"#E6E6E6"];
    self.underline.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 0.5, CGRectGetWidth(self.contentView.frame), 0.5);
    [self.contentView addSubview:self.underline];
}

- (void)setItem:(SelectorDialogItem *)item {
    _item = item;
}

- (void)enableUnderlineShown:(BOOL)shown {
    self.underline.hidden = !shown;
}

- (UIView *)underline {
    if (!_underline) {
        _underline = [[UIView alloc] init];
    }
    return _underline;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont fontForGothamBookWithSize:16.0];
    }
    return _titleLab;
}

- (UILabel *)subtitleLab {
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.textAlignment = NSTextAlignmentRight;
        _subtitleLab.font = [UIFont fontForGothamBookWithSize:14.0];
    }
    return _subtitleLab;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageNamed:@"SelectorDialogArrow"];
    }
    return _arrowView;
}

- (UIImageView *)selectView {
    if (!_selectView) {
        _selectView = [[UIImageView alloc] init];
        _selectView.image = [UIImage imageNamed:@"SelectorDialogDot0"];
        _selectView.highlightedImage = [UIImage imageNamed:@"SelectorDialogDot1"];
    }
    return _selectView;
}

@end


@interface SelectorDialogElement () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedIndexs;
@property (nonatomic, strong) NSMutableArray<SelectorDialogItem *> *selectedItems;

@end


@implementation SelectorDialogElement

#pragma mark - Setter Methods
- (void)setModel:(BasicDialogModel *)model {
    [super setModel:model];

    SelectorDialogModel *selectorModel = (SelectorDialogModel *)self.model;

    if (selectorModel.items.count == 0) {
        return;
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self.tableView registerClass:[SelectorCell class] forCellReuseIdentifier:@"SelectorCell"];
    [self addSubview:self.tableView];
}


#pragma mark - Lazy load Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray<NSNumber *> *)selectedIndexs {
    if (!_selectedIndexs) {
        _selectedIndexs = [NSMutableArray array];
    }
    return _selectedIndexs;
}

- (NSMutableArray<SelectorDialogItem *> *)selectedItems {
    if (_selectedItems) {
        [_selectedItems removeAllObjects];
    } else {
        _selectedItems = [NSMutableArray array];
    }

    SelectorDialogModel *selectorModel = (SelectorDialogModel *)self.model;
    for (NSNumber *num in self.selectedIndexs) {
        [_selectedItems addObject:[selectorModel.items objectAtIndex:[num integerValue]]];
    }
    return _selectedItems;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SelectorDialogModel *selectorModel = (SelectorDialogModel *)self.model;
    return selectorModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectorCell"];
    if (!cell) {
        cell = [[SelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectorCell"];
    }

    SelectorDialogModel *selectorModel = (SelectorDialogModel *)self.model;
    SelectorDialogItem *item = selectorModel.items[indexPath.row];
    cell.item = item;

    [cell enableUnderlineShown:indexPath.row != selectorModel.items.count - 1];

    if (item.preference.maxSelectNum == 1 && item.preference.resultFromItemTap && item.isEnabled) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectorDialogModel *selectorModel = (SelectorDialogModel *)self.model;
    SelectorDialogItem *item = selectorModel.items[indexPath.row];

    if (!item.isEnabled) {
        return;
    }

    if ([self.selectedIndexs containsObject:@(indexPath.row)]) {
        item.selected = NO;

        [self.selectedIndexs removeObject:@(indexPath.row)];

        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        if (selectorModel.preference.maxSelectNum > 1) {
            if (self.selectedIndexs.count < selectorModel.preference.maxSelectNum) {
                item.selected = YES;

                [self.selectedIndexs addObject:@(indexPath.row)];

                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        } else if (selectorModel.preference.maxSelectNum == 1) {
            if (self.selectedIndexs.count == 1) {
                item.selected = YES;

                NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:[self.selectedIndexs[0] integerValue] inSection:0];
                SelectorDialogItem *oldItem = selectorModel.items[oldIndexPath.row];
                oldItem.selected = NO;

                [self.tableView reloadRowsAtIndexPaths:@[indexPath, oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];

                [self.selectedIndexs removeAllObjects];
                [self.selectedIndexs addObject:@(indexPath.row)];
            } else {
                item.selected = YES;

                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

                [self.selectedIndexs addObject:@(indexPath.row)];

                if (selectorModel.preference.isResultFromItemTap && self.resultBlock) {
                    self.resultBlock([self.selectedItems copy], [self.selectedIndexs copy]);
                }
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return minimalCellHeight;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Element Height
+ (CGFloat)elementHeightWithModel:(BasicDialogModel *)model elementWidth:(CGFloat)elementWidth {
    SelectorDialogModel *selectorModel = (SelectorDialogModel *)model;
    NSInteger cellNumShown =
        selectorModel.items.count < selectorModel.preference.maxShownItemNum ? selectorModel.items.count : selectorModel.preference.maxShownItemNum;
    return cellNumShown * minimalCellHeight;
}

@end
