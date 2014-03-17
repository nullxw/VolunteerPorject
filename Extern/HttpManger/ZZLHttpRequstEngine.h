//
//  ZZLHttpRequstEngine.h
//  MyEngineProject
//
//  Created by zelong zou on 13-9-1.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "ZZLRequestOperation.h"
#import "ZZLModalObjectFactory.h"
#import "ZZLBaseJsonObject.h"



#define kAccessTokenDefaultsKey @"ACCESS_TOKEN"

typedef void (^voidBlock)(void);
typedef void (^dictionaryBlock)(id responseObject);
typedef void (^arrayBlock)(NSMutableArray *listOfModalObjects);
typedef void (^modelBlock)(ZZLBaseJsonObject *modelObject);
typedef void (^erroBlock)(NSError *erro);
typedef void (^objectBlock)(id obj);

@interface ZZLHttpRequstEngine : MKNetworkEngine
{
    //服务器请求可能需要的Authorization (HttpHeader头授权字段)
    NSString *_accessToken;
    
    //请求池（包装了一组键值对） key:路径 value:对应的请求操作对象
    NSMutableDictionary *_requestPoolDict;
}

+ (id)engine;

@property (nonatomic) NSString *accessToken;



/*------------------------------Get 请求----------------------------------*/
/*!
 @abstract:通用的请求网络数据
 @description:获取服务器返回的JSON数据字典
 @path:对应请求的(除掉host)路径 如：（@"newmb.php/mbv2/homepage"）
 @successBlock:成功回调的一个块函数，参数即为生成好的数据。client处理该数据即可
 @errorBlock:失败的回调函数，参数为失败的说明
 @return:返回当前请求操作的状态
 */
-(MKNetworkOperationState)requestWithServicePath:(NSString *)path
                                       onSuccess:(objectBlock)successBlock
                                          onFail:(erroBlock)errorBlock;

/*!
 @abstract:请求单独的数据模型对象
 @description:如获取某个用户的信息
 @path:对应请求的(除掉host)路径 如：（@"newmb.php/mbv2/homepage"）
 @className:对应的数据模型类型
 @successBlock:成功回调的一个块函数，参数即为生成好的数据模型。client只要用一个模型对象的指引引用即可
 @errorBlock:失败的回调函数，参数为失败的说明
 @return:返回当前请求操作的状态
 */
- (MKNetworkOperationState)requestSingleModelWithServicePath:(NSString *)path
                                                    keyPaths:(NSArray *)keyPath
                                                  modelClass:(Class)className
                                                   onSuccess:(modelBlock)successBlock
                                                      onFail:(erroBlock)errorBlock;

/*!
 @abstract:请求一组数据模型对象列表
 @description:通常，在一个复杂的字典里取出一个列表，映射成模型对象列表
 
 @path:对应请求的(除掉host)路径 如：（@"newmb.php/mbv2/homepage"）
 @keyPath:对应的服务器字典里的 数据列表 的键路径,可以为nil
 @className:对应的数据模型类型
 @successBlock:成功回调的一个块函数，参数即为生成好的数据模型数组列表。client只要用一个数组接收即可
 @errorBlock:失败的回调函数，参数为失败的说明 
 @return:返回当前请求操作的状态
 */
- (MKNetworkOperationState)requestModelListWithServicePath:(NSString *)path
                                                keyPaths:(NSArray *)keyPath
                                              modelClass:(Class)className
                                               onSuccess:(arrayBlock)successBlock
                                                  onFail:(erroBlock)errorBlock;

/*------------------------------Post 请求----------------------------------*/

/*!
 @abstract:向服务器提交数据
 @description:发起一个请求向服务器提交数据
 @paras:需要提交数据的字典
 @successBlock:成功回调的一个块函数，参数为服务器返回的JOSN数据字典
 @errorBlock:失败的回调函数，参数为失败的说明
 @return:返回当前请求操作的状态
 */
