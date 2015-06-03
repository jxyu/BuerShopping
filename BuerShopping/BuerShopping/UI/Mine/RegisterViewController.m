//
//  RegisterViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/1.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/CountryAndAreaCode.h>
#import "DataProvider.h"


@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"注册"];
//    [self addLeftButton:<#(NSString *)#>]
    // Do any additional setup after loading the view from its nib.
    _FirstView.layer.masksToBounds=YES;
    _FirstView.layer.cornerRadius=6;
    _VerifyBackView.layer.masksToBounds=YES;
    _VerifyBackView.layer.cornerRadius=6;
    _thirdView.layer.masksToBounds=YES;
    _thirdView.layer.cornerRadius=6;
    _GetVerifyCode.layer.masksToBounds=YES;
    _GetVerifyCode.layer.cornerRadius=6;
    _Submit.layer.masksToBounds=YES;
    _Submit.layer.cornerRadius=6;
    [_GetVerifyCode addTarget:self action:@selector(GetVerifyCodeFunc:) forControlEvents:UIControlEventTouchUpInside];
    [_Submit addTarget:self action:@selector(SubmitInfoToReg) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickLeftButton:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)GetVerifyCodeFunc:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"正在发送验证码..." maskType:SVProgressHUDMaskTypeBlack];
    if (_txt_PhoneNo.text.length==11) {
        [SMS_SDK getVerificationCodeBySMSWithPhone:_txt_PhoneNo.text
                                              zone:@"86"
                                            result:^(SMS_SDKError *error)
         {
             if (!error)
             {
                 [SVProgressHUD dismiss];
                 sender.enabled=NO;
                 sender.titleLabel.text=@"验证码已发送";
             }
             else
             {
                 [SVProgressHUD dismiss];
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                               message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
    }
}
-(void)SubmitInfoToReg
{
    if (_txt_PhoneNo.text.length==11&&_txt_VerifyCode.text&&_txt_pwd.text) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"registerBackCall:"];
        NSDictionary * prm=@{@"mobile":_txt_PhoneNo.text,@"password":[_txt_pwd.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"verify_code":_txt_VerifyCode.text,@"client":@"ios"};
        [dataprovider RegisterUserInfo:prm];
    }
}

-(void)registerBackCall:(id)dict
{
    NSLog(@"%@",dict);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
