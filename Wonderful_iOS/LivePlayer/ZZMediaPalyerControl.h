//
//  ZZMediaPalyerControl.h
//  Wonderful_iOS
//
//  Created by 泽泽 on 2019/8/9.
//  Copyright © 2019 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "ZZPlayModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ZZMediaPalyerControlDelegate <NSObject>
- (void)playControlButtonEventCallBack:(UIButton *)sender tag:(NSInteger)tag;
- (void)playControlSliderValueChanged:(UISlider *)slider event:(UITouchPhase)event;
@end
@interface ZZMediaPalyerControl : UIView
@property (nonatomic,weak) id<ZZMediaPalyerControlDelegate> delegate;
- (void)loadControlWithModel:(ZZPlayModel *)playModel;
- (void)changedPlayingState:(BOOL)state;
- (void)reloadTimeSliderWithPlayer:(VLCMediaPlayer *)player;
@end

NS_ASSUME_NONNULL_END
