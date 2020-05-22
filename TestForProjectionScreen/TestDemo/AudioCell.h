//
//  AudioCell.h
//  TestForProjectionScreen
//
//  Created by Shane on 2020/5/21.
//  Copyright © 2020 Shane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioCellDelegate <NSObject>

- (void)audioCell:(UITableViewCell *)cell sliderTouchDown:(UISlider *)slider;
- (void)audioCell:(UITableViewCell *)cell sliderValueChanged:(UISlider *)slider;
- (void)audioCell:(UITableViewCell *)cell sliderTOuchEnd:(UISlider *)slider;

@end

@interface AudioCell : UITableViewCell

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, weak) id<AudioCellDelegate> delegate;

- (void)reloadAudioPlayer:(AVAudioPlayer *)player;
- (void)reloadTitle:(NSString *)title;
- (CGFloat)getCurrentAudioVolume;

@end

NS_ASSUME_NONNULL_END
