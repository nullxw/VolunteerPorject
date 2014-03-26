//
//  ZZLHttpRequstEngine.m
//  MyEngineProject
//
//  Created by zelong zou on 13-9-1.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import "ZZLHttpRequstEngine.h"
#import "Reachability.h"
#include "OpenUDID.h"
#import "NSString+WiFi.h"
#include "UrlDefine.h"
typedef enum
{
    NETWORK_UNCONNECT_ERROR=9001,//没有连接网络
    NETWORK_EXCEPTION = 9002,//网络连接异常
    NETWORK_REQUEST_TIMEOUT = 9003, //网络连接超时
    DATA_IS_NOT_DICTIONARY = 9004,
    DATA_REQUEST_FAILURE = 9005
    
} NETWORK_ERROR;

#define ERROR_NETWORK_UNCONNECT_DESC        @"网络不可用，请检查！"
#define ERROR_NETWORK_EXCEPTION_DESC        @"获取信息失败，请重试!"
#define ERROR_NETWORK_REQUEST_TIMEOUT_DESC  @"网络连接超时, 请重试!"
#define ERROR_DATA_IS_NOT_DICTIONARY        @"请求失败，请重试!"
#define ERROR_DATA_REQUEST_FAILURE          @"请求失败，请重试!"

static ZZLHttpRequstEngine *httpRequestEngine = nil;


@implementation ZZLHttpRequstEngine

+ (id)engine
{
    if (httpRequestEngine == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{

            httpRequestEngine = [[ZZLHttpRequstEngine alloc]initWithHostName:BASE_URL];
            
        });
    }
    return httpRequestEngine;
}
#pragma mark -  init
- (id)initWithHostName:(NSString *)hostName
{
    if (self = [super initWithHostName:hostName]) {
        _requestPoolDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return self;
}
#pragma mark - add accessToken
-(NSString*) accessToken
{
    if(!_accessToken)
    {

        _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessTokenDefaultsKey];

    }
    
    return _accessToken;
}
-(void) setAccessToken:(NSString *) aAccessToken
{

    if (!aAccessToken) {
        return;
    }
    _accessToken = aAccessToken;

    
    // if you are going to have multiple accounts support,
    // it's advisable to store the access token as a serialized object
    // this code will break when a second RESTfulEngine object is instantiated and a new token is issued for him
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessTokenDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) prepareHeaders:(MKNetworkOperation *)operation {
    
    // this inserts a header like ''Authorization = Token blahblah''
    if(self.accessToken)
        [operation setAuthorizationHeaderValue:self.accessToken forAuthType:@"Token"];
    
    [super prepareHeaders:operation];
}
#pragma mark - 
#pragma mark - handle error response
+ (NSError *)CheckNetworkConnection
{
    
    NSInteger status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        NSError *err=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:NETWORK_UNCONNECT_ERROR userInfo:
                      [NSDictionary dictionaryWithObjectsAndKeys:ERROR_NETWORK_UNCONNECT_DESC,@"description", nil]];
        return err;
    }
    return nil;
}

+ (void)handleServerResponseError:(NSError *)error FailureBlock:(erroBlock)failure
{
    if (failure) {
        //检查网络连接
        NSError *networkError = [self CheckNetworkConnection];
        if (networkError) {

            failure(networkError);
            return ;
        }else{
            if (error && [error.domain isEqualToString:@"NSURLErrorDomain"]) {
                if (error.code == NSURLErrorTimedOut) {
                    NSError *err=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:NETWORK_UNCONNECT_ERROR userInfo:
                                  [NSDictionary dictionaryWithObjectsAndKeys:ERROR_NETWORK_REQUEST_TIMEOUT_DESC,@"description", nil]];

                        failure(err);
                    
                    
                }else
                {
                    NSError *err=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:NETWORK_UNCONNECT_ERROR userInfo:
                                  [NSDictionary dictionaryWithObjectsAndKeys:ERROR_NETWORK_EXCEPTION_DESC,@"description", nil]];
                 
                        failure(err);
                    
                }
            }
        }
    }
}
#pragma mark - general request
-(MKNetworkOperationState)requestWithServicePath:(NSString *)path
                                       onSuccess:(objectBlock)successBlock
                                          onFail:(erroBlock)errorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    if (op == nil) {
        op = (ZZLRequestOperation *)[self operationWithPath:path];
        [_requestPoolDict setObject:op forKey:path];
        
        NSLog(@"dict:%@",_requestPoolDict);
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            //原始数据
            id object  = [completedOperation responseJSON];
            
            if (successBlock) {
                successBlock(object);
            }
            
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;

        } onError:^(NSError *error) {
            
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:errorBlock];
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;

        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }

    return state;
}
- (MKNetworkOperationState)requestSingleModelWithServicePath:(NSString *)path
                                                    keyPaths:(NSArray *)keyPath
                                                  modelClass:(Class)className
                                                   onSuccess:(modelBlock)successBlock
                                                      onFail:(erroBlock)errorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    if (op == nil) {
        op = (ZZLRequestOperation *)[self operationWithPath:path];
        [_requestPoolDict setObject:op forKey:path];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            //原始数据
            id object  = [completedOperation responseJSON];
            ZZLBaseJsonObject *modelObject = nil;
            if ([object isKindOfClass:[NSDictionary class]]) {
                
                //求出键的深度
                NSUInteger keyDeeps = 0;
                if (keyPath !=nil) {
                    keyDeeps = [keyPath count];
                    for (int i=0; i<keyDeeps; i++) {
                        if ([[object allKeys]containsObject:keyPath[i]]) {
                            object = [object objectForKey:keyPath[i]];
                        }else
                        {
                            NSLog(@"[该字典不存在键值:%@]",keyPath[i]);
                        }
                    }
                    object = (NSDictionary *)object;
                }
                modelObject= [ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:object];
                
                if (successBlock) {
                    successBlock(modelObject);
                }
                
                
            }else{
                
                if (successBlock) {
                    successBlock(nil);
                }
                
            }
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
        } onError:^(NSError *error) {
            
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:errorBlock];

            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;
        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }
    
    return state;
}


