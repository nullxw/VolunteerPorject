//
//  OptionViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "OptionViewController.h"
#import "MyTableView.h"
#import "ProtypeInfo.h"
#import "ProjectSearchViewController.h"

@interface OptionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MyTableView *myTableView;
    NSMutableArray *list;
    
    int selectedRow;
}
@end

@implementation OptionViewController

#pragma mark - view Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleWithString:@"项目类型"];
    myTableView = [[MyTableView alloc]initWithFrame:CGRectMake(0, self.navView.height, self.view.width, self.view.height-self.navView.height) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;

    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:myTableView];
    
    list = [[NSMutableArray alloc]init];
    
    ProtypeInfo *all = [[ProtypeInfo alloc]init];
    all.typeName = @"全部";
    all.missionTypeId = -1;
    [list addObject:all];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestprotype];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        //create cell
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    
        
    }
    ProtypeInfo *info  = list[indexPath.row];
    cell.textLabel.text = info.typeName;
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedRow = indexPath.row;
    [self performSelector:@selector(backAction:) withObject:nil afterDelay:0.5];
    
    
}
- (void)backAction:(UIButton *)btn
{
    if ([list count]>0) {
        
        ProtypeInfo *temp= list[selectedRow];

        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Send_ProTYPE object:temp];
    }
    [self.flipboardNavigationController popViewControllerWithCompletion:^{
        
    }];
}
- (void)requestprotype
{

    [myTableView showLoadingView];
    [[ZZLHttpRequstEngine engine]requestSearchProjectTypeWithDistrictid:@"8e9715d3444dd11701444dd446fa0008" pageSize:100 pageIndex:1 onSuccess:^(id responseObject) {
        [myTableView removeCenterMsgView];
        [myTableView hideLoadingView];
        NSLog(@">>>>>%@",responseObject);
        NSArray *array = (NSArray *)responseObject;
        for (int i=0; i<[array count]; i++) {
            ProtypeInfo *info = [ProtypeInfo JsonModalWithDictionary:array[i]];
            [list addObject:info];
        }
        [myTableView reloadData];
        
    } onFail:^(NSError *erro) {
        NSLog(@"%@",[erro.userInfo objectForKey:@"description"]);
        [myTableView hideLoadingView];
        [myTableView addCenterMsgView:@"获取项目类型失败！"];
    }];
}
@end
