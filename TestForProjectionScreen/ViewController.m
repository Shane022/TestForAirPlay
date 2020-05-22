//
//  ViewController.m
//  TestForProjectionScreen
//
//  Created by Shane on 2020/5/20.
//  Copyright © 2020 Shane. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVFAudio.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "LoadingView.h"

@interface ViewController ()<AVRoutePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *startDLNAButton;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) LoadingView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubviews];
    [self addNotification];
}

- (void)setSubviews {
    /**
     http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8
     http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8
     https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8
     */
    NSURL *url = [NSURL URLWithString:@"http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8"];
    
    self.player = [AVPlayer playerWithURL:url];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.playerView.bounds;
    [self.playerView.layer insertSublayer:playerLayer atIndex:0];
    [self.player play];
    
    if (@available(iOS 11.0,*)) {
        AVRoutePickerView *pickerView = [[AVRoutePickerView alloc] init];
        pickerView.tintColor = [UIColor clearColor];
        
        NSArray *arrTemp = pickerView.subviews;
        for (UIView *view in arrTemp) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                button.alpha = 0;
                [button.layer removeAllAnimations];
            }
        }
        
        pickerView.frame = self.startDLNAButton.bounds;
        pickerView.delegate = self;
        [self.startDLNAButton addSubview:pickerView];
    } else {
        // TODO:
    }
    
    [self.playerView insertSubview:self.loadingView atIndex:self.playerView.subviews.count];
    [self handleLoadingView];
}

#pragma mark - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)screenDidConnect:(NSNotification *)noti {
    NSLog(@"-- %s", __func__);
}

- (void)screenDidDisconnect:(NSNotification *)noti {
    NSLog(@"-- %s", __func__);
}

- (void)audioSessionRouteChangeNotification:(NSNotification *)noti {
    [self handleLoadingView];
}

#pragma mark - <AVRoutePickerViewDelegate>
- (void)routePickerViewWillBeginPresentingRoutes:(AVRoutePickerView *)routePickerView {
    NSLog(@"-- %s", __func__);
}

- (void)routePickerViewDidEndPresentingRoutes:(AVRoutePickerView *)routePickerView {
    NSLog(@"-- %s", __func__);
}

#pragma mark - Action
- (IBAction)clickDLNAButton:(id)sender {
    
}

- (IBAction)changeToCCTV5:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}

- (IBAction)changeToCCTV6:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}

- (IBAction)changeToCCTV1:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}

#pragma mark - Private methods
- (NSString*)activeAirplayOutputRouteName
{
    /**
    遍历当前设备所有通道.返回isEqualToString:AVAudioSessionPortAirPlay通道的具体名称,
    如果名称不为nil则为当前连接到了AirPlay
    */
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription* currentRoute = audioSession.currentRoute;
    NSArray *arrTemp = currentRoute.outputs;
    for (AVAudioSessionPortDescription* outputPort in arrTemp){
        if ([outputPort.portType isEqualToString:AVAudioSessionPortAirPlay])
            return outputPort.portName;
    }
    
    return nil;
}

- (void)handleLoadingView {
    NSString *airplayDeviceName = [self activeAirplayOutputRouteName];
    BOOL isAirPlay = airplayDeviceName.length > 0;
    NSLog(@"-- %s - airPlayDeveiceName:%@ - %@", __func__, airplayDeviceName, isAirPlay ? @"YES" : @"NO");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadingView.alpha = isAirPlay ? 1 : 0;
    });
}

#pragma mark - Lazy load
- (LoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) / (16.0 / 9.0))];
        _loadingView.alpha = 0;
    }
    
    return _loadingView;
}

#pragma mark - Dealloc
- (void)dealloc {
    [self removeNotification];
    NSLog(@"%s", __func__);
}

@end
