//
//  ViewController.m
//  VideoLogin Demo
//
//  Created by linchao on 16/3/13.
//  Copyright © 2016年 LC. All rights reserved.
//

// 自定义参数宏 设置音量，按钮的圆角
const float PLAYER_VOLUME = 0.0;
const float BUTTON_PADDING = 20.0f;
const float BUTTON_CORNER_RADIUS = 8.0f;

#import "ViewController.h"
#import "VideoLoginView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UIAlertViewDelegate>
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *logInButton;
@property (nonatomic) UIButton *signUpButton;
@property (nonatomic) AVPlayer *player;
@property (weak, nonatomic) IBOutlet VideoLoginView *playerView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createVideoPlayer];
    [self createTitleLabel];
    [self createTwoButton];
    [self createShowAnim];
}

- (void)createShowAnim
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @0.0f;
    anim.toValue = @1.0f;
    anim.duration = 3.0f;
    for (UIView *subview in self.view.subviews) {
        if ([subview isEqual:self.playerView]) {
            continue;
        }
        [subview.layer addAnimation:anim forKey:@"alpha"];
    }
    
}

- (void)createVideoPlayer
{
    // 获取本地视频文件Ferrari
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TestVideo" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player.volume = PLAYER_VOLUME;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.playerView.layer addSublayer:playerLayer];
    
    [self.playerView setPlayer:self.player];
    [self.player play];
    
    [self.player.currentItem addObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

// 设置渐隐logo标示
- (void)createTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 80, 80)];
    self.titleLabel.center = self.view.center;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = @"Ferrari";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    self.titleLabel.font = [UIFont systemFontOfSize:72.0f];
    [self.view addSubview:self.titleLabel];
}

- (void)createTwoButton
{
    self.logInButton = [self createButtonWithTitle:@"Log in" index:0 action:@selector(loginClick)];
    self.signUpButton = [self createButtonWithTitle:@"Sign up" index:1 action:@selector(signupClick)];
    [self.view addSubview:self.logInButton];
    [self.view addSubview:self.signUpButton];
}

// 设置按钮初始状态
- (UIButton *)createButtonWithTitle:(NSString *)title index:(NSUInteger)index action:(SEL)action
{
    float screenWidth = self.view.frame.size.width;
    float screenHeight = self.view.frame.size.height;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(0, 0, (screenWidth - 3*BUTTON_PADDING) / 2, 30)];
    [button setCenter:CGPointMake((screenWidth / 4) + (index * screenWidth / 2), screenHeight - 30)];
    [button setTintColor:[UIColor whiteColor]];
    [button setBackgroundColor:[UIColor clearColor]];
    
    button.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    button.clipsToBounds = YES;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - observer of player
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}

- (void)moviePlayDidEnd:(NSNotification*)notification
{
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - button click 点击跳转
- (void)loginClick
{
    /* 登录页面*/
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Login" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:nil animated:YES];
    });
}

- (void)signupClick
{
    /* 注册页面*/
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"sign" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:nil animated:YES];
    });
}

// 销毁通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
