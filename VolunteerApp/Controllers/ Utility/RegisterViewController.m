//
//  RegisterViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-25.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "RegisterViewController.h"
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "FlipBoardNavigationController.h"
#import "ZZLHttpRequstEngine.h"
#import "DistrictModel.h"
#import "AppDelegate.h"
@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,RETableViewManagerDelegate,LoginViewDelegate>
{
    NSMutableArray *cityList;
    NSMutableArray *cityList1;
    NSMutableArray *cityList2;
    UITableView *tableView;
    //    NSMutableArray *listArray;
    //    NSMutableArray  *answerArray;
    RETableViewManager *manager;
    
    RERadioItem* cardTypeItem;
    RENumberItem* idcardNoItem;
    RETextItem* userNameItem;
    RETextItem* userPwdItem;
    RETextItem* userPwdConfirmItem;
    RERadioItem* genderItem;
    RETextItem* emailItem;
    RENumberItem* phoneItem;
    RERadioItem* cityItem;
    
    NSArray  *cardOptions;
    
    NSMutableArray  *genderOptions;
    
    RETableViewSection *section;

}

@end

@implementation RegisterViewController

#pragma mark - view Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cityList = [[NSMutableArray alloc]init];
    cityList1 = [[NSMutableArray alloc]init];
    cityList2 = [[NSMutableArray alloc]init];
    
    __typeof (&*self) __weak weakSelf = self;
    self.title                  = @"test";
	// Do any additional setup after loading the view.
    tableView                   = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.height, 320, self.view.height-self.navView.height) style:UITableViewStyleGrouped];
    tableView.dataSource        = self;
    tableView.delegate          = self;
    tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tableView];
    
    
    
    
    
    manager                     = [[RETableViewManager alloc] initWithTableView:tableView];
    
    
    manager.delegate            = self;
    

    
    section = [RETableViewSection section];
    [manager addSection:section];
    
    

