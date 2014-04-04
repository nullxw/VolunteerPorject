//
//  BelongViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-29.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "BelongViewController.h"
#import "AreaViewController.h"
#import "UrlDefine.h"
@interface BelongViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    
    NSArray     *list;
}
@end

@implementation BelongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleWithString:@"选择归属单位"];
    // Do any additional setup after loading the view from its nib.
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
//    广东省青年志愿者协会 district_id:402800e2446cffd501447154ac31000b
    
    list = @[@"地市",@"行业",@"高校",@"广东省青年志愿者协会"];
    
    
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
    cell.textLabel.text = list[indexPath.row];
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
    
    if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        global_districtName = @"广东省青年志愿者协会";
        global_districtId = @"402800e2446cffd501447154ac31000b";
        
        [self.flipboardNavigationController popViewController];
        
    }else{
        AreaViewController *vc = [AreaViewController ViewContorller];
        vc.type = indexPath.row;
        [self.flipboardNavigationController pushViewController:vc];
    }

    
    
}

@end
