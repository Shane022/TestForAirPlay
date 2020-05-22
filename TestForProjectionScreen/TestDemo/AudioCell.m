//
//  AudioCell.m
//  TestForProjectionScreen
//
//  Created by Shane on 2020/5/21.
//  Copyright © 2020 Shane. All rights reserved.
//

#import "AudioCell.h"

@interface AudioCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@end

@implementation AudioCell
{
    CGFloat _curVolume;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _curVolume = 0;
    [self setSelected:NO];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = [UIColor blackColor];
        self.volumeSlider.minimumTrackTintColor = [UIColor blackColor];
        self.volumeSlider.userInteractionEnabled = YES;
    } else {
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.volumeSlider.minimumTrackTintColor = [UIColor lightGrayColor];
        self.volumeSlider.userInteractionEnabled = NO;
        self.volumeSlider.value = 0;
    }
}

#pragma mark - Data
- (void)reloadAudioPlayer:(AVAudioPlayer *)player {
    if (self.audioPlayer || !player) {
        return;
    }
    self.audioPlayer = player;
}

- (void)reloadTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (CGFloat)getCurrentAudioVolume {
    return _curVolume;
}

#pragma mark - <AudioCellDelegate>
- (IBAction)sliderTouchDown:(UISlider *)sender {

}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (self.audioPlayer) {
        self.audioPlayer.volume = sender.value;
        _curVolume = sender.value;
    }
}

- (IBAction)sliderTouchEnd:(UISlider *)sender {

}

@end
