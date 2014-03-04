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
- (MKNetworkOperationState)postRequestWithServicePath:(NSString *)path
                                               params:(NSMutableDictionary *)params
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)aerrorBlock
{
    __block MKNetworkOperationState state = MKNetworkOperationStateReady;
    ZZLRequestOperation *op = [_requestPoolDict objectForKey:path];
    
    if (op == nil) {
        
        op = (ZZLRequestOperation *)[self operationWithPath:path params:params httpMethod:@"POST"];
        
        
        [op setUsername:SystemKey_Parameter_Value password:SystemValue_Parameter_Value basicAuth:NO];
        if (_accessToken) {
            [params setObject:_accessToken forKey:@"token"];
        }
        
        [params setObject:SystemKey_Parameter_Value forKey:@"systemKey"];
        [params setObject:SystemValue_Parameter_Value forKey:@"systemValue"];
        [_requestPoolDict setObject:op forKey:path];
        
        
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
            
            
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFinished;
            
            
            
            NSLog(@"URL--->:%@",op.url);
        } onError:^(NSError *error)
            {
            [ZZLHttpRequstEngine handleServerResponseError:error FailureBlock:aerrorBlock];
            
            [_requestPoolDict removeObjectForKey:path];
            state = MKNetworkOperationStateFailed;
                
            NSLog(@"URL--->:%@",op.url);
        }];
        [self enqueueOperation:op];
    }else
    {
        state = MKNetworkOperationStateExecuting;
    }
    return state;
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
    
    [self postRequestWithServicePath:LOGIN_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:LOGIN_URL];
    
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
    [self postRequestWithServicePath:REGISTER_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:REGISTER_URL];
    

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
    
    [self postRequestWithServicePath:USERINFO_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:USERINFO_URL];
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
    
    [self postRequestWithServicePath:PERSON_RANK_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:PERSON_RANK_URL];
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
    
    [self postRequestWithServicePath:SERVICE_LOG_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:SERVICE_LOG_URL];
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
    
    [self postRequestWithServicePath:URL9_GET_USER_WEIBO_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL9_GET_USER_WEIBO_URL];
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
    
    [self postRequestWithServicePath:URL10_WEIBO_FRIEND_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL10_WEIBO_FRIEND_URL];
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
    
    [self postRequestWithServicePath:URL11_WEIBO_GETCOMMENT_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL11_WEIBO_GETCOMMENT_URL];
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

    
    [self postRequestWithServicePath:URL12_WEIBO_COLLECTWEIBO_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL12_WEIBO_COLLECTWEIBO_URL];
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
    
    
    [self postRequestWithServicePath:URL13_WEIBO_DELWEIBO_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL13_WEIBO_DELWEIBO_URL];
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
    
    
    [self postRequestWithServicePath:URL14_WEIBO_UPLOADPIC_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL14_WEIBO_UPLOADPIC_URL];
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
    
    [self postRequestWithServicePath:URL15_WEIBO_SENDWEIBO_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL15_WEIBO_SENDWEIBO_URL];
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
    
    [self postRequestWithServicePath:URL16_WEIBO_SENDCOMMENT_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL16_WEIBO_SENDCOMMENT_URL];
}

//17 获取新浪是否已授权
- (ZZLRequestOperation *)requestWeiboIsAuthroedWithUid:(NSString *)uid
                                             onSuccess:(dictionaryBlock)successBlock
                                                onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];

    
    [self postRequestWithServicePath:URL17_WEIBO_SYNSINA_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL17_WEIBO_SYNSINA_URL];
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

    
    [self postRequestWithServicePath:URL18_WEIBO_SYNONETOSINA_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL18_WEIBO_SYNONETOSINA_URL];
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
    
    
    [self postRequestWithServicePath:URL19_WEIBO_GETPORTRAIN_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL19_WEIBO_GETPORTRAIN_URL];
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
    
    [self postRequestWithServicePath:USERINFO_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:USERINFO_URL];
}

//21 获取待审批、用户没有被录取项目数目（个人）
- (ZZLRequestOperation *)requestGetWaitCountWithUid:(NSString *)uid
                                          onSuccess:(dictionaryBlock)successBlock
                                             onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];

    
    [self postRequestWithServicePath:URL21_GETWAITCOUNT_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL21_GETWAITCOUNT_URL];
}
//22 获取任务(个人)

- (ZZLRequestOperation *)requestGetMissionlistWithUid:(NSString *)uid
                                         missionState:(int)mState
                                             pageSize:(int)psize
                                            pageIndex:(int)page
                                            onSuccess:(dictionaryBlock)successBlock
                                               onFail:(erroBlock)errorBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"currentUserId"];
    [dic setObject:[NSNumber numberWithInt:mState] forKey:@"missionState"];
    [dic setObject:[NSNumber numberWithInt:psize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageIndex"];
    
    [self postRequestWithServicePath:URL22_GETMISSIONLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL22_GETMISSIONLIST_URL];
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

    [self postRequestWithServicePath:URL23_GETMISSIONCOUNT_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL23_GETMISSIONCOUNT_URL];
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
    
    [self postRequestWithServicePath:URL24_GETMISSION_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL24_GETMISSION_URL];
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
    [self postRequestWithServicePath:URL25_APPLYMISSION_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL25_APPLYMISSION_URL];
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
    [self postRequestWithServicePath:URL26_GETFLIGHTLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL26_GETFLIGHTLIST_URL];
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
    [self postRequestWithServicePath:URL31_GETMISSION_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL31_GETMISSION_URL];
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
    [self postRequestWithServicePath:URL33_GETPROLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL33_GETPROLIST_URL];
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
    [self postRequestWithServicePath:URL_61_GETPLANLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL_61_GETPLANLIST_URL];
    
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
    [self postRequestWithServicePath:URL64_GETDISTRICTLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL64_GETDISTRICTLIST_URL];
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
    [self postRequestWithServicePath:URL65_GETDISTRICTLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL65_GETDISTRICTLIST_URL];
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
    
    [self postRequestWithServicePath:URL63_GETDISTRICTLIST_URL params:dic onSuccess:successBlock onFail:errorBlock];
    return [_requestPoolDict objectForKey:URL63_GETDISTRICTLIST_URL];
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
