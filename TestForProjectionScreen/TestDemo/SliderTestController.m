//
//  SliderTestController.m
//  TestForProjectionScreen
//
//  Created by Shane on 2020/5/22.
//  Copyright © 2020 Shane. All rights reserved.
//

#import "SliderTestController.h"

@interface SliderTestController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation SliderTestController
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 10000;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    CGFloat roundedValue = round(sender.value / 5) * 5;
    self.titleLabel.text = [NSString stringWithFormat:@"%.f", roundedValue];
}

@end
