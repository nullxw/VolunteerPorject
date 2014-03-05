//
//  MyTableView.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-26.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyTableView.h"

#define init_pageSize 10
#define init_pageIndex 1
@implementation MyTableView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


    }
    return self;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.pageIndex = init_pageIndex;
        self.pageSize = init_pageSize;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/*
- (void)PullToRefreshWithActionHandler:(void (^)(ZZLHttpRequstEngine *engin))actionHandler
{

    
    isDown = YES;
    __weak MyTableView *weakSelf = self;
    [self addPullToRefreshWithActionHandler:^{
        [weakSelf removeCenterMsgView];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_current_queue(), ^(void){
            if (actionHandler) {
                
                
                actionHandler([ZZLHttpRequstEngine engine]);
            }
        });
    }];
}

- (void)pullToLoadMoreWithActionHandler:(void (^)(ZZLHttpRequstEngine *engin))actionHandler
{

    isDown = NO;
    __weak MyTableView *weakSelf = self;
    [self addInfiniteScrollingWithActionHandler:^{
        [weakSelf removeCenterMsgView];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_current_queue(), ^(void){
            if (actionHandler) {
                
                actionHandler([ZZLHttpRequstEngine engine]);
            }
        });
    }];
}
- (void)handleRefreshWithResponeArray:(NSMutableArray *)dataList ModelClass:(Class)aClass loadMoreAction:(void (^)(ZZLHttpRequstEngine *engin))action
{
    int listCount = [self.list count];
    int itemCount = [dataList count];
    if (itemCount == 0) {//未返回数据
        
        [self stopRefreshAnimation];
        // 如果LIST里无数据
        if (listCount == 0) {
            self.pageIndex = init_pageIndex;
            
            [self addCenterMsgView:@"数据空空"];
            
        }
        
        
    }else{//get data
        
        [self removeCenterMsgView];
        if (itemCount < self.pageSize) {//没有更多了
            
            if (isDown) {//下拉刷新
                [self.list removeAllObjects];
                [self reloadData];
                
                [self beginUpdates];
                for (int i=0; i<itemCount; i++) {
                    NSMutableDictionary *dic = (NSMutableDictionary *)dataList[i];
                    ZZLBaseJsonObject *info = [aClass JsonModalWithDictionary:dic];
                    [self.list addObject:info];
                    [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                }
                [self endUpdates];
                
            }else{//加载更多
                [self beginUpdates];
                for (int i=0; i<itemCount; i++) {
                    NSMutableDictionary *dic = (NSMutableDictionary *)dataList[i];
                    ZZLBaseJsonObject *info = [aClass JsonModalWithDictionary:dic];
                    [self.list addObject:info];
                    [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:listCount inSection:0]] withRowAnimation:UITableViewRowAnimationTop];

                }
                [self endUpdates];
                self.pageIndex++;

            }
            
        }
        
        if (itemCount == self.pageSize) {//有更多
            
            if (listCount == 0) {
                [self beginUpdates];
                for (int i=0; i<itemCount; i++) {
                    NSMutableDictionary *dic = (NSMutableDictionary *)dataList[i];
                    ZZLBaseJsonObject *info = [aClass JsonModalWithDictionary:dic];
                    [self.list addObject:info];
                    [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                }
                [self endUpdates];
            }else{
                [self beginUpdates];
                for (int i=0; i<itemCount; i++) {
                    NSMutableDictionary *dic = (NSMutableDictionary *)dataList[i];
                    ZZLBaseJsonObject *info = [aClass JsonModalWithDictionary:dic];
                    [self.list addObject:info];
                    [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:listCount inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                    
                }
                [self endUpdates];
                self.pageIndex++;

            }
            [self pullToLoadMoreWithActionHandler:^(ZZLHttpRequstEngine *engin) {
                if (action) {
                    action(engin);
                }
            }];
            
            
        }
        
    }
    
}
- (void)stopRefreshAnimation
{
    [self.pullToRefreshView stopAnimating];
    [self.infiniteScrollingView stopAnimating];
}
 */

- (void)insertRowAtTopWithCount:(int)count
{
    
    [self beginUpdates];
    for (int i=0; i<count; i++) {
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self endUpdates];
    
}
- (void)insertRowAtBottomWithCount:(int)count
{
    
    [self beginUpdates];
    for (int i=0; i< count; i++) {
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.list count]-1-(count - i) inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self endUpdates];
}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource

@end
