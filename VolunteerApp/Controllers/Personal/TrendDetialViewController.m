//
//  TrendDetialViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-6.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "TrendDetialViewController.h"
#import "MyTableView.h"
#import "CommentCell.h"
#import "DetailCell.h"
#import "AppDelegate.h"
@interface TrendDetialViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    MyTableView *mytableView;

    
}
@property (weak, nonatomic) IBOutlet UIView *mBottomView;
@property (weak, nonatomic) IBOutlet UITextField *mTextField;
- (IBAction)actionCommit:(UIButton *)sender;
@end

@implementation TrendDetialViewController

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
    [self setTitleWithString:@"动态详情"];
    
    NSMutableArray *list = [[NSMutableArray alloc]init];
    mytableView =    [[MyTableView alloc]
                      initWithFrame:
                      CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom-self.mBottomView.height)
                      style:
                      UITableViewStylePlain];
    mytableView.backgroundColor =[UIColor whiteColor];
    mytableView.dataSource                     = self;
    mytableView.delegate                       = self;
    mytableView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
    mytableView.list = list;
    
    
    [self.view addSubview:mytableView];
    
    self.mBottomView.top = mytableView.bottom;
    
    [self.view addSubview:self.mBottomView];
    

    
    __weak TrendDetialViewController *weakSelf = self;
    [mytableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [mytableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    mytableView.infiniteScrollingView.enabled = NO;
    
    [mytableView triggerPullToRefresh];
    
    [self registerForKeyboardNotifications];
    

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
    [self.mTextField resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"用户评论:";
    }else{
        return @"";
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 20;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSInteger section = indexPath.section;
    
        
        if (section == 0) {

            DetailCell *cell = [DetailCell cellForTableView:mytableView fromNib:[DetailCell nib]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setupWithWeiboInfo:self.info];
            return cell;
        }else{
            CommentCell *cell = [CommentCell cellForTableView:mytableView fromNib:[CommentCell nib]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell setupWithWeiboInfo:mytableView.list[indexPath.row]];
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }


    
    
    return nil;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [mytableView.list count];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat height = 0;
        if (self.info.picOriginal.length>0) {
            height = 80;
        }
        return [self caculateFontSizeStr:self.info.content]+100+height;
    }else{
        WeiboInfo *temp = mytableView.list[indexPath.row];
        return [self caculateFontSizeStr:temp.content]+65;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)caculateFontSizeStr:(NSString *)str
{
    return [str sizeWithFont:Font(14) constrainedToSize:CGSizeMake(300, 20000)].height;
}
#pragma mark -  networkData


- (void)refreshData
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UserInfo *user = [UserInfo share];
        
        

        

        
        
        [[ZZLHttpRequstEngine engine]requestGetWeiboReplyWithUid:user.userId weiboId:[NSString stringWithFormat:@"%d",self.info.weiboId] pageSize:mytableView.pageSize pageIndex:mytableView.pageIndex createTime:@"" onSuccess:^(id responseDict) {
            [mytableView.pullToRefreshView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        if ([mytableView.list count]==0) {
                            [mytableView reloadData];
                            
                        }else{
                            [mytableView.pullToRefreshView stopAnimating];
                        }
                        
                        
                    }else{
                        [mytableView removeCenterMsgView];
                        if ([mytableView.list count] > 0) {
                            [mytableView.list removeAllObjects];
                            [mytableView reloadData];
                            mytableView.pageIndex = 1;
                            
                        }
                        
                        [self insertRowAtTopWithList:responseDict];
                        
                        if ((itemCount%mytableView.pageSize) == 0) {
                            mytableView.infiniteScrollingView.enabled = YES;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [mytableView.pullToRefreshView stopAnimating];
            
        }];
    });
    
}
- (void)loadMore
{
    UserInfo *user = [UserInfo share];
    
    
    
    [[ZZLHttpRequstEngine engine]requestGetWeiboReplyWithUid:user.userId weiboId:[NSString stringWithFormat:@"%d",self.info.weiboId] pageSize:mytableView.pageSize pageIndex:mytableView.pageIndex createTime:@"" onSuccess:^(id responseDict) {
        
        [mytableView.infiniteScrollingView stopAnimating];
        NSLog(@"___YYY__%@",responseDict);
        if ([responseDict isKindOfClass:[NSArray class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                int itemCount = [responseDict count];
                if (itemCount == 0 ) {
                    
                    mytableView.infiniteScrollingView.enabled = NO;
                }else{
                    
                    [self insertRowAtBottomWithList:responseDict];
                    if ((itemCount%mytableView.pageSize) == 0) {
                        mytableView.pageIndex++;
                        mytableView.infiniteScrollingView.enabled = YES;
                    }else{
                        mytableView.infiniteScrollingView.enabled = NO;
                    }
                    
                }
                
            }) ;
        }
        
    } onFail:^(NSError *erro) {
        NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
        
        
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        [mytableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)insertRowAtTopWithList:(NSArray *)array
{
    [mytableView beginUpdates];
    for (int i=0; i<[array count]; i++) {
        NSMutableDictionary *dic = array[i];
        WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
        [mytableView.list addObject:info];
        [mytableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [mytableView endUpdates];
    
}
- (void)insertRowAtBottomWithList:(NSArray *)array
{
    [mytableView beginUpdates];
    for (int i=0; i< [array count]; i++) {
        NSMutableDictionary *dic = array[i];
        WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
        [mytableView.list addObject:info];
        [mytableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mytableView.list.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [mytableView endUpdates];
}

- (void)requestComment
{
    UserInfo *user = [UserInfo share];
    [[ZZLHttpRequstEngine engine]requestWeiboCommentWithUid:user.userId content:self.mTextField.text weiboId:[NSString stringWithFormat:@"%d",self.info.weiboId] onSuccess:^(id responseObject) {
        [self.view showHudMessage:@"评论成功"];
        self.mTextField.text = @"";
        [mytableView triggerPullToRefresh];
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}

- (IBAction)actionCommit:(UIButton *)sender {
    
    [self.mTextField resignFirstResponder];
    if (self.mTextField.text.length>0) {
        [self requestComment];
    }
    
}



- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardwillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardwillChange:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        self.mBottomView.top = self.view.height - self.mBottomView.height-kbSize.height ;
    }];
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [mytableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.mBottomView.top = self.view.height - self.mBottomView.height;
    }];
}
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    
    [UIView animateWithDuration:0.25 animations:^{
        self.mBottomView.top = self.view.height - self.mBottomView.height-kbSize.height ;
    }];
    
    
    [mytableView setContentOffset:CGPointMake(0.0, kbSize.height) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.mTextField.text.length>0) {
        [self requestComment];
    }
}
@end
