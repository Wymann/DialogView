//
//  UIView+Dialog.m
//  TlifeApp
//
//  Created by Wymann Chan on 2021/12/15.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

#import "UIView+Dialog.h"


@implementation UIView (Dialog)

- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners {
    CALayer *oldShaperLayer = nil;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:@"cornerRadiusLayer"]) {
            oldShaperLayer = layer;
            break;
        }
    }
    if (oldShaperLayer) {
        [oldShaperLayer removeFromSuperlayer];
    }
    // 1. 加一个layer 显示形状
    CGRect rect = CGRectMake(borderWidth / 2.0, borderWidth / 2.0, CGRectGetWidth(self.frame) - borderWidth, CGRectGetHeight(self.frame) - borderWidth);
    CGSize radii = CGSizeMake(cornerRadius, borderWidth);

    // create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];

    // create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;

    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    shapeLayer.name = @"cornerRadiusLayer";

    [self.layer addSublayer:shapeLayer];
    // 2. 加一个layer 按形状 把外面的减去
    CGRect clipRect = CGRectMake(0, 0, CGRectGetWidth(self.frame) - 0, CGRectGetHeight(self.frame) - 0);
    CGSize clipRadii = CGSizeMake(cornerRadius, borderWidth);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:clipRect byRoundingCorners:corners cornerRadii:clipRadii];

    CAShapeLayer *clipLayer = [CAShapeLayer layer];
    clipLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;

    clipLayer.lineWidth = 0;
    clipLayer.lineJoin = kCALineJoinRound;
    clipLayer.lineCap = kCALineCapRound;
    clipLayer.path = clipPath.CGPath;

    self.layer.mask = clipLayer;
}

@end