- (ZZLRequestOperation *)postRequestWithServicePath:(NSString *)path
                                               params:(NSMutableDictionary *)params
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;
/*------------------------------custom 请求----------------------------------*/
/*!
 定制的方法
 */

#pragma mark -  用户相关的接口
//1 授权登录 login

- (ZZLRequestOperation *)loginWithUserName:(NSString *)userName
                                  password:(NSString *)psd
                                 onSuccess:(dictionaryBlock)successBlock
                                    onFail:(erroBlock)errorBlock;



//2 用户注册
-(ZZLRequestOperation *)requestUserRegsiterWithIDCardType:(int)type
                                            rc4IDCardCode:(NSString *)code
                                                 userName:(NSString *)uname
                                                  rc4Pwd:(NSString *)pwd
                                                   gender:(int)gender
                                                 rc4email:(NSString *)email
                                                   rc4mobile:(NSString *)mobile
                                                   areaid:(NSString *)aid
                                                onSuccess:(dictionaryBlock)successBlock
                                                   onFail:(erroBlock)errorBlock;



//3获取用户基本信息

- (ZZLRequestOperation *)requestUserGetUserInfoWithUid:(NSString *)uid
                                                 curid:(NSString *)cid
                                             onSuccess:(dictionaryBlock)successBlock
                                                onFail:(erroBlock)errorBlock;

//4 个人排名
- (ZZLRequestOperation *)requestPersonalRankWithUid:(NSString *)uid
                                           otherUid:(NSString *)oid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock;
//5 获取服务记录
- (ZZLRequestOperation *)requestServiceLogWithUid:(NSString *)uid
                                         otherUid:(NSString *)oid
                                        isUpdated:(BOOL)isupdated
                                        pageIndex:(int)page
                                         pageSize:(int)psize
                                        missionId:(int)mid
                                        onSuccess:(dictionaryBlock)successBlock
                                           onFail:(erroBlock)errorBlock;

//6 获取服务记录数目
- (ZZLRequestOperation *)requestServiceLogNumWithUid:(NSString *)uid
                                            otheruid:(NSString *)oid
                                           onSuccess:(dictionaryBlock)successBlock
                                              onFail:(erroBlock)errorBlock;

//7 修改用户基本信息

- (ZZLRequestOperation *)requestUpdateUserInfoWithUid:(NSString *)uid
                                             userName:(NSString *)uname
                                               gender:(int)genderIndex
                                                Rc4email:(NSString *)email
                                               Rc4mobile:(NSString *)moblie
                                              areadId:(NSString *)areaid
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;


//8 修改密码
- (ZZLRequestOperation *)requestUpdatePwdWithUid:(NSString *)uid
                                        Rc4oldPwd:(NSString *)opwd
                                        Rc4newPwd:(NSString*)npwd
                                       onSuccess:(dictionaryBlock)successBlock
                                          onFail:(erroBlock)errorBlock;


#pragma mark - 微博相关的接口
//9 获取用户微博
- (ZZLRequestOperation *)requestGetWeiboWithUid:(NSString *)uid
                                         curid:(NSString *)cid
                                       pageSize:(int)psize
                                      pageIndex:(int)page
                                     createTime:(NSString *)dataTime
                                      onSuccess:(dictionaryBlock)successBlock
                                         onFail:(erroBlock)errorBlock;

//10 获取好友的微博
- (ZZLRequestOperation *)requestGetFriendWeiboWithUid:(NSString *)uid
                                               curid:(NSString *)cid
                                             pageSize:(int)psize
                                            pageIndex:(int)page
                                           createTime:(NSString *)dataTime
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;

//11 获取微博评论
- (ZZLRequestOperation *)requestGetWeiboReplyWithUid:(NSString *)uid
                                             weiboId:(NSString *)wid
                                            pageSize:(int)psize
                                           pageIndex:(int)page
                                          createTime:(NSString *)dataTime
                                           onSuccess:(dictionaryBlock)successBlock
                                              onFail:(erroBlock)errorBlock;

