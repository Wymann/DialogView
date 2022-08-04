//
//  Dialog+ImageText.m
//  TCLPlus
//
//  Created by Wymann Chan on 2021/6/10.
//  Copyright © 2021 TCL Electronics Holdings Ltd. All rights reserved.
//

#import "DialogModelEditor.h"

#import "Dialog+Common.h"
#import "Dialog+LocalImage.h"
#import "Dialog+SpecialColors.h"


@implementation Dialog (LocalImage)

#pragma mark - 自动显示弹框

/// 显示图片在顶部的弹框
+ (DialogView *)showDialogWithImage:(UIImage *)image
                          imageType:(DialogImageType)imageType
                              title:(NSString *)title
                           subtitle:(NSString *)subtitle
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImage:image
                                   imageType:imageType
                                       title:title
                                    subtitle:subtitle
                                     buttons:buttons
                                 resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示图片在顶部的弹框（可自定义弹按钮颜色）
+ (DialogView *)showDialogWithImage:(UIImage *)image
                          imageType:(DialogImageType)imageType
                              title:(NSString *)title
                           subtitle:(NSString *)subtitle
                            buttons:(NSArray<NSString *> *)buttons
                       buttonColors:(NSArray<NSString *> *)buttonColors
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImage:image
                                   imageType:imageType
                                       title:title
                                    subtitle:subtitle
                                     buttons:buttons
                                buttonColors:buttonColors
                                 resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示图片在顶部的弹框（副标题是富文本）
+ (DialogView *)showDialogWithImage:(UIImage *)image
                          imageType:(DialogImageType)imageType
                              title:(NSString *)title
                 attributedSubtitle:(NSAttributedString *)attributedSubtitle
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImage:image
                                   imageType:imageType
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
                              image:(UIImage *)image
                          imageType:(DialogImageType)imageType
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithTitle:title
                                    subtitle:subtitle
                                       image:image
                                   imageType:imageType
                                     buttons:buttons
                                 resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                              image:(UIImage *)image
                  imageCornerRadius:(CGFloat)imageCornerRadius
                          imageType:(DialogImageType)imageType
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithTitle:title
                                    subtitle:subtitle
                                       image:image
                           imageCornerRadius:(CGFloat)imageCornerRadius
                                   imageType:imageType
                                     buttons:buttons
                                 resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

/// 显示图片在标题下面的弹框（图片大小自定义）
+ (DialogView *)showDialogWithTitle:(NSString *)title
                           subtitle:(NSString *)subtitle
                              image:(UIImage *)image
                    customImageSize:(CGSize)customImageSize
                            buttons:(NSArray<NSString *> *)buttons
                        resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithTitle:title
                                    subtitle:subtitle
                                       image:image
                             customImageSize:customImageSize
                                     buttons:buttons
                                 resultBlock:resultBlock];

    [self addDialogView:view];

    return view;
}

#pragma mark - 生成弹框，不自动显示

/// 图片在顶部的弹框
+ (DialogView *)dialogWithImage:(UIImage *)image
                      imageType:(DialogImageType)imageType
                          title:(NSString *)title
                       subtitle:(NSString *)subtitle
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImage:image
                                   imageType:imageType
                                       title:title
                                    subtitle:subtitle
                          attributedSubtitle:nil
                                     buttons:buttons
                                buttonColors:nil
                                 resultBlock:resultBlock];
    return view;
}

/// 图片在顶部的弹框（可自定义弹按钮颜色）
+ (DialogView *)dialogWithImage:(UIImage *)image
                      imageType:(DialogImageType)imageType
                          title:(NSString *)title
                       subtitle:(NSString *)subtitle
                        buttons:(NSArray<NSString *> *)buttons
                   buttonColors:(NSArray<NSString *> *)buttonColors
                    resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImage:image
                                   imageType:imageType
                                       title:title
                                    subtitle:subtitle
                          attributedSubtitle:nil
                                     buttons:buttons
                                buttonColors:buttonColors
                                 resultBlock:resultBlock];
    return view;
}

/// 图片在顶部的弹框（副标题是富文本）
+ (DialogView *)dialogWithImage:(UIImage *)image
                      imageType:(DialogImageType)imageType
                          title:(NSString *)title
             attributedSubtitle:(NSAttributedString *)attributedSubtitle
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock {
    DialogView *view = [self dialogWithImage:image
                                   imageType:imageType
                                       title:title
                                    subtitle:nil
                          attributedSubtitle:attributedSubtitle
                                     buttons:buttons
                                buttonColors:nil
                                 resultBlock:resultBlock];
    return view;
}

