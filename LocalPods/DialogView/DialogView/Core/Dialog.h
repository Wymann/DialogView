//
//  Dialog.h
//  TCLPlus
//
//  Created by OwenChen on 2020/8/18.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DialogView.h"

#ifdef DEBUG
#define DIALOG_LOG(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#define DIALOG_LOG(...) ;
#endif

// 弹框优先级
typedef NS_ENUM(NSInteger, DialogPriorityType) {
    DialogPriorityS = 0, // 优先级最高的全局弹框（比如强制升级等）
    DialogPriorityA = 1, // 普通的全局弹框 (Push 弹框等)
    DialogPriorityB = 2, // 局部弹框一般都放这里
    DialogPriorityC = 3,
};

// 弹框便捷优先级设置 （0 到 20）
typedef NS_ENUM(NSInteger, DialogConvenientType) {
    DialogConvenientTypeP0 = 0,   // DialogPriorityA @(200)
    DialogConvenientTypeP1 = 1,   // DialogPriorityA @(190)
    DialogConvenientTypeP2 = 2,   // DialogPriorityA @(180)
    DialogConvenientTypeP3 = 3,   // DialogPriorityA @(170)
    DialogConvenientTypeP4 = 4,   // DialogPriorityA @(160)
    DialogConvenientTypeP5 = 5,   // DialogPriorityA @(150)
    DialogConvenientTypeP6 = 6,   // DialogPriorityA @(140)
    DialogConvenientTypeP7 = 7,   // DialogPriorityA @(130)
    DialogConvenientTypeP8 = 8,   // DialogPriorityA @(120)
    DialogConvenientTypeP9 = 9,   // DialogPriorityA @(110)
    DialogConvenientTypeP10 = 10, // DialogPriorityA @(100)
    DialogConvenientTypeP11 = 11, // DialogPriorityA @(90)
    DialogConvenientTypeP12 = 12, // DialogPriorityA @(80)
    DialogConvenientTypeP13 = 13, // DialogPriorityA @(70)
    DialogConvenientTypeP14 = 14, // DialogPriorityA @(60)
    DialogConvenientTypeP15 = 15, // DialogPriorityA @(50)
    DialogConvenientTypeP16 = 16, // DialogPriorityA @(40)
    DialogConvenientTypeP17 = 17, // DialogPriorityA @(30)
    DialogConvenientTypeP18 = 18, // DialogPriorityA @(20)
    DialogConvenientTypeP19 = 19, // DialogPriorityA @(10)
    DialogConvenientTypeP20 = 20, // DialogPriorityA @(0)
};


@interface DialogPriorityModel : NSObject

@property (nonatomic, strong) DialogView *dialogView; // 弹框视图

@property (nonatomic, assign) DialogPriorityType priorityType; // 优先级

@property (nonatomic, strong) NSNumber *priorityValue; // 优先值

@property (nonatomic, assign) CGFloat timeInQueue; // 在队列中等待时长（大于0才生效）

@property (nonatomic, assign) CGFloat timeOnShow; // 在显示中等待时长（大于0才生效）

// 是否只显示一次
// YES：（默认）显示之后，后面被更高优先级的弹框挤下去，后面也不再显示
// NO：被更高优先级的弹框挤下去，还会在队列中等待
@property (nonatomic, assign, getter=isShowOnce) BOOL showOnce;

// 是否为队列中最后一个
// YES：队列中最后一个，之后的弹框不会再显示，也不允许再增加，直到这个弹框关闭
// NO：（默认）
@property (nonatomic, assign, getter=isEndDialog) BOOL endDialog;

/// 根据弹框创建 DialogPriorityModel，（priorityType 为 DialogPriorityB， priorityValue 为0）
/// @param dialogView 弹框
+ (DialogPriorityModel *)createDialogPriorityModelWithDialogView:(DialogView *)dialogView;

/// 创建 DialogPriorityModel
/// @param dialogView 弹框
/// @param priorityType 优先级
/// @param priorityValue 优先值
+ (DialogPriorityModel *)createDialogPriorityModelWithDialogView:(DialogView *)dialogView
                                                    priorityType:(DialogPriorityType)priorityType
                                                   priorityValue:(NSNumber *)priorityValue;

/// 创建 DialogPriorityModel
/// @param dialogView 弹框
/// @param convenientType 便捷优先级设置
+ (DialogPriorityModel *)createDialogPriorityModelWithDialogView:(DialogView *)dialogView
                                                  convenientType:(DialogConvenientType)convenientType;

/// 移除显示时候的计时时间
- (void)stopCountTimeOnShow;

/// 重新设置显示中等待时长
/// @param timeOnShow 显示中等待时长
- (void)restartCountTimeOnShowWithTime:(CGFloat)timeOnShow;

@end


@interface Dialog : NSObject

@property (nonatomic, assign) ShowAnimation animationType;  //弹框动画
@property (nonatomic, assign, getter=isBounce) BOOL bounce; //动画是否有弹性

@property (nonatomic, strong, readonly) NSMutableArray<DialogPriorityModel *> *prioritySArray;
@property (nonatomic, strong, readonly) NSMutableArray<DialogPriorityModel *> *priorityAArray;
@property (nonatomic, strong, readonly) NSMutableArray<DialogPriorityModel *> *priorityBArray;
@property (nonatomic, strong, readonly) NSMutableArray<DialogPriorityModel *> *priorityCArray;
@property (nonatomic, strong, readonly) NSArray *allPriorityArray;

+ (instancetype)sharedInstance;

/// 添加一个弹框
/// @param dialogView 弹框
/// @param priorityType 优先级
/// @param priorityValue 优先值
+ (DialogPriorityModel *)addDialogView:(DialogView *)dialogView
                        dialogPriority:(DialogPriorityType)priorityType
                         priorityValue:(NSNumber *)priorityValue;

/// 添加一个弹框（priorityType 为 DialogPriorityB， priorityValue 为0）
/// @param dialogView 弹框
+ (DialogPriorityModel *)addDialogView:(DialogView *)dialogView;

/// 添加多个弹框（priorityType 为 DialogPriorityB， priorityValue 为0），依次弹出
/// @param dialogViews 弹框集合
+ (NSArray<DialogPriorityModel *> *)addDialogViews:(NSArray<DialogView *> *)dialogViews;

/// 添加多个弹框模型
/// @param priorityModels 弹框模型集合
+ (void)addDialogPriorityModels:(NSArray<DialogPriorityModel *> *)priorityModels;

/// 移除所有弹框
+ (void)removeAllDialog;

/// 移除所有弹框
/// @param exceptCurrentDialog 是否除去当前正在显示的（YES的话当前显示的弹框不移除）
+ (void)removeAllDialogWithExceptCurrentDialog:(BOOL)exceptCurrentDialog;

/// 移除指定弹框
/// @param tag tag
+ (void)removeDialogWithTag:(NSInteger)tag;

/// 移除指定弹框
/// @param priorityType 优先级
+ (void)removeDialogWithPriorityType:(DialogPriorityType)priorityType;

/// 绑定弹框与控制器（只会在这个控制器上显示）
/// @param dialogView 弹框
/// @param viewController 控制器
+ (void)bindWithDialogView:(DialogView *)dialogView viewController:(UIViewController *)viewController;


@end
