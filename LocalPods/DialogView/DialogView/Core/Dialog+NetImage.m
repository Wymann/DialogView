//
//  Dialog+NetImage.m
//  TCLPlus
//
//  Created by Wymann Chan on 2021/6/16.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogModelEditor.h"

#import "Dialog+Common.h"
#import "Dialog+NetImage.h"
#import "Dialog+SpecialColors.h"


@implementation Dialog (NetImage)

#pragma mark - 自动显示弹框

/// 显示图片在顶部的弹框
+ (DialogView *)showDialogWithImageUrl:(NSString *)imageUrl
                             imageType:(DialogImageType)imageType
                             imageSize:(CGSize)imageSize
                           placeholder:(UIImage *)placeholder
                            errorImage:(UIImage *)errorImage
                                 title:(NSString *)title
                              subtitle:(NSString *)subtitle
                               buttons:(NSArray<NSString *> *)buttons
                           resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImageUrl:imageUrl
                                      imageType:imageType
                                      imageSize:imageSize
                                    placeholder:placeholder
                                     errorImage:errorImage
                                          title:title
                                       subtitle:subtitle
                                        buttons:buttons
                                    resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示图片在顶部的弹框（可自定义弹按钮颜色）
+ (DialogView *)showDialogWithImageUrl:(NSString *)imageUrl
                             imageType:(DialogImageType)imageType
                             imageSize:(CGSize)imageSize
                           placeholder:(UIImage *)placeholder
                            errorImage:(UIImage *)errorImage
                                 title:(NSString *)title
                              subtitle:(NSString *)subtitle
                           maxSubLines:(NSInteger)maxSubLines
                               buttons:(NSArray<NSString *> *)buttons
                          buttonColors:(NSArray<NSString *> *)buttonColors
                           resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImageUrl:imageUrl
                                      imageType:imageType
                                      imageSize:imageSize
                                    placeholder:placeholder
                                     errorImage:errorImage
                                          title:title
                                       subtitle:subtitle
                                    maxSubLines:maxSubLines
                                        buttons:buttons
                                   buttonColors:buttonColors
                                    resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示图片在顶部的弹框（可自定义弹按钮颜色；带时间文字）
+ (DialogView *)showDialogWithImageUrl:(NSString *)imageUrl
                             imageType:(DialogImageType)imageType
                             imageSize:(CGSize)imageSize
                           placeholder:(UIImage *)placeholder
                            errorImage:(UIImage *)errorImage
                                 title:(NSString *)title
                              timeText:(NSString *)timeText
                              subtitle:(NSString *)subtitle
                           maxSubLines:(NSInteger)maxSubLines
                               buttons:(NSArray<NSString *> *)buttons
                          buttonColors:(NSArray<NSString *> *)buttonColors
                           resultBlock:(DialogResultBlock)resultBlock {
    NSString *timeString;

    if (timeText.length > 0) {
        timeString = timeText;
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *datenow = [NSDate date];
        timeString = [formatter stringFromDate:datenow];
    }

    DialogView *view = [self dialogWithImageUrl:imageUrl
                                      imageType:imageType
                                      imageSize:imageSize
                                    placeholder:placeholder
                                     errorImage:errorImage
                                          title:title
                                       timeText:timeString
                                       subtitle:subtitle
                                    maxSubLines:maxSubLines
                                        buttons:buttons
                                   buttonColors:buttonColors
                                    resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示图片在顶部的弹框（副标题是富文本）
+ (DialogView *)showDialogWithImageUrl:(NSString *)imageUrl
                             imageType:(DialogImageType)imageType
                             imageSize:(CGSize)imageSize
                           placeholder:(UIImage *)placeholder
                            errorImage:(UIImage *)errorImage
                                 title:(NSString *)title
                    attributedSubtitle:(NSAttributedString *)attributedSubtitle
                               buttons:(NSArray<NSString *> *)buttons
                           resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImageUrl:imageUrl
                                      imageType:imageType
                                      imageSize:imageSize
                                    placeholder:placeholder
                                     errorImage:errorImage
                                          title:title
                             attributedSubtitle:attributedSubtitle
                                        buttons:buttons
                                    resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示图片在标题下面的弹框
+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                           imageUrl:(NSString *)imageUrl
                          imageType:(DialogImageType)imageType
                          imageSize:(CGSize)imageSize
                        placeholder:(UIImage *)placeholder
                         errorImage:(UIImage *)errorImage
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithTitle:title
                                    subtitle:subtitle
                                    imageUrl:imageUrl
                                   imageType:imageType
                                   imageSize:imageSize
                                 placeholder:placeholder
                                  errorImage:errorImage
                                     buttons:buttons
                                 resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

#pragma mark - 生成弹框，不自动显示

/// 图片在顶部的弹框
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle
                           buttons:(NSArray<NSString *> *)buttons
                       resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImageUrl:imageUrl
                                      imageType:imageType
                                      imageSize:imageSize
                                    placeholder:placeholder
                                     errorImage:errorImage
                                          title:title
                                       timeText:nil
                                       subtitle:subtitle
                             attributedSubtitle:nil
                                    maxSubLines:0
                                        buttons:buttons
                                   buttonColors:nil
                                    resultBlock:resultBlock];
    return view;
}

