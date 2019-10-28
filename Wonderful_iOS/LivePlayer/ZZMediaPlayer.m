//
//  ZZMediaPlayer.m
//  Wonderful_iOS
//
//  Created by 泽泽 on 2019/8/9.
//  Copyright © 2019 泽泽. All rights reserved.
//

#import "ZZMediaPlayer.h"

@interface ZZMediaPlayer ()<VLCMediaPlayerDelegate,ZZMediaPalyerControlDelegate>
{
    CGRect _frame;
}
@property (nonatomic,strong) VLCMediaPlayer *vlcPlayer;
@property (nonatomic,strong) UIView *videoPlayView;
@property (nonatomic,strong) ZZMediaPalyerControl *playControl;
@end
@implementation ZZMediaPlayer
- (instancetype)init
{
    if(self == [super init]){
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    [self addSubview:self.videoPlayView];
    [self loadVLCMediaPlayer];
    [self addSubview:self.playControl];
}
#pragma mark - get
- (void)loadVLCMediaPlayer
{
    if(!_vlcPlayer){
        _vlcPlayer = [[VLCMediaPlayer alloc]init];
        _vlcPlayer.delegate = self;
        _vlcPlayer.drawable = self.videoPlayView;
    }
}
- (UIView *)videoPlayView
{
    if(!_videoPlayView){
        _videoPlayView = [[UIView alloc]init];
        _videoPlayView.backgroundColor = [UIColor blackColor];
    }
    return _videoPlayView;
}
- (ZZMediaPalyerControl *)playControl
{
    if(!_playControl){
        _playControl = [[ZZMediaPalyerControl alloc]init];
        _playControl.delegate = self;
    }
    return _playControl;
}
- (void)layoutSubviews
{
    XXLog(@"layoutSubviews");
    [_videoPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_playControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
#pragma mark - public methods
- (void)zz_playWithModel:(ZZPlayModel *)playModel
{
    [_playControl loadControlWithModel:playModel];
    _vlcPlayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:playModel.live]];
    if(_vlcPlayer.isPlaying){
        [_vlcPlayer pause];
    }
    [_vlcPlayer play];
}
- (void)zz_playWithURL:(NSString *)URLString
{
    _vlcPlayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:URLString]];
    if(_vlcPlayer.isPlaying){
        [_vlcPlayer pause];
    }
    [_vlcPlayer play];
}
#pragma mark - private methods
- (void)play
{
    [_vlcPlayer play];
}
- (void)jumpToPosition:(float)position
{
    if(_vlcPlayer.isSeekable){
        [_vlcPlayer setPosition:position];
        [self play];
    }
}
- (void)pause
{
    [_vlcPlayer pause];
}
- (void)stop
{
    [_vlcPlayer stop];
}

#pragma mark - ZZMediaPalyerControlDelegate
- (void)playControlButtonEventCallBack:(UIButton *)sender tag:(NSInteger)tag
{
    switch (tag) {
        case 501://播放/暂停
        {
            if(sender.selected){
                [self pause];
            }else{
                [self play];
            }
            sender.selected = !sender.selected;
        }
            break;
            case 502: //缩放
        {
            if(sender.selected){
                NSLog(@"小屏");
            }else{
                NSLog(@"全屏");
            }
            sender.selected = !sender.selected;
        }
            break;
        default:
            break;
    }
    if([self.delegate respondsToSelector:@selector(zz_mediaPlayerEventClick:sender:)]){
        [self.delegate zz_mediaPlayerEventClick:tag sender:sender];
    }
}
- (void)playControlSliderValueChanged:(UISlider *)slider event:(UITouchPhase)event
{
    if(event == UITouchPhaseMoved){
        if(_vlcPlayer.isPlaying){
            [self pause];
        }
    }else if(event == UITouchPhaseEnded){
        [self jumpToPosition:slider.value/slider.maximumValue];
    }
}
#pragma mark - VLCMediaPlayerDelegate
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    NSLog(@"state: %@",VLCMediaPlayerStateToString(_vlcPlayer.state));
    switch (_vlcPlayer.state) {
            case VLCMediaPlayerStatePlaying:
            {
                //播放
                [self.playControl changedPlayingState:YES];
            }
            break;
            case VLCMediaPlayerStateBuffering:
            {
                //加载中...
                [self.playControl changedPlayingState:YES];
            }
            break;
            case VLCMediaPlayerStatePaused:
            {
                [self.playControl changedPlayingState:NO];
            }
            break;
            case VLCMediaPlayerStateError:
            {
                [self.playControl changedPlayingState:NO];
            }
            break;
            case VLCMediaPlayerStateESAdded:
            {
                
            }
            break;
        default:
            break;
    }
}
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification
{
    VLCMediaPlayer *currentPlayer = (VLCMediaPlayer *)aNotification.object;
    [self.playControl reloadTimeSliderWithPlayer:currentPlayer];
}
- (void)mediaPlayerTitleChanged:(NSNotification *)aNotification
{
//    NSLog(@"%s:\nname:%@\nuserInfo:%@\nobject:%@\n",__func__,aNotification.name,aNotification.userInfo,aNotification.object);
}
- (void)dealloc
{
    [_vlcPlayer stop];
    NSLog(@"\n%s dealloc",__func__);
}
@end