//    0: PAS-国际护照
//    1: CID-中国身份证
//    2: JGZ-中国人民解放军军官证或士兵证
//    3: WJZ-中国武警证件
//    4: TWT-台湾居民来往大陆通行证
//    5: GAT-港、澳居民来往内地通行证
//    6: GAB-公安现役警官证件或士兵证（边防系统）
//    7: GAJ-公安现役警官证件或士兵证（警卫系统）
//    8: GAX-公安现役警官证件或士兵证（消防系统）
    

    cardOptions = [NSArray arrayWithObjects:@"PAS-国际护照",
                   @"CID-中国身份证",
                   @"JGZ-中国人民解放军军官证或士兵证",
                   @"WJZ-中国武警证件",
                   @"TWT-台湾居民来往大陆通行证",
                   @"GAT-港、澳居民来往内地通行证",
                   @"GAB-公安现役警官证件或士兵证（边防系统)",
                   @"GAJ-公安现役警官证件或士兵证（警卫系统）",
                   @"GAX-公安现役警官证件或士兵证（消防系统）", nil];
    //1证件类型
    cardTypeItem =[RERadioItem itemWithTitle:@"证件类型" value:@"身份证" selectionHandler:^(RERadioItem *item) {
        [weakSelf hideAction];
        [item deselectRowAnimated:YES];

        

        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:cardOptions multipleChoice:NO completionHandler:^{
            [weakSelf.flipboardNavigationController popViewController];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        }];
        

        optionsController.delegate = weakSelf;
        optionsController.style = section.style;
        
        
        [weakSelf.flipboardNavigationController pushViewController:optionsController];
    }];
    
    
    
    //2证件号
    idcardNoItem =[RENumberItem itemWithTitle:@"证件号" value:@"" placeholder:@"您的证件号码" format:@"XXXXXXXXXXXXXXXXXX"];
    //3
    userNameItem = [[RETextItem alloc]initWithTitle:@"姓名" value:@"" placeholder:@"您的姓名"];
    //4

    
    userPwdItem = [[RETextItem alloc]initWithTitle:@"密码" value:@"" placeholder:@"请输入密码"];
    userPwdItem.secureTextEntry = YES;
    
    [userPwdItem selectRowAnimated:YES scrollPosition:UITableViewScrollPositionBottom];
    //5
    userPwdConfirmItem = [[RETextItem alloc]initWithTitle:@"确认密码" value:@"" placeholder:@"输入确认密码"];
    userPwdConfirmItem.secureTextEntry = YES;
    
    [userPwdConfirmItem selectRowAnimated:YES scrollPosition:UITableViewScrollPositionTop];
    [userPwdConfirmItem setOnBeginEditing:^(RETextItem *item) {
        [weakSelf moveUpWithOffset:44*3];
    }];
    [userPwdConfirmItem setOnEndEditing:^(RETextItem *item) {
        [weakSelf moveDown];
    }];

    
    
    //6
    genderOptions =  [[NSMutableArray alloc] init];
    
    [genderOptions addObject:[NSString stringWithFormat:@"未知"]];
    [genderOptions addObject:[NSString stringWithFormat:@"男"]];
    [genderOptions addObject:[NSString stringWithFormat:@"女"]];

    
    //性别
    genderItem =[RERadioItem itemWithTitle:@"性别" value:@"未知" selectionHandler:^(RERadioItem *item) {
        [weakSelf hideAction];
        [item deselectRowAnimated:YES];
        
 

        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:genderOptions multipleChoice:NO completionHandler:^{
            [weakSelf.flipboardNavigationController popViewController];
            [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        }];

        optionsController.delegate = weakSelf;
        optionsController.style = section.style;
        
        [weakSelf.flipboardNavigationController pushViewController:optionsController];
    }];
    [genderItem selectRowAnimated:YES scrollPosition:UITableViewScrollPositionTop];
    
    //7 邮箱
    emailItem = [[RETextItem alloc]initWithTitle:@"邮箱" value:@"" placeholder:@"您的邮箱"];
    
  
    [emailItem selectRowAnimated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [emailItem setOnBeginEditing:^(RETextItem *item) {
        [weakSelf moveUpWithOffset:44*5];
    }];
    [emailItem setOnEndEditing:^(RETextItem *item) {
        [weakSelf moveDown];
    }];

    
    //8电话
    phoneItem =[RENumberItem itemWithTitle:@"电话" value:@"" placeholder:@"您的电话号码" format:@"XXX-XXXX-XXXX"];
    [phoneItem selectRowAnimated:YES scrollPosition:UITableViewScrollPositionTop];

    [phoneItem setOnBeginEditing:^(RETextItem *item) {
        [weakSelf moveUpWithOffset:44*6];
    }];
    [phoneItem setOnEndEditing:^(RETextItem *item) {
        [weakSelf moveDown];
    }];


    
    
    //9城市
    cityItem =[RERadioItem itemWithTitle:@"所在城市" value:@"广州" selectionHandler:^(RERadioItem *item) {
        [weakSelf hideAction];
        [item deselectRowAnimated:YES];
        if ([cityList count]==0) {
            [self requestCity];
        }else{
            [self pushToOptionWithOptions:cityList WithItems:cityItem];
        }
    }];
    [cityItem selectRowAnimated:YES scrollPosition:UITableViewScrollPositionMiddle];
    

    

    

    //提交
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"提交" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [tableView deselectRowAtIndexPath:item.indexPath animated:YES];
//        NSLog(@"Button pressed");
        [self requestForRegister];
        
    }];
    UIImage *bgimage1 = [[UIImage imageNamed:@"login_nl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    UIImage *bgimage2 = [[UIImage imageNamed:@"login_hl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    buttonItem.image = bgimage1;
    buttonItem.highlightedImage = bgimage2;
    

    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)] ;
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(20, 20, 280, 40) ;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setBackgroundImage:bgimage1 forState:UIControlStateNormal];
    [button setBackgroundImage:bgimage2 forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    tableView.tableFooterView = view;
    
    [section addItem:cardTypeItem];
    [section addItem:idcardNoItem];
    [section addItem:userNameItem];
    [section addItem:userPwdItem];
    [section addItem:userPwdConfirmItem];
    [section addItem:genderItem];
    [section addItem:emailItem];
    [section addItem:phoneItem];
    [section addItem:cityItem];
    

    
    [self setTitleWithString:@"用户注册"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    tableView.contentSize = CGSizeMake(320, tableView.contentSize.height+100);
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([cityList count]==0) {
        [self requestCity];
    }

    
}

- (void)hideAction
{
    [tableView resignFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
- (void)moveUpWithOffset:(CGFloat)offset
{
    
    [UIView animateWithDuration:0.3 animations:^{
        tableView.top = -offset;
    }];
    
    

}
- (void)moveDown{
    
    [UIView animateWithDuration:0.3 animations:^{
        tableView.top = self.navView.bottom;
    }];
}
#pragma mark -  actions
- (void)actionRegister:(UIButton *)btn

{
    [self requestForRegister];

}
- (void)backAction:(UIButton *)btn
{
    [self.flipboardNavigationController popViewController];
}



#pragma mark - get city list
- (void)requestCity
{
    [[ZZLHttpRequstEngine engine] requestGetCityListWithDistrictid:@"" type:0 pageSize:100 pageIndex:1 onSuccess:^(id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        for (NSMutableDictionary *dic in array) {
            [cityList addObject:[DistrictModel JsonModalWithDictionary:dic]];
        }
        


        

    } onFail:^(NSError *erro) {
        [self.view showHudMessage:@"城市列表获取失败"];
        NSLog(@"citylist error:%@",[erro.userInfo objectForKey:@"description"]);
    }];
}
- (void)pushToOptionWithOptions:(NSArray *)options WithItems:(RERadioItem *)item
{
    NSMutableArray *namearray = [[NSMutableArray alloc]init];
    for (DistrictModel *temp in options) {
        [namearray addObject:temp.districtName];
    }
    RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:namearray multipleChoice:NO completionHandler:^{
        [self.flipboardNavigationController popViewController];
        
        [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        
        
    }];
    
    optionsController.delegate = self;

    
    [self.flipboardNavigationController pushViewController:optionsController];
}

- (void)requestForRegister
{
    
    if (![self validateForm]) {
        return;
    }
    NSString *area = cityItem.value;
    if ([cityList count]>0) {
        for (DistrictModel *temp in cityList) {
            if ([temp.districtName isEqualToString:area]) {
                area = temp.districtId;
                break;
            }
        }
    }else{
        [self.view showHudMessage:@"城市不能为空哦!"];
        return;
    }
    

//    [[ZZLHttpRequstEngine engine]requestUserRegsiterWithIDCardType:[cardOptions indexOfObject:cardTypeItem.value] rc4IDCardCode:idcardNoItem.value userName:userNameItem.value rc4Pwd:userPwdItem.value gender:[genderOptions indexOfObject:genderItem.value] rc4email:emailItem.value rc4mobile:phoneItem.value areaid:area onSuccess:^(id responseObject) {
//        
//        
//        NSLog(@"register success:%@",responseObject);
//        [self.view showHudMessage:@"注册成功！"];
//    } onFail:^(NSError *erro) {
//        [self.view showHudMessage:@"注册failrue！"];
//        NSLog(@"register error:%@",[erro.userInfo objectForKey:@"description"]);
//    }];
    [[ZZLHttpRequstEngine engine]requestUserRegsiterWithIDCardType:1 rc4IDCardCode:@"3607821988111870" userName:@"aaabbb" rc4Pwd:@"123456" gender:1 rc4email:@"qvbicfhdx@126.com" rc4mobile:@"15652512884" areaid:area onSuccess:^(id responseObject) {
        
        
        NSLog(@"register success:%@",responseObject);
        [self.view showHudMessage:@"注册成功！"];
        [self.flipboardNavigationController popViewController];
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        NSLog(@"register error:%@",[erro.userInfo objectForKey:@"description"]);
    }];
}

- (BOOL)validateForm
{
    if (![userPwdItem.value isEqualToString:userPwdConfirmItem.value]) {
        [self.view showHudMessage:@"两次输入的密码不一致"];
        return NO;
    
    }
    return YES;

}


@end
