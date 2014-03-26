//
//  EditInfoViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-26.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "EditInfoViewController.h"
#import "EditCell.h"
@interface EditInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
}
@end

@implementation EditInfoViewController

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
    [self setTitleWithString:@"编辑资料"];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.list count]>0) {
        int row = indexPath.row;
        if (row) {
            
        }
        EditCell *cell = [EditCell cellForTableView:tableView fromNib:[EditCell nib]];
        
        
        return cell;
    }
    return nil;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count]-3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
    if (row == 1) {

    }
    if (row>=4) {
        return;
    }
    
}
@end