- (MKNetworkOperationState)requestModelListWithServicePath:(NSString *)path
                                                keyPaths:(NSArray *)keyPath
                                              modelClass:(Class)className
                                               onSuccess:(arrayBlock)successBlock
                                                  onFail:(erroBlock)errorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    if (op == nil) {
        op = (ZZLRequestOperation *)[self operationWithPath:path];
        [_requestPoolDict setObject:op forKey:path];
        
        [op onCompletion:^(MKNetworkOperation *completedOperation) {
            
            //原始数据
            id object  = [completedOperation responseJSON];
            if ([object isKindOfClass:[NSDictionary class]]) {
                
                //求出键的深度
                NSUInteger keyDeeps = 0;
                
                NSMutableArray *ModelList =[NSMutableArray array];
                if (keyPath !=nil) {
                    keyDeeps = [keyPath count];
                    for (int i=0; i<keyDeeps; i++) {
                        if ([[object allKeys]containsObject:keyPath[i]]) {
                            object = [object objectForKey:keyPath[i]];
                        }else
                        {
                            NSLog(@"[该字典不存在键值:%@]",keyPath[i]);
                        }
                    
                    }
                    object = (NSMutableArray *)object;
                    
                    [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [ModelList addObject:[ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:obj]];
                    }];
                    

                }else
                {
                    //返回只有一个对象的列表
                    [ModelList addObject:[ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:object]];
                }
                
                if (successBlock) {
                    successBlock(ModelList);
                }
                
                
            }else if ([object isKindOfClass:[NSArray class]])
            {
                NSMutableArray *ModelList =[NSMutableArray array];
                [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [ModelList addObject:[ZZLModalObjectFactory ModalObjectWithClass:className jsonDictionary:obj]];
                }];
                if (successBlock) {
                    successBlock(ModelList);
                }
                
                
            }else
            {
                if (successBlock) {
                    successBlock(nil);
                }
                
            }
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
        } onError:^(NSError *error) {
            
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:errorBlock];

            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;
        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }
    
    return state;

}
- (NSString *)urlstr:(NSString *)url param:(NSMutableDictionary *)dic
{
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSString *key in [dic allKeys] ) {
        [str appendString:[NSString stringWithFormat:@"%@ = %@&",key,[dic valueForKey:key]]];
    }

    return [NSString stringWithFormat:@"%@?%@",url,str];
}
#pragma mark - post request
- (ZZLRequestOperation *)postRequestWithServicePath:(NSString *)path
                                               params:(NSMutableDictionary *)params
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)aerrorBlock
{

    
    
   
        
        ZZLRequestOperation *op = (ZZLRequestOperation *)[self operationWithPath:path params:params httpMethod:@"POST"];
        
        
        [op setUsername:SystemKey_Parameter_Value password:SystemValue_Parameter_Value basicAuth:NO];
        if (_accessToken) {
            [params setObject:_accessToken forKey:@"token"];
        }
        
        [params setObject:SystemKey_Parameter_Value forKey:@"systemKey"];
        [params setObject:SystemValue_Parameter_Value forKey:@"systemValue"];

        
        
        [op onCompletion:^(MKNetworkOperation *completedOperation)
        {
            NSLog(@"<<>>url:%@",[self urlstr:completedOperation.url param:params]);
            NSMutableDictionary *responseDict = [completedOperation responseJSON];
            if ([responseDict isKindOfClass:[NSDictionary class]])
            {
                
                NSString *status = [responseDict objectForKey:@"status"];
                
                if ([status isEqualToString:@"OK"])
                {
                    if ([[responseDict allKeys] containsObject:@"dataList"]) {

                        id obj = [responseDict objectForKey:@"dataList"];
                        if ([obj isKindOfClass:[NSArray class]]) {//多个数据对象
                            NSArray *array = (NSArray *)obj;
                            if (successBlock)
                            {
                                successBlock(array);
                            }
                        }else if([obj isKindOfClass:[NSDictionary class]]){// 单个数据对象
                            NSDictionary *dic = (NSDictionary *)obj;
                            if (successBlock)
                            {
                                successBlock(dic);
                            }
                        }
                        

                        

                    }else if ([[responseDict allKeys] containsObject:@"data"])
                    {
                        id obj= [responseDict objectForKey:@"data"];
                        if (successBlock)
                        {
                            successBlock(obj);
                        }

                    }
                    else if ([[responseDict allKeys] containsObject:@"msg"])
                    {
                        id obj= [responseDict objectForKey:@"msg"];
                        if (successBlock)
                        {
                            successBlock(obj);
                        }
                        
                    }else
                    {
                        
                        
                        if (aerrorBlock) {
                            NSError *anerr=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:DATA_REQUEST_FAILURE userInfo:
                                           [NSDictionary dictionaryWithObjectsAndKeys:ERROR_DATA_REQUEST_FAILURE,@"description", nil]];
                            aerrorBlock(anerr);
                        }

                    }
                    
                    
                    
                }else if([status isEqualToString:@"ERROR"])
                {
                    if (aerrorBlock) {
                        
                        NSString *erroMsg = [responseDict objectForKey:@"msg"];
                        NSError *anerr=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:DATA_REQUEST_FAILURE userInfo:
                                        [NSDictionary dictionaryWithObjectsAndKeys:erroMsg,@"description", nil]];
                        aerrorBlock(anerr);
                    }

                }
            }
            
            
            


            
            
            
            NSLog(@"URL--->:%@",op.url);
        } onError:^(NSError *error)
            {
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:aerrorBlock];
            


                
            NSLog(@"URL--->:%@",op.url);
        }];
        [self enqueueOperation:op];
    
    return op;
}


