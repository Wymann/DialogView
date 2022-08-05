//
//  DialogView.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogView.h"

#define DIALOG_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width   //手机屏幕宽
#define DIALOG_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height //手机屏幕高
#define BackStartColor [UIColor colorWithWhite:0 alpha:0]             // 背景色（动画前）
#define BackFinalColor [UIColor colorWithWhite:0 alpha:0.5]           // 背景色（动画后）
static const CGFloat cornerRadius = 12.0;                             //圆角


@interface DialogView () <UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate>

// Data
@property (nonatomic, strong) NSArray *dialogModels;            //数据模型
@property (nonatomic, assign) ShowAnimation animation;          //出现时候的动画
@property (nonatomic, assign) DialogPosition position;          //出现时候的动画
@property (nonatomic, assign) BOOL sideTap;                     // 点击周边空白处是否关闭
@property (nonatomic, assign) BOOL bounce;                      // 是否弹性动画弹出
@property (nonatomic, assign) BOOL openedKeyboard;              // 键盘是否开启
@property (nonatomic) CGRect startRect;                         // contentView初始位置
@property (nonatomic) CGRect finalRect;                         // contentView最后位置
@property (nonatomic) CGFloat contentViewWidth;                 // contentView宽
@property (nonatomic) CGFloat contentViewHeight;                // contentView高
@property (nonatomic, strong) DialogResult *result;             // 结果
@property (nonatomic, strong) ButtonsDialogModel *buttonsModel; // 按钮

@property (nonatomic, strong) NSMutableArray *showBlocks;
@property (nonatomic, strong) NSMutableArray *releaseFromQueueBlocks;
@property (nonatomic, strong) NSMutableArray *disappearBlocks;

@property (nonatomic, copy) ReleaseFromQueueBlock mainReleaseFromQueueBlock;

// UI
@property (nonatomic, strong) UIView *contentView; //主内容视图
// 单行输入框
@property (nonatomic, strong) UITextField *textField;
// 多行输入框
@property (nonatomic, strong) UITextView *textView;
// 选择器组件
@property (nonatomic, strong) SelectorDialogElement *selectorElement;
// 输入框错误提醒
@property (nonatomic, strong) UILabel *errorLabel;
// 输入框字数实时
@property (nonatomic, strong) UILabel *maxLengthLabel;

/// TextView 最大数字限制
@property (nonatomic, assign) NSInteger textViewMaxLength;
// 按钮面板
@property (nonatomic, strong) ButtonsDialogElement *buttonsElement;
// 自定义视图
@property (nonatomic, strong) UIView *customView;
// 自定义视图 高度
@property (nonatomic) CGFloat customViewHeight;
// 自定义视图 宽度
@property (nonatomic) CGFloat customViewWidth;

@end


@implementation DialogView

#pragma mark - Init Methods
/** 初始化 */
- (instancetype)initWithDialogModels:(NSArray *)dialogModels
                           animation:(ShowAnimation)animation
                            position:(DialogPosition)position
                             sideTap:(BOOL)sideTap
                              bounce:(BOOL)bounce {
    self = [super init];
    if (self) {
        _dialogModels = dialogModels;
        _animation = animation;
        _position = position;
        _sideTap = sideTap;
        _bounce = bounce;

        [self commonConfig];
    }
    return self;
}

/** 初始化 */
- (instancetype)initWithCustomView:(UIView *)customView
                  customViewHeight:(CGFloat)customViewHeight
                         animation:(ShowAnimation)animation
                          position:(DialogPosition)position
                           sideTap:(BOOL)sideTap
                            bounce:(BOOL)bounce {
    self = [super init];
    if (self) {
        _customView = customView;
        _customViewWidth = [DialogView contentWidth];
        _customViewHeight = customViewHeight;
        _animation = animation;
        _position = position;
        _sideTap = sideTap;
        _bounce = bounce;

        [self commonConfig];
    }
    return self;
}

