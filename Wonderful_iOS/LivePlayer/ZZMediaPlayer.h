//
//  ZZMediaPlayer.h
//  Wonderful_iOS
//
//  Created by 泽泽 on 2019/8/9.
//  Copyright © 2019 泽泽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "ZZMediaPalyerControl.h"
#import "ZZPlayModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ZZMediaPlayerDelegate <NSObject>
- (void)zz_mediaPlayerEventClick:(NSInteger)tag sender:(UIButton *)sender;
@end
@interface ZZMediaPlayer : UIView
@property (nonatomic,weak) id<ZZMediaPlayerDelegate> delegate;
- (void)zz_playWithModel:(ZZPlayModel *)playModel;
- (void)zz_playWithURL:(NSString *)URLString;
@end

NS_ASSUME_NONNULL_END