/// 图片在顶部的弹框（可自定义弹按钮颜色）
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle
                       maxSubLines:(NSInteger)maxSubLines
                           buttons:(NSArray<NSString *> *)buttons
                      buttonColors:(NSArray<NSString *> *)buttonColors
                       resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImageUrl:imageUrl
                                      imageType:imageType
                                      imageSize:imageSize
                                    placeholder:placeholder
                                     errorImage:errorImage
                                          title:title
                                       timeText:nil
                                       subtitle:subtitle
                             attributedSubtitle:nil
                                    maxSubLines:maxSubLines
                                        buttons:buttons
                                   buttonColors:buttonColors
                                    resultBlock:resultBlock];
    return view;
}

/// 图片在顶部的弹框（可自定义弹按钮颜色；带时间文字）
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                          timeText:(NSString *)timeText
                          subtitle:(NSString *)subtitle
                       maxSubLines:(NSInteger)maxSubLines
                           buttons:(NSArray<NSString *> *)buttons
                      buttonColors:(NSArray<NSString *> *)buttonColors
                       resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImageUrl:imageUrl
                                      imageType:imageType
                                      imageSize:imageSize
                                    placeholder:placeholder
                                     errorImage:errorImage
                                          title:title
                                       timeText:timeText
                                       subtitle:subtitle
                             attributedSubtitle:nil
                                    maxSubLines:maxSubLines
                                        buttons:buttons
                                   buttonColors:buttonColors
                                    resultBlock:resultBlock];
    return view;
}

/// 图片在顶部的弹框（副标题是富文本）
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                attributedSubtitle:(NSAttributedString *)attributedSubtitle
                           buttons:(NSArray<NSString *> *)buttons
                       resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImageUrl:imageUrl
                                      imageType:imageType
                                      imageSize:imageSize
                                    placeholder:placeholder
                                     errorImage:errorImage
                                          title:title
                                       timeText:nil
                                       subtitle:nil
                             attributedSubtitle:attributedSubtitle
                                    maxSubLines:0
                                        buttons:buttons
                                   buttonColors:nil
                                    resultBlock:resultBlock];
    return view;
}

