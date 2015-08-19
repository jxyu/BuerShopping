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
#import "AddressManageViewController.h"
#import "DataProvider.h"

@interface DuihuanDetialViewController ()
@property(nonatomic,strong)AddressManageViewController * myaddressManager;
@end

@implementation DuihuanDetialViewController
{
    NSString * address_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"兑换详情";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightbuttontitle:@"取消"];
    _btn_duihuan.layer.masksToBounds=YES;
    _btn_duihuan.layer.cornerRadius=3;
    [_btn_duihuan addTarget:self action:@selector(duihuanFunction:) forControlEvents:UIControlEventTouchUpInside];
    _good_title.text=_goods_dict[@"pgoods_name"];
    _goodsDetial.text=_goods_dict[@"pgoods_body"];
    _goodsjifen.text=_goods_dict[@"pgoods_points"];
    [_Image_logo sd_setImageWithURL:[NSURL URLWithString:_goods_dict[@"pgoods_image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FinishSelectAddress:) name:@"select_address_for_duihuan" object:nil];
}

-(void)duihuanFunction:(UIButton *)sender
{
    if (address_id&&_userkey) {
        NSDictionary * prm=@{@"key":_userkey,@"pgoods_id":_goods_dict[@"pgoods_id"],@"address_id":address_id,@"pcart_message":_txt_message.text};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"DuihuanBackcall:"];
        [dataprovider DuihuanFunction:prm];
    }
}

-(void)DuihuanBackcall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"兑换成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)FinishSelectAddress:(NSNotification*) notification
{
    NSDictionary * addressInfo=[notification object];
    if (addressInfo) {
        address_id=addressInfo[@"address_id"];
        UIView * BackView_Address=[[UIView alloc] initWithFrame:_addaddressBackView.frame];
        BackView_Address.backgroundColor=[UIColor grayColor];
        UILabel * lbl_Address=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, BackView_Address.frame.size.width, 30)];
        lbl_Address.numberOfLines=2;
        lbl_Address.font=[UIFont systemFontOfSize:14];
        lbl_Address.text=[NSString stringWithFormat:@"地址：%@",addressInfo[@"address"]];
        lbl_Address.textColor=[UIColor whiteColor];
        [BackView_Address addSubview:lbl_Address];
        [self.view addSubview:BackView_Address];
    }
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
    _myaddressManager=[[AddressManageViewController alloc] init];
    _myaddressManager.userkey=_userkey;
    _myaddressManager.isfromDuihuan=YES;
    [self.navigationController pushViewController:_myaddressManager animated:YES];
}

@end
