//
//  Dialog.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "Dialog.h"

#import "UIViewController+Dialog.h"

typedef void (^OverTimeOnShowBlock)(DialogView *dialogView);


@interface DialogPriorityModel ()

@property (nonatomic, assign, getter=isDisplayed) BOOL displayed; // 是否已经显示过

@property (nonatomic, assign, getter=isNeedWaitInQueue) BOOL needWaitInQueue; // 是否需要在队列中计时

@property (nonatomic, assign, getter=isOverTimeInQueue) BOOL overTimeInQueue; // 是否在队列中已经超时

@property (nonatomic, strong) NSTimer *timerInQueue; // 队列计时器

@property (nonatomic, assign, getter=isNeedWaitOnShow) BOOL needWaitOnShow; // 是否需要在显示中计时

@property (nonatomic, assign, getter=isOverTimeOnShow) BOOL overTimeOnShow; // 是否在显示中已经超时

@property (nonatomic, strong) NSTimer *timerOnShow; // 显示计时器

@property (nonatomic, copy) OverTimeOnShowBlock timeOnShowBlock;

@end


@implementation DialogPriorityModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showOnce = YES;
        self.endDialog = NO;
    }
    return self;
}

+ (DialogPriorityModel *)createDialogPriorityModelWithDialogView:(DialogView *)dialogView {
    DialogPriorityModel *model = [[DialogPriorityModel alloc] init];
    model.dialogView = dialogView;
    model.priorityType = DialogPriorityB;
    model.priorityValue = @(0);
    return model;
}

+ (DialogPriorityModel *)createDialogPriorityModelWithDialogView:(DialogView *)dialogView
                                                    priorityType:(DialogPriorityType)priorityType
                                                   priorityValue:(NSNumber *)priorityValue {
    DialogPriorityModel *model = [[DialogPriorityModel alloc] init];
    model.dialogView = dialogView;
    model.priorityType = priorityType;
    model.priorityValue = priorityValue ? priorityValue : @(0);
    return model;
}

+ (DialogPriorityModel *)createDialogPriorityModelWithDialogView:(DialogView *)dialogView
                                                  convenientType:(DialogConvenientType)convenientType {
    DialogPriorityModel *model = [[DialogPriorityModel alloc] init];
    model.dialogView = dialogView;

    NSInteger totalConvenientTypes = 20;
    model.priorityType = DialogPriorityA;
    model.priorityValue = @(totalConvenientTypes * 10 - convenientType * 10);

    return model;
}

- (void)setTimeInQueue:(CGFloat)timeInQueue {
    _timeInQueue = timeInQueue;

    if (_timeInQueue > 0) {
        self.needWaitInQueue = YES;
    }
}

- (void)setTimeOnShow:(CGFloat)timeOnShow {
    _timeOnShow = timeOnShow;

    if (_timeOnShow > 0) {
        self.needWaitOnShow = YES;
    }
}

- (void)setPriorityValue:(NSNumber *)priorityValue {
    if (priorityValue && [priorityValue integerValue] >= 0) {
        _priorityValue = priorityValue;
    } else {
        _priorityValue = @(0);
    }
}