//12 收藏微博
- (ZZLRequestOperation *)requestCollectWeiboWithUid:(NSString *)uid
                                            weiboId:(NSString *)wid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock;

//13 删除微博
- (ZZLRequestOperation *)requestDelWeiboWithUid:(NSString *)uid
                                        weiboId:(NSString *)wid
                                      onSuccess:(dictionaryBlock)successBlock
                                         onFail:(erroBlock)errorBlock;

//14 微博图片上传
- (ZZLRequestOperation *)requestWeiboUploadImageWithUid:(NSString *)uid
                                                  image:(NSData *)imageData
                                              onSuccess:(dictionaryBlock)successBlock
                                                 onFail:(erroBlock)errorBlock;
//15 提交微博
- (ZZLRequestOperation *)requestSendNewWeiboWithUid:(NSString *)uid
                                              content:(NSString *)content
                                           weiboimage:(NSString *)imagePath
                                       synchSinaWeibo:(BOOL)synch
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;
//16 提交评论
- (ZZLRequestOperation *)requestWeiboCommentWithUid:(NSString *)uid
                                          content:(NSString *)content
                                          weiboId:(NSString *)wid
                                        onSuccess:(dictionaryBlock)successBlock
                                           onFail:(erroBlock)errorBlock;
//17 获取新浪是否已授权
- (ZZLRequestOperation *)requestWeiboIsAuthroedWithUid:(NSString *)uid
                                             onSuccess:(dictionaryBlock)successBlock
                                                onFail:(erroBlock)errorBlock;

//18 同步单条记录到新浪
- (ZZLRequestOperation *)requestWeiboSynchOneToSinaWithUid:(NSString *)uid
                                                   weiboId:(NSString *)wid
                                                 onSuccess:(dictionaryBlock)successBlock
                                                    onFail:(erroBlock)errorBlock;

//19 获取个人空间头像（微博头像）
- (ZZLRequestOperation *)requestGetUserAvatorWithUid:(NSString *)uid
                                                curid:(NSString *)cid
                                           onSuccess:(dictionaryBlock)successBlock
                                              onFail:(erroBlock)errorBlock;


#pragma mark - 项目相关
//20 获取待审批、用户没有被录取的项目列表（个人）
- (ZZLRequestOperation *)requestGetWaitListWithUid:(NSString *)uid
                                          pageSize:(int)psize
                                         pageIndex:(int)page
                                         onSuccess:(dictionaryBlock)successBlock
                                            onFail:(erroBlock)errorBlock;

//21 获取待审批、用户没有被录取项目数目（个人）
- (ZZLRequestOperation *)requestGetWaitCountWithUid:(NSString *)uid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock;
//22 获取任务(个人)

- (ZZLRequestOperation *)requestGetMissionlistWithUid:(NSString *)uid
                                            selection:(int)sel
                                         missionState:(int)mState
                                             pageSize:(int)psize
                                            pageIndex:(int)page
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;


//23 获取任务数目(个人)
- (ZZLRequestOperation *)requestGetMissionCountWithUid:(NSString *)uid
                                          missionState:(NSString *)state
                                             onSuccess:(dictionaryBlock)successBlock
                                                onFail:(erroBlock)errorBlock;


//24 获取项目详情
- (ZZLRequestOperation *)requestGetProjectDetailWithUid:(NSString *)uid
                                                  MissionID:(int)mid
                                                    onSuccess:(dictionaryBlock)successBlock
                                                       onFail:(erroBlock)errorBlock;






//25 报名或取消报名项目

- (ZZLRequestOperation *)requestProjectApplyWithUid:(NSString *)uid
                                          missionID:(int)mid
                                         applyOrNOT:(int)flag
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock;