/// 初始化
- (instancetype)initWithCustomView:(UIView *)customView
                    customViewSize:(CGSize)customViewSize
                         animation:(ShowAnimation)animation
                          position:(DialogPosition)position
                           sideTap:(BOOL)sideTap
                            bounce:(BOOL)bounce {
    self = [super init];
    if (self) {
        _customView = customView;
        _customViewWidth = customViewSize.width;
        _customViewHeight = customViewSize.height;
        _animation = animation;
        _position = position;
        _sideTap = sideTap;
        _bounce = bounce;

        [self commonConfig];
    }
    return self;
}

- (void)commonConfig {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeFullScreenAndPauseVideo" object:nil];
    self.frame = CGRectMake(0, 0, DIALOG_SCREEN_WIDTH, DIALOG_SCREEN_HEIGHT);
    [[DialogView keyView] addSubview:self];
    [self setUIDetailUI];
    [self createGestureRecognizer];
}

#pragma mark - Data & UI
- (void)setUIDetailUI {
    [self becomeFirstResponder];
    // 内容宽度
    if (self.customView) {
        self.contentViewWidth = self.customViewWidth;
        self.contentViewHeight = self.customViewHeight;
        self.customView.frame = CGRectMake(0, 0, self.customViewWidth, self.customViewHeight);
        [self.contentView addSubview:self.customView];
        self.contentView.backgroundColor = [UIColor clearColor];
    } else {
        self.contentViewWidth = [DialogView contentWidth];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = cornerRadius;
        self.contentView.clipsToBounds = YES;

        // 布局
        CGFloat Y = 0;
        for (NSInteger i = 0; i < self.dialogModels.count; i++) {
            BasicDialogModel *model = self.dialogModels[i];
            if (model.elementClassName.length == 0) {
                continue;
            }
            CGFloat X = model.margin.left;
            Y += model.margin.top;
            CGFloat W = self.contentViewWidth - model.margin.left - model.margin.right;
            CGFloat H = ceil([NSClassFromString(model.elementClassName) elementHeightWithModel:model elementWidth:W]);
            BasicDialogElement *element = [[NSClassFromString(model.elementClassName) alloc] init];
            element.frame = CGRectMake(X, Y, W, H);
            element.model = model;
            [self.contentView addSubview:element];

            if ([model.elementClassName isEqualToString:@"ButtonsDialogElement"]) {
                ButtonsDialogElement *buttonsElement = (ButtonsDialogElement *)element;
                self.buttonsModel = (ButtonsDialogModel *)model;
                __weak typeof(self) weakSelf = self;
                buttonsElement.clickBlock = ^void(NSInteger buttonIndex) {
                    [weakSelf clickOnButtonIndex:buttonIndex];
                };

                self.buttonsElement = buttonsElement;
            }

            if ([model.elementClassName isEqualToString:@"TextFieldDialogElement"]) {
                TextFieldDialogElement *textFieldElement = (TextFieldDialogElement *)element;
                self.textField = [textFieldElement textField];
                self.errorLabel = [textFieldElement errorLabel];
                self.textField.delegate = self;
                if (self.textField) {
                    [self addNotifications];
                }
            }

            if ([model.elementClassName isEqualToString:@"TextViewDialogElement"]) {
                TextViewDialogElement *textViewElement = (TextViewDialogElement *)element;
                self.textView = [textViewElement textView];
                self.errorLabel = [textViewElement errorLabel];
                self.maxLengthLabel = [textViewElement maxLengthLabel];
                self.textViewMaxLength = [textViewElement textViewMaxLength];
                self.textView.delegate = self;
                if (self.textView) {
                    [self addNotifications];
                }
            }

            if ([model.elementClassName isEqualToString:@"SelectorDialogElement"]) {
                self.selectorElement = (SelectorDialogElement *)element;

                __weak typeof(self) weakSelf = self;

                self.selectorElement.resultBlock = ^(NSArray<SelectorDialogItem *> *_Nonnull selectedItems, NSArray<NSNumber *> *_Nonnull selectedIndexes) {
                    weakSelf.result.selectedItems = selectedItems;
                    weakSelf.result.selectedIndexes = selectedIndexes;

                    if (weakSelf.resultBlock) {
                        BOOL close = weakSelf.resultBlock(weakSelf.result);
                        if (close) {
                            [weakSelf close];
                        }
                    }
                };
            }

            Y += (H + model.margin.bottom);
        }
        self.contentViewHeight = Y;
    }

    CGFloat finalRectY = 0;
    switch (self.position) {
        case DialogPositionMiddle:
            finalRectY = (DIALOG_SCREEN_HEIGHT - self.contentViewHeight) / 2;
            break;
        case DialogPositionBottom:
            finalRectY = DIALOG_SCREEN_HEIGHT - self.contentViewHeight;
            break;
        case DialogPositionTop:
            finalRectY = 0;
            break;
        default:
            break;
    }
    finalRectY = floor(finalRectY);
    CGFloat finalRectX = floor((DIALOG_SCREEN_WIDTH - self.contentViewWidth) / 2);
    self.finalRect = CGRectMake(finalRectX, finalRectY, self.contentViewWidth, self.contentViewHeight);
    self.backgroundColor = BackStartColor;
    switch (self.animation) {
        case ShowAnimationNone: {
            self.startRect = self.finalRect;
            self.backgroundColor = BackFinalColor;
        } break;
        case ShowAnimationFromTop: {
            self.startRect = CGRectMake(CGRectGetMinX(self.finalRect), -CGRectGetHeight(self.finalRect), self.contentViewWidth, self.contentViewHeight);
        } break;
        case ShowAnimationFromLeft: {
            self.startRect = CGRectMake(-CGRectGetWidth(self.finalRect), CGRectGetMinY(self.finalRect), self.contentViewWidth, self.contentViewHeight);
        } break;
        case ShowAnimationFromBottom: {
            self.startRect = CGRectMake(CGRectGetMinX(self.finalRect), DIALOG_SCREEN_HEIGHT, self.contentViewWidth, self.contentViewHeight);
        } break;
        case ShowAnimationFromRight: {
            self.startRect =
                CGRectMake(DIALOG_SCREEN_WIDTH + CGRectGetWidth(self.finalRect), CGRectGetMinY(self.finalRect), self.contentViewWidth, self.contentViewHeight);
        } break;
        case ShowAnimationFade: {
            self.startRect = self.finalRect;
        } break;
        default:
            break;
    }

    self.contentView.frame = self.startRect;
    [self addSubview:self.contentView];
}

