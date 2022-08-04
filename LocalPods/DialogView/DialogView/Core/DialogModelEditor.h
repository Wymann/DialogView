//
//  DialogModelEditor.h
//  TCLPlus
//
//  Created by OwenChen on 2021/1/4.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ButtonsDialogModel.h"
#import "ImageDialogModel.h"
#import "SelectorDialogModel.h"
#import "TextDialogModel.h"
#import "TextFieldDialogModel.h"
#import "TextViewDialogModel.h"

static const CGFloat DialogLeftGap = 24.0;
static const CGFloat DialogRightGap = 24.0;
static const CGFloat DialogTopGapWithTile = 24.0;
static const CGFloat DialogTopGapWithNoneTile = 36.0;
static const CGFloat DialogBottomGap = 24.0; //除去底部button
static const CGFloat DialogVGap = 8.0;


@interface DialogModelEditor : NSObject

+ (TextDialogModel *)createTextDialogModelWithTitle:(NSString *)title titleColor:(NSString *)titleColor;

+ (TextDialogModel *)createTextDialogModelWithTimeText:(NSString *)timeText;

+ (TextDialogModel *)createTextDialogModelWithSubtitle:(NSString *)subtitle subtitleColor:(NSString *)subtitleColor;

+ (TextDialogModel *)createTextDialogModelWithSubtitle:(NSString *)subtitle fontSize:(CGFloat)fontSize subtitleColor:(NSString *)subtitleColor;

+ (TextDialogModel *)createTextDialogModelWithAttributedSubtitle:(NSAttributedString *)attributedSubtitle subtitleColor:(NSString *)subtitleColor;

+ (ButtonsDialogModel *)createButtonsDialogModelWithButtons:(NSArray<NSString *> *)buttons buttonColors:(NSArray<NSString *> *)buttonColors;

+ (ButtonsDialogModel *)createButtonsDialogModelWithButtons:(NSArray<NSString *> *)buttons
                                               buttonColors:(NSArray<NSString *> *)buttonColors
                                          buttonsLayoutType:(DialogButtonsLayoutType)buttonsLayoutType;

+ (TextFieldDialogModel *)createTextFieldDialogModelWithInputText:(NSString *)inputText
                                                      placeHolder:(NSString *)placeHolder
                                                     keyboardType:(UIKeyboardType)keyboardType;

+ (TextViewDialogModel *)createTextViewDialogModelWithInputText:(NSString *)inputText
                                                    placeHolder:(NSString *)placeHolder
                                                   keyboardType:(UIKeyboardType)keyboardType
                                                  maxTextLength:(NSInteger)maxTextLength;

+ (ImageDialogModel *)createImageDialogModelWithImage:(UIImage *)image
                                            imageSize:(CGSize)imageSize
                                        imageFitWidth:(BOOL)imageFitWidth;

+ (ImageDialogModel *)createImageDialogModelWithImageUrl:(NSString *)imageUrl
                                             placeholder:(UIImage *)placeholder
                                              errorImage:(UIImage *)errorImage
                                               imageSize:(CGSize)imageSize
                                           imageFitWidth:(BOOL)imageFitWidth;

+ (SelectorDialogModel *)createSelectorDialogModelWithSelectorDialogItems:(NSArray<SelectorDialogItem *> *)items
                                                             maxSelectNum:(NSInteger)maxSelectNum
                                                        resultFromItemTap:(BOOL)resultFromItemTap;

+ (void)createModelMarginWithModels:(NSArray<BasicDialogModel *> *)models existTitle:(BOOL)existTitle;

@end