- (void)startCountTimeInQueue {
    if (self.timerInQueue) {
        return;
    }

    __weak typeof(self) weakSelf = self;

    self.timerInQueue = [NSTimer scheduledTimerWithTimeInterval:self.timeInQueue repeats:YES block:^(NSTimer *_Nonnull timer) {
        weakSelf.overTimeInQueue = YES;
        [weakSelf stopCountTimeInQueue];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timerInQueue forMode:NSRunLoopCommonModes];
}

- (void)stopCountTimeInQueue {
    if (self.timerInQueue) {
        [self.timerInQueue invalidate];
        self.timerInQueue = nil;
    }
}

- (void)startCountTimeOnShow {
    if (self.timerOnShow) {
        return;
    }

    __weak typeof(self) weakSelf = self;

    self.timerOnShow = [NSTimer scheduledTimerWithTimeInterval:self.timeOnShow repeats:YES block:^(NSTimer *_Nonnull timer) {
        weakSelf.overTimeOnShow = YES;

        if (weakSelf.timeOnShowBlock) {
            weakSelf.timeOnShowBlock(weakSelf.dialogView);
        }

        [weakSelf stopCountTimeOnShow];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timerOnShow forMode:NSRunLoopCommonModes];
}

- (void)stopCountTimeOnShow {
    if (self.timerOnShow) {
        [self.timerOnShow invalidate];
        self.timerOnShow = nil;
    }
}

- (void)dealloc {
    [self stopCountTimeInQueue];
    [self stopCountTimeOnShow];
}

- (void)restartCountTimeOnShowWithTime:(CGFloat)timeOnShow {
    BOOL needStartCount = NO;
    if (self.timerOnShow) {
        needStartCount = YES;
        [self stopCountTimeOnShow];
    }

    self.timeOnShow = timeOnShow;

    if (needStartCount) {
        [self startCountTimeOnShow];
    }
}

@end


@interface Dialog ()

@property (nonatomic, strong) NSMutableArray<DialogPriorityModel *> *prioritySArray;
@property (nonatomic, strong) NSMutableArray<DialogPriorityModel *> *priorityAArray;
@property (nonatomic, strong) NSMutableArray<DialogPriorityModel *> *priorityBArray;
@property (nonatomic, strong) NSMutableArray<DialogPriorityModel *> *priorityCArray;
@property (nonatomic, strong) NSArray *allPriorityArray;
@property (nonatomic, strong) DialogPriorityModel *currentPriorityModel;

@end


@implementation Dialog

#pragma mark - 单例
+ (instancetype)sharedInstance {
    static Dialog *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[Dialog alloc] init];
        _instance.animationType = ShowAnimationFade;
        _instance.bounce = YES;
    });
    return _instance;
}

#pragma mark - Public Methods
/// 添加一个弹框
+ (DialogPriorityModel *)addDialogView:(DialogView *)dialogView
                        dialogPriority:(DialogPriorityType)priorityType
                         priorityValue:(NSNumber *)priorityValue {
    DialogPriorityModel *model = [[Dialog sharedInstance] addDialogView:dialogView dialogPriority:priorityType priorityValue:priorityValue];
    [[Dialog sharedInstance] checkCurrentPriorityModel];
    return model;
}

/// 添加一个弹框（priorityType 为 DialogPriorityB， priorityValue 为0）
+ (DialogPriorityModel *)addDialogView:(DialogView *)dialogView {
    DialogPriorityModel *model = [[Dialog sharedInstance] addDialogView:dialogView dialogPriority:DialogPriorityB priorityValue:@(0)];
    [[Dialog sharedInstance] checkCurrentPriorityModel];
    return model;
}

/// 添加多个弹框（priorityType 为 DialogPriorityB， priorityValue 为0），依次弹出
+ (NSArray<DialogPriorityModel *> *)addDialogViews:(NSArray<DialogView *> *)dialogViews {
    NSMutableArray<DialogPriorityModel *> *models = [NSMutableArray array];
    for (NSInteger i = 0; i < dialogViews.count; i++) {
        DialogPriorityModel *priorityModel = [DialogPriorityModel createDialogPriorityModelWithDialogView:[dialogViews objectAtIndex:i]
                                                                                             priorityType:DialogPriorityB
                                                                                            priorityValue:@(0)];
        [models addObject:priorityModel];
    }
    [[Dialog sharedInstance] addDialogPriorityModels:models];
    [[Dialog sharedInstance] checkCurrentPriorityModel];

    return [models copy];
}

/// 添加多个弹框模型
+ (void)addDialogPriorityModels:(NSArray<DialogPriorityModel *> *)priorityModels {
    [[Dialog sharedInstance] addDialogPriorityModels:priorityModels];
    [[Dialog sharedInstance] checkCurrentPriorityModel];
}