//26 获取某个项目的班次
- (ZZLRequestOperation *)requestProjectGetClassListWithUid:(NSString *)uid
                                                 missionID:(int)mid
                                            missionStatues:(int)mstate
                                               serviceTime:(NSString *)stime
                                                  pageSize:(int)psize
                                                 pageIndex:(int)page
                                                 onSuccess:(dictionaryBlock)successBlock
                                                    onFail:(erroBlock)errorBlock;

//27 选择班次（报名班次）
- (ZZLRequestOperation *)requestProjectClassApplyWithUid:(NSString *)uid
                                                 classId:(int)classID
                                               onSuccess:(dictionaryBlock)successBlock
                                                  onFail:(erroBlock)errorBlock;

//28 任务签到
- (ZZLRequestOperation *)requestProjectMissionSiginWithUid:(NSString *)uid
                                                     curId:(NSString *)cid
                                                 missionID:(int)mid
                                                 onSuccess:(dictionaryBlock)successBlock
                                                    onFail:(erroBlock)errorBlock;




//29 任务签出
- (ZZLRequestOperation *)requestProjectMissionSiginOutWithUid:(NSString *)uid
                                                        curId:(NSString *)cid
                                                    missionID:(int)mid
                                                    onSuccess:(dictionaryBlock)successBlock
                                                       onFail:(erroBlock)errorBlock;

//30 手机客户端手动考勤
- (ZZLRequestOperation *)requestProjectMissionSiginWithMobileWithUid:(NSString *)uid
                                                               curId:(NSString *)cid
                                                           missionId:(int)mid
                                                              statue:(int)state
                                                         checkOnDate:(NSString *)date
                                                                hour:(int)h
                                                              minute:(int)m
                                                              teamId:(int)tid
                                                           onSuccess:(dictionaryBlock)successBlock
                                                              onFail:(erroBlock)errorBlock;

//31 搜索项目
- (ZZLRequestOperation *)requestSearchProjectListWithUid:(NSString *)uid
                                             isAllowJoin:(BOOL)canJoin
                                                   title:(NSString *)title
                                               startDate:(NSString *)sdate
                                                 endDate:(NSString *)endDate
                                             missionType:(int)mtype
                                                 arearId:(NSString *)areaId
                                          distributeDate:(int)dDate
                                                pageSize:(int)psize
                                               pageIndex:(int)page
                                               onSuccess:(dictionaryBlock)successBlock
                                                  onFail:(erroBlock)errorBlock;

//32 队长或管理员查看项目数量(管理员和队长权限)

- (ZZLRequestOperation *)reqeustManagerGetMissionCountWithUid:(NSString *)uid
                                                 missionState:(NSString *)state
                                                    onSuccess:(dictionaryBlock)successBlock
                                                       onFail:(erroBlock)errorBlock;


//33 队长或管理员查看项目列表(管理员和队长权限)
- (ZZLRequestOperation *)reqeustManagerGetMissionListWithUid:(NSString *)uid
                                                missionState:(NSString *)state
                                            managerCategory:(int)method
                                                    pageSize:(int)psize
                                                   pageIndex:(int)page
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock;

//34 获取项目的最高权限的考勤队伍
//考勤时要加载队伍列表，通过异步加载的形式，先加载项目中最高权限的队伍

- (ZZLRequestOperation *)requestHighestTeamWithUid:(NSString *)uid
                                         missionId:(int)mid
                                         onSuccess:(dictionaryBlock)successBlock
                                            onFail:(erroBlock)errorBlock;


//35 获取子队伍列表   加载队伍列表，根据上级队伍的ID获取下级队伍
- (ZZLRequestOperation *)requestChildTeamWithUid:(NSString *)uid
                                          teamId:(int)tid
                                        pageSize:(int)psize
                                       pageIndex:(int)page
                                       onSuccess:(dictionaryBlock)successBlock
                                          onFail:(erroBlock)errorBlock;


#pragma mark -  考勤
//36.统计队伍考勤待签到、待签出、未确认考勤、已确认考勤的人数