/// 图片在标题下面的弹框
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                       imageUrl:(NSString *)imageUrl
                      imageType:(DialogImageType)imageType
                      imageSize:(CGSize)imageSize
                    placeholder:(UIImage *)placeholder
                     errorImage:(UIImage *)errorImage
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock {
    if ([imageUrl hasPrefix:@"http"]) {
        NSMutableArray *array = [NSMutableArray array];

        TextDialogModel *textModel;
        if (title.length > 0) {
            textModel = [DialogModelEditor createTextDialogModelWithTitle:title titleColor:nil];
            [array addObject:textModel];
        }

        TextDialogModel *textModel1;
        if (subtitle.length > 0) {
            textModel1 = [DialogModelEditor createTextDialogModelWithSubtitle:subtitle subtitleColor:nil];
            [array addObject:textModel1];
        }

        CGSize size = imageSize;
        BOOL imageFitWidth = YES;
        if (imageSize.width > 0 && imageSize.height > 0) {
            switch (imageType) {
                case DialogImageTypeCommon: {
                    size = imageSize;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeLarge: {
                    size = imageSize;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeSmall: {
                    size = CGSizeMake(100, imageSize.height * 100 / imageSize.width);
                    imageFitWidth = NO;
                } break;
                case DialogImageTypeTiny: {
                    size = CGSizeMake(50, imageSize.height * 50 / imageSize.width);
                    imageFitWidth = NO;
                } break;
                default:
                    break;
            }
        }
        ImageDialogModel *imageModel = [DialogModelEditor createImageDialogModelWithImageUrl:imageUrl
                                                                                 placeholder:placeholder
                                                                                  errorImage:errorImage
                                                                                   imageSize:size
                                                                               imageFitWidth:imageFitWidth];
        [array addObject:imageModel];

        [DialogModelEditor createModelMarginWithModels:array existTitle:title.length > 0];

        if (buttons.count > 0) {
            ButtonsDialogModel *buttonsModel = [DialogModelEditor createButtonsDialogModelWithButtons:buttons buttonColors:nil];
            [array addObject:buttonsModel];
        }

        if (imageType == DialogImageTypeLarge) {
            UIEdgeInsets imageMargin = imageModel.margin;
            imageMargin.left = 0;
            imageMargin.right = 0;

            imageModel.margin = imageMargin;
        } else if (imageType == DialogImageTypeCommon) {
            UIEdgeInsets imageMargin = imageModel.margin;
            imageMargin.left = 24.0;
            imageMargin.right = 24.0;

            imageModel.margin = imageMargin;
        }

        DialogView *view = [[DialogView alloc] initWithDialogModels:array
                                                          animation:[Dialog sharedInstance].animationType
                                                           position:DialogPositionMiddle
                                                            sideTap:YES
                                                             bounce:YES];
        view.resultBlock = resultBlock;

        return view;
    } else {
        return [Dialog dialogWithTitle:title
                              subtitle:subtitle
                               buttons:buttons
                           resultBlock:resultBlock];
    }
}

#pragma mark - Private Methods

/// 图片在顶部
+ (DialogView *)dialogWithImageUrl:(NSString *)imageUrl
                         imageType:(DialogImageType)imageType
                         imageSize:(CGSize)imageSize
                       placeholder:(UIImage *)placeholder
                        errorImage:(UIImage *)errorImage
                             title:(NSString *)title
                          timeText:(NSString *)timeText
                          subtitle:(NSString *)subtitle
                attributedSubtitle:(NSAttributedString *)attributedSubtitle
                       maxSubLines:(NSInteger)maxSubLines
                           buttons:(NSArray<NSString *> *)buttons
                      buttonColors:(NSArray<NSString *> *)buttonColors
                       resultBlock:(DialogResultBlock)resultBlock {
    if ([imageUrl hasPrefix:@"http"]) {
        NSMutableArray *array = [NSMutableArray array];

        CGSize size = imageSize;
        BOOL imageFitWidth = YES;
        if (imageSize.width > 0 && imageSize.height > 0) {
            switch (imageType) {
                case DialogImageTypeCommon: {
                    size = imageSize;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeLarge: {
                    size = imageSize;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeSmall: {
                    size = CGSizeMake(100, imageSize.height * 100 / imageSize.width);
                    imageFitWidth = NO;
                } break;
                case DialogImageTypeTiny: {
                    size = CGSizeMake(50, imageSize.height * 50 / imageSize.width);
                    imageFitWidth = NO;
                } break;
                default:
                    break;
            }
        }

        ImageDialogModel *imageModel = [DialogModelEditor createImageDialogModelWithImageUrl:imageUrl
                                                                                 placeholder:placeholder
                                                                                  errorImage:errorImage
                                                                                   imageSize:size
                                                                               imageFitWidth:imageFitWidth];
        [array addObject:imageModel];

        TextDialogModel *textModel;
        if (title.length > 0) {
            textModel = [DialogModelEditor createTextDialogModelWithTitle:title titleColor:nil];
            [array addObject:textModel];
        }

        TextDialogModel *timeModel;
        if (timeText.length > 0) {
            timeModel = [DialogModelEditor createTextDialogModelWithTimeText:timeText];
            [array addObject:timeModel];
        }

        TextDialogModel *textModel1;
        if (subtitle.length > 0) {
            textModel1 = [DialogModelEditor createTextDialogModelWithSubtitle:subtitle subtitleColor:nil];
            textModel1.maxLines = maxSubLines;
            [array addObject:textModel1];
        }

        if (attributedSubtitle) {
            textModel1 = [DialogModelEditor createTextDialogModelWithAttributedSubtitle:attributedSubtitle subtitleColor:nil];
            textModel1.maxLines = maxSubLines;
            [array addObject:textModel1];
        }

        [DialogModelEditor createModelMarginWithModels:array existTitle:title.length > 0];

        if (buttons.count > 0) {
            ButtonsDialogModel *buttonsModel = [DialogModelEditor createButtonsDialogModelWithButtons:buttons buttonColors:buttonColors];
            [array addObject:buttonsModel];
        }

        if (imageType != DialogImageTypeSmall) {
            if (imageType == DialogImageTypeLarge) {
                UIEdgeInsets imageMargin = imageModel.margin;
                imageMargin.left = 0;
                imageMargin.right = 0;
                imageMargin.top = 0;

                imageModel.margin = imageMargin;
            } else if (imageType == DialogImageTypeCommon) {
                UIEdgeInsets imageMargin = imageModel.margin;
                imageMargin.left = 24.0;
                imageMargin.right = 24.0;
                imageMargin.top = 16.0;

                imageModel.margin = imageMargin;
            }

            UIEdgeInsets textModelMargin = textModel.margin;
            textModelMargin.top = 25.0;
            textModel.margin = textModelMargin;

            UIEdgeInsets textModel1Margin = textModel1.margin;
            textModel1Margin.top = 12.0;
            textModel1.margin = textModel1Margin;
        }

        DialogView *view = [[DialogView alloc] initWithDialogModels:array
                                                          animation:[Dialog sharedInstance].animationType
                                                           position:DialogPositionMiddle
                                                            sideTap:YES
                                                             bounce:YES];
        view.resultBlock = resultBlock;

        return view;
    } else {
        if (!attributedSubtitle) {
            if (buttonColors.count > 0 && buttonColors.count == buttons.count) {
                return [Dialog dialogWithTitle:title
                                    titleColor:nil
                                      subtitle:subtitle
                                 subtitleColor:nil
                                       buttons:buttons
                                  buttonColors:buttonColors
                                   resultBlock:resultBlock];
            } else {
                return [Dialog dialogWithTitle:title
                                      subtitle:subtitle
                                       buttons:buttons
                                   resultBlock:resultBlock];
            }
        } else {
            if (buttonColors.count > 0 && buttonColors.count == buttons.count) {
                return [Dialog dialogWithTitle:title
                                    titleColor:nil
                            attributedSubtitle:attributedSubtitle
                                       buttons:buttons
                                  buttonColors:buttonColors
                                   resultBlock:resultBlock];
            } else {
                return [Dialog dialogWithTitle:title
                            attributedSubtitle:attributedSubtitle
                                       buttons:buttons
                                   resultBlock:resultBlock];
            }
        }
    }
}

@end