/// 移除所有弹框
+ (void)removeAllDialog {
    [[Dialog sharedInstance] removeAllDialog];
}

/// 移除所有弹框
/// @param exceptCurrentDialog 是否除去当前正在显示的（YES的话当前显示的弹框不移除）
+ (void)removeAllDialogWithExceptCurrentDialog:(BOOL)exceptCurrentDialog {
    [[Dialog sharedInstance] removeAllDialogWithExceptCurrentDialog:exceptCurrentDialog];
}

/// 移除指定弹框
+ (void)removeDialogWithTag:(NSInteger)tag {
    [[Dialog sharedInstance] removeDialogWithTag:tag];
}

/// 移除指定弹框
+ (void)removeDialogWithPriorityType:(DialogPriorityType)priorityType {
    [[Dialog sharedInstance] removeDialogWithPriorityType:priorityType];
}

/// 绑定弹框与控制器
+ (void)bindWithDialogView:(DialogView *)dialogView viewController:(UIViewController *)viewController {
    dialogView.boundViewController = viewController;
}

#pragma mark - Private Methods
/// 添加一个弹框
- (DialogPriorityModel *)addDialogView:(DialogView *)dialogView
                        dialogPriority:(DialogPriorityType)priorityType
                         priorityValue:(NSNumber *)priorityValue {
    DialogPriorityModel *priorityModel = [DialogPriorityModel createDialogPriorityModelWithDialogView:dialogView
                                                                                         priorityType:priorityType
                                                                                        priorityValue:priorityValue];

    [self addDialogPriorityModel:priorityModel];

    return priorityModel;
}

- (void)addDialogPriorityModel:(DialogPriorityModel *)priorityModel {
    NSMutableArray<DialogPriorityModel *> *priorityArray;
    switch (priorityModel.priorityType) {
        case DialogPriorityS:
            priorityArray = self.prioritySArray;
            break;
        case DialogPriorityA:
            priorityArray = self.priorityAArray;
            break;
        case DialogPriorityB:
            priorityArray = self.priorityBArray;
            break;
        case DialogPriorityC:
            priorityArray = self.priorityCArray;
            break;
        default:
            break;
    }

    [self insertPriorityArray:priorityArray withPriorityModel:priorityModel];
}

- (void)addDialogPriorityModels:(NSArray<DialogPriorityModel *> *)priorityModels {
    for (NSInteger i = 0; i < priorityModels.count; i++) {
        DialogPriorityModel *model = [priorityModels objectAtIndex:i];
        [self addDialogPriorityModel:model];
    }
}

- (void)insertPriorityArray:(NSMutableArray<DialogPriorityModel *> *)priorityArray withPriorityModel:(DialogPriorityModel *)priorityModel {
    @synchronized(self) {
        if (self.currentPriorityModel && self.currentPriorityModel.isEndDialog) {
            [priorityModel.dialogView closeWithAnimation:NO holdInQueue:NO];
            return;
        }

        if (!priorityArray || ![priorityArray isKindOfClass:[NSMutableArray class]] || !priorityModel) {
            return;
        }

        __weak typeof(self) weakSelf = self;
        __weak typeof(priorityModel) weakPriorityModel = priorityModel;
        [priorityModel.dialogView setUpMainReleaseFromQueueBlock:^{
            [weakSelf deletePriorityModel:weakPriorityModel];
            weakSelf.currentPriorityModel = nil;
            [weakSelf checkCurrentPriorityModel];
        }];

        priorityModel.dialogView.hidden = YES;
        priorityModel.dialogView.existPriority = YES;

        if (priorityArray.count == 0) {
            [priorityArray addObject:priorityModel];
        } else {
            for (NSInteger i = 0; i < priorityArray.count; i++) {
                DialogPriorityModel *existModel = [priorityArray objectAtIndex:i];
                if ([existModel.priorityValue floatValue] < [priorityModel.priorityValue floatValue]) {
                    [priorityArray insertObject:priorityModel atIndex:i];
                    break;
                } else if (i == priorityArray.count - 1) {
                    [priorityArray addObject:priorityModel];
                    break;
                }
            }
        }

        if (priorityModel.isNeedWaitInQueue) {
            [priorityModel startCountTimeInQueue];
        }
    }
}

