//
//  ZZMediaPalyerControl.m
//  Wonderful_iOS
//
//  Created by 泽泽 on 2019/8/9.
//  Copyright © 2019 泽泽. All rights reserved.
//

#define TOOL_HEIGHT 40.0f

#import "ZZMediaPalyerControl.h"
@interface ZZMediaPalyerControl ()
{
    CGRect _frame;
    UIView *_navView;               //导航栏
    UILabel *_titleLabel;           //标题
    UIButton *_backButton;          //返回按钮
    UIView *_toolView;              //工具栏
    UIButton *_playButton;          //播放按钮
    UILabel *_leftTimeLabel;        //已完成时间
    UISlider *_timeSlider;          //进度条
    UILabel *_rightTimeLabel;       //总时长
    UIButton *_changeScreenBtn;     //屏幕缩放
    
    UILabel *_caseBoardLabel;       //实时直播显示label
}
@end
@implementation ZZMediaPalyerControl

- (instancetype)init
{
    if(self == [super init]){
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    //导航
    _navView = [[UIView alloc]init];
    _navView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.5];
    [self addSubview:_navView];
    //返回按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.tag = 500;
    [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_backButton];
    //标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = 1;
    _titleLabel.text = @"标题";
    [_navView addSubview:_titleLabel];
    //工具条
    _toolView = [[UIView alloc]init];
    _toolView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.5];
    [self addSubview:_toolView];
    //播放按钮
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    _playButton.tag = 501;
    [_playButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_playButton];
    //leftTime
    _leftTimeLabel = [[UILabel alloc]init];
    _leftTimeLabel.font = [UIFont systemFontOfSize:11];
    _leftTimeLabel.text = @"00:00:00";
    _leftTimeLabel.textColor = [UIColor whiteColor];
    _leftTimeLabel.textAlignment = 1;
    [_toolView addSubview:_leftTimeLabel];
    //全屏/小屏
    _changeScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeScreenBtn setImage:[UIImage imageNamed:@"full_screen"] forState:UIControlStateNormal];
    [_changeScreenBtn setImage:[UIImage imageNamed:@"small_screen"] forState:UIControlStateSelected];
    _changeScreenBtn.tag = 502;
    [_changeScreenBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_changeScreenBtn];
    //rightTime
    _rightTimeLabel = [[UILabel alloc]init];
    _rightTimeLabel.font = [UIFont systemFontOfSize:11];
    _rightTimeLabel.text = @"00:00:00";
    _rightTimeLabel.textColor = [UIColor whiteColor];
    _rightTimeLabel.textAlignment = 1;
    [_toolView addSubview:_rightTimeLabel];
    //进度条 10 + 24 + 5 + 36 + 5 <---->  5 + 36 + 5 + 24 + 10
    _timeSlider = [[UISlider alloc]init];
    _timeSlider.tag = 503;
    _timeSlider.minimumValue = 0;
    _timeSlider.maximumValue = 1;
    [_timeSlider setThumbImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [_timeSlider addTarget:self action:@selector(onSliderValueChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    [_toolView addSubview:_timeSlider];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

#pragma mark - tap点击
- (void)tapClick
{
    
}

#pragma mark - 处理点击事件
- (void)onClick:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(playControlButtonEventCallBack:tag:)]){
        [self.delegate playControlButtonEventCallBack:sender tag:sender.tag];
    }
}
- (void)onSliderValueChanged:(UISlider *)slider forEvent:(UIEvent *)event
{
    UITouch *touchEvent = [[event allTouches]anyObject];
    if([self.delegate respondsToSelector:@selector(playControlSliderValueChanged:event:)]){
        [self.delegate playControlSliderValueChanged:slider event:touchEvent.phase];
    }
    if(touchEvent.phase == UITouchPhaseMoved){
//        NSLog(@"正在拖动 %.0f",slider.value);
        VLCTime *currentTime = [VLCTime timeWithNumber:[NSNumber numberWithFloat:slider.value]];
        _leftTimeLabel.text = [NSString stringWithFormat:@"%@",currentTime.stringValue];
    }else if (touchEvent.phase == UITouchPhaseEnded){
//        NSLog(@"拖动结束 %.0f",slider.value);
    }
}
#pragma mark - 刷新数据
- (void)loadControlWithModel:(ZZPlayModel *)playModel
{
    if([playModel.live hasPrefix:@"rtmp"]||[playModel.live hasSuffix:@"m3u8"]||[playModel.live hasSuffix:@"flv"]){
        //实时直播
        
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@",playModel.group_title];
}

- (void)changedPlayingState:(BOOL)state
{
    if(state){
        _playButton.selected = YES;
    }else{
        _playButton.selected = NO;
    }
}
- (void)reloadTimeSliderWithPlayer:(VLCMediaPlayer *)player
{
//    NSLog(@"vlcmedia == %d",);
    int totalTime = player.media.length.intValue;
    int currentTime = player.time.intValue;
    _timeSlider.maximumValue = (float)totalTime;
    _timeSlider.value = (float)currentTime;
    _leftTimeLabel.text = [NSString stringWithFormat:@"%@",player.time.stringValue];
    _rightTimeLabel.text = [NSString stringWithFormat:@"%@",player.media.length];
//    NSLog(@"\ntime:%@ \nremaining:%@",player.time,player.remainingTime);
}

- (void)layoutSubviews
{
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(TOOL_HEIGHT);
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self->_navView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self->_navView.mas_centerX);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(TOOL_HEIGHT);
        make.width.mas_equalTo(150);
    }];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(TOOL_HEIGHT);
    }];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self->_toolView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [_leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_playButton.mas_right).offset(10);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(TOOL_HEIGHT);
    }];
    [_changeScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self->_toolView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [_rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self->_changeScreenBtn.mas_left).offset(-10);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(TOOL_HEIGHT);
    }];
    [_timeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_leftTimeLabel.mas_right).offset(10);
        make.right.mas_equalTo(self->_rightTimeLabel.mas_left).offset(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(TOOL_HEIGHT);
    }];
}

@end
