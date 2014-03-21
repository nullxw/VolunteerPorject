//
//  MgAttendViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-19.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MgAttendViewController.h"
#import "TeamInfo.h"
#import "CheckAttendViewController.h"
@interface MgAttendViewController ()
{
    TeamInfo  *teamObject;
    NSString  *temaName;
    NSString  *searchTime;

    
    UIDatePicker *FristPick;
    UIToolbar    *inputToolBar;
    
    UILabel  *dateLabel;
    UILabel  *teamLable;
}

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mSearchBtn;
- (IBAction)actionSearch:(UIButton *)sender;
@end

@implementation MgAttendViewController

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
    [self setTitleWithString:@"志愿者考勤"];
    
    
    searchTime = @"";
    temaName = @"";
    UIImage *bgimage1 = [[UIImage imageNamed:@"login_nl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    UIImage *bgimage2 = [[UIImage imageNamed:@"login_hl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    [self.mSearchBtn setBackgroundImage:bgimage1 forState:UIControlStateNormal];
    [self.mSearchBtn setBackgroundImage:bgimage2 forState:UIControlStateHighlighted];
    
    
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
    
    
    // 工具条
    inputToolBar = [[UIToolbar alloc] init];
    inputToolBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44);
    // set style
    [inputToolBar setBarStyle:UIBarStyleDefault];
    
    // 工具条上的按钮
    UIBarButtonItem  *previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStyleBordered target:self action:@selector(previousButtonIsClicked:)];
    
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonIsClicked:)];
    
    NSArray *barButtonItems = @[previousBarButton, flexBarButton, doneBarButton];
    
    inputToolBar.items = barButtonItems;
    
    inputToolBar.hidden = YES;
    
    
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
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        //create cell
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"考勤日期:";
        
        if (dateLabel == nil) {
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 8, 180, 30)];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            [cell.contentView addSubview:dateLabel];
        }
        dateLabel.text = searchTime;
            
        
        
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"考勤队伍:";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (teamObject.missionTeamname) {
            
            if (teamLable == nil) {
                teamLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 8, 180, 30)];
                teamLable.backgroundColor = [UIColor clearColor];
                teamLable.text = teamObject.missionTeamname;
                teamLable.lineBreakMode = UILineBreakModeCharacterWrap;
                [cell.contentView addSubview:teamLable];
            }
            teamLable.text = teamObject.missionTeamname;
            
        }
        
        

        
    }
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        if (FristPick.hidden) {
            [self addPikcer];
        }
        
        
    }else if (indexPath.row == 1)
    {
        [self hidePicker];
        if (teamObject.missionTeamname.length == 0) {
            [self requestTeam];
        }
        
    }
    
}

- (void)requestTeam
{
    UserInfo *user = [UserInfo share];
    [[ZZLHttpRequstEngine engine]requestHighestTeamWithUid:user.userId missionId:self.mid onSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
        teamObject = [TeamInfo JsonModalWithDictionary:responseObject];
        
        [self.mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}
- (IBAction)actionSearch:(UIButton *)sender {
    
    if (searchTime.length==0) {
        [self.view showHudMessage:@"日期不能为空"];
        return;
    }
    if (teamObject.missionTeamname.length == 0) {
        [self.view showHudMessage:@"请选择队伍"];
        return;
    }
    if (searchTime.length>0 && teamObject.missionTeamname.length>0) {
        [self hidePicker];
        CheckAttendViewController *vc = [CheckAttendViewController ViewContorller];
        [vc setupMissionId:self.mid date:searchTime teamId:teamObject.missionTeamId];
        [self.flipboardNavigationController pushViewController:vc];
    }
}

#pragma mark - picker


- (void)addPikcer
{
    if (![FristPick isDescendantOfView:self.view]) {
        inputToolBar.top = FristPick.top-44;
        [self.view addSubview:inputToolBar];
        [self.view addSubview:FristPick];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        FristPick.hidden = NO;
        inputToolBar.hidden = NO;
        FristPick.top = self.view.height - FristPick.height;
        inputToolBar.top = FristPick.top-44;
    }];
    NSString *datestr = [self stringFromDate:FristPick.date];
    searchTime = datestr;
    [self.mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)hidePicker
{
    if (!FristPick.hidden) {
        [UIView animateWithDuration:0.3f animations:^{
            inputToolBar.top = self.view.height;
            FristPick.top = self.view.height+inputToolBar.height;
            FristPick.hidden = YES;
            inputToolBar.hidden = YES;
        }];
    }
    
}
- (void)datePickerValueChanged:(UIDatePicker *)picker
{
    NSString *datestr = [self stringFromDate:picker.date];
    searchTime = datestr;
    [self.mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

- (void)doneButtonIsClicked:(id)sender
{
    [self hidePicker];
//    NSString *datestr = [self stringFromDate:FristPick.date];
//    searchTime = datestr;
//    [self.mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)previousButtonIsClicked:(id)sender
{
    [self hidePicker];
    
    searchTime = @"";
    [self.mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
