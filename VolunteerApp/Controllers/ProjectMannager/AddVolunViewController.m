//
//  AddVolunViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-19.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "AddVolunViewController.h"
#import "MyTableView.h"
#import "VolunteersCell.h"
@interface AddVolunViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,VolunteersCellDelegate>
{
    UIView *backvIEW;

    MyTableView *myTableView;
    
    NSMutableArray *list;
}
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@end

@implementation AddVolunViewController

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
    [self setTitleWithString:@"添加志愿者"];
    
    myTableView = [[MyTableView alloc]initWithFrame:CGRectMake(0, self.mSearchBar.bottom, self.view.width, self.view.height-self.mSearchBar.bottom) style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    list = [[NSMutableArray alloc]init];
    

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
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

    if (!backvIEW) {
        
        backvIEW = [[UIView alloc]initWithFrame:myTableView.frame];
        backvIEW.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBg:)];
        backvIEW.alpha = 0;
        [backvIEW addGestureRecognizer:tap];
        [self.view addSubview:backvIEW];
        
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.top = -44;
        self.navView.hidden = YES;
        backvIEW.alpha = 0.4;
    }];
    
    
    
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self hidaAction];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self doSearch];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

    [self hidaAction];
    
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [myTableView removeCenterMsgView];
    if (list.count>0) {
        [list removeAllObjects];
        [myTableView reloadData];
    }
}
- (void)tapBg:(UITapGestureRecognizer *)recongnizer
{
    if (recongnizer.state == UIGestureRecognizerStateEnded) {
        [self hidaAction];
        
    }
}
- (void)hidaAction
{
    [self.mSearchBar resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        backvIEW.alpha = 0;
        self.view.top = 0;
        self.navView.hidden = NO;
    }];
}
- (void)doSearch
{
    [myTableView removeCenterMsgView];
    if (list.count>0) {
        [list removeAllObjects];
        [myTableView reloadData];
        
    }
    NSString *username = @"";
    NSString *code = @"";
    NSString *mobile = @"";
    if (self.mSearchBar.selectedScopeButtonIndex == 0) {
        username = self.mSearchBar.text;
    }else if (self.mSearchBar.selectedScopeButtonIndex == 1)
    {
        mobile = self.mSearchBar.text;
    }else if (self.mSearchBar.selectedScopeButtonIndex == 2)
    {
        code = self.mSearchBar.text;
    }
    
    UserInfo *user = [UserInfo share];
    [self.view showLoadingView];
    [[ZZLHttpRequstEngine engine]requestSearchVolunteersWithUid:user.userId Rc4mobile:mobile userName:username rc4IdcardCode:code arearId:@"b0dc9771d14211e18718000aebf5352e" onSuccess:^(id responseObject) {
        [self.view hideLoadingView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hidaAction];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                if ([responseObject count] == 0) {
                    [myTableView addCenterMsgView:@"无结果"];
                    return ;
                }
                for (NSMutableDictionary *dic in responseObject) {
                    AddVolunteerInfo *info = [AddVolunteerInfo JsonModalWithDictionary:dic];
                    [list addObject:info];
                    
                }
                [myTableView reloadData];
            }
        });
        
        
    } onFail:^(NSError *erro) {
        
        [self hidaAction];
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        [self.view hideLoadingView];
    }];
}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( [list count]>0) {
        VolunteersCell *cell = [VolunteersCell cellForTableView:tableView fromNib:[VolunteersCell nib]];
        cell.delegate = self;
        cell.indexPath = indexPath;
        AddVolunteerInfo *info = [list objectAtIndex:indexPath.row];
        [cell setupWithAddVolunteerInfo:info];
        return cell;
    }else{
        return nil;
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VolunteersCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)VolunteersCell:(VolunteersCell *)cell actionRescruit:(UIButton *)rescruit
{
    UserInfo *user = [UserInfo share];
    

    AddVolunteerInfo *info = list[cell.indexPath.row];
    [[ZZLHttpRequstEngine engine]requestRecruitUserWithUid:user.userId ugroupId:info.userId missionid:self.missionID onSuccess:^(id responseObject) {
        
        [self.view showHudMessage:@"录用成功!"];
        [rescruit setTitle:@"已录用" forState:UIControlStateNormal];
        rescruit.enabled = NO;
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}
@end
