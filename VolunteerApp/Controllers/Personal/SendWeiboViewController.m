//
//  SendWeiboViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-4.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "PersonalViewController.h"
@interface SendWeiboViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet UIImageView *mBgView;
@property (weak, nonatomic) IBOutlet UITextView *mTextView;
@property (weak, nonatomic) IBOutlet UIButton *msiginBtn;
@property (weak, nonatomic) IBOutlet UIButton *msignOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *mplaceHoldLb;
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
/*
- (IBAction)addImageBtn:(UIButton *)sender {
    
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        return;
    }
    //获得相机模式下支持的媒体类型
    NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL canTakePicture = NO;
    for (NSString* mediaType in availableMediaTypes) {
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
            //支持拍照
            canTakePicture = YES;
            break;
        }
    }
    //检查是否支持拍照
    if (!canTakePicture) {
        NSLog(@"sorry, taking picture is not supported.");
        return;
    }
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置图像选取控制器的类型为静态图像
    imagePickerController.mediaTypes = [[[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil] autorelease];
    //允许用户进行编辑
    imagePickerController.allowsEditing = YES;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
}

- (IBAction)shareBtn:(UIButton *)sender {
}


#pragma mark - image picker


- (IBAction)captureVideoButtonClick:(id)sender{
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable!!!");
        return;
    }
    //获得相机模式下支持的媒体类型
    NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL canTakeVideo = NO;
    for (NSString* mediaType in availableMediaTypes) {
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            //支持摄像
            canTakeVideo = YES;
            break;
        }
    }
    //检查是否支持摄像
    if (!canTakeVideo) {
        NSLog(@"sorry, capturing video is not supported.!!!");
        return;
    }
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置图像选取控制器的类型为动态图像
    imagePickerController.mediaTypes = [[[NSArray alloc] initWithObjects:(NSString*)kUTTypeMovie, nil] autorelease];
    //设置摄像图像品质
    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //设置最长摄像时间
    imagePickerController.videoMaximumDuration = 30;
    //允许用户进行编辑
    imagePickerController.allowsEditing = YES;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模式视图控制器的形式显示
    [self.flipboardNavigationController presentModalViewController:imagePickerController animated:YES];

    
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
    }
    else
    {
        NSLog(@"error occured while saving the picture%@", error);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //获取用户编辑之后的图像
        UIImage* editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //将该图像保存到媒体库中
        UIImageWriteToSavedPhotosAlbum(editedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
*/

- (void)actionSend:(UIButton *)btn
{
    UserInfo *user = [UserInfo share];
    [self.mTextView resignFirstResponder];
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
