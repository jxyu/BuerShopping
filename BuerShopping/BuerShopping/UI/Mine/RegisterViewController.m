//
//  RegisterViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/1.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "RegisterViewController.h"

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
}
-(void)clickLeftButton:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
