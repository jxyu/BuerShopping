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
#import "AppDelegate.h"
#import "LoginViewController.h"


@interface RegisterViewController ()
@property(nonatomic,strong)LoginViewController *myLogin;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=_viewTitle;
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
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
    [_Submit setTitle:_viewTitle forState:UIControlStateNormal];
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
        [SVProgressHUD showWithStatus:@"正在注册" maskType:SVProgressHUDMaskTypeBlack];
        if (_resetPwd) {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"resetPWDBackCall:"];
            NSDictionary * prm=@{@"mobile":_txt_PhoneNo.text,@"password":[_txt_pwd.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"verify_code":_txt_VerifyCode.text,@"client":@"ios"};
            [dataprovider ResetPwd:prm];
        }
        else
        {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"registerBackCall:"];
            NSDictionary * prm=@{@"mobile":_txt_PhoneNo.text,@"password":[_txt_pwd.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"verify_code":_txt_VerifyCode.text,@"client":@"ios"};
            [dataprovider RegisterUserInfo:prm];
            
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整数据" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)resetPWDBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    NSLog(@"%@",dict[@"datas"]);
    if ([dict[@"datas"] isEqual:@"1"]) {
        [self.navigationController popoverPresentationController];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)registerBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:_myLogin animated:YES];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
