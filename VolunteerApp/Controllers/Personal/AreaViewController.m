//
//  AreaViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-29.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "AreaViewController.h"
#import "DistrictModel.h"
#import "UrlDefine.h"
@interface AreaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
    
    NSMutableArray *list;
    
    UITableViewCell *curCell;
    
    NSString  *tempDistrctId;
}
@end

@implementation AreaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleWithString:@"请选择"];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    list = [[NSMutableArray alloc]init];
    
    [self requestData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    
    if (list.count >0) {
        static NSString *cellIdentify = @"cellIdentify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            //create cell
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];

            
        }
        DistrictModel *info = list[indexPath.row];
        cell.textLabel.text = info.districtName;
        return cell;
    }

    return nil;
    
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

    if (list.count == 0) {
        return;
    }
    if (curCell) {
        curCell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    curCell = cell;
    
    DistrictModel *info = list[indexPath.row];
    
    global_districtId = [NSString stringWithString:info.districtId];
    global_districtName = [NSString stringWithString:info.districtName];
    
    
    BaseViewController *vc = [self.flipboardNavigationController.viewControllers objectAtIndex:self.flipboardNavigationController.viewControllers.count-2];
    
    [self.flipboardNavigationController popViewControllerWithCompletion:^{
        [vc.flipboardNavigationController popViewController];
    }];
    

//    [self.flipboardNavigationController popViewControllerAfterDelay:1.0f];
}

- (void)requestData
{
    [[ZZLHttpRequstEngine engine] requestGetCityListWithDistrictid:@"" type:self.type pageSize:100 pageIndex:1 onSuccess:^(id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        for (NSMutableDictionary *dic in array) {
            [list addObject:[DistrictModel JsonModalWithDictionary:dic]];
        }
        [myTableView reloadData];
        
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:@"城市列表获取失败"];
        NSLog(@"citylist error:%@",[erro.userInfo objectForKey:@"description"]);
    }];
}
@end
