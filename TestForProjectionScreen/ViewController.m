//
//  ViewController.m
//  TestForProjectionScreen
//
//  Created by Shane on 2020/5/20.
//  Copyright © 2020 Shane. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()<AVRoutePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *startDLNAButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
#if 0
        NSArray *arrTemp = pickerView.subviews;
        for (UIView *view in arrTemp) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                [button.layer removeAllAnimations];
            }
        }
#endif
        pickerView.frame = self.startDLNAButton.bounds;
        pickerView.delegate = self;
        [self.startDLNAButton addSubview:pickerView];
    } else {
        
    }

    [self.playerView insertSubview:self.shadowImageView atIndex:self.playerView.subviews.count];
    [self.playerView insertSubview:self.startDLNAButton aboveSubview:self.shadowImageView];
    
    [self addNotification];
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

#pragma mark - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
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


@end