- (void)clickOnButtonIndex:(NSInteger)buttonIndex {
    self.result.buttonIndex = buttonIndex;
    if (buttonIndex >= 0) {
        self.result.buttonTitle = self.buttonsModel.buttonTitles[buttonIndex];
    } else {
        self.result.buttonTitle = @"空白处";
    }

    if (self.resultBlock) {
        if (self.textField) {
            self.result.inputText = self.textField.text;
        }
        if (self.textView) {
            self.result.inputText = self.textView.text;
        }

        if (self.selectorElement) {
            self.result.selectedItems = [self.selectorElement.selectedItems copy];
            self.result.selectedIndexes = [self.selectorElement.selectedIndexes copy];
        }

        BOOL close = self.resultBlock(self.result);
        if (close) {
            [self close];
        }
    } else {
        [self close];
    }
}

#pragma mark - Target Methods
- (void)createGestureRecognizer {
    // tap
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapClick)];
    closeTap.delegate = self;
    [self addGestureRecognizer:closeTap];
    self.userInteractionEnabled = YES;
}

- (void)closeTapClick {
    if (self.openedKeyboard) {
        [self.textField resignFirstResponder];
        [self.textView resignFirstResponder];
        return;
    }
    if (self.sideTap) {
        [self clickOnButtonIndex:-1];
    }
}

#pragma mark - Public Methods

/** 弹出 */
- (void)show {
    self.hidden = NO;
    self.contentView.alpha = self.animation == ShowAnimationFade ? 0.0 : 1.0;
    [self.superview bringSubviewToFront:self];

    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = BackFinalColor;
        self.contentView.alpha = 1.0;
    }];

    if (self.bounce) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.contentView.frame = self.finalRect;
        } completion:^(BOOL finished) {
            if (self.showBlocks.count > 0) {
                for (ShowBlock block in self.showBlocks) {
                    block();
                }
            }
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = self.finalRect;
        } completion:^(BOOL finished) {
            if (self.showBlocks.count > 0) {
                for (ShowBlock block in self.showBlocks) {
                    block();
                }
            }
        }];
    }
}