- (ZZLRequestOperation *)postRequestNoTokenWithServicePath:(NSString *)path
                                             params:(NSMutableDictionary *)params
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)aerrorBlock
{
    
    
    
    
    
    ZZLRequestOperation *op = (ZZLRequestOperation *)[self operationWithPath:path params:params httpMethod:@"POST"];
    
    
    [op setUsername:SystemKey_Parameter_Value password:SystemValue_Parameter_Value basicAuth:NO];

    [params setObject:SystemKey_Parameter_Value forKey:@"systemKey"];
    [params setObject:SystemValue_Parameter_Value forKey:@"systemValue"];
    
    
    
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         NSLog(@"<<>>url:%@",[self urlstr:completedOperation.url param:params]);
         NSMutableDictionary *responseDict = [completedOperation responseJSON];
         if ([responseDict isKindOfClass:[NSDictionary class]])
         {
             
             NSString *status = [responseDict objectForKey:@"status"];
             
             if ([status isEqualToString:@"OK"])
             {
                 if ([[responseDict allKeys] containsObject:@"dataList"]) {
                     
                     id obj = [responseDict objectForKey:@"dataList"];
                     if ([obj isKindOfClass:[NSArray class]]) {//多个数据对象
                         NSArray *array = (NSArray *)obj;
                         if (successBlock)
                         {
                             successBlock(array);
                         }
                     }else if([obj isKindOfClass:[NSDictionary class]]){// 单个数据对象
                         NSDictionary *dic = (NSDictionary *)obj;
                         if (successBlock)
                         {
                             successBlock(dic);
                         }
                     }
                     
                     
                     
                     
                 }else if ([[responseDict allKeys] containsObject:@"data"])
                 {
                     id obj= [responseDict objectForKey:@"data"];
                     if (successBlock)
                     {
                         successBlock(obj);
                     }
                     
                 }
                 else if ([[responseDict allKeys] containsObject:@"msg"])
                 {
                     id obj= [responseDict objectForKey:@"msg"];
                     if (successBlock)
                     {
                         successBlock(obj);
                     }
                     
                 }else
                 {
                     
                     
                     if (aerrorBlock) {
                         NSError *anerr=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:DATA_REQUEST_FAILURE userInfo:
                                         [NSDictionary dictionaryWithObjectsAndKeys:ERROR_DATA_REQUEST_FAILURE,@"description", nil]];
                         aerrorBlock(anerr);
                     }
                     
                 }
                 
                 
                 
             }else if([status isEqualToString:@"ERROR"])
             {
                 if (aerrorBlock) {
                     
                     NSString *erroMsg = [responseDict objectForKey:@"msg"];
                     NSError *anerr=[NSError errorWithDomain:@"ZZLHttpRequest.engine" code:DATA_REQUEST_FAILURE userInfo:
                                     [NSDictionary dictionaryWithObjectsAndKeys:erroMsg,@"description", nil]];
                     aerrorBlock(anerr);
                 }
                 
             }
         }
         
         
         
         
         
         
         
         
         NSLog(@"URL--->:%@",op.url);
     } onError:^(NSError *error)
     {
         [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:aerrorBlock];
         
         
         
         
         NSLog(@"URL--->:%@",op.url);
     }];
    [self enqueueOperation:op];
    
    return op;
}
#pragma mark - custom request
//login

- (ZZLRequestOperation *)loginWithUserName:(NSString *)userName
                                  password:(NSString *)psd
                                 onSuccess:(dictionaryBlock)successBlock
                                    onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[OpenUDID value] stringByEncodeingRC4] forKey:@"machineCode"];
    [dic setObject:userName forKey:@"loginName"];
    [dic setObject:[psd stringByEncodeingRC4] forKey:@"userPwd"];
    
    return [self postRequestWithServicePath:LOGIN_URL params:dic onSuccess:successBlock onFail:errorBlock];

    
}
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
                                                   onFail:(erroBlock)errorBlock
{
    //    userVo.idcardType
    //    userVo.idcardCode
    //    userVo.userName
    //    userVo.userPwd
    //    userVo.gender
    //    userVo.email
    //    userVo.mobile
    //    userVo.areaId
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"userVo.idcardType"];
    [dic setObject:[code stringByEncodeingRC4] forKey:@"userVo.idcardCode"];
    [dic setObject:uname forKey:@"userVo.userName"];
    [dic setObject:[pwd stringByEncodeingRC4] forKey:@"userVo.userPwd"];
    [dic setObject:[NSNumber numberWithInt:gender] forKey:@"userVo.gender"];
    [dic setObject:[email stringByEncodeingRC4] forKey:@"userVo.email"];
    [dic setObject:[mobile stringByEncodeingRC4] forKey:@"userVo.mobile"];
    [dic setObject:aid forKey:@"userVo.areaId"];
    return [self postRequestWithServicePath:REGISTER_URL params:dic onSuccess:successBlock onFail:errorBlock];

    

}
//3获取用户基本信息

