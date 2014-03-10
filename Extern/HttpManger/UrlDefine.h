//
//  define.h
//  VolunteerApp
//
//  Created by 邹泽龙 on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#ifndef                              VolunteerApp_define_h
#define                              VolunteerApp_define_h


//http://59.41.39.98:443/VolunteerService/mobile/mission/getMissionList.action
//Url define

#define SystemKey_Parameter_Value    @"B5647DB7C490AF68E0F59682335275D4"
#define SystemValue_Parameter_Value  @"F828469B4A4150B3E9236694F42B5552"

//#define BASE_URL                    @"59.41.9.198:8096/VolunteerService"
#define BASE_URL                     @"59.41.39.98:443/VolunteerService"


#define IMAGE_URL                    @"http://125cn.net"
//1-5

#define LOGIN_URL                    @"visitor/mobileLogin.action"
#define USERINFO_URL                 @"mobile/userInfo.action"
#define REGISTER_URL                 @"visitor/mobileRegister.action"
#define PERSON_RANK_URL              @"mobile/personRank.action"
#define SERVICE_LOG_URL              @"mobile/queryServiceLog.action"

//6-10
#define SERVICE_COUNT_URL            @"mobile/serviceLogNum.action"
#define UPDATE_USER_INFO_URL         @"mobile/updateUser.action"
#define UPDATE_USER_PWD_URL          @"mobile/updatePwd.action"
#define URL9_GET_USER_WEIBO_URL      @"mobile/weibo/getWeiboById.action"
#define URL10_WEIBO_FRIEND_URL       @"mobile/weibo/getWeiboById_all.action"

//11-15
#define URL11_WEIBO_GETCOMMENT_URL   @"mobile/weibo/getReplyByWeiboId.action"
#define URL12_WEIBO_COLLECTWEIBO_URL @"mobile/weibo/collectWeibo.action"
#define URL13_WEIBO_DELWEIBO_URL     @"mobile/weibo/delWeibo.action"
#define URL14_WEIBO_UPLOADPIC_URL    @"mobile/weibo/WeiboNewImg.action"
#define URL15_WEIBO_SENDWEIBO_URL    @"mobile/weibo/newWeibo.action"
//16-20
#define URL16_WEIBO_SENDCOMMENT_URL  @"mobile/weibo/weiboReply.action"
#define URL17_WEIBO_SYNSINA_URL      @"mobile/weibo/isSynchSina.action"
#define URL18_WEIBO_SYNONETOSINA_URL @"mobile/weibo/synchOneToSina.action"
#define URL19_WEIBO_GETPORTRAIN_URL  @"mobile/weibo/getPortrain.action"


//21-25
#define URL21_GETWAITCOUNT_URL       @"mobile/mission/getWaitCount.action"
#define URL22_GETMISSIONLIST_URL     @"mobile/mission/getMissionList.action"
#define URL23_GETMISSIONCOUNT_URL    @"mobile/mission/getMissionCount.action"
#define URL24_GETMISSION_URL         @"visitor/getMission.action"
#define URL25_APPLYMISSION_URL       @"mobile/mission/applyMission.action"
//26-30
#define URL28_MISSIONSIGIN_URL       @"mobile/mission/mobileSignIn.action"
#define URL29_MISSIONSIGOUT_URL      @"mobile/mission/mobileSignOut.action"
#define URL26_GETFLIGHTLIST_URL      @"mobile/flight/getFlightList.action"

//31-35

#define URL33_GETPROLIST_URL         @"mobile/mission/getLeaderPersonalList.action"
#define URL31_GETMISSION_URL         @"visitor/findMissionList.action"
//36-40
//41-45
//46-50
//51-55
//56-60
//61-65
#define URL_61_GETPLANLIST_URL       @"mobile/flight/getFlightPlantList.action"
#define URL63_GETDISTRICTLIST_URL    @"visitor/getDistrictList.action"

#define URL64_GETDISTRICTLIST_URL    @"visitor/findMissionType.action"
#define URL65_GETDISTRICTLIST_URL    @"VolunteerService/mobile/findUsersByIdcard.action"
#endif