- (void)close {
    [self closeWithAnimation:YES holdInQueue:NO];
}

- (void)closeWithHoldInQueue:(BOOL)holdInQueue {
    [self closeWithAnimation:NO holdInQueue:holdInQueue];
}

- (void)releaseFromQueue {
    [self removeFromSuperview];

    if (self.releaseFromQueueBlocks.count > 0) {
        for (ReleaseFromQueueBlock block in self.releaseFromQueueBlocks) {
            block();
        }
    }

    if (self.mainReleaseFromQueueBlock) {
        self.mainReleaseFromQueueBlock();
    }
}

- (void)closeWithAnimation:(BOOL)animation holdInQueue:(BOOL)holdInQueue {
    if (self.animation == ShowAnimationNone || !animation) {
        self.backgroundColor = BackStartColor;
        self.contentView.frame = self.startRect;
        if (self.animation == ShowAnimationFade) {
            self.contentView.alpha = 0.0;
        }

        [self finishedCloseWithHoldInQueue:holdInQueue];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = BackStartColor;
            self.contentView.frame = self.startRect;
            if (self.animation == ShowAnimationFade) {
                self.contentView.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            [self finishedCloseWithHoldInQueue:holdInQueue];
        }];
    }
}

- (void)finishedCloseWithHoldInQueue:(BOOL)holdInQueue {
    if (holdInQueue) {
        self.hidden = YES;
        [self.superview sendSubviewToBack:self];
    } else {
        [self removeFromSuperview];
    }

    if (self.releaseFromQueueBlocks.count > 0 && !holdInQueue) {
        for (ReleaseFromQueueBlock block in self.releaseFromQueueBlocks) {
            block();
        }
    }

    if (self.mainReleaseFromQueueBlock && !holdInQueue) {
        self.mainReleaseFromQueueBlock();
    }

    if (self.disappearBlocks.count > 0) {
        for (DisappearBlock block in self.disappearBlocks) {
            block(holdInQueue);
        }
    }
}

/// 开启键盘
- (void)becomeFirstResponder {
    if (self.textField) {
        [self.textField becomeFirstResponder];
    }

    if (self.textView) {
        [self.textView becomeFirstResponder];
    }
}

/// 关闭键盘
- (void)resignFirstResponder {
    if (self.textField) {
        [self.textField resignFirstResponder];
    }

    if (self.textView) {
        [self.textView resignFirstResponder];
    }
}

/** 设置是否可点击周边空白区关闭 */
- (void)sideTapEnable:(BOOL)enable {
    self.sideTap = enable;
}

/** 使某个按钮重新恢复点击事件 */
- (void)enableButtonAtIndex:(NSInteger)buttonIndex {
    [self.buttonsElement enableButtonAtIndex:buttonIndex];
}

/**使某个按钮无法点击。*/
- (void)disabledButtonAtIndex:(NSInteger)buttonIndex {
    [self.buttonsElement disabledButtonAtIndex:buttonIndex];
}

/// 添加显示回调
- (void)addShowBlock:(ShowBlock)showBlock {
    if (showBlock) {
        [self.showBlocks addObject:showBlock];
    }
}

/// 添加消失回调
- (void)addDisappearBlock:(DisappearBlock)disappearBlock {
    if (disappearBlock) {
        [self.disappearBlocks addObject:disappearBlock];
    }
}

/// 添加从队列中移除回调
- (void)addReleaseFromQueueBlock:(ReleaseFromQueueBlock)releaseFromQueueBlock {
    if (releaseFromQueueBlock) {
        [self.releaseFromQueueBlocks addObject:releaseFromQueueBlock];
    }
}

/// 添加从队列中移除主要回调
- (void)setUpMainReleaseFromQueueBlock:(ReleaseFromQueueBlock)mainReleaseFromQueueBlock {
    self.mainReleaseFromQueueBlock = mainReleaseFromQueueBlock;
}

