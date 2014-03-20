//
//  ProjectSearchViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ProjectSearchViewController.h"
#import "MyTableView.h"
#import "OptionViewController.h"
#import "ProtypeInfo.h"
#import "MyInfoCell.h"
#import "SearchResultViewController.h"


@interface ProjectSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray *list;
    MyTableView *myTableView;
    BOOL isRequest;
    int typeIndex;
    UIView *backvIEW;
    NSString *typeStr;
    
    
    int  curRow;
    UIDatePicker *FristPick;
    

    NSString   *fristDate;
    NSString   *secnodDate;
    NSString   *thridDate;
    
    int        distrubuteIndex;
    UIActionSheet *actionSheet;
}
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;

@end

@implementation ProjectSearchViewController

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
    // Do any additional setup after loading the view from its nib.
    myTableView = [[MyTableView alloc]initWithFrame:CGRectMake(0, self.mSearchBar.bottom, self.view.width, self.view.height-self.mSearchBar.bottom) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];



    
    // 初始化UIDatePicker
    FristPick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.height, 320, 216)];

    FristPick.backgroundColor = [UIColor whiteColor];
    // 设置时区
    [FristPick setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    // 设置当前显示时间
    [FristPick setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [FristPick setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [FristPick setDatePickerMode:UIDatePickerModeDate];
    // 当值发生改变的时候调用的方法
    [FristPick addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    FristPick.hidden = YES;
    

    
    list = [[NSMutableArray alloc]initWithObjects:@"项目类型",@"实施日期",@"开始时间",@"结束时间", nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(255, self.navView.bottom - 35, 40, 30);
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:btn];
    

    typeStr = @"";
    fristDate = @"全部";
    secnodDate = @"";
    thridDate = @"";
    [self registerNotification];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateWithProType:) name:Notification_Send_ProTYPE object:nil];
    
}
- (void)actionSearch:(UIButton *)btn
{
    [self doSearch];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view Lifecycle


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitleWithString:@"项目查找"];
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

    
    
    MyInfoCell *cell = [MyInfoCell cellForTableView:myTableView fromNib:[MyInfoCell nib]];
    cell.mInfoLb.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.mTitleLb.text = list[indexPath.row];

    if (indexPath.row == 0) {
        cell.mInfoLb.text  = typeStr;
    }else if(indexPath.row == 1){
        
        cell.mInfoLb.text =  fristDate;
    }else if(indexPath.row == 2){
        
        cell.mInfoLb.text = secnodDate;
    }else if(indexPath.row == 3){
        
       cell.mInfoLb.text = thridDate;
    }

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
    curRow = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (curRow == 0) {
        OptionViewController *vc = [[OptionViewController alloc]init];
        [self.flipboardNavigationController pushViewController:vc];
    }else if(curRow == 1)
    {
        [self actionDistrbute];
    }else
    {
        
        if (FristPick.hidden== NO) {
            [self hidePicker];
            if (curRow == 2) {
                secnodDate = @"";
            }else if (curRow == 3)
            {
                thridDate = @"";
            }
            [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self addPikcer];
        }
        
    }
    

}
- (void)updateProjectTypeWithString:(NSString *)str index:(int)index
{


    typeIndex = index;
    typeStr = str;


    [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)doSearch
{
    


    if (typeStr.length == 0) {
        [self.view showHudMessage:@"请选择项目类型"];
        return;
    }
//    if (self.mSearchBar.text.length ==0) {
//        return;
//    }
    [self.mSearchBar resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        backvIEW.alpha = 0;
        self.view.top = 0;
        self.navView.hidden = NO;
    }];
    isRequest = YES;
    UserInfo *user = [UserInfo share];
    
    
    
    SearchResultViewController *vc = [SearchResultViewController ViewContorller];
    vc.key  = self.mSearchBar.text;
    vc.userId = user.userId;
    vc.startDate = secnodDate;
    vc.endDate = thridDate;
    vc.typeindex = typeIndex;
    vc.distrubutetype = distrubuteIndex;
    
    [self.flipboardNavigationController pushViewController:vc];


}
- (void)updateWithProType:(NSNotification *)obj
{
    if ([obj.object isKindOfClass:[ProtypeInfo class]]) {
        ProtypeInfo *info = (ProtypeInfo *)obj.object;
        typeStr = info.typeName;
        [self updateProjectTypeWithString:info.typeName index:info.missionTypeId];
    }
    
    
   
}
#pragma mark - 
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self hidePicker];
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
    [self.mSearchBar resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        backvIEW.alpha = 0;
        self.view.top = 0;
        self.navView.hidden = NO;
    }];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [self doSearch];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        backvIEW.alpha = 0;
        self.view.top = 0;
        self.navView.hidden = NO;
    }];
    [self hidePicker];
    
}
- (void)tapBg:(UITapGestureRecognizer *)recongnizer
{
    if (recongnizer.state == UIGestureRecognizerStateEnded) {
        [self.mSearchBar resignFirstResponder];
        [UIView animateWithDuration:0.3f animations:^{
            backvIEW.alpha = 0;
            self.view.top = 0;
            self.navView.hidden = NO;
        }];
        
    }
}


#pragma mark - 
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//}
- (void)addPikcer
{
    if (![FristPick isDescendantOfView:self.view]) {
        [self.view addSubview:FristPick];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        FristPick.hidden = NO;
        FristPick.top = self.view.height - FristPick.height;
    }];
}
- (void)hidePicker
{
    if (!FristPick.hidden) {
        [UIView animateWithDuration:0.3f animations:^{
            FristPick.top = self.view.height;
            FristPick.hidden = YES;
        }];
    }

}
- (void)datePickerValueChanged:(UIDatePicker *)picker
{
    NSString *datestr = [self stringFromDate:picker.date];
    if (curRow == 2)
    {
        secnodDate = datestr;
    }else if(curRow == 3)
    {
        thridDate = datestr;
    }
    [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

- (void)actionDistrbute
{
//    0全部，1最近一周，2最近一个月，3最近3个月
    [self hidePicker];
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"选择发布时间段"
                       delegate:self
                       cancelButtonTitle:@"取消"
                       destructiveButtonTitle:@"全部"
                       otherButtonTitles:@"最近一周", @"最近一个月",@"最近3个月",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    }

    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    distrubuteIndex = buttonIndex;
    if (buttonIndex == 0) {
        fristDate = @"全部";
    }else if (buttonIndex == 1) {
        fristDate = @"最近一周";
    }else if(buttonIndex == 2) {
        fristDate = @"最近一个月";
    }else if(buttonIndex == 3) {
        fristDate = @"最近3个月";
    }
    [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    
}


@end