- (ZZLRequestOperation *)requestUserGetUserInfoWithUid:(NSString *)uid
                                                 curid:(NSString *)cid
                                             onSuccess:(dictionaryBlock)successBlock
                                                onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:cid forKey:@"userId"];
    
    return [self postRequestWithServicePath:USERINFO_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
//4 个人排名
- (ZZLRequestOperation *)requestPersonalRankWithUid:(NSString *)uid
                                           otherUid:(NSString *)oid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:oid forKey:@"userId"];
    
    return [self postRequestWithServicePath:PERSON_RANK_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
//5 获取服务记录
- (ZZLRequestOperation *)requestServiceLogWithUid:(NSString *)uid
                                         otherUid:(NSString *)oid
                                        isUpdated:(BOOL)isupdated
                                        pageIndex:(int)page
                                         pageSize:(int)psize
                                        missionId:(int)mid
                                        onSuccess:(dictionaryBlock)successBlock
                                           onFail:(erroBlock)errorBlock
{
    /*
     userId
     currentUserId
     isUpdated
     pageIndex
     pageSize
     missionId
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:oid forKey:@"userId"];
    [dic setObject:[NSNumber numberWithBool:isupdated] forKey:@"isUpdated"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    
    return [self postRequestWithServicePath:SERVICE_LOG_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
//7 修改用户基本信息

- (ZZLRequestOperation *)requestUpdateUserInfoWithUid:(NSString *)uid
                                             userName:(NSString *)uname
                                               gender:(int)genderIndex
                                             Rc4email:(NSString *)email
                                            Rc4mobile:(NSString *)moblie
                                              areadId:(NSString *)areaid
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:genderIndex] forKey:@"userVo.gender"];
    [dic setObject:uname forKey:@"userVo.userName"];
    [dic setObject:[email stringByDeCodeingRC4] forKey:@"userVo.userPwdNew"];
    [dic setObject:[moblie stringByDeCodeingRC4] forKey:@"userVo.userPwdNew"];
    [dic setObject:areaid forKey:@"userVo.areaId"];
//    userVo. userName
//    userVo. gender
//    userVo. email
//    userVo. mobile
//    userVo. areaId
    return [self postRequestWithServicePath:UPDATE_USER_INFO_URL params:dic onSuccess:successBlock onFail:errorBlock];
}


//8 修改密码
- (ZZLRequestOperation *)requestUpdatePwdWithUid:(NSString *)uid
                                       Rc4oldPwd:(NSString *)opwd
                                       Rc4newPwd:(NSString*)npwd
                                       onSuccess:(dictionaryBlock)successBlock
                                          onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];

    [dic setObject:[opwd stringByEncodeingRC4]  forKey:@"userVo.userPwd"];
    [dic setObject:[npwd stringByEncodeingRC4] forKey:@"userVo.userPwdNew"];

    
    return [self postRequestWithServicePath:UPDATE_USER_PWD_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
//9 获取用户微博
- (ZZLRequestOperation *)requestGetWeiboWithUid:(NSString *)uid
                                          curid:(NSString *)cid
                                       pageSize:(int)psize
                                      pageIndex:(int)page
                                     createTime:(NSString *)dataTime
                                      onSuccess:(dictionaryBlock)successBlock
                                         onFail:(erroBlock)errorBlock
{
    /*
     userId
     currentUserId
     pageSize
     pageIndex
     createTime
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:cid forKey:@"userId"];
    [dic setObject:dataTime forKey:@"createTime"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    
    return [self postRequestWithServicePath:URL9_GET_USER_WEIBO_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//10 获取好友的微博
- (ZZLRequestOperation *)requestGetFriendWeiboWithUid:(NSString *)uid
                                                curid:(NSString *)cid
                                             pageSize:(int)psize
                                            pageIndex:(int)page
                                           createTime:(NSString *)dataTime
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:cid forKey:@"userId"];
    [dic setObject:dataTime forKey:@"createTime"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    
    return [self postRequestWithServicePath:URL10_WEIBO_FRIEND_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//11 获取微博评论
- (ZZLRequestOperation *)requestGetWeiboReplyWithUid:(NSString *)uid
                                             weiboId:(NSString *)wid
                                            pageSize:(int)psize
                                           pageIndex:(int)page
                                          createTime:(NSString *)dataTime
                                           onSuccess:(dictionaryBlock)successBlock
                                              onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:wid forKey:@"weiboId"];
    [dic setObject:dataTime forKey:@"createTime"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    
    return [self postRequestWithServicePath:URL11_WEIBO_GETCOMMENT_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//12 收藏微博
- (ZZLRequestOperation *)requestCollectWeiboWithUid:(NSString *)uid
                                            weiboId:(NSString *)wid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:wid forKey:@"weiboId"];

    
    return [self postRequestWithServicePath:URL12_WEIBO_COLLECTWEIBO_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//13 删除微博
- (ZZLRequestOperation *)requestDelWeiboWithUid:(NSString *)uid
                                        weiboId:(NSString *)wid
                                      onSuccess:(dictionaryBlock)successBlock
                                         onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:wid forKey:@"weiboId"];
    
    
    return [self postRequestWithServicePath:URL13_WEIBO_DELWEIBO_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//14 微博图片上传
- (ZZLRequestOperation *)requestWeiboUploadImageWithUid:(NSString *)uid
                                                  image:(NSData *)imageData
                                              onSuccess:(dictionaryBlock)successBlock
                                                 onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:imageData forKey:@"image"];
    
    
    return [self postRequestWithServicePath:URL14_WEIBO_UPLOADPIC_URL params:dic onSuccess:successBlock onFail:errorBlock];
 
}
//15 提交微博
- (ZZLRequestOperation *)requestSendNewWeiboWithUid:(NSString *)uid
                                            content:(NSString *)content
                                         weiboimage:(NSString *)imagePath
                                     synchSinaWeibo:(BOOL)synch
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:imagePath forKey:@"weiboImg"];
    [dic setObject:[NSNumber numberWithBool:synch] forKey:@"synch_sina"];
    
    return [self postRequestWithServicePath:URL15_WEIBO_SENDWEIBO_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
//16 提交评论
- (ZZLRequestOperation *)requestWeiboCommentWithUid:(NSString *)uid
                                            content:(NSString *)content
                                            weiboId:(NSString *)wid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:wid forKey:@"weiboId"];
    [dic setObject:content forKey:@"content"];
    
    return [self postRequestWithServicePath:URL16_WEIBO_SENDCOMMENT_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//17 获取新浪是否已授权
- (ZZLRequestOperation *)requestWeiboIsAuthroedWithUid:(NSString *)uid
                                             onSuccess:(dictionaryBlock)successBlock
                                                onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];

    
    return [self postRequestWithServicePath:URL17_WEIBO_SYNSINA_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//18 同步单条记录到新浪
- (ZZLRequestOperation *)requestWeiboSynchOneToSinaWithUid:(NSString *)uid
                                                   weiboId:(NSString *)wid
                                                 onSuccess:(dictionaryBlock)successBlock
                                                    onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:wid forKey:@"weiboId"];

    
    return [self postRequestWithServicePath:URL18_WEIBO_SYNONETOSINA_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//19 获取个人空间头像（微博头像）
- (ZZLRequestOperation *)requestGetUserAvatorWithUid:(NSString *)uid
                                               curid:(NSString *)cid
                                           onSuccess:(dictionaryBlock)successBlock
                                              onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:cid forKey:@"userId"];
    
    
    return [self postRequestWithServicePath:URL19_WEIBO_GETPORTRAIN_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
#pragma mark - 项目相关
//20 获取待审批、用户没有被录取的项目列表（个人）
- (ZZLRequestOperation *)requestGetWaitListWithUid:(NSString *)uid
                                          pageSize:(int)psize
                                         pageIndex:(int)page
                                         onSuccess:(dictionaryBlock)successBlock
                                            onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    
    return [self postRequestWithServicePath:USERINFO_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

//21 获取待审批、用户没有被录取项目数目（个人）
- (ZZLRequestOperation *)requestGetWaitCountWithUid:(NSString *)uid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];

    
    return [self postRequestWithServicePath:URL21_GETWAITCOUNT_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
//22 获取任务(个人)

- (ZZLRequestOperation *)requestGetMissionlistWithUid:(NSString *)uid
                                            selection:(int)sel
                                         missionState:(int)mState
                                             pageSize:(int)psize
                                            pageIndex:(int)page
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:sel] forKey:@"selection"];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mState] forKey:@"missionState"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    
    return [self postRequestWithServicePath:URL22_GETMISSIONLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];

}


//23 获取任务数目(个人)
- (ZZLRequestOperation *)requestGetMissionCountWithUid:(NSString *)uid
                                          missionState:(NSString *)state
                                             onSuccess:(dictionaryBlock)successBlock
                                                onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:state forKey:@"missionState"];

    return [self postRequestWithServicePath:URL23_GETMISSIONCOUNT_URL params:dic onSuccess:successBlock onFail:errorBlock];
    
}


//24 获取项目详情
- (ZZLRequestOperation *)requestGetProjectDetailWithUid:(NSString *)uid
                                              MissionID:(int)mid
                                              onSuccess:(dictionaryBlock)successBlock
                                                 onFail:(erroBlock)errorBlock;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    
    return [self postRequestWithServicePath:URL24_GETMISSION_URL params:dic onSuccess:successBlock onFail:errorBlock];
    
}

//25 报名或取消报名项目

- (ZZLRequestOperation *)requestProjectApplyWithUid:(NSString *)uid
                                          missionID:(int)mid
                                         applyOrNOT:(int)flag
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:[NSNumber numberWithInt:flag] forKey:@"flag"];
    return [self postRequestWithServicePath:URL25_APPLYMISSION_URL params:dic onSuccess:successBlock onFail:errorBlock];
    
}

//26 获取某个项目的班次
- (ZZLRequestOperation *)requestProjectGetClassListWithUid:(NSString *)uid
                                                 missionID:(int)mid
                                            missionStatues:(int)mstate
                                               serviceTime:(NSString *)stime
                                                  pageSize:(int)psize
                                                 pageIndex:(int)page
                                                 onSuccess:(dictionaryBlock)successBlock
                                                    onFail:(erroBlock)errorBlock
{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:stime forKey:@"serviceTime"];
    [dic setObject:[NSNumber numberWithInt:mstate] forKey:@"status"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    return  [self postRequestWithServicePath:URL26_GETFLIGHTLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];
    
}

//28 任务签到
- (ZZLRequestOperation *)requestProjectMissionSiginWithUid:(NSString *)uid
                                                     curId:(NSString *)cid
                                                 missionID:(int)mid
                                                 onSuccess:(dictionaryBlock)successBlock
                                                    onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:cid forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    
    return  [self postRequestWithServicePath:URL28_MISSIONSIGIN_URL params:dic onSuccess:successBlock onFail:errorBlock];
}




//29 任务签出
- (ZZLRequestOperation *)requestProjectMissionSiginOutWithUid:(NSString *)uid
                                                        curId:(NSString *)cid
                                                    missionID:(int)mid
                                                    onSuccess:(dictionaryBlock)successBlock
                                                       onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:cid forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    
    return  [self postRequestWithServicePath:URL29_MISSIONSIGOUT_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
//get movie list
/*
-(ZZLRequestOperation *)requestMovieListOnSuccess:(arrayBlock)successBlock
                                           OnFail:(erroBlock)erroBlock
{

    ZZLRequestOperation *op = (ZZLRequestOperation *)[self operationWithPath:HOME_PAGE_URL];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDictionary = [completedOperation responseJSON];
        NSMutableArray *movielistJson = [[responseDictionary objectForKey:@"hot"]objectForKey:@"movie_list"];
        NSMutableArray *movielistItems = [NSMutableArray array];
        [movielistJson enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [movielistItems addObject:[ZZLModalObjectFactory ModalObjectWithType:kMovieList jsonDictionary:obj]];
        } ];
        if (successBlock) {
            successBlock(movielistItems);
        }
        
    } onError:^(NSError *error) {
        [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:erroBlock];
        
    }];
    [self enqueueOperation:op];
    return op;
}
 
 
 */
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
                                                              onFail:(erroBlock)errorBlock
{
    /*currentUserId
     userId
     missionId
     statue
     checkOnDate
     hour
     minute
     teamId*/
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:cid forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:[NSNumber numberWithInt:state] forKey:@"statue"];
    [dic setObject:date forKey:@"checkOnDate"];
    [dic setObject:[NSNumber numberWithInt:h] forKey:@"hour"];
    [dic setObject:[NSNumber numberWithInt:m] forKey:@"minute"];
    [dic setObject:[NSNumber numberWithInt:tid] forKey:@"teamId"];
    return [self postRequestWithServicePath:URL30_mobileSign_URL params:dic onSuccess:successBlock onFail:errorBlock];
}

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
                                                  onFail:(erroBlock)errorBlock
{
    
//    missionView. subject
//    missionView. startDate
//    missionView. endDate
//    missionType
//    districtId
//    findDate
//    pageIndex
//    pageSize
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithBool:canJoin] forKey:@"missionView.isAllowJoin"];
    [dic setObject:sdate forKey:@"missionView.startDate"];
    [dic setObject:endDate forKey:@"missionView.endDate"];
    [dic setObject:[NSNumber numberWithInt:mtype] forKey:@"missionType"];
    [dic setObject:[NSNumber numberWithInt:dDate] forKey:@"findDate"];
    [dic setObject:areaId forKey:@"districtId"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL31_GETMISSION_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
//33 
- (ZZLRequestOperation *)reqeustManagerGetMissionListWithUid:(NSString *)uid
                                                missionState:(NSString *)state
                                             managerCategory:(int)method
                                                    pageSize:(int)psize
                                                   pageIndex:(int)page
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock
{
    
//    token
//    currentUserId
//    missionState
//    method
//    pageIndex
//    pageSize
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:state forKey:@"missionState"];
    [dic setObject:[NSNumber numberWithInt:method] forKey:@"method"];

    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL33_GETPROLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];

}


