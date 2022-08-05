#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BasicDialogElement.h"
#import "BasicDialogModel.h"
#import "UIColor+Dialog.h"
#import "UIFont+Dialog.h"
#import "UITextView+Dialog.h"
#import "UIView+Dialog.h"
#import "UIViewController+Dialog.h"
#import "Dialog+Common.h"
#import "Dialog+CustomView.h"
#import "Dialog+Input.h"
#import "Dialog+LocalImage.h"
#import "Dialog+NetImage.h"
#import "Dialog+Selector.h"
#import "Dialog+SpecialColors.h"
#import "Dialog.h"
#import "DialogConfig.h"
#import "DialogHeader.h"
#import "DialogModelEditor.h"
#import "DialogView.h"
#import "DialogDemoViewController.h"
#import "ButtonsDialogElement.h"
#import "ImageDialogElement.h"
#import "SelectorDialogElement.h"
#import "TextDialogElement.h"
#import "TextFieldDialogElement.h"
#import "TextViewDialogElement.h"
#import "ButtonsDialogModel.h"
#import "DialogColor.h"
#import "DialogFont.h"
#import "DialogPattern.h"
#import "DialogResult.h"
#import "ImageDialogModel.h"
#import "SelectorDialogModel.h"
#import "TextDialogModel.h"
#import "TextFieldDialogModel.h"
#import "TextShouldChangeResModel.h"
#import "TextViewDialogModel.h"
#import "DialogTextTool.h"

FOUNDATION_EXPORT double DialogViewVersionNumber;
FOUNDATION_EXPORT const unsigned char DialogViewVersionString[];