- (void)checkCurrentPriorityModel {
    @synchronized(self) {
        for (NSInteger i = 0; i < self.allPriorityArray.count; i++) {
            NSMutableArray<DialogPriorityModel *> *priorityArray = [self.allPriorityArray objectAtIndex:i];
            if (priorityArray.count > 0) {
                DialogPriorityModel *priorityModel = [self firstPriorityModelInPriorityArray:priorityArray];

                if (priorityModel) {
                    if (priorityModel != self.currentPriorityModel) {
                        if (self.currentPriorityModel) {
                            self.currentPriorityModel.displayed = YES;

                            [self.currentPriorityModel.dialogView closeWithHoldInQueue:!self.currentPriorityModel.isShowOnce];

                            if (self.currentPriorityModel.isNeedWaitInQueue && !self.currentPriorityModel.isShowOnce) {
                                [self.currentPriorityModel startCountTimeInQueue];
                            }

                            if (self.currentPriorityModel.isNeedWaitOnShow && !self.currentPriorityModel.isShowOnce) {
                                [self.currentPriorityModel stopCountTimeOnShow];
                            }
                        }

                        if (priorityModel.isNeedWaitInQueue) {
                            [priorityModel stopCountTimeInQueue];
                        }

                        if (priorityModel.isNeedWaitOnShow) {
                            [priorityModel startCountTimeOnShow];

                            priorityModel.timeOnShowBlock = ^(DialogView *dialogView) {
                                [dialogView closeWithAnimation:YES holdInQueue:NO];
                            };
                        }

                        [self deleteNonexistentPriority];

                        [priorityModel.dialogView show];

                        self.currentPriorityModel = priorityModel;

                        if (priorityModel.isEndDialog) {
                            [self removeAllDialogWithExceptCurrentDialog:YES];
                        }
                    }
                }

                break;
            }
        }
    }
}

- (DialogPriorityModel *)firstPriorityModelInPriorityArray:(NSMutableArray *)priorityArray {
    @synchronized(self) {
        if (priorityArray.count > 0) {
            DialogPriorityModel *model = [priorityArray firstObject];

            BOOL passed = YES;
            if (model.dialogView.boundViewController) {
                passed = model.dialogView.boundViewController == [UIViewController windowCurrentViewController];
            }

            if ((model.isNeedWaitInQueue && model.isOverTimeInQueue) || !passed) {
                [priorityArray removeObject:model];
                return [self firstPriorityModelInPriorityArray:priorityArray];
            } else {
                return model;
            }
        } else {
            return nil;
        }
    }
}

- (void)deletePriorityModel:(DialogPriorityModel *)priorityModel {
    @synchronized(self) {
        for (NSMutableArray<DialogPriorityModel *> *array in self.allPriorityArray) {
            if ([array containsObject:priorityModel]) {
                [array removeObject:priorityModel];
            }
        }
    }
}

/// 删除除队列中之外的弹框
- (void)deleteNonexistentPriority {
    for (id object in [self keyView].subviews) {
        if ([object isKindOfClass:[DialogView class]]) {
            DialogView *view = (DialogView *)object;
            if (!view.isExistPriority) {
                [view close];
            }
        }
    }
}

- (void)removeAllDialog {
    [self removeAllDialogWithExceptCurrentDialog:NO];
}

- (UIView *)keyView {
    UIView *keyView = [UIApplication sharedApplication].keyWindow;
    if (!keyView) {
        keyView = [[[UIApplication sharedApplication] windows] lastObject];
    }
    return keyView;
}