- (ZZLRequestOperation *)reqeustTeamAttendanceWithUid:(NSString *)uid
                                          checkOndate:(NSString *)date
                                            missionid:(int)mid
                                               teamId:(int)tid
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;

//37 获取队伍考勤待签到考勤的用户

- (ZZLRequestOperation *)requestTeamAttendanceWaitCheckListWithUid:(NSString *)uid
                                                       checkOnDate:(NSString *)date
                                                         missionid:(int)mid
                                                            teamID:(int)tid
                                                          pageSize:(int)psize
                                                         pageIndex:(int)page
                                                         onSuccess:(dictionaryBlock)successBlock
                                                            onFail:(erroBlock)errorBlock;
//38 获取队伍考勤待签出考勤的用户
- (ZZLRequestOperation *)requestTeamAttendanceWaitCheckOutListWithUid:(NSString *)uid
                                                          checkOnDate:(NSString *)date
                                                            missionid:(int)mid
                                                               teamID:(int)tid
                                                             pageSize:(int)psize
                                                            pageIndex:(int)page
                                                            onSuccess:(dictionaryBlock)successBlock
                                                               onFail:(erroBlock)errorBlock;

//39 获取队伍考勤未确认考勤、已确认考勤的用户
- (ZZLRequestOperation *)requestTeamAttendanceDidCheckOutWithUid:(NSString *)uid
                                                          checkOnDate:(NSString *)date
                                                            missionid:(int)mid
                                                               teamID:(int)tid
                                                             isUpdate:(int)isupdate
                                                             pageSize:(int)psize
                                                            pageIndex:(int)page
                                                            onSuccess:(dictionaryBlock)successBlock
                                                               onFail:(erroBlock)errorBlock;
//40 大队长确认/取消考勤
- (ZZLRequestOperation *)requestTeamAttendanceConfirmWithUid:(NSString *)uid
                                                   missionid:(int)mid
                                                      teamID:(int)tid
                                                    isUpdate:(int)isupdate
                                         missionServiceLogId:(int)msid
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock;

//41 删除考勤
- (ZZLRequestOperation *)requestTeamAttendanceDelWithUid:(NSString *)uid
                                               missionid:(int)mid
                                                  teamID:(int)tid
                                     missionServiceLogId:(int)msid
                                               onSuccess:(dictionaryBlock)successBlock
                                                  onFail:(erroBlock)errorBlock;


#pragma mark -  招募

//42 招募志愿者

- (ZZLRequestOperation *)requestRecruitUserWithUid:(NSString *)uid
                                          ugroupId:(NSString *)uuidss
                                         missionid:(int)mid
                                         onSuccess:(dictionaryBlock)successBlock
                                            onFail:(erroBlock)errorBlock;


//43 获取招募列表中已录用/未录用的志愿者人数
- (ZZLRequestOperation *)requestRecruitCountWithUid:(NSString *)uid
                                          missionid:(int)mid
                                           userName:(NSString *)userName
                                           moblieno:(NSString *)moblie
                                         selections:(NSString *)state
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock;

//44 获取招募列表中已录用/未录用的志愿者
- (ZZLRequestOperation *)requestRecruitListWithUid:(NSString *)uid
                                         missionid:(int)mid
                                          userName:(NSString *)userName
                                          moblieno:(NSString *)moblie
                                        selections:(NSString *)state
                                          pageSize:(int)psize
                                         pageIndex:(int)page
                                         onSuccess:(dictionaryBlock)successBlock
                                            onFail:(erroBlock)errorBlock;

//45 批量录用项目志愿者

- (ZZLRequestOperation *)requestRecruitHirePersonWithUid:(NSString *)uid
                                            personaIdGroups:(NSString *)idgroup
                                               missionId:(int)mid
                                               onSuccess:(dictionaryBlock)successBlock
                                                  onFail:(erroBlock)errorBlock;

