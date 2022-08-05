//
//  DialogFont.h
//  DialogView
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialogFont : NSObject

// 普通字体
@property (nonatomic, copy) NSString *normalFontName;

// 加粗字体
@property (nonatomic, copy) NSString *boldFontName;

/// 快捷创建 DialogFont
/// @param normalFontName 普通字体
/// @param boldFontName 加粗字体
+ (DialogFont *)dialogFontWithNormalFontName:(NSString *)normalFontName
                                BoldFontName:(NSString *)boldFontName;

@end

NS_ASSUME_NONNULL_END
