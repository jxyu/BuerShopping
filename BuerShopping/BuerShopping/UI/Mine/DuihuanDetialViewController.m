//
//  DuihuanDetialViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DuihuanDetialViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface DuihuanDetialViewController ()

@end

@implementation DuihuanDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"兑换详情";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightbuttontitle:@"取消"];
    _btn_duihuan.layer.masksToBounds=YES;
    _btn_duihuan.layer.cornerRadius=3;
    
    _good_title.text=_goods_dict[@"pgoods_name"];
    _goodsDetial.text=_goods_dict[@"pgoods_body"];
    _goodsjifen.text=_goods_dict[@"pgoods_points"];
    [_Image_logo sd_setImageWithURL:[NSURL URLWithString:_goods_dict[@"pgoods_image"]] placeholderImage:[UIImage imageNamed:@"muying"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)clickRightButton:(UIButton *)sender
{
    [_txt_message resignFirstResponder];
}




- (IBAction)AddAddressClick:(id)sender {
}
@end