#pragma mark - Private Methods
+ (UIView *)keyView {
    UIView *keyView = [UIApplication sharedApplication].keyWindow;
    if (!keyView) {
        keyView = [[[UIApplication sharedApplication] windows] lastObject];
    }
    return keyView;
}

/** 输入框错误提示 */
- (void)showErrorTips:(NSString *)errorTips {
    self.errorLabel.text = errorTips;
}

#pragma mark - Notifications
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:UIKeyboardWillHideNotification object:nil];
    if (self.textField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification
                                                   object:self.textField];
    }
}

- (void)keyboardShowAction:(NSNotification *)sender {
    self.openedKeyboard = YES;
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardHeight = ceil([value CGRectValue].size.height);
    if (CGRectGetMaxY(self.finalRect) > (DIALOG_SCREEN_HEIGHT - keyBoardHeight)) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newRect = self.finalRect;
            newRect.origin.y = floor(DIALOG_SCREEN_HEIGHT - keyBoardHeight - CGRectGetHeight(self.finalRect) - 24.0);
            self.contentView.frame = newRect;
        }];
    }
}

- (void)keyboardHideAction:(NSNotification *)sender {
    self.openedKeyboard = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = self.finalRect;
    }];
}

- (void)textFieldDidChanged:(NSNotification *)sender {
    if (self.textDidChangeBlock) {
        NSString *errorString = self.textDidChangeBlock(self.textField);
        [self showErrorTips:errorString];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Lazy Load Methods
/** 主内容视图 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (DialogResult *)result {
    if (!_result) {
        _result = [[DialogResult alloc] init];
        _result.dialogView = self;
    }
    return _result;
}

- (NSMutableArray *)showBlocks {
    if (!_showBlocks) {
        _showBlocks = [NSMutableArray array];
    }
    return _showBlocks;
}

- (NSMutableArray *)disappearBlocks {
    if (!_disappearBlocks) {
        _disappearBlocks = [NSMutableArray array];
    }
    return _disappearBlocks;
}

- (NSMutableArray *)releaseFromQueueBlocks {
    if (!_releaseFromQueueBlocks) {
        _releaseFromQueueBlocks = [NSMutableArray array];
    }
    return _releaseFromQueueBlocks;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.result.inputText = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textShouldChangeBlock) {
        TextShouldChangeResModel *model = self.textShouldChangeBlock(textField, range, string);
        if (model.tip && model.tip.length > 0) {
            [self showErrorTips:model.tip];
        } else {
            [self showErrorTips:@""];
        }
        return model.shouldChange;
        //        NSString *errorString = self.textShouldChangeBlock(textField, range, string);
        //        [self showErrorTips:errorString];
        //        return errorString.length == 0;
    } else {
        return YES;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.result.inputText = textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewMaxLength > 0) {
        NSString *toBeString = textView.text;

        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];

        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.textViewMaxLength) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.textViewMaxLength];
                if (rangeIndex.length == 1) {
                    textView.text = [toBeString substringToIndex:self.textViewMaxLength];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.textViewMaxLength)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
                self.maxLengthLabel.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.length, self.textViewMaxLength];
            } else {
                self.maxLengthLabel.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.length, self.textViewMaxLength];
            }
        }
    }

    self.result.inputText = textView.text;
    if (self.textDidChangeBlock) {
        NSString *errorString = self.textDidChangeBlock(textView);
        [self showErrorTips:errorString];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.textShouldChangeBlock) {
        TextShouldChangeResModel *model = self.textShouldChangeBlock(textView, range, text);
        if (model.tip && model.tip.length > 0) {
            [self showErrorTips:model.tip];
        } else {
            [self showErrorTips:@""];
        }
        return model.shouldChange;
        //        NSString *errorString = self.textShouldChangeBlock(textView, range, text);
        //        [self showErrorTips:errorString];
        //        return errorString.length == 0;
    } else {
        return YES;
    }
}

/// 弹框宽度
+ (CGFloat)contentWidth {
    CGFloat width = DIALOG_SCREEN_WIDTH < DIALOG_SCREEN_HEIGHT ? DIALOG_SCREEN_WIDTH : DIALOG_SCREEN_HEIGHT;
    return width - 72;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self;
}

@end