//46 批量删除项目志愿者
- (ZZLRequestOperation *)requestRecruitDelPersonWithUid:(NSString *)uid
                                         personaIdGroups:(NSString *)idgroup
                                               missionId:(int)mid
                                               onSuccess:(dictionaryBlock)successBlock
                                                  onFail:(erroBlock)errorBlock;


#pragma mark -  班次
// 47   添加/更新班次计划 备注：班次ID为空的时候是新增班次，不为空是更新。
- (ZZLRequestOperation *)requestClassPlanWithUid:(NSString *)uid
                                       missionId:(int)mid
                                          planid:(int)pid
                                        planName:(NSString *)pname
                                        planType:(int)ptype
                                       recycleType:(int)rtype
                                        weekDays:(NSString *)wdays
                                       monthDays:(NSString *)mdays
                                       startTime:(NSString *)stime
                                         endTime:(NSString *)etime
                                       startDate:(NSString *)sdate
                                         endDate:(NSString *)edate
                                      countlimit:(int)limits
                                         caption:(NSString *)caption
                                       onSuccess:(dictionaryBlock)successBlock
                                          onFail:(erroBlock)errorBlock;
//48 删除班次计划

- (ZZLRequestOperation *)requestClassPlanDelWithUid:(NSString *)uid
                                             planId:(int)pid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock;

//49 关闭班次
- (ZZLRequestOperation *)requestClassPlanCloseWithUid:(NSString *)uid
                                             planId:(int)pid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock;

//50 添加（录用）班次志愿者
- (ZZLRequestOperation *)requestClassPlanAddPersonWithUid:(NSString *)uid
                                                  fightId:(NSString *)fid
                                             userGroupIds:(NSString *)gid
                                                onSuccess:(dictionaryBlock)successBlock
                                                   onFail:(erroBlock)errorBlock;
//51 删除班次志愿者
- (ZZLRequestOperation *)requestClassPlanDelPersonWithUid:(NSString *)uid
                                             planIds:(NSString *)gid
                                                onSuccess:(dictionaryBlock)successBlock
                                                   onFail:(erroBlock)errorBlock;
//52  获取班次志愿者列表

- (ZZLRequestOperation *)requestClassPlanGetVolunteerlistWithUid:(NSString *)uid
                                                          planid:(NSString *)pid
                                                        pageSize:(int)psize
                                                       pageIndex:(int)page
                                                       onSuccess:(dictionaryBlock)successBlock
                                                          onFail:(erroBlock)errorBlock;


//53 我要求助
- (ZZLRequestOperation *)requestClassPlanNeedHelpWithUid:(NSString *)uid
                                                    name:(NSString *)name
                                                    type:(NSString *)type
                                               startTime:(NSString *)stime
                                                   phone:(NSString *)phone
                                          VolunteerCount:(int)count
                                                   arear:(NSString *)arear
                                                 content:(NSString *)content
                                                  cardID:(NSString *)cid
                                                   eamil:(NSString *)eamil
                                            otherContact:(NSString *)ocontact
                                                 address:(NSString *)address
                                                  remark:(NSString *)remark
                                               onSuccess:(dictionaryBlock)successBlock
                                                  onFail:(erroBlock)errorBlock;

//54 自动生成班次

- (ZZLRequestOperation *)requestClassPlanAddPlanWithUid:(NSString *)uid
                                           opertionCode:(NSString *)ocode
                                              missionID:(NSString *)mid
                                              onSuccess:(dictionaryBlock)successBlock
                                                 onFail:(erroBlock)errorBlock;


// 55 查看自动生成班次
- (ZZLRequestOperation *)requestClassPlanCheckPlanWithUid:(NSString *)uid
                                           opertionCode:(NSString *)ocode
                                              missionID:(NSString *)mid
                                                 pageSize:(int)psize
                                                pageIndex:(int)page
                                                onSuccess:(dictionaryBlock)successBlock
                                                   onFail:(erroBlock)errorBlock;
// 56 更新班次

