//
//  AudioController.m
//  TestForProjectionScreen
//
//  Created by Shane on 2020/5/21.
//  Copyright © 2020 Shane. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "AudioController.h"

#import "AudioCell.h"

@interface AudioController ()<UITableViewDelegate, UITableViewDataSource, AudioCellDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UITableView *contentView;

@end

@implementation AudioController
{
    NSArray *_arrTitles;
    NSArray *_arrAudioURL;
    NSMutableArray *_arrAudioPlayers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    [self.contentView registerNib:[UINib nibWithNibName:NSStringFromClass([AudioCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AudioCell class])];
    [self.view addSubview:self.contentView];
    
    _arrTitles = @[@"ocean", @"rain"];
    NSURL *oceanURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"25-Ocean-10min" ofType:@"mp3"]];
    NSURL *rainURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"42-Rain-10min" ofType:@"mp3"]];
    _arrAudioURL = @[oceanURL, rainURL];
    _arrAudioPlayers = [NSMutableArray arrayWithCapacity:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioCell *cell = (AudioCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AudioCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell reloadTitle:_arrTitles[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioCell *cell = (AudioCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    if (!cell.audioPlayer) {
        NSURL *audioURL = _arrAudioURL[indexPath.row];
        NSError *audioErr ;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&audioErr];
        if (audioPlayer) {
            [_arrAudioPlayers addObject:audioPlayer];
            [cell reloadAudioPlayer:audioPlayer];
            [audioPlayer play];
            audioPlayer.volume = [cell getCurrentAudioVolume];
        }
    }
}

#pragma mark - <AudioCellDelegate>
- (void)audioCell:(AudioCell *)cell sliderTouchDown:(UISlider *)slider {
    
}

- (void)audioCell:(AudioCell *)cell sliderValueChanged:(UISlider *)slider {
    
}

- (void)audioCell:(AudioCell *)cell sliderTOuchEnd:(UISlider *)slider {
    
}

@end
