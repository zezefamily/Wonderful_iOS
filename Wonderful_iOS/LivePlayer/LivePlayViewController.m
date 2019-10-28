
//
//  LivePlayViewController.m
//  Wonderful_iOS
//
//  Created by 泽泽 on 2019/8/8.
//  Copyright © 2019 泽泽. All rights reserved.
// http://streams.videolan.org/
// http://streams.videolan.org/streams/mp4/DCSHOESTheTrase-DASH.mp4
// http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4
// http://ivi.bupt.edu.cn/hls/chchd.m3u8
// 列表地址
// https://codeload.github.com/zezefamily/playlist/zip/master
#define VIDEO_URL @"http://ivi.bupt.edu.cn/hls/chchd.m3u8"

#import "LivePlayViewController.h"
#import "ZZMediaPlayer.h"
#import "ZZPlayModel.h"
#import "MJExtension.h"
@interface LivePlayViewController ()<ZZMediaPlayerDelegate,VLCMediaPlayerDelegate, VLCMediaThumbnailerDelegate, VLCMediaDelegate>
{
    BOOL _isFullScreen;
    UIImageView *_imageView;
}
//@property (nonatomic,strong) VLCMediaPlayer *mediaplayer;
@property (nonatomic,strong) UIView *videoView;
@property (nonatomic,strong) ZZMediaPlayer *mediaPlayer;  //播放器
@property (nonatomic,strong) VLCMediaThumbnailer *thumbnailer; //缩略图
@end

@implementation LivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    //获取视频流缩略图
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, 400, 300)];
    _imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_imageView];
    [self getThumbnailer];
}
- (void)getThumbnailer
{
    VLCLibrary *sharedLibrary = [VLCLibrary sharedLibrary];
    sharedLibrary.debugLogging = YES;
    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:self.liveData.live]];
    media.delegate = self;
    VLCMediaThumbnailer *thumbnailer = [VLCMediaThumbnailer thumbnailerWithMedia:media delegate:self andVLCLibrary:[VLCLibrary sharedLibrary]];
    [thumbnailer fetchThumbnail];
}
- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, mediaThumbnailer);
}
- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, mediaThumbnailer);
    _imageView.image = [UIImage imageWithCGImage:thumbnail];
}

- (ZZMediaPlayer *)mediaPlayer
{
    if(!_mediaPlayer){
        _mediaPlayer = [[ZZMediaPlayer alloc]init];
        _mediaPlayer.delegate = self;
    }
    return _mediaPlayer;
}
#pragma marl - ZZMediaPlayerDelegate
- (void)zz_mediaPlayerEventClick:(NSInteger)tag sender:(UIButton *)sender
{
    if(tag == 500){
        if(_isFullScreen == YES){
            [[UIDevice currentDevice]setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
            _isFullScreen = NO;
            return;
        }
        [self backVC];
    }else if (tag == 502){
        if(sender.selected){
            [[UIDevice currentDevice]setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
            _isFullScreen = YES;
        }else{
            [[UIDevice currentDevice]setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
            _isFullScreen = NO;
        }
    }
}
- (void)viewDidLayoutSubviews
{
    XXLog(@"viewDidLayoutSubviews");
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:case UIInterfaceOrientationPortraitUpsideDown:
        {
            XXLog(@"viewDidLayoutSubviews small screen");
            [_mediaPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(44);
                make.right.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 0.75));
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:case UIInterfaceOrientationLandscapeRight:
        {
            XXLog(@"viewDidLayoutSubviews full screen");
            [_mediaPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(44);
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(-34);
                make.bottom.mas_equalTo(0);
            }];
        }
            break;
        default:
            break;
    }
}
- (void)loadUI
{
    _isFullScreen = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mediaPlayer];
//    ZZPlayModel *playModel = [ZZPlayModel mj_objectWithKeyValues:self.liveData];
//    [self.mediaPlayer zz_playWithURL:VIDEO_URL];
    [self.mediaPlayer zz_playWithModel:self.liveData];
}
- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    NSLog(@"--dealloc-- %s",__func__);
}
@end
