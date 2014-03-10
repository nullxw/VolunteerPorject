//
//  SendWeiboViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-4.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "PersonalViewController.h"
#import "AppDelegate.h"
#import "NSString+WiFi.h"
@interface SendWeiboViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,UIActionSheetDelegate>
{
    SinaWeibo   *weiBo;
    
    NSData      *imageData;

}

@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet UIImageView *mBgView;
@property (weak, nonatomic) IBOutlet UITextView *mTextView;
@property (weak, nonatomic) IBOutlet UIButton *msiginBtn;
@property (weak, nonatomic) IBOutlet UIButton *msignOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *mAddImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *mplaceHoldLb;
@property (weak, nonatomic) IBOutlet UIImageView *mSharePic;
- (IBAction)actionSigin:(UIButton *)sender;
- (IBAction)actionSigout:(UIButton *)sender;
- (IBAction)addImageBtn:(UIButton *)sender;
- (IBAction)shareBtn:(UIButton *)sender;
@end

@implementation SendWeiboViewController

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
    
    [self setTitleWithString:@"发表微博"];
    UIImage *bgImage = [[UIImage imageNamed:@"home_bg"]
                        stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.mBgView.image = bgImage;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(265, self.navView.bottom - 44, 46, 46);
    [btn setImage:[UIImage imageNamed:@"nav_complete.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(actionSend:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:btn];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    weiBo = delegate.weibo;
    weiBo.delegate = self;
    
    
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
#pragma mark - textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.mplaceHoldLb.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length>0) {
        self.mplaceHoldLb.hidden = YES;
    }else{
        self.mplaceHoldLb.hidden = NO;
    }
    
}
- (IBAction)actionSigin:(UIButton *)sender {
}

- (IBAction)actionSigout:(UIButton *)sender {
}

- (IBAction)addImageBtn:(UIButton *)sender {
    
    [self showActionSheet];
}




#pragma mark - image picker

#pragma mark - imagePickerDelegate
-(void)showActionSheet
{
    //[self hideAllActions];
    [self.mTextView resignFirstResponder];
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册上传", nil];
    actionSheet.delegate = self;
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:self.view];

}
//判断用户点击的是摄像头还是相册
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init]; //初始化图片选择器
    imagePicker.delegate = (id)self;
    switch (buttonIndex) {
            //选择摄像头拍照
        case 0:
            NSLog(@"摄像头");
            //判断设备是否有拍照功能
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }
            else {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
            
            //选择相册
        case 1:
            NSLog(@"相册");
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        default:
            break;
    }

}
//拍照或选择照片成功后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        //如果是摄像头
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            UIImage * picture = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            [self performSelector:@selector(saveImage:) withObject:picture ];
            
        }
        //如果是相册选取
        else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
        {
            UIImage * picture = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            [self performSelector:@selector(saveImage:) withObject:picture ];
        }
    }];
    
    
}
- (void)saveImage:(UIImage *)image
{
    
    [self.view showHudMessage:@"图片处理中..."];
    UIImage *scaleImage = [self scaleImage:image toScale:0.5];
    
    //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
    
    //将图片转换为JPG格式的二进制数据
    imageData = UIImageJPEGRepresentation(scaleImage, 0.5);
    
    //将二进制数据生成UIImage
    image = [UIImage imageWithData:imageData];
    
    self.mSharePic.image = image;
    self.mSharePic.hidden = NO;
    self.mSharePic.alpha = 0;
    self.mSharePic.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.5 animations:^{
        self.mSharePic.alpha = 1.0;
        self.mSharePic.transform = CGAffineTransformIdentity;
    }];


    
}
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (IBAction)shareBtn:(UIButton *)sender {
    [self sendWeiBo];
}
//发表微博
-(void)sendWeiBo
{
    
    
    [self.mTextView resignFirstResponder];
    
    NSString * text = self.mTextView.text;
    
    
    if ([weiBo isAuthValid]){
        //如果字数在1-140字以内,便可发送微博
        if (text.length<140 && text.length >0) {
            //发起请求
            [weiBo requestWithURL:@"statuses/upload.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   text, @"status",
                                   self.mSharePic.image, @"pic", nil]
                       httpMethod:@"POST"
                         delegate:self];
            
            [self.view showLoadingViewWithString:@"正在发布"];
            
            NSLog(@"确认发送");
            
        }
        if (text.length > 140) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的字数超出限制了哟！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            
        }
    }
    
    //如果微博账号过期或未登陆,让用户首先登陆
    else {
        [weiBo logOut];
        [weiBo logIn];
        NSLog(@"重新登录");
    }
}

//登陆成功调用的代理方法
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"登录成功");
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token",nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self sendWeiBo];
}

-(void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"新浪微博错误 %@",error);
    
    [sinaweibo logOut];
    [sinaweibo logIn];
}
-(void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"微博用户已退出");
}

//登陆失败的调用代理方法
-(void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"登陆失败%@",error);
    
    [self.view hideLoadingView];
    
}
- (void)actionSend:(UIButton *)btn
{
    UserInfo *user = [UserInfo share];
    [self.mTextView resignFirstResponder];
    
    if (self.mSharePic.image) {
        [[ZZLHttpRequstEngine engine]requestWeiboUploadImageWithUid:user.userId image:imageData onSuccess:^(id responseObject) {
            NSLog(@"《》＊＊＊《》上传照片%@",responseObject);
        } onFail:^(NSError *erro) {
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        }];
    }
    [self.view showLoadingViewWithString:@"正在发布..."];
    

    [[ZZLHttpRequstEngine engine]requestSendNewWeiboWithUid:user.userId content:self.mTextView.text weiboimage:@"" synchSinaWeibo:NO onSuccess:^(id responseObject) {
        NSString *msg = responseObject;
        NSLog(@"\n=================\n send weibo !!!!%@",responseObject);
        [self.view hideLoadingView];
        [self.view showHudMessage:msg];
        [self.flipboardNavigationController popViewControllerWithCompletion:^{

        }];
    } onFail:^(NSError *erro) {
        [self.view hideLoadingView];
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}

@end
