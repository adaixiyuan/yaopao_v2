//
//  FriendDetailFromChatViewController.m
//  YaoPao
//
//  Created by 张驰 on 15/4/18.
//  Copyright (c) 2015年 张 驰. All rights reserved.
//

#import "FriendDetailFromChatViewController.h"
#import "FriendInfo.h"
#import "ASIHTTPRequest.h"

@interface FriendDetailFromChatViewController ()

@end

@implementation FriendDetailFromChatViewController
@synthesize friend;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    if(self.friend.avatarUrlInYaoPao != nil && ![self.friend.avatarUrlInYaoPao isEqualToString:@""]){//有头像url
        NSString* fullurl = [NSString stringWithFormat:@"%@%@",kApp.imageurl,self.friend.avatarUrlInYaoPao];
        __block UIImage* image = [kApp.avatarDic objectForKey:fullurl];
        if(image != nil){//缓存中有
            NSLog(@"缓存中有");
            self.imageview_avatar.image = image;
        }else{//下载
            NSURL *url = [NSURL URLWithString:fullurl];
            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setCompletionBlock :^{
                image = [[UIImage alloc] initWithData:[request responseData]];
                if(image != nil){
                    self.imageview_avatar.image = image;
                    [kApp.avatarDic setObject:image forKey:fullurl];
                }
            }];
            [request startAsynchronous ];
        }
    }
    self.label_name.text =  friend.nameInYaoPao;
    self.label_phone.text = friend.phoneNO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)button_clicked:(id)sender {
    switch ([sender tag]) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:
        {
            NSLog(@"清空聊天记录");
            
        }
        default:
            break;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
