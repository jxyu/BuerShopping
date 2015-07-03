//
//  GoodDetialViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/2.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "GoodDetialViewController.h"

@interface GoodDetialViewController ()

@end

@implementation GoodDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightButton:@"ShopCar_icon_goodslist@2x.png"];
    _lblTitle.text=@"产品详情";
    _lblTitle.textColor=[UIColor whiteColor];
//    [self InitAllView];
}

-(void)InitAllView
{
    UIView * backVeiw=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    backVeiw.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UIButton * btn_dianpu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0,backVeiw.frame.size.width/6, backVeiw.frame.size.height)];
    btn_dianpu.backgroundColor=[UIColor whiteColor];
    UIImageView * img_dianpuicon=[[UIImageView alloc] initWithFrame:CGRectMake((btn_dianpu.frame.size.width-20)/2, 5, 20, 20)];
    img_dianpuicon.image=[UIImage imageNamed:@"dianpu_gray_icon"];
    [btn_dianpu addSubview:img_dianpuicon];
    UILabel * lbl_dianpuTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, img_dianpuicon.frame.origin.y+img_dianpuicon.frame.size.height+10, btn_dianpu.frame.size.width, 15)];
    lbl_dianpuTitle.font=[UIFont systemFontOfSize:15];
    lbl_dianpuTitle.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    lbl_dianpuTitle.text=@"店铺";
    lbl_dianpuTitle.textAlignment=NSTextAlignmentCenter;
    [btn_dianpu addSubview:lbl_dianpuTitle];
    [backVeiw addSubview:btn_dianpu];
    UIButton * btn_shoucang=[[UIButton alloc] initWithFrame:CGRectMake(btn_dianpu.frame.size.width+1, 0, backVeiw.frame.size.width/6, backVeiw.frame.size.height)];
    UIImageView * img_shoucangicon=[[UIImageView alloc] initWithFrame:CGRectMake((btn_shoucang.frame.size.width-20)/2+1, 5, 20, 20)];
    img_shoucangicon.image=[UIImage imageNamed:@"star_gray_icon"];
    [btn_shoucang addSubview:img_shoucangicon];
    UILabel * lbl_shoucangTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, img_shoucangicon.frame.origin.y+img_shoucangicon.frame.size.height+10, btn_shoucang.frame.size.width, 15)];
    lbl_shoucangTitle.font=[UIFont systemFontOfSize:15];
    lbl_shoucangTitle.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    lbl_shoucangTitle.text=@"店铺";
    lbl_dianpuTitle.textAlignment=NSTextAlignmentCenter;
    [btn_shoucang addSubview:lbl_shoucangTitle];
    [backVeiw addSubview:btn_shoucang];
    UIButton * btn_AddToShoppingCar=[[UIButton alloc] initWithFrame:CGRectMake(btn_shoucang.frame.origin.x+btn_shoucang.frame.size.width, 0, backVeiw.frame.size.width/3, backVeiw.frame.size.height)];
    btn_AddToShoppingCar.backgroundColor=[UIColor colorWithRed:255/255.0 green:204/255.0 blue:1/255.0 alpha:1.0];
    btn_AddToShoppingCar.titleLabel.text=@"加入购物车";
    btn_AddToShoppingCar.titleLabel.textColor=[UIColor whiteColor];
    [backVeiw addSubview:btn_AddToShoppingCar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)PayforRightNow:(UIButton *)sender {
}

- (IBAction)AddToShoppingCarClick:(UIButton *)sender {
}
@end
