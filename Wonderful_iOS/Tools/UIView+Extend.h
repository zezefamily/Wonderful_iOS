//
//  UIView+Extend.h
//  Wonderful_iOS
//
//  Created by 泽泽 on 2019/8/15.
//  Copyright © 2019 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extend)

#pragma mark - Frame
/// 视图原点
@property (nonatomic) CGPoint ZZ_viewOrigin;
/// 视图尺寸
@property (nonatomic) CGSize ZZ_viewSize;

#pragma mark - Frame Origin
/// frame 原点 x 值
@property (nonatomic) CGFloat ZZ_x;
/// frame 原点 y 值
@property (nonatomic) CGFloat ZZ_y;

#pragma mark - Frame Size
/// frame 尺寸 width
@property (nonatomic) CGFloat ZZ_width;
/// frame 尺寸 height
@property (nonatomic) CGFloat ZZ_height;

@property (nonatomic) CGFloat ZZ_centerX;

@property (nonatomic) CGFloat ZZ_centerY;

@property (nonatomic) CGFloat ZZ_left;

@property (nonatomic) CGFloat ZZ_right;

@property (nonatomic) CGFloat ZZ_top;

@property (nonatomic) CGFloat ZZ_bottom;

//记录一些信息的字典
@property(nonatomic,copy, nullable)NSDictionary   *ZZ_userInfo;

//对象的唯一标识符
@property(nonatomic,copy,nullable)id       ZZ_key;

#pragma mark - 截屏
/// 当前视图内容生成的图像
@property (nonatomic, readonly, nullable)UIImage *ZZ_capturedImage;
#pragma mark - 画圆角
- (void)setRadiusWithView:(UIView *)view radius:(float)cornerRadius;

@end

NS_ASSUME_NONNULL_END
