//
//  TextShouldChangeResModel.h
//  TCLPlus
//
//  Created by Liuqs on 2020/10/14.
//  Copyright © 2020 TCL Electronics Holdings Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TextShouldChangeResModel : NSObject

//是否允许修改
@property (nonatomic, assign) BOOL shouldChange;
//提示语句--如果为空则不显示
@property (nonatomic, strong) NSString *tip;

+ (instancetype)modelWithShouldChange:(BOOL)shouldChange tipString:(NSString *)tipString;

@end

NS_ASSUME_NONNULL_END
