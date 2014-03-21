//
//  ModifyPwdViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-10.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ModifyPwdViewController.h"
#import "EditCell.h"
@interface ModifyPwdViewController ()<UITextFieldDelegate>
{
    NSArray *namelist;
    NSArray *placeHoldlist;
    NSMutableArray *newPwdList;
    
    UITextField *curTextFiled;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation ModifyPwdViewController

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
    [self setTitleWithString:@"修改密码"];
    
    namelist = @[@"原始密码:",@"新密码:",@"确认密码:"];
    placeHoldlist = @[@"请输入原密码",@"请输入新密码",@"请输入确认密码"];
    newPwdList = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    
    UIImage *bgimage1 = [[UIImage imageNamed:@"login_nl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    UIImage *bgimage2 = [[UIImage imageNamed:@"login_hl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)] ;
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(20, 20, 280, 40) ;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setBackgroundImage:bgimage1 forState:UIControlStateNormal];
    [button setBackgroundImage:bgimage2 forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(actionUpdate:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    self.mTableView.tableFooterView = view;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.mTableView addGestureRecognizer:tap];
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
    EditCell *cell = [EditCell cellForTableView:self.mTableView fromNib:[EditCell nib]];
    cell.mTextLb.text = namelist[indexPath.row];
    cell.mTextFiled.placeholder = placeHoldlist[indexPath.row];
    cell.mTextFiled.secureTextEntry = YES;
    cell.mTextFiled.delegate = self;
    cell.mTextFiled.tag = indexPath.row+1000;
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return namelist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    curTextFiled = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length==0) {
        return;
    }


    

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (void)actionUpdate:(UIButton *)sender
{
    for (int i=0; i<3; i++) {
        EditCell *cell = (EditCell *)[self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [newPwdList replaceObjectAtIndex:i withObject:cell.mTextFiled.text];
        
    }

    
    NSString *str = newPwdList[0];
    NSString *str1 = newPwdList[1];
    NSString *str2 = newPwdList[2];
    
    if (str.length==0) {
        [self.view showHudMessage:@"原始密码不能为空"];
        return;
    }
    if (str1.length ==0) {
        [self.view showHudMessage:@"新密码不能为空"];
        return;
    }
    if (str2.length == 0) {
        [self.view showHudMessage:@"确认密码不能为空"];
        return;
    }
    if (str1.length>0 && str2.length>0) {
        if ([str1 isEqualToString:str2]) {
            [self requestUpdatePwd];
        }else{
            [self.view showHudMessage:@"两次输入的密码不一致"];
        }
    }else{
        [self.view showHudMessage:@"密码不能为空"];
    }
    
    
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [newPwdList replaceObjectAtIndex:curTextFiled.tag-1000 withObject:curTextFiled.text];
//    return YES;
//}
- (void)requestUpdatePwd
{
    UserInfo *user = [UserInfo share];
    [[ZZLHttpRequstEngine engine]requestUpdatePwdWithUid:user.userId Rc4oldPwd:newPwdList[0] Rc4newPwd:newPwdList[1] onSuccess:^(id responseObject) {
        [self.view showHudMessage:responseObject];
        [self back];
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}
- (void)back
{
    [curTextFiled resignFirstResponder];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.flipboardNavigationController popViewController];
    });
    
}
- (void)tapBackground:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    if ([view isKindOfClass:[EditCell class]]) {
        return;
    }else{
        [curTextFiled resignFirstResponder];
    }

}

@end
