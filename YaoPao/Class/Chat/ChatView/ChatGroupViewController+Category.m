//
//  ChatViewController+Category.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 1/21/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "ChatGroupViewController+Category.h"

@implementation ChatGroupViewController (Category)
- (void)registerBecomeActive{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)didBecomeActive{
    [self reloadData];
}

@end
