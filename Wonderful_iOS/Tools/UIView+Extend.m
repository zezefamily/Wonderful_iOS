//
//  UIView+Extend.m
//  Wonderful_iOS
//
//  Created by 泽泽 on 2019/8/15.
//  Copyright © 2019 泽泽. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

#pragma mark - Frame
- (CGPoint)ZZ_viewOrigin {
    return self.frame.origin;
}

- (void)setZZ_viewOrigin:(CGPoint)ZZ_viewOrigin {
    CGRect newFrame = self.frame;
    newFrame.origin = ZZ_viewOrigin;
    self.frame = newFrame;
}

- (CGSize)ZZ_viewSize {
    return self.frame.size;
}

- (void)setZZ_viewSize:(CGSize)ZZ_viewSize {
    CGRect newFrame = self.frame;
    newFrame.size = ZZ_viewSize;
    self.frame = newFrame;
}

#pragma mark - Frame Origin
- (CGFloat)ZZ_x {
    return self.frame.origin.x;
}

- (void)setZZ_x:(CGFloat)ZZ_x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = ZZ_x;
    self.frame = newFrame;
}

- (CGFloat)ZZ_y {
    return self.frame.origin.y;
}

- (void)setZZ_y:(CGFloat)ZZ_y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = ZZ_y;
    self.frame = newFrame;
}

#pragma mark - Frame Size
- (CGFloat)ZZ_width {
    return self.frame.size.width;
}

- (void)setZZ_width:(CGFloat)ZZ_width {
    CGRect newFrame = self.frame;
    newFrame.size.width = ZZ_width;
    self.frame = newFrame;
}

- (CGFloat)ZZ_height {
    return self.frame.size.height;
}

- (void)setZZ_height:(CGFloat)ZZ_height {
    CGRect newFrame = self.frame;
    newFrame.size.height = ZZ_height;
    self.frame = newFrame;
}

- (CGFloat)ZZ_bottom {
    return self.frame.origin.y + self.frame.size.height;
}
-(void)setZZ_bottom:(CGFloat)ZZ_bottom{
    
    CGRect frame = self.frame;
    frame.origin.y = ZZ_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ZZ_left {
    return self.frame.origin.x;
}
-(void)setZZ_left:(CGFloat)ZZ_left{
    CGRect frame = self.frame;
    frame.origin.x = ZZ_left;
    self.frame = frame;
}
- (CGFloat)ZZ_top {
    return self.frame.origin.y;
}

-(void)setZZ_top:(CGFloat)ZZ_top{
    CGRect frame = self.frame;
    frame.origin.y = ZZ_top;
    self.frame = frame;
}

- (CGFloat)ZZ_right {
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setZZ_right:(CGFloat)ZZ_right{
    CGRect frame = self.frame;
    frame.origin.x = ZZ_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ZZ_centerX {
    return self.center.x;
}
-(void)setZZ_centerX:(CGFloat)ZZ_centerX{
    self.center = CGPointMake(ZZ_centerX, self.center.y);
}

- (CGFloat)ZZ_centerY {
    return self.center.y;
}
-(void)setZZ_centerY:(CGFloat)ZZ_centerY{
    
    self.center = CGPointMake(self.center.x, ZZ_centerY);
}

-(NSDictionary *)ZZ_userInfo{
    
    if (!self.ZZ_userInfo) {
        self.ZZ_userInfo = [NSDictionary dictionary];
    }
    return self.ZZ_userInfo;
}

-(void)setZZ_userInfo:(NSDictionary *)ZZ_userInfo{
    
    if (!ZZ_userInfo) {
        self.ZZ_userInfo = [NSDictionary dictionary];
    }else{
        self.ZZ_userInfo = ZZ_userInfo;
    }
    
}

-(id)ZZ_key{
    
    if (!self.ZZ_key) {
        self.ZZ_key = @"it's not have key";
    }
    
    return self.ZZ_key;
}

-(void)setZZ_key:(id)ZZ_key{
    
    if (XXIsEmpty(ZZ_key)) {
        self.ZZ_key = @"it's not have key";
    }else{
        self.ZZ_key = ZZ_key;
    }
}

#pragma mark - 截屏
- (UIImage *)ZZ_capturedImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    UIImage *result = nil;
    if ([self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES]) {
        result = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    return result;
}

//设置圆角(测试性能ing)
- (void)setRadiusWithView:(UIView *)view radius:(float)cornerRadius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = view.bounds;
    layer.path = path.CGPath;
    view.layer.mask = layer;
}
@end