/// 删除所有队列中的弹框
/// @param exceptCurrentDialog 是否除当前正显示的弹框（YES：不删除当前显示的弹框，NO：当前显示的弹框也删除）
- (void)removeAllDialogWithExceptCurrentDialog:(BOOL)exceptCurrentDialog {
    @synchronized(self) {
        [self deleteNonexistentPriority];

        for (NSMutableArray<DialogPriorityModel *> *models in self.allPriorityArray) {
            NSArray<DialogPriorityModel *> *needRemoves = [NSArray arrayWithArray:models];
            [models removeAllObjects];

            DialogPriorityModel *current;
            for (DialogPriorityModel *model in needRemoves) {
                if (!exceptCurrentDialog || self.currentPriorityModel != model) {
                    [model.dialogView closeWithAnimation:NO holdInQueue:NO];
                } else {
                    current = model;
                }
            }

            if (current) {
                self.currentPriorityModel = current;
                [models addObject:current];
            }
        }

        if (!exceptCurrentDialog) {
            self.currentPriorityModel = nil;
        }
    }
}

- (void)removeDialogWithTag:(NSInteger)tag {
    @synchronized(self) {
        for (NSMutableArray<DialogPriorityModel *> *models in self.allPriorityArray) {
            NSMutableArray<DialogPriorityModel *> *needRemove = [NSMutableArray array];
            for (DialogPriorityModel *model in models) {
                if (model.dialogView.tag == tag) {
                    [needRemove addObject:model];
                }
            }
            [models removeObjectsInArray:[needRemove copy]];

            for (DialogPriorityModel *model in needRemove) {
                [model.dialogView closeWithAnimation:NO holdInQueue:NO];
            }
        }

        if (self.currentPriorityModel.dialogView.tag == tag) {
            self.currentPriorityModel = nil;
        }
    }
}

- (void)removeDialogWithPriorityType:(DialogPriorityType)priorityType {
    @synchronized(self) {
        NSMutableArray<DialogPriorityModel *> *priorityArray;
        switch (priorityType) {
            case DialogPriorityS:
                priorityArray = self.prioritySArray;
                break;
            case DialogPriorityA:
                priorityArray = self.priorityAArray;
                break;
            case DialogPriorityB:
                priorityArray = self.priorityBArray;
                break;
            case DialogPriorityC:
                priorityArray = self.priorityCArray;
                break;
            default:
                break;
        }

        if (priorityArray.count > 0) {
            NSArray<DialogPriorityModel *> *needRemoves = [NSArray arrayWithArray:priorityArray];
            [priorityArray removeAllObjects];
            for (DialogPriorityModel *model in needRemoves) {
                [model.dialogView closeWithAnimation:NO holdInQueue:NO];
            }

            if (self.currentPriorityModel.priorityType == priorityType) {
                self.currentPriorityModel = nil;
            }
        }
    }
}

#pragma mark - Lazy Loading Methods
- (NSMutableArray<DialogPriorityModel *> *)prioritySArray {
    if (!_prioritySArray) {
        _prioritySArray = [NSMutableArray array];
    }
    return _prioritySArray;
}

- (NSMutableArray<DialogPriorityModel *> *)priorityAArray {
    if (!_priorityAArray) {
        _priorityAArray = [NSMutableArray array];
    }
    return _priorityAArray;
}

- (NSMutableArray<DialogPriorityModel *> *)priorityBArray {
    if (!_priorityBArray) {
        _priorityBArray = [NSMutableArray array];
    }
    return _priorityBArray;
}

- (NSMutableArray<DialogPriorityModel *> *)priorityCArray {
    if (!_priorityCArray) {
        _priorityCArray = [NSMutableArray array];
    }
    return _priorityCArray;
}

- (NSArray *)allPriorityArray {
    if (!_allPriorityArray) {
        _allPriorityArray = @[self.prioritySArray, self.priorityAArray, self.priorityBArray, self.priorityCArray];
    }
    return _allPriorityArray;
}

@end
