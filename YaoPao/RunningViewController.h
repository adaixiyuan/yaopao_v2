//
//  RunningViewController.h
//  AssistUI
//
//  Created by 张驰 on 15/3/14.
//  Copyright (c) 2015年 张驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSliderView.h"
#import "CNCustomButton.h"
@class CNOverlayViewController;
@class CircleView;

@interface RunningViewController : UIViewController<MBSliderViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label_dis_big;
@property (weak, nonatomic) IBOutlet UILabel *label_during_big;
@property (weak, nonatomic) IBOutlet UILabel *label_during_small;
@property (weak, nonatomic) IBOutlet UILabel *label_dis_small;
@property (weak, nonatomic) IBOutlet UILabel *label_secondPerKm;
@property (weak, nonatomic) IBOutlet CircleView *view_circle;
@property (weak, nonatomic) IBOutlet UIImageView *image_gps1;
@property (weak, nonatomic) IBOutlet UIImageView *image_gps2;
@property (weak, nonatomic) IBOutlet UIImageView *image_gps3;
@property (weak, nonatomic) IBOutlet UIImageView *image_gps4;

@property (strong, nonatomic) IBOutlet MBSliderView *sliderview;
@property (strong, nonatomic) IBOutlet UIView *view_bottom_bar;
@property (strong, nonatomic) IBOutlet CNCustomButton *button_complete;
@property (strong, nonatomic) IBOutlet CNCustomButton *button_reset;

@property (strong, nonatomic) IBOutlet UILabel *label_dis;
@property (strong, nonatomic) IBOutlet UILabel *label_time;
@property (strong, nonatomic) IBOutlet UIView *view_bottom_slider;
@property (strong, nonatomic) NSTimer* timer_dispalyTime;


@property (assign, nonatomic) double distance_add;//用于计算积分
@property (assign, nonatomic) int second_add;//用户计算积分

@property (assign , nonatomic) int pass_km;//刚刚过的km
@property (assign, nonatomic) BOOL playkm;//是否播放过整公里
@property (assign, nonatomic) BOOL reachTarget;//是否达到目标
@property (assign, nonatomic) BOOL playTarget;//是否播报过达到目标
@property (assign, nonatomic) BOOL reachHalf;//是否达到一半
@property (assign, nonatomic) BOOL playHalf;//是否播报过一半
@property (assign, nonatomic) BOOL closeToTarget;//接近目标

@property (assign, nonatomic) int pass_5munite;//刚过的第几个5分钟
@property (assign, nonatomic) BOOL play5munite;//是否播放过整5分钟

@property (strong, nonatomic) UIImagePickerController* cameraPicker;
@property (strong, nonatomic) CNOverlayViewController* overlayVC;

- (IBAction)button_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_middle;
@property (weak, nonatomic) IBOutlet UIButton *button_takephoto;
@property (weak, nonatomic) IBOutlet UIButton *button_map;

@end
