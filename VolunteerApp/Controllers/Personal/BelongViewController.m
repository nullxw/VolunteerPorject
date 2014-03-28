//
//  BelongViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-29.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "BelongViewController.h"
#import "AreaViewController.h"
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
    
    [self setTitleWithString:@"选择归属地"];
    // Do any additional setup after loading the view from its nib.
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    
    list = @[@"地市",@"行业",@"高校"];
    
    
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
//        cell.backgroundColor = [UIColor clearColor];
        
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
    
    AreaViewController *vc = [AreaViewController ViewContorller];
    vc.type = indexPath.row;
    [self.flipboardNavigationController pushViewController:vc];
    
    
}

@end
