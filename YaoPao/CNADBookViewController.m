//
//  CNADBookViewController.m
//  YaoPao
//
//  Created by 张驰 on 15/4/9.
//  Copyright (c) 2015年 张 驰. All rights reserved.
//

#import "CNADBookViewController.h"
#import "GetFirstLetter.h"
#import "IntroduceFriendsTableViewCellCondition1.h"
#import "IntroduceFriendsTableViewCellCondition3.h"
#import "IntroduceFriendsTableViewCellCondition4.h"
#import "NewFriendsViewController.h"
#import "FriendInfo.h"
#import "NewFriendsTableViewCell.h"
#import "FriendDetailViewController.h"
#import "CNGroupInfo.h"
#import "ChatGroupViewController.h"
#import "FriendsHandler.h"

@interface CNADBookViewController ()

@end

@implementation CNADBookViewController
@synthesize keys;
@synthesize groupedMap;
@synthesize keysJustFriend;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableview.sectionIndexBackgroundColor = [UIColor clearColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(kApp.friendHandler.friendList1NeedRefresh){
        NSLog(@"需要刷新好友列表1");
        //获取好友列表
        [self displayLoading];
        kApp.friendHandler.delegete_requestFriends = self;
        [kApp.friendHandler dorequest];
    }else{
        NSLog(@"不需要刷新好友列表1");
        [self initKeys];
    }
}
- (void)initKeys{
    self.keys = [[NSMutableArray alloc]init];
    self.groupedMap = [[NSMutableDictionary alloc]init];
    self.keysJustFriend = [[NSMutableArray alloc]init];
    for (FriendInfo* friend in kApp.friendHandler.friends)
    {
        NSString* name = friend.nameInYaoPao;
        char c = [GetFirstLetter  pinyinFirstLetter:([name characterAtIndex:0])];
        NSString* oneKey = [[NSString stringWithFormat:@"%c",c] uppercaseString];
        
        /*
         对 ”长“ 进行特殊处理
         直接归属为C
         */
//        if (nil != oneObjStreetInfo.str_imgname && ![oneObjStreetInfo.str_imgname isEqualToString:@""])
//        {
//            NSString* str_firstChar = [oneObjStreetInfo.str_imgname substringToIndex:1];
//            
//            if ([str_firstChar isEqualToString:@"长"])
//            {
//                oneKey = @"C";
//            }
//            if ([str_firstChar isEqualToString:@"重"])
//            {
//                oneKey = @"C";
//            }
//        }
        NSMutableArray* nameStartWithSameLetter = [self.groupedMap valueForKey:oneKey];
        if (nameStartWithSameLetter == nil)
        {
            [self.keysJustFriend addObject:oneKey];
            nameStartWithSameLetter = [[NSMutableArray alloc]init];
        }
        [nameStartWithSameLetter addObject:friend];
        [self.groupedMap setValue:nameStartWithSameLetter forKey:oneKey];
    }
    //在dic里加上跑团的信息
    [self.groupedMap setValue:kApp.friendHandler.myGroups forKey:@"跑团"];
    
    self.keys = [[NSMutableArray alloc]init];
    [self.keys addObject:@"推荐好友"];
    if([kApp.friendHandler.myGroups count]>0){
        [self.keys addObject:@"跑团"];
    }
    [self.keys addObjectsFromArray:[self.keysJustFriend sortedArrayUsingSelector:@selector(compare:)]];
    [self.tableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keys count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){//第一行
        return 1;
    }else{
        return [[self.groupedMap objectForKey:[self.keys objectAtIndex:section]] count];
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc]init];
    customView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 22)];
    headerLabel.textColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1];
    [headerLabel setFont:[UIFont systemFontOfSize:12]];
    if(section == 0){//第一行
        headerLabel.text = @"好友推荐";
    }else{
        headerLabel.text = [self.keys objectAtIndex:section];
    }
    [customView addSubview:headerLabel];
    return customView;
}
- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    if(self.keys == nil||[self.keys count]<1){
//        return nil;
//    }
    return self.keysJustFriend;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if(section == 0){//第一行
        int condition = 2;
        NSInteger suggestFriendCount = [kApp.friendHandler.myContactUseAppButNotFriend count];//推荐的好友数（手机里使用app的人-其中已经是好友的人）
        if([kApp.friendHandler.frinedsWantMe count]>0){//有验证的好友
            condition = 1;
        }else{//没有验证的好友
            if(suggestFriendCount == 0){//没有推荐好友
                condition = 2;
            }else{//有推荐好友
                if(suggestFriendCount == 1){//只有一个
                    condition = 3;
                }else{
                    condition = 4;
                }
            }
        }
        int displayNum = [kApp.friendHandler.friendsNew count];
        switch (condition) {
            case 1:
            {
                IntroduceFriendsTableViewCellCondition1 *cell = [[[NSBundle mainBundle] loadNibNamed:@"IntroduceFriendsTableViewCellCondition1" owner:self options:nil] lastObject];
                FriendInfo* friend = [kApp.friendHandler.frinedsWantMe firstObject];
                cell.label_name.text = friend.nameInYaoPao;
                if(kApp.friendHandler.haveNewFriends){
                    cell.button_num.hidden = NO;
                    [cell.button_num setTitle:[NSString stringWithFormat:@"%i",displayNum] forState:UIControlStateNormal] ;
                }else{
                    cell.button_num.hidden = YES;
                }
                
                if(friend.avatarUrlInYaoPao != nil && ![friend.avatarUrlInYaoPao isEqualToString:@""]){//有头像url
                    NSString* fullurl = [NSString stringWithFormat:@"%@%@",kApp.imageurl,friend.avatarUrlInYaoPao];
                    __block UIImage* image = [kApp.avatarDic objectForKey:fullurl];
                    if(image != nil){//缓存中有
                        cell.imageview_avatar.image = image;
                    }else{//下载
                        NSURL *url = [NSURL URLWithString:fullurl];
                        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                        [request setCompletionBlock :^{
                            image = [[UIImage alloc] initWithData:[request responseData]];
                            if(image != nil){
                                cell.imageview_avatar.image = image;
                                [kApp.avatarDic setObject:image forKey:fullurl];
                            }
                        }];
                        [request startAsynchronous ];
                    }
                }
                return cell;
                break;
            }
            case 2:
            {
                IntroduceFriendsTableViewCellCondition3 *cell = [[[NSBundle mainBundle] loadNibNamed:@"IntroduceFriendsTableViewCellCondition3" owner:self options:nil] lastObject];
                cell.imageview_avatar.image = [UIImage imageNamed:@"avatar_default.png"];
                cell.label_name.text = @"添加好友";
                cell.button_num.hidden = YES;
                return cell;
                break;
            }
            case 3:
            {
                IntroduceFriendsTableViewCellCondition3 *cell = [[[NSBundle mainBundle] loadNibNamed:@"IntroduceFriendsTableViewCellCondition3" owner:self options:nil] lastObject];
                FriendInfo* friend = [kApp.friendHandler.myContactUseAppButNotFriend firstObject];
                cell.label_name.text = friend.nameInYaoPao;
                if(kApp.friendHandler.haveNewFriends){
                    cell.button_num.hidden = NO;
                    [cell.button_num setTitle:[NSString stringWithFormat:@"%i",displayNum] forState:UIControlStateNormal];
                }else{
                    cell.button_num.hidden = YES;
                }
                if(friend.avatarUrlInYaoPao != nil && ![friend.avatarUrlInYaoPao isEqualToString:@""]){//有头像url
                    NSString* fullurl = [NSString stringWithFormat:@"%@%@",kApp.imageurl,friend.avatarUrlInYaoPao];
                    __block UIImage* image = [kApp.avatarDic objectForKey:fullurl];
                    if(image != nil){//缓存中有
                        cell.imageview_avatar.image = image;
                    }else{//下载
                        NSURL *url = [NSURL URLWithString:fullurl];
                        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                        [request setCompletionBlock :^{
                            image = [[UIImage alloc] initWithData:[request responseData]];
                            if(image != nil){
                                cell.imageview_avatar.image = image;
                                [kApp.avatarDic setObject:image forKey:fullurl];
                            }
                        }];
                        [request startAsynchronous ];
                    }
                }
                return cell;
                break;
            }
            case 4:
            {
                IntroduceFriendsTableViewCellCondition4 *cell = [[[NSBundle mainBundle] loadNibNamed:@"IntroduceFriendsTableViewCellCondition4" owner:self options:nil] lastObject];
                NSArray* arraytemp = [[NSArray alloc]initWithObjects:cell.imageview1,cell.imageview2,cell.imageview3,cell.imageview4, nil];
                int i = 0;
                for(i=0;i<4;i++){
                    if(i == [kApp.friendHandler.myContactUseAppButNotFriend count]){
                        break;
                    }
                    FriendInfo* friend = [kApp.friendHandler.myContactUseAppButNotFriend objectAtIndex:i];
                    if(friend.avatarUrlInYaoPao != nil && ![friend.avatarUrlInYaoPao isEqualToString:@""]){//有头像url
                        NSString* fullurl = [NSString stringWithFormat:@"%@%@",kApp.imageurl,friend.avatarUrlInYaoPao];
                        __block UIImage* image = [kApp.avatarDic objectForKey:fullurl];
                        if(image != nil){//缓存中有
                            ((UIImageView*)[arraytemp objectAtIndex:i]).image = image;
                        }else{//下载
                            NSURL *url = [NSURL URLWithString:fullurl];
                            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                            [request setCompletionBlock :^{
                                image = [[UIImage alloc] initWithData:[request responseData]];
                                if(image != nil){
                                    ((UIImageView*)[arraytemp objectAtIndex:i]).image = image;
                                    [kApp.avatarDic setObject:image forKey:fullurl];
                                }
                            }];
                            [request startAsynchronous ];
                        }
                    }
                }
                if(kApp.friendHandler.haveNewFriends){
                    cell.label_num.hidden = NO;
                    cell.label_num.text = [NSString stringWithFormat:@"%i",displayNum];
                }else{
                    cell.label_num.hidden = YES;
                }
                return cell;
                break;
            }
                
            default:
                return nil;
        }
        
    }else if(section == 1){//跑团
        NSString* key = [self.keys objectAtIndex:section];
        static NSString *CellIdentifier = @"NewFriendsTableViewCell";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([NewFriendsTableViewCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            nibsRegistered = YES;
        }
        CNGroupInfo* group = [[groupedMap objectForKey:key]objectAtIndex:row];
        NewFriendsTableViewCell *cell = (NewFriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.label_username.text = group.groupName;
        cell.imageview_avatar.image = [UIImage imageNamed:@"group_avatar_default.png"];
        cell.button_action.hidden = YES;
        return cell;
    }else{
        NSString* key = [self.keys objectAtIndex:section];
        static NSString *CellIdentifier = @"NewFriendsTableViewCell";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([NewFriendsTableViewCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            nibsRegistered = YES;
        }
        FriendInfo* friend = [[groupedMap objectForKey:key]objectAtIndex:row];
        NewFriendsTableViewCell *cell = (NewFriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.label_username.text = friend.nameInYaoPao;
        if(friend.avatarUrlInYaoPao != nil && ![friend.avatarUrlInYaoPao isEqualToString:@""]){//有头像url
            NSString* fullurl = [NSString stringWithFormat:@"%@%@",kApp.imageurl,friend.avatarUrlInYaoPao];
            __block UIImage* image = [kApp.avatarDic objectForKey:fullurl];
            if(image != nil){//缓存中有
                cell.imageview_avatar.image = image;
            }else{//下载
                NSURL *url = [NSURL URLWithString:fullurl];
                __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                [request setCompletionBlock :^{
                    image = [[UIImage alloc] initWithData:[request responseData]];
                    if(image != nil){
                        cell.imageview_avatar.image = image;
                        [kApp.avatarDic setObject:image forKey:fullurl];
                    }
                }];
                [request startAsynchronous ];
            }
        }else{
            cell.imageview_avatar.image = [UIImage imageNamed:@"avatar_default.png"];
        }
        cell.button_action.hidden = YES;
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    NSString* key = [self.keys objectAtIndex:section];
    if(section == 0){//点击推荐好友
        NewFriendsViewController* nfVC = [[NewFriendsViewController alloc]init];
        [self.navigationController pushViewController:nfVC animated:YES];
        [self writeNewFriendsStringToPlist];
    }else if(section == 1){//点击跑团
        CNGroupInfo* group = [kApp.friendHandler.myGroups objectAtIndex:row];
        ChatGroupViewController* chatController = [[ChatGroupViewController alloc] initWithChatter:group.groupId isGroup:YES];
        [self.navigationController pushViewController:chatController animated:YES];
    }else{
        FriendInfo* friend = [[groupedMap objectForKey:key]objectAtIndex:row];
        FriendDetailViewController* fdVC = [[FriendDetailViewController alloc]init];
        fdVC.friend = friend;
        [self.navigationController pushViewController:fdVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)friendsListDidFailed:(NSString *)mes{
    NSLog(@"请求好友列表失败，原因是%@",mes);
}
- (void)requestFriendsDidFailed{
    [self hideLoading];
}
- (void)requestFriendsDidSuccess{
    [self initKeys];
    [self hideLoading];
}


- (void)writeNewFriendsStringToPlist{
    NSString* filePath = [CNPersistenceHandler getDocument:@"newFriend.plist"];
    NSMutableDictionary* newFriendsDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    if(newFriendsDic == nil){//没有这个文件，说明第一次
        newFriendsDic = [[NSMutableDictionary alloc]init];
    }
    [newFriendsDic setObject:kApp.friendHandler.FriendNewString forKey:@"newFriends"];
    [newFriendsDic writeToFile:filePath atomically:YES];
}
- (IBAction)button_clicked:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        {
            NewFriendsViewController* nfVC = [[NewFriendsViewController alloc]init];
            [self.navigationController pushViewController:nfVC animated:YES];
            [self writeNewFriendsStringToPlist];
        }
        default:
            break;
    }
    
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
}
@end