//34 获取项目的最高权限的考勤队伍
//考勤时要加载队伍列表，通过异步加载的形式，先加载项目中最高权限的队伍

- (ZZLRequestOperation *)requestHighestTeamWithUid:(NSString *)uid
                                         missionId:(int)mid
                                         onSuccess:(dictionaryBlock)successBlock
                                            onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"teamVo._missionId"];
    
    return [self postRequestWithServicePath:URL34_highestTeam_URL params:dic onSuccess:successBlock onFail:errorBlock];
}


//35 获取子队伍列表   加载队伍列表，根据上级队伍的ID获取下级队伍
- (ZZLRequestOperation *)requestChildTeamWithUid:(NSString *)uid
                                          teamId:(int)tid
                                        pageSize:(int)psize
                                       pageIndex:(int)page
                                       onSuccess:(dictionaryBlock)successBlock
                                          onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];

    [dic setObject:[NSNumber numberWithInt:tid] forKey:@"teamVo._teamPid"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL35_childTeam_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
//36.统计队伍考勤待签到、待签出、未确认考勤、已确认考勤的人数

- (ZZLRequestOperation *)reqeustTeamAttendanceWithUid:(NSString *)uid
                                          checkOndate:(NSString *)date
                                            missionid:(int)mid
                                               teamId:(int)tid
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"serviceLogVo._missionId"];
    [dic setObject:date forKey:@"serviceLogVo._checkOnDate"];
    [dic setObject:[NSNumber numberWithInt:tid] forKey:@"teamId"];

    return [self postRequestWithServicePath:URL36_queryCheckOutNum_URL params:dic onSuccess:successBlock onFail:errorBlock];
}