- (ZZLRequestOperation *)requestClassPlanUpdateWithUid:(NSString *)uid
                                             missionId:(int)mid
                                                planid:(int)pid
                                              planName:(NSString *)pname
                                              planType:(int)ptype
                                           recycleType:(int)rtype
                                              weekDays:(NSString *)wdays
                                             monthDays:(NSString *)mdays
                                             startTime:(NSString *)stime
                                               endTime:(NSString *)etime
                                             startDate:(NSString *)sdate
                                            countlimit:(int)limits
                                             onSuccess:(dictionaryBlock)successBlock
                                                onFail:(erroBlock)errorBlock;

//57 确认班次

- (ZZLRequestOperation *)requestClassPlanConfirmPlaneWithUid:(NSString *)uid
                                                opertionCode:(NSString *)ocode
                                                   missionID:(NSString *)mid
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock;


//58 删除班次
- (ZZLRequestOperation *)requestClassPlanDelPlaneWithUid:(NSString *)uid
                                                   planeID:(NSString *)mid
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock;

//59 搜索志愿者
- (ZZLRequestOperation *)requestSearchVolunteersWithUid:(NSString *)uid
                                              Rc4mobile:(NSString *)mobile
                                               userName:(NSString *)userName
                                             rc4IdcardCode:(NSString *)cid
                                                arearId:(NSString *)aid
                                              onSuccess:(dictionaryBlock)successBlock
                                                 onFail:(erroBlock)errorBlock;

//60 获取当天班次

- (ZZLRequestOperation *)requestClassPlanTodayPlaneWithUid:(NSString *)uid
                                                   missionID:(NSString *)mid
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock;


//61 获取班次计划
- (ZZLRequestOperation *)requestClassPlanPlaneListWithUid:(NSString *)uid
                                                missionID:(int)mid
                                                 pageSize:(int)psize
                                                pageIndex:(int)page
                                                onSuccess:(dictionaryBlock)successBlock
                                                   onFail:(erroBlock)errorBlock;
//62 保存授权码
- (ZZLRequestOperation *)requestSaveAuthorCodeWithUid:(NSString *)uid
                                          accesstoken:(NSString *)token
                                           expiredate:(NSString *)etime
                                             weibouid:(NSString *)wid
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;



#pragma mark -   搜索
// 63 获取下级区域地理树

- (ZZLRequestOperation *)requestGetCityListWithDistrictid:(NSString *)did
                                                     type:(int)type
                                                 pageSize:(int)psize
                                                pageIndex:(int)page
                                                onSuccess:(dictionaryBlock)successBlock
                                                   onFail:(erroBlock)errorBlock;



//64 查找项目类型

- (ZZLRequestOperation *)requestSearchProjectTypeWithDistrictid:(NSString *)did
                                                       pageSize:(int)psize
                                                      pageIndex:(int)page
                                                      onSuccess:(dictionaryBlock)successBlock
                                                         onFail:(erroBlock)errorBlock;

// 65 根据证件号搜索志愿者

- (ZZLRequestOperation *)requestSearchVolunteersByIDCardCodeWithUid:(NSString *)uid
                                                      rc4IdcardCode:(NSString *)code
                                                      missionTeamId:(NSString *)mid
                                                          onSuccess:(dictionaryBlock)successBlock
                                                             onFail:(erroBlock)errorBlock;







// 66 获取志愿资讯
- (ZZLRequestOperation *)requestGetVolunteerInfoWithPageSize:(int)psize
                                                   pageIndex:(int)page
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock;
/*!
 @abstract:取消一个请求操作
 @description:通常，在一个页面返回的时候 （若该请求还未完成，我们需要取消该请求）
 一般在控制器中 viewDidDisapper中调用
 @urlpath:对应请求(除掉host)的路径 如：（@"newmb.php/mbv2/homepage"）
 */
- (void)cancelRequestWithPath:(NSString *)urlpath;

/*!
 @abstract:取消所有请求操作
 @description:慎用!
 */
- (void)cancelAllRequest;
@end