+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                          image:(UIImage *)image
              imageCornerRadius:(CGFloat)imageCornerRadius
                      imageType:(DialogImageType)imageType
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock {
    if (image) {
        NSMutableArray *array = [NSMutableArray array];

        TextDialogModel *textModel;
        if (title.length > 0) {
            textModel = [DialogModelEditor createTextDialogModelWithTitle:title titleColor:nil];
            [array addObject:textModel];
        }

        TextDialogModel *textModel1;
        if (subtitle.length > 0) {
            textModel1 = [DialogModelEditor createTextDialogModelWithSubtitle:subtitle fontSize:14.0 subtitleColor:nil];
            [array addObject:textModel1];
        }

        CGSize imageSize = image.size;
        BOOL imageFitWidth = YES;
        if (image.size.width > 0 && image.size.height > 0) {
            switch (imageType) {
                case DialogImageTypeCommon: {
                    imageSize = image.size;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeLarge: {
                    imageSize = image.size;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeSmall: {
                    imageSize = CGSizeMake(100, image.size.height * 100 / image.size.width);
                    imageFitWidth = NO;
                } break;
                case DialogImageTypeTiny: {
                    imageSize = CGSizeMake(50, image.size.height * 50 / image.size.width);
                    imageFitWidth = NO;
                } break;
                default:
                    break;
            }
        }

        ImageDialogModel *imageModel = [DialogModelEditor createImageDialogModelWithImage:image
                                                                                imageSize:imageSize
                                                                            imageFitWidth:imageFitWidth];
        imageModel.cornerRadius = imageCornerRadius;
        [array addObject:imageModel];

        [DialogModelEditor createModelMarginWithModels:array existTitle:title.length > 0];

        if (buttons.count > 0) {
            ButtonsDialogModel *buttonsModel = [DialogModelEditor createButtonsDialogModelWithButtons:buttons buttonColors:nil];
            buttonsModel.bold = YES;
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
            imageMargin.top = 4.0;

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


/// 图片在标题下面的弹框
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                          image:(UIImage *)image
                      imageType:(DialogImageType)imageType
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock {
    if (image) {
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

        CGSize imageSize = image.size;
        BOOL imageFitWidth = YES;
        if (image.size.width > 0 && image.size.height > 0) {
            switch (imageType) {
                case DialogImageTypeCommon: {
                    imageSize = image.size;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeLarge: {
                    imageSize = image.size;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeSmall: {
                    imageSize = CGSizeMake(100, image.size.height * 100 / image.size.width);
                    imageFitWidth = NO;
                } break;
                case DialogImageTypeTiny: {
                    imageSize = CGSizeMake(50, image.size.height * 50 / image.size.width);
                    imageFitWidth = NO;
                } break;
                default:
                    break;
            }
        }

        ImageDialogModel *imageModel = [DialogModelEditor createImageDialogModelWithImage:image
                                                                                imageSize:imageSize
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

/// 图片在标题下面的弹框（图片大小自定义）
+ (DialogView *)dialogWithTitle:(NSString *)title
                       subtitle:(NSString *)subtitle
                          image:(UIImage *)image
                customImageSize:(CGSize)customImageSize
                        buttons:(NSArray<NSString *> *)buttons
                    resultBlock:(DialogResultBlock)resultBlock {
    if (image) {
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

        ImageDialogModel *imageModel = [DialogModelEditor createImageDialogModelWithImage:image
                                                                                imageSize:customImageSize
                                                                            imageFitWidth:NO];
        [array addObject:imageModel];

        [DialogModelEditor createModelMarginWithModels:array existTitle:title.length > 0];

        if (buttons.count > 0) {
            ButtonsDialogModel *buttonsModel = [DialogModelEditor createButtonsDialogModelWithButtons:buttons buttonColors:nil];
            [array addObject:buttonsModel];
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
+ (DialogView *)dialogWithImage:(UIImage *)image
                      imageType:(DialogImageType)imageType
                          title:(NSString *)title
                       subtitle:(NSString *)subtitle
             attributedSubtitle:(NSAttributedString *)attributedSubtitle
                        buttons:(NSArray<NSString *> *)buttons
                   buttonColors:(NSArray<NSString *> *)buttonColors
                    resultBlock:(DialogResultBlock)resultBlock {
    if (image) {
        NSMutableArray *array = [NSMutableArray array];

        CGSize imageSize = image.size;
        BOOL imageFitWidth = YES;
        if (image.size.width > 0 && image.size.height > 0) {
            switch (imageType) {
                case DialogImageTypeCommon: {
                    imageSize = image.size;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeLarge: {
                    imageSize = image.size;
                    imageFitWidth = YES;
                } break;
                case DialogImageTypeSmall: {
                    imageSize = CGSizeMake(100, image.size.height * 100 / image.size.width);
                    imageFitWidth = NO;
                } break;
                case DialogImageTypeTiny: {
                    imageSize = CGSizeMake(50, image.size.height * 50 / image.size.width);
                    imageFitWidth = NO;
                } break;
                default:
                    break;
            }
        }
        ImageDialogModel *imageModel = [DialogModelEditor createImageDialogModelWithImage:image
                                                                                imageSize:imageSize
                                                                            imageFitWidth:imageFitWidth];
        [array addObject:imageModel];

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

        if (attributedSubtitle) {
            textModel1 = [DialogModelEditor createTextDialogModelWithAttributedSubtitle:attributedSubtitle subtitleColor:nil];
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
