//
//  NewFriendsTableViewCell.m
//  YaoPao
//
//  Created by 张驰 on 15/4/14.
//  Copyright (c) 2015年 张 驰. All rights reserved.
//

#import "NewFriendsTableViewCell.h"

@implementation NewFriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imageview_avatar.layer.cornerRadius = self.imageview_avatar.bounds.size.width/2;
    self.imageview_avatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