//37 获取队伍考勤待签到考勤的用户

- (ZZLRequestOperation *)requestTeamAttendanceWaitCheckListWithUid:(NSString *)uid
                                                       checkOnDate:(NSString *)date
                                                         missionid:(int)mid
                                                            teamID:(int)tid
                                                          pageSize:(int)psize
                                                         pageIndex:(int)page
                                                         onSuccess:(dictionaryBlock)successBlock
                                                            onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"serviceLogVo._missionId"];
    [dic setObject:date forKey:@"serviceLogVo._checkOnDate"];
    [dic setObject:[NSNumber numberWithInt:tid] forKey:@"teamId"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL37_waitCheckInList_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
//38 获取队伍考勤待签出考勤的用户
- (ZZLRequestOperation *)requestTeamAttendanceWaitCheckOutListWithUid:(NSString *)uid
                                                          checkOnDate:(NSString *)date
                                                            missionid:(int)mid
                                                               teamID:(int)tid
                                                             pageSize:(int)psize
                                                            pageIndex:(int)page
                                                            onSuccess:(dictionaryBlock)successBlock
                                                               onFail:(erroBlock)errorBlock
{
    
    /*
     currentUserId
     serviceLogVo._checkOnDate
     serviceLogVo._missionId
     pageIndex
     pageSize*/
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"serviceLogVo._missionId"];
    [dic setObject:date forKey:@"serviceLogVo._checkOnDate"];
    [dic setObject:[NSNumber numberWithInt:tid] forKey:@"teamId"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL38_waitCheckOutList_URL params:dic onSuccess:successBlock onFail:errorBlock];
}

