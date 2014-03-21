//
//  MgAttendViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-19.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MgAttendViewController.h"
#import "TeamInfo.h"
@interface MgAttendViewController ()
{
    TeamInfo  *teamObject;
    NSString  *temaName;
    NSString  *searchTime;
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
        
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"考勤队伍:";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (teamObject.missionTeamname) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 160, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.text = teamObject.missionTeamname;
            label.lineBreakMode = UILineBreakModeCharacterWrap;
            [cell.contentView addSubview:label];
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
        
    }else if (indexPath.row == 1)
    {
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
    
    
}
@end
