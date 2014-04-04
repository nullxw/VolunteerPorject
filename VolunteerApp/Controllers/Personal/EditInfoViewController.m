//
//  EditInfoViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-26.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "EditInfoViewController.h"
#import "EditCell.h"
#import "MyInfoCell.h"
#import "BelongViewController.h"
#import "UrlDefine.h"
@interface EditInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UITableView *myTableView;
    
    
    UITextField  *curTextField;

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
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(265, self.navView.bottom - 44, 46, 46);
    [btn setImage:[UIImage imageNamed:@"nav_complete.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(actionModify:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:btn];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    
    self.list = [NSArray arrayWithObjects:@"姓名",@"邮箱",@"手机号码",@"性别",@"归属单位", nil];
    UserInfo *user = [UserInfo share];
    NSString *gender;
    if (user.gender == 0) {
        gender = @"未知";
    }
    if (user.gender == 1) {
        gender = @"男";
    }
    if (user.gender == 2) {
        gender = @"女";
    }
    
    
    
    global_districtName= @"";
    global_districtId = @"";

    self.infoList = [NSMutableArray arrayWithObjects:user.userName,user.email,user.mobile,gender,user.areaName,nil];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (global_districtName.length>0) {
        [self.infoList replaceObjectAtIndex:4 withObject:global_districtName];
        [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionModify:(UIButton *)sender
{
    [self hideKeyBorad];
    for (int i=0; i<3; i++) {
        if ([self.infoList[i] isEqualToString:@""]) {
            [self.view showHudMessage:[NSString stringWithFormat:@"%@不能为空",self.list[i]]];
             return;
        }
    }

    
    UserInfo *user = [UserInfo share];
    
    int gender  = 0;
    if ([self.infoList[3] isEqualToString:@"男"]) {
        gender = 1;
    }else if([self.infoList[3] isEqualToString:@"女"]){
        gender = 2;
    }
    
    
    [[ZZLHttpRequstEngine engine]requestUpdateUserInfoWithUid:user.userId userName:self.infoList[0] gender:gender Rc4email:self.infoList[1] Rc4mobile:self.infoList[2] areadId:(global_districtId.length>0)?global_districtId:user.areaId onSuccess:^(id responseObject) {
        
        NSLog(@"modify info : %@",responseObject);
        
        [self.view showHudMessage:responseObject];
        
        user.userName = self.infoList[0];
        user.gender = gender;
        user.email = self.infoList[1];
        user.mobile = self.infoList[2];
        if (global_districtId.length>0) {
            user.areaId = global_districtId;
        }
        if (global_districtName.length>0) {
            user.areaName = global_districtName;
        }
        
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.list count]>0) {
        int row = indexPath.row;
        if (row<3) {
            
            EditCell *cell = [EditCell cellForTableView:tableView fromNib:[EditCell nib]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.mTextLb.text = self.list[row];
            cell.mTextFiled.text = self.infoList[row];
            cell.mTextFiled.textColor = [UIColor darkGrayColor];
            cell.mTextFiled.delegate = self;
            cell.mTextFiled.tag = row+200;
            cell.mTextFiled.borderStyle = UITextBorderStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else
        {
            MyInfoCell *cell = [MyInfoCell cellForTableView:tableView fromNib:[MyInfoCell nib]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.mTitleLb.text = self.list[row];
            cell.mInfoLb.text = self.infoList[row];
            return cell;
        }
    
        
        
    }
    return nil;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
    if (row < 3) {
        
    }
    
    [self hideKeyBorad];
    if (row==3) {
        [self showAction];
    }
    if (row == 4) {
        
        [self chooseArea];
    }
    
}
- (void)chooseArea
{
    BelongViewController *vc =[BelongViewController ViewContorller] ;
    [self.flipboardNavigationController pushViewController:vc];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    curTextField = textField;
    [textField becomeFirstResponder];
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    
    int index = textField.tag - 200;
    [self.infoList replaceObjectAtIndex:index withObject:textField.text];
    [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)hideKeyBorad
{
    if (curTextField) {
        [curTextField resignFirstResponder];
    }
    
}
- (void)showAction
{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionSheet.delegate = self;
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0) {

        [self.infoList replaceObjectAtIndex:3 withObject:@"男"];
    }else if(buttonIndex == 1)
    {
        [self.infoList replaceObjectAtIndex:3 withObject:@"女"];
    }
    [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
@end