//39 获取队伍考勤未确认考勤、已确认考勤的用户
- (ZZLRequestOperation *)requestTeamAttendanceDidCheckOutWithUid:(NSString *)uid
                                                     checkOnDate:(NSString *)date
                                                       missionid:(int)mid
                                                          teamID:(int)tid
                                                        isUpdate:(int)isupdate
                                                        pageSize:(int)psize
                                                       pageIndex:(int)page
                                                       onSuccess:(dictionaryBlock)successBlock
                                                          onFail:(erroBlock)errorBlock
{
    /*currentUserId
     serviceLogVo._checkOnDate
     serviceLogVo._missionId
     serviceLogVo.isUpdated
     pageIndex
     pageSize
     teamId*/
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"serviceLogVo._missionId"];
    [dic setObject:date forKey:@"serviceLogVo._checkOnDate"];
    [dic setObject:[NSNumber numberWithInt:tid] forKey:@"teamId"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:isupdate] forKey:@"serviceLogVo.isUpdated"];
    return [self postRequestWithServicePath:URL39_waitIsSureCheck_URL params:dic onSuccess:successBlock onFail:errorBlock];
}

//40 大队长确认/取消考勤
- (ZZLRequestOperation *)requestTeamAttendanceConfirmWithUid:(NSString *)uid
                                                   missionid:(int)mid
                                                      teamID:(int)tid
                                                    isUpdate:(int)isupdate
                                         missionServiceLogId:(NSString *)msid
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock
{
    /*currentUserId
     missionId
     missionServiceLogIds
     serviceLogVo.isUpdated
     teamId*/
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:msid forKey:@"missionServiceLogIds"];
    [dic setObject:[NSNumber numberWithInt:tid] forKey:@"teamId"];
    [dic setObject:[NSNumber numberWithInt:isupdate] forKey:@"serviceLogVo.isUpdated"];
    return [self postRequestWithServicePath:URL40_updateServiceLog_URL params:dic onSuccess:successBlock onFail:errorBlock];
    
}

//41 删除考勤
- (ZZLRequestOperation *)requestTeamAttendanceDelWithUid:(NSString *)uid
                                               missionid:(int)mid
                                                  teamID:(int)tid
                                     missionServiceLogId:(NSString *)msid
                                               onSuccess:(dictionaryBlock)successBlock
                                                  onFail:(erroBlock)errorBlock
{
    /*currentUserId
     missionId
     missionServiceLogIds
     teamId*/
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:msid forKey:@"missionServiceLogIds"];
    [dic setObject:[NSNumber numberWithInt:tid] forKey:@"teamId"];
    
    return [self postRequestWithServicePath:URL41_delSeviceLog_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
//42 招募志愿者

- (ZZLRequestOperation *)requestRecruitUserWithUid:(NSString *)uid
                                          ugroupId:(NSString *)uuidss
                                         missionid:(int)mid
                                         onSuccess:(dictionaryBlock)successBlock
                                            onFail:(erroBlock)errorBlock
{
    //currentUserId
//    uuidss
//    missionId
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:uuidss forKey:@"uuidss"];

    return [self postRequestWithServicePath:URL42_GETPERSONL_URL params:dic onSuccess:successBlock onFail:errorBlock];
}


//43 获取招募列表中已录用/未录用的志愿者人数
- (ZZLRequestOperation *)requestRecruitCountWithUid:(NSString *)uid
                                          missionid:(int)mid
                                           userName:(NSString *)userName
                                           moblieno:(NSString *)moblie
                                         selections:(NSString *)state
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"personalVo.mission_id"];
    [dic setObject:userName forKey:@"personalVo.userName"];
    [dic setObject:moblie forKey:@"personalVo.mobile"];
    [dic setObject:state forKey:@"selections"];
    return [self postRequestWithServicePath:URL43_GETPERSONL_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
//44 获取招募列表中已录用/未录用的志愿者
- (ZZLRequestOperation *)requestRecruitListWithUid:(NSString *)uid
                                         missionid:(int)mid
                                          userName:(NSString *)userName
                                          moblieno:(NSString *)moblie
                                        selections:(NSString *)state
                                          pageSize:(int)psize
                                         pageIndex:(int)page
                                         onSuccess:(dictionaryBlock)successBlock
                                            onFail:(erroBlock)errorBlock
{
    
    /*currentUserId
    personalVo. mission_id
    personalVo. userName
    personalVo. mobile
    selections
    pageSize
    pageIndex
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"personalVo.mission_id"];
    [dic setObject:userName forKey:@"personalVo.userName"];
    [dic setObject:moblie forKey:@"personalVo.mobile"];
    [dic setObject:state forKey:@"selections"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL44_GETPERSONL_URL params:dic onSuccess:successBlock onFail:errorBlock];
}

//45 批量录用项目志愿者

- (ZZLRequestOperation *)requestRecruitHirePersonWithUid:(NSString *)uid
                                         personaIdGroups:(NSString *)idgroup
                                               missionId:(int)mid
                                               onSuccess:(dictionaryBlock)successBlock
                                                  onFail:(erroBlock)errorBlock
{
    
    /*
     currentUserId
     personalIds
     missionId
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:idgroup forKey:@"personalIds"];
    
    return [self postRequestWithServicePath:URL45_GETPERSONL_URL params:dic onSuccess:successBlock onFail:errorBlock];
}

//46 批量删除项目志愿者
- (ZZLRequestOperation *)requestRecruitDelPersonWithUid:(NSString *)uid
                                        personaIdGroups:(NSString *)idgroup
                                              missionId:(int)mid
                                              onSuccess:(dictionaryBlock)successBlock
                                                 onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:idgroup forKey:@"personalIds"];
    
    return [self postRequestWithServicePath:URL46_GETPERSONL_URL params:dic onSuccess:successBlock onFail:errorBlock];
}

//59 搜索志愿者
- (ZZLRequestOperation *)requestSearchVolunteersWithUid:(NSString *)uid
                                              Rc4mobile:(NSString *)mobile
                                               userName:(NSString *)userName
                                          rc4IdcardCode:(NSString *)cid
                                                arearId:(NSString *)aid
                                              onSuccess:(dictionaryBlock)successBlock
                                                 onFail:(erroBlock)errorBlock
{
    /*currentUserId
     users.mobile
     users.userName
     users.idcardCode
     districtId*/
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[mobile stringByEncodeingRC4] forKey:@"users.mobile"];
    [dic setObject:userName forKey:@"users.userName"];
    [dic setObject:[cid stringByEncodeingRC4] forKey:@"users.idcardCode"];
    [dic setObject:aid forKey:@"districtId"];
    
    return [self postRequestWithServicePath:URL59_SEARCHVOLUNTEER_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
//61 获取班次计划
- (ZZLRequestOperation *)requestClassPlanPlaneListWithUid:(NSString *)uid
                                                missionID:(int)mid
                                                 pageSize:(int)psize
                                                pageIndex:(int)page
                                                onSuccess:(dictionaryBlock)successBlock
                                                   onFail:(erroBlock)errorBlock
{
//    currentUserId
//    missionId
//    pageSize
//    pageIndex
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mid] forKey:@"missionId"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL_61_GETPLANLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];

    
}
#pragma mark -   搜索

