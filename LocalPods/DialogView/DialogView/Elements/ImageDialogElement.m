//
//  ImageDialogElement.m
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import <SDWebImage/SDWebImage.h>

#import "ImageDialogElement.h"


@interface ImageDialogElement ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation ImageDialogElement

#pragma mark - Setter Methods
- (void)setModel:(BasicDialogModel *)model {
    [super setModel:model];

    ImageDialogModel *imageModel = (ImageDialogModel *)self.model;

    if (CGRectGetHeight(self.frame) > 0) {
        [self addSubview:self.imageView];

        self.imageView.contentMode = imageModel.contentMode;

        if (imageModel.imageFitWidth) {
            CGFloat X = imageModel.imageEdgeInsets.left;
            CGFloat Y = imageModel.imageEdgeInsets.top;
            CGFloat W = CGRectGetWidth(self.frame) - imageModel.imageEdgeInsets.left - imageModel.imageEdgeInsets.right;
            CGFloat H = CGRectGetHeight(self.frame) - imageModel.imageEdgeInsets.top - imageModel.imageEdgeInsets.bottom;
            self.imageView.frame = CGRectMake(X, Y, W, H);
        } else {
            CGFloat imageViewHeight = CGRectGetHeight(self.frame) - imageModel.imageEdgeInsets.top - imageModel.imageEdgeInsets.bottom;
            CGFloat imageViewWidth = imageModel.imageHeight > 0 ? imageModel.imageWidth * imageViewHeight / imageModel.imageHeight : 0;
            self.imageView.frame =
                CGRectMake((CGRectGetWidth(self.frame) - imageViewWidth) / 2, imageModel.imageEdgeInsets.top, imageViewWidth, imageViewHeight);
        }

        if (imageModel.image) {
            self.imageView.image = imageModel.image;
            if (imageModel.imgBackColor.length > 0) {
                self.imageView.backgroundColor = [UIColor dialog_colorWithHexString:imageModel.imgBackColor];
            }
        } else {
            __weak typeof(self) weakSelf = self;

            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.imgUrl] placeholderImage:imageModel.placeholder completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (!error && imageModel.imgBackColor.length > 0) {
                    weakSelf.imageView.backgroundColor = [UIColor dialog_colorWithHexString:imageModel.imgBackColor];
                } else if (error && imageModel.errorImage) {
                    weakSelf.imageView.image = imageModel.errorImage;
                }
            }];
        }
    }
}

#pragma mark - Lazy load Methods
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - Element Height
+ (CGFloat)elementHeightWithModel:(BasicDialogModel *)model elementWidth:(CGFloat)elementWidth {
    ImageDialogModel *imageModel = (ImageDialogModel *)model;

    if (imageModel.imageFitWidth) {
        CGFloat imgWidth = 0;
        CGFloat imgHeight = 0;

        if (imageModel.image) {
            imgWidth = imageModel.image.size.width;
            imgHeight = imageModel.image.size.height;
        } else if (imageModel.imgUrl.length > 0) {
            imgWidth = imageModel.imageWidth;
            imgHeight = imageModel.imageHeight;
        }

        CGFloat width = elementWidth - imageModel.imageEdgeInsets.left - imageModel.imageEdgeInsets.right;
        CGFloat height = imgWidth > 0 ? imgHeight * width / imgWidth : 0;
        return height + imageModel.imageEdgeInsets.top + imageModel.imageEdgeInsets.bottom;
    } else {
        CGFloat height = imageModel.imageHeight;
        return height + imageModel.imageEdgeInsets.top + imageModel.imageEdgeInsets.bottom;
    }
}

@end