//64 查找项目类型

- (ZZLRequestOperation *)requestSearchProjectTypeWithDistrictid:(NSString *)did
                                                       pageSize:(int)psize
                                                      pageIndex:(int)page
                                                      onSuccess:(dictionaryBlock)successBlock
                                                         onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:did forKey:@"districtId"];

    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL64_GETDISTRICTLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];

}

// 65 根据证件号搜索志愿者

- (ZZLRequestOperation *)requestSearchVolunteersByIDCardCodeWithUid:(NSString *)uid
                                                      rc4IdcardCode:(NSString *)code
                                                      missionTeamId:(NSString *)mid
                                                          onSuccess:(dictionaryBlock)successBlock
                                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[code stringByEncodeingRC4] forKey:@"idcardCode"];
    [dic setObject:mid forKey:@"missionTeamId"];
    return [self postRequestWithServicePath:URL65_GETDISTRICTLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
// 63 获取下级区域地理树

- (ZZLRequestOperation *)requestGetCityListWithDistrictid:(NSString *)did
                                                     type:(int)type
                                                 pageSize:(int)psize
                                                pageIndex:(int)page
                                                onSuccess:(dictionaryBlock)successBlock
                                                   onFail:(erroBlock)errorBlock;
{
//    districtId
//    pageSize
//    pageIndex
//    地市: 8e9715d3444dd11701444dd446fa0008
//    行业：8e9715d3444dd11701444dd461fa0009
//    高校：8e9715d3444dd11701444dd47e12000a
    NSString *str;
    if (type == 0) {
        str = @"8e9715d3444dd11701444dd446fa0008";
    }else if (type == 1)
    {
        str  = @"8e9715d3444dd11701444dd461fa0009";
    }else if (type == 2)
    {
        str = @"8e9715d3444dd11701444dd47e12000a";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:str forKey:@"districtId"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    
    return [self postRequestWithServicePath:URL63_GETDISTRICTLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];

}
// 66 获取志愿资讯
- (ZZLRequestOperation *)requestGetVolunteerInfoWithPageSize:(int)psize
                                                   pageIndex:(int)page
                                                   onSuccess:(dictionaryBlock)successBlock
                                                      onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    return [self postRequestWithServicePath:URL66_GETVOLUNINFO_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
//67 手机用户密码更改效验码
- (ZZLRequestOperation *)requestCheckAccountWithIdcardCode:(NSString *)cardCode onSuccess:(dictionaryBlock)successBlock
                                                    onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:cardCode forKey:@"idcardCode"];
    return [self postRequestWithServicePath:URL67_GETVOLUNINFO_URL params:dic onSuccess:successBlock onFail:errorBlock];
}

//68 手机用户密码更改
- (ZZLRequestOperation *)requestUpdatePwdbyUserId:(NSString *)uid password:(NSString *)pwd surePassword:(NSString *)spwd onSuccess:(dictionaryBlock)successBlock
                                           onFail:(erroBlock)errorBlock
{
    
    //userId
//    password
//    surePassword
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"userId"];
    [dic setObject:pwd forKey:@"password"];
    [dic setObject:spwd forKey:@"surePassword"];
    return [self postRequestWithServicePath:URL68_GETVOLUNINFO_URL params:dic onSuccess:successBlock onFail:errorBlock];
}
#pragma mark - cancel request
- (void)cancelRequestWithPath:(NSString *)urlpath
{
    if ([[_requestPoolDict allKeys] containsObject:urlpath]) {
        ZZLRequestOperation *op = [_requestPoolDict objectForKey:urlpath];
        [op cancel];
        NSLog(@"url request:%@ was canceled",op.url);
        [_requestPoolDict removeObjectForKey:urlpath];

    }
}
- (void)cancelAllRequest
{
    if ([_requestPoolDict count]>0) {
        [_requestPoolDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            ZZLRequestOperation *op = obj;
            [op cancel];
        }];
        [_requestPoolDict removeAllObjects];
    }
}


@end
