//
//  MineViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "MineViewController.h"
#import "AppDelegate.h"
#import "CommenDef.h"
#import "UIImageView+WebCache.h"
#import "DataProvider.h"
#import "VPImageCropperViewController.h"
#import "AddressManageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "JifenDetialViewController.h"
#import "PurseViewController.h"
#import "OrderListViewController.h"
#import "WXViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f


@interface MineViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
@property (nonatomic, strong) UIImageView *portraitImageView;
@property(nonatomic,strong)AddressManageViewController * myAddressManager;
@property(nonatomic,strong)JifenDetialViewController * myjifenDetial;
@end

@implementation MineViewController
{
    NSDictionary* userinfoWithFile;
    NSString * nickName;
    UILabel * lbl_jifeneveryday;
    UILabel * lbl_qiandaoBack;
    BOOL isLogin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"我的海淘";
    _lblTitle.textColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"Login_success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ExistSuccess) name:@"Exit_success" object:nil];
    
    [self LoadDataUserInfo];
    [self initAllTheView];
}
-(void)LoadDataUserInfo
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@",userinfoWithFile);
}
-(void)initAllTheView
{
    _TableView_Mine.delegate=self;
    _TableView_Mine.dataSource=self;
    if (userinfoWithFile[@"key"]) {
        [self BuildHeaderViewAfterLogin];
        nickName=userinfoWithFile[@"username"];
        isLogin=YES;
    }
    else
    {
        isLogin=NO;
        nickName=@"";
        [self addRightbuttontitle:@"注册"];
        UIView * myHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 205)];
        myHeaderView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/25.0 alpha:1.0];
        UIImageView * img_Back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myHeaderView.frame.size.width, 110)];
        [img_Back sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"my_title_bg"]];
        [myHeaderView addSubview:img_Back];
        UIButton * btn_login=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-250, img_Back.frame.size.height-30, 105, 20)];
        [btn_login setTitle:@"登录" forState:UIControlStateNormal];
        [btn_login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_login.backgroundColor=[UIColor whiteColor];
        [btn_login addTarget:self action:@selector(Btn_LoginClick) forControlEvents:UIControlEventTouchUpInside];
        btn_login.layer.masksToBounds=YES;
        btn_login.titleLabel.font=[UIFont systemFontOfSize:13];
        btn_login.layer.cornerRadius=3;
        [myHeaderView addSubview:btn_login];
        UIButton * btn_showOrder=[[UIButton alloc] initWithFrame:CGRectMake(btn_login.frame.origin.x+btn_login.frame.size.width+10, btn_login.frame.origin.y, 75, 20)];
        btn_showOrder.layer.masksToBounds=YES;
        btn_showOrder.backgroundColor=[UIColor whiteColor];
        [btn_showOrder.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 128/255.0, 100/255.0, 154/255.0, 1.0 });
        [btn_showOrder.layer setBorderColor:colorref]; //边框颜色
        btn_showOrder.layer.cornerRadius=3;
        btn_showOrder.imageView.frame=CGRectMake(0, 0, 5, 5);
        [btn_showOrder setImage:[UIImage imageNamed:@"showorder_icon"] forState:UIControlStateNormal];
        [btn_showOrder setTitle:@"  晒单圈" forState:UIControlStateNormal];
        btn_showOrder.titleLabel.font=[UIFont systemFontOfSize:13];
        [btn_showOrder addTarget:self action:@selector(Btn_ShowOrderClick) forControlEvents:UIControlEventTouchUpInside];
        [btn_showOrder setTitleColor:[UIColor colorWithRed:115/255.0 green:73/255.0 blue:139/255.0 alpha:1.0] forState:UIControlStateNormal];
        [myHeaderView addSubview:btn_showOrder];
        
        
        UIImageView * img_touxiang=[[UIImageView alloc] initWithFrame:CGRectMake(18, img_Back.frame.size.height-35, 50, 50)];
        [img_touxiang sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"head_icon_placeholder"]];
        img_touxiang.layer.masksToBounds=YES;
        img_touxiang.layer.cornerRadius=25;
        [myHeaderView addSubview:img_touxiang];
        
        UILabel * lbl_tishi=[[UILabel alloc] initWithFrame:CGRectMake(80, img_Back.frame.origin.y+img_Back.frame.size.height+5, SCREEN_WIDTH-80, 20)];
        lbl_tishi.text=@"每一天，我们都在期待新的不二朋友";
        lbl_tishi.textColor=[UIColor grayColor];
        lbl_tishi.font=[UIFont systemFontOfSize:13];
        [myHeaderView addSubview:lbl_tishi];
        UIView * BackHeaderViewbottom=[[UIView alloc] initWithFrame:CGRectMake(10, lbl_tishi.frame.origin.y+lbl_tishi.frame.size.height+6, SCREEN_WIDTH-20, 60)];
        BackHeaderViewbottom.layer.masksToBounds=YES;
        BackHeaderViewbottom.backgroundColor=[UIColor whiteColor];
        [BackHeaderViewbottom.layer setBorderWidth:1.0]; //边框宽度
        CGColorRef colorref1 = CGColorCreate(colorSpace,(CGFloat[]){ 212/255.0, 190/255.0, 224/255.0, 1.0 });
        [BackHeaderViewbottom.layer setBorderColor:colorref1]; //边框颜色
        BackHeaderViewbottom.layer.cornerRadius=3;
        UIView * BackView_qianbao=[[UIView alloc] initWithFrame:CGRectMake(0, 0, BackHeaderViewbottom.frame.size.width/3, BackHeaderViewbottom.frame.size.height)];
        UILabel * lbl_priceNum=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, BackView_qianbao.frame.size.width, 20)];
        lbl_priceNum.text=@"¥0.00";
        lbl_priceNum.textColor=[UIColor orangeColor];
        lbl_priceNum.font=[UIFont systemFontOfSize:15];
        lbl_priceNum.textAlignment=NSTextAlignmentCenter;
        [BackView_qianbao addSubview:lbl_priceNum];
        UILabel * lbl_backViewTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, BackView_qianbao.frame.size.width, 20)];
        lbl_backViewTitle.text=@"我的钱包";
        lbl_backViewTitle.textAlignment=NSTextAlignmentCenter;
        lbl_backViewTitle.font=[UIFont systemFontOfSize:15];
        [BackView_qianbao addSubview:lbl_backViewTitle];
        [BackHeaderViewbottom addSubview:BackView_qianbao];
        UIView * fengeView=[[UIView alloc] initWithFrame:CGRectMake(BackView_qianbao.frame.size.width, 10, 1, 40)];
        fengeView.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        [BackHeaderViewbottom addSubview:fengeView];
        [myHeaderView addSubview:BackHeaderViewbottom];
        UIView * BackView_jifen=[[UIView alloc] initWithFrame:CGRectMake(fengeView.frame.origin.x+1, 0, BackHeaderViewbottom.frame.size.width/3-15, BackHeaderViewbottom.frame.size.height)];
        UILabel * lbl_jifenNum=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, BackView_jifen.frame.size.width, 20)];
        lbl_jifenNum.text=@"0";
        lbl_jifenNum.font=[UIFont systemFontOfSize:15];
        lbl_jifenNum.textAlignment=NSTextAlignmentCenter;
        lbl_jifenNum.textColor=[UIColor orangeColor];
        [BackView_jifen addSubview:lbl_jifenNum];
        UILabel * lbl_jifenTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, BackView_jifen.frame.size.width, 20)];
        lbl_jifenTitle.text=@"积分";
        lbl_jifenTitle.font=[UIFont systemFontOfSize:15];
        lbl_jifenTitle.textAlignment=NSTextAlignmentCenter;
        [BackView_jifen addSubview:lbl_jifenTitle];
        [BackHeaderViewbottom addSubview:BackView_jifen];
        UIView * BackView_qiandao=[[UIView alloc] initWithFrame:CGRectMake(BackView_jifen.frame.origin.x+BackView_jifen.frame.size.width, 0, BackHeaderViewbottom.frame.size.width/3+15, BackHeaderViewbottom.frame.size.height)];
        lbl_jifeneveryday=[[UILabel alloc] initWithFrame:CGRectMake(2, 1, 30, 30)];
        lbl_jifeneveryday.layer.masksToBounds=YES;
        lbl_jifeneveryday.layer.cornerRadius=15;
        lbl_jifeneveryday.text=@"+5";
        lbl_jifeneveryday.textAlignment=NSTextAlignmentCenter;
        lbl_jifeneveryday.backgroundColor=[UIColor colorWithRed:243/255.0 green:152/255.0 blue:1/255.0 alpha:1.0];
        lbl_jifeneveryday.textColor=[UIColor whiteColor];
        lbl_qiandaoBack=[[UILabel alloc] initWithFrame:CGRectMake(0, (BackView_qiandao.frame.size.height-32)/2, BackView_qiandao.frame.size.width+32, 32)];
        lbl_qiandaoBack.layer.masksToBounds=YES;
        lbl_qiandaoBack.text=@"签到送积分      ";
        lbl_qiandaoBack.layer.cornerRadius=16;
        lbl_qiandaoBack.font=[UIFont systemFontOfSize:13];
        lbl_qiandaoBack.textAlignment=NSTextAlignmentCenter;
        lbl_qiandaoBack.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        lbl_qiandaoBack.layer.borderWidth=1;
        lbl_qiandaoBack.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]);
        [lbl_qiandaoBack addSubview:lbl_jifeneveryday];
        [BackView_qiandao addSubview:lbl_qiandaoBack];
        [BackHeaderViewbottom addSubview:BackView_qiandao];
        [_TableView_Mine setTableHeaderView:myHeaderView];
        
        UIView*view =[ [UIView alloc]init];
        view.backgroundColor= [UIColor clearColor];
        [_TableView_Mine setTableFooterView:view];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellheight=60;
    switch (indexPath.section) {
        case 0:
            cellheight=60;
            break;
        case 1:
            cellheight=30;
            break;
        case 2:
            cellheight=30;
            break;
        case 3:
            cellheight=30;
            break;
        case 4:
            cellheight=30;
            break;
        default:
            break;
    }
    return cellheight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat cellheight=95;
    switch (indexPath.section) {
        case 0:
            cellheight=60;
            break;
        case 1:
            cellheight=30;
            break;
        case 2:
            cellheight=30;
            break;
        case 3:
            cellheight=30;
            break;
        case 4:
            cellheight=30;
            break;
        default:
            break;
    }
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, cellheight)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UIView * BackView_SpecialPrice=[[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, cellheight)];
    BackView_SpecialPrice.backgroundColor=[UIColor whiteColor];
    BackView_SpecialPrice.layer.masksToBounds=YES;
    BackView_SpecialPrice.layer.cornerRadius=3;
    [BackView_SpecialPrice.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){  212/255.0, 190/255.0, 224/255.0, 1.0 });
    [BackView_SpecialPrice.layer setBorderColor:colorref]; //边框颜色
    switch (indexPath.section) {
        case 0:
        {
            UIView * FirstBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width/4, BackView_SpecialPrice.frame.size.height)];
            FirstBackView.backgroundColor=[UIColor whiteColor];
            UIImageView * img_icon1=[[UIImageView alloc] initWithFrame:CGRectMake((FirstBackView.frame.size.width-18)/2, 10, 18, 18)];
            img_icon1.image=[UIImage imageNamed:@"first_icon"];
            [FirstBackView addSubview:img_icon1];
            UILabel * lbl_FirstTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, img_icon1.frame.origin.y+img_icon1.frame.size.height+8, FirstBackView.frame.size.width, 20)];
            lbl_FirstTitle.text=@"待付款";
            lbl_FirstTitle.textAlignment=NSTextAlignmentCenter;
            lbl_FirstTitle.font=[UIFont systemFontOfSize:15];
            [FirstBackView addSubview:lbl_FirstTitle];
            UIButton * btn_wait=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, FirstBackView.frame.size.width, FirstBackView.frame.size.height)];
            btn_wait.tag=1;
            [btn_wait addTarget:self action:@selector(JumpToOrderListVC:) forControlEvents:UIControlEventTouchUpInside];
            [FirstBackView addSubview:btn_wait];
            [BackView_SpecialPrice addSubview:FirstBackView];
            UIView * secondBackView=[[UIView alloc] initWithFrame:CGRectMake(FirstBackView.frame.size.width+FirstBackView.frame.origin.x, 0,BackView_SpecialPrice.frame.size.width/4 , BackView_SpecialPrice.frame.size.height)];
            secondBackView.backgroundColor=[UIColor whiteColor];
            UIImageView * img_icon2=[[UIImageView alloc] initWithFrame:CGRectMake((secondBackView.frame.size.width-18)/2, 10, 18, 18)];
            img_icon2.image=[UIImage imageNamed:@"second_icon"];
            [secondBackView addSubview:img_icon2];
            UILabel * lbl_SecondTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, img_icon2.frame.origin.y+img_icon2.frame.size.height+8, FirstBackView.frame.size.width, 20)];
            lbl_SecondTitle.text=@"待发货";
            lbl_SecondTitle.textAlignment=NSTextAlignmentCenter;
            lbl_SecondTitle.font=[UIFont systemFontOfSize:15];
            [secondBackView addSubview:lbl_SecondTitle];
            UIButton * btn_waitforseal=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, secondBackView.frame.size.width, secondBackView.frame.size.height)];
            btn_waitforseal.tag=2;
            [btn_waitforseal addTarget:self action:@selector(JumpToOrderListVC:) forControlEvents:UIControlEventTouchUpInside];
            [secondBackView addSubview:btn_waitforseal];
            [BackView_SpecialPrice addSubview:secondBackView];
            
            UIView * thirdBackView=[[UIView alloc] initWithFrame:CGRectMake(secondBackView.frame.size.width+secondBackView.frame.origin.x, 0,BackView_SpecialPrice.frame.size.width/4 , BackView_SpecialPrice.frame.size.height)];
            thirdBackView.backgroundColor=[UIColor whiteColor];
            UIImageView * img_icon3=[[UIImageView alloc] initWithFrame:CGRectMake((thirdBackView.frame.size.width-18)/2, 10, 18, 18)];
            img_icon3.image=[UIImage imageNamed:@"third_icon"];
            [thirdBackView addSubview:img_icon3];
            UILabel * lbl_ThirdTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, img_icon3.frame.origin.y+img_icon3.frame.size.height+8, thirdBackView.frame.size.width, 20)];
            lbl_ThirdTitle.text=@"待收货";
            lbl_ThirdTitle.textAlignment=NSTextAlignmentCenter;
            lbl_ThirdTitle.font=[UIFont systemFontOfSize:15];
            [thirdBackView addSubview:lbl_ThirdTitle];
            UIButton * btn_waitforreseive=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, thirdBackView.frame.size.width, thirdBackView.frame.size.height)];
            btn_waitforreseive.tag=3;
            [btn_waitforreseive addTarget:self action:@selector(JumpToOrderListVC:) forControlEvents:UIControlEventTouchUpInside];
            [thirdBackView addSubview:btn_waitforreseive];
            [BackView_SpecialPrice addSubview:thirdBackView];
            
            UIView * fourthBackView=[[UIView alloc] initWithFrame:CGRectMake(thirdBackView.frame.size.width+thirdBackView.frame.origin.x, 0,BackView_SpecialPrice.frame.size.width/4 , BackView_SpecialPrice.frame.size.height)];
            fourthBackView.backgroundColor=[UIColor whiteColor];
            UIImageView * img_icon4=[[UIImageView alloc] initWithFrame:CGRectMake((fourthBackView.frame.size.width-18)/2, 10, 18, 18)];
            img_icon4.image=[UIImage imageNamed:@"fourth_icon"];
            [fourthBackView addSubview:img_icon4];
            UILabel * lbl_fourthTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, img_icon4.frame.origin.y+img_icon4.frame.size.height+8, fourthBackView.frame.size.width, 20)];
            lbl_fourthTitle.text=@"已收货";
            lbl_fourthTitle.textAlignment=NSTextAlignmentCenter;
            lbl_fourthTitle.font=[UIFont systemFontOfSize:15];
            [fourthBackView addSubview:lbl_fourthTitle];
            UIButton * btn_isreseaive=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, fourthBackView.frame.size.width, fourthBackView.frame.size.height)];
            btn_isreseaive.tag=4;
            [btn_isreseaive addTarget:self action:@selector(JumpToOrderListVC:) forControlEvents:UIControlEventTouchUpInside];
            [fourthBackView addSubview:btn_isreseaive];
            [BackView_SpecialPrice addSubview:fourthBackView];
            [cell addSubview:BackView_SpecialPrice];
        }
            break;
        case 1:
        {
            UIImageView * img_iconForCell=[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 17, 18)];
            img_iconForCell.image=[UIImage imageNamed:@"address_icon"];
            [BackView_SpecialPrice addSubview:img_iconForCell];
            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 150, 20)];
            lbl_specialpriceTitle.text=@"我的收货地址";
            lbl_specialpriceTitle.font=[UIFont systemFontOfSize:14];
            [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
            UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-30-60, 5, 60, 20)];
            lbl_moreSpecialprice.text=@"";
            lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
            lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+12, 9, 7, 12)];
            img_go.image=[UIImage imageNamed:@"index_go"];
            [BackView_SpecialPrice addSubview:img_go];
            UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, 30)];
            [btn_morespecialprice addTarget:self action:@selector(jumpToAddressManager:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_SpecialPrice addSubview:btn_morespecialprice];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, btn_morespecialprice.frame.size.height, BackView_SpecialPrice.frame.size.width-20, 1)];
            fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:fenge];
            [cell addSubview:BackView_SpecialPrice];
        }
            break;
        case 2:
        {
            UIImageView * img_iconForCell=[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 17, 18)];
            img_iconForCell.image=[UIImage imageNamed:@"shoucang_icon"];
            [BackView_SpecialPrice addSubview:img_iconForCell];
            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, 20)];
            lbl_specialpriceTitle.text=@"我的收藏";
            lbl_specialpriceTitle.font=[UIFont systemFontOfSize:14];
            [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
            UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-30-100, 5, 100, 20)];
            lbl_moreSpecialprice.text=@"";
            lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
            lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
            lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
            [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+12, 9, 7, 12)];
            img_go.image=[UIImage imageNamed:@"index_go"];
            [BackView_SpecialPrice addSubview:img_go];
            UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, 30)];
//            [btn_morespecialprice addTarget:self action:@selector(Btn_MoreshowOrderClick) forControlEvents:UIControlEventTouchUpInside];
            [BackView_SpecialPrice addSubview:btn_morespecialprice];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, btn_morespecialprice.frame.size.height, BackView_SpecialPrice.frame.size.width-20, 1)];
            fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:fenge];
            [cell addSubview:BackView_SpecialPrice];
        }
            break;
        case 3:
        {
            UIImageView * img_iconForCell=[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 17, 18)];
            img_iconForCell.image=[UIImage imageNamed:@"jifenshangcheng_icon"];
            [BackView_SpecialPrice addSubview:img_iconForCell];
            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, 20)];
            lbl_specialpriceTitle.text=@"积分商城";
            lbl_specialpriceTitle.font=[UIFont systemFontOfSize:14];
            [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
            UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-30-100, 5, 100, 20)];
            lbl_moreSpecialprice.text=@"";
            lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
            lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
            lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
            [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+12, 9, 7, 12)];
            img_go.image=[UIImage imageNamed:@"index_go"];
            [BackView_SpecialPrice addSubview:img_go];
            UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, 30)];
            [btn_morespecialprice addTarget:self action:@selector(JumpToJiFenShangCheng:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_SpecialPrice addSubview:btn_morespecialprice];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, btn_morespecialprice.frame.size.height, BackView_SpecialPrice.frame.size.width-20, 1)];
            fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:fenge];
            [cell addSubview:BackView_SpecialPrice];
        }
            break;
        case 4:
        {
            UIImageView * img_iconForCell=[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 17, 18)];
            img_iconForCell.image=[UIImage imageNamed:@"set_icon"];
            [BackView_SpecialPrice addSubview:img_iconForCell];
            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, 20)];
            lbl_specialpriceTitle.text=@"设置";
            lbl_specialpriceTitle.font=[UIFont systemFontOfSize:14];
            [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
            UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-30-100, 5, 100, 20)];
            lbl_moreSpecialprice.text=@"";
            lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
            lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
            lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
            [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+12, 9, 7, 12)];
            img_go.image=[UIImage imageNamed:@"index_go"];
            [BackView_SpecialPrice addSubview:img_go];
            UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, 30)];
            [btn_morespecialprice addTarget:self action:@selector(SetBtnclick) forControlEvents:UIControlEventTouchUpInside];
            [BackView_SpecialPrice addSubview:btn_morespecialprice];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, btn_morespecialprice.frame.size.height, BackView_SpecialPrice.frame.size.width-20, 1)];
            fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:fenge];
            [cell addSubview:BackView_SpecialPrice];
        }
            break;
        default:
            break;
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(void)jumpToAddressManager:(UIButton *)sender
{
    _myAddressManager=[[AddressManageViewController alloc] init];
    _myAddressManager.isfromDuihuan=NO;
    _myAddressManager.userkey=userinfoWithFile[@"key"];
    [self.navigationController pushViewController:_myAddressManager animated:YES];
}

-(void)JumpToJiFenShangCheng:(UIButton *)sender
{
    _myJifen=[[JiFenShangChengViewController alloc] init];
    _myJifen.userkey=userinfoWithFile[@"key"];
    [self.navigationController pushViewController:_myJifen animated:YES];
}

/**
 *  登录
 */
-(void)Btn_LoginClick
{
    NSLog(@"点击登录");
    _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_myLogin animated:YES];
}
/**
 *  晒单圈
 */
-(void)Btn_ShowOrderClick
{
    WXViewController *wxVc = [WXViewController new];
    wxVc.key=userinfoWithFile[@"key"];
    wxVc.nickName=userinfoWithFile[@"username"];
    wxVc.avatarImageHeader=userinfoWithFile[@"avatar"];
    [self.navigationController pushViewController:wxVc animated:YES];
}

-(void)loginSuccess
{
    NSLog(@"Mine 登录成功");
    [_lblRight removeFromSuperview];
    [self BuildHeaderViewAfterLogin];
}

-(void)BuildHeaderViewAfterLogin
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    UIView * myHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 205)];
    myHeaderView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/25.0 alpha:1.0];
    UIImageView * img_Back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myHeaderView.frame.size.width, 110)];
    [img_Back sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"my_title_bg"]];
    [myHeaderView addSubview:img_Back];
    UIButton * btn_login=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-250, img_Back.frame.size.height-30, 105, 20)];
    [btn_login setTitle:userinfoWithFile[@"username"] forState:UIControlStateNormal];
    [btn_login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_login.backgroundColor=[UIColor whiteColor];
    [btn_login addTarget:self action:@selector(changenickName) forControlEvents:UIControlEventTouchUpInside];
    btn_login.layer.masksToBounds=YES;
    btn_login.titleLabel.font=[UIFont systemFontOfSize:13];
    btn_login.layer.cornerRadius=3;
    [myHeaderView addSubview:btn_login];
    UIButton * btn_showOrder=[[UIButton alloc] initWithFrame:CGRectMake(btn_login.frame.origin.x+btn_login.frame.size.width+10, btn_login.frame.origin.y, 75, 20)];
    btn_showOrder.layer.masksToBounds=YES;
    btn_showOrder.backgroundColor=[UIColor whiteColor];
    [btn_showOrder.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 128/255.0, 100/255.0, 154/255.0, 1.0 });
    [btn_showOrder.layer setBorderColor:colorref]; //边框颜色
    btn_showOrder.layer.cornerRadius=3;
    btn_showOrder.imageView.frame=CGRectMake(0, 0, 5, 5);
    [btn_showOrder setImage:[UIImage imageNamed:@"showorder_icon"] forState:UIControlStateNormal];
    [btn_showOrder setTitle:@"  晒单圈" forState:UIControlStateNormal];
    btn_showOrder.titleLabel.font=[UIFont systemFontOfSize:13];
    [btn_showOrder addTarget:self action:@selector(Btn_ShowOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [btn_showOrder setTitleColor:[UIColor colorWithRed:115/255.0 green:73/255.0 blue:139/255.0 alpha:1.0] forState:UIControlStateNormal];
    [myHeaderView addSubview:btn_showOrder];
    
    
    UIImageView * img_touxiang=[[UIImageView alloc] initWithFrame:CGRectMake(18, img_Back.frame.size.height-35, 50, 50)];
    [img_touxiang sd_setImageWithURL:[NSURL URLWithString:userinfoWithFile[@"avatar"]] placeholderImage:[UIImage imageNamed:@"head_icon_placeholder"]];
    img_touxiang.layer.masksToBounds=YES;
    img_touxiang.layer.cornerRadius=25;
    img_touxiang.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Btn_touxiangClick)];
    [img_touxiang addGestureRecognizer:singleTap1];

//    UIButton * btn_uploadtouxiang=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    btn_uploadtouxiang.layer.masksToBounds=YES;
//    btn_uploadtouxiang.layer.cornerRadius=25;
//    [btn_uploadtouxiang addTarget:self action:@selector(Btn_touxiangClick) forControlEvents:UIControlEventTouchUpInside];
//    [img_touxiang addSubview:btn_uploadtouxiang];
    [myHeaderView addSubview:img_touxiang];
    
    UILabel * lbl_tishi=[[UILabel alloc] initWithFrame:CGRectMake(80, img_Back.frame.origin.y+img_Back.frame.size.height+5, SCREEN_WIDTH-80, 20)];
    lbl_tishi.text=@"每一天，我们都在期待新的不二朋友";
    lbl_tishi.textColor=[UIColor grayColor];
    lbl_tishi.font=[UIFont systemFontOfSize:13];
    [myHeaderView addSubview:lbl_tishi];
    UIView * BackHeaderViewbottom=[[UIView alloc] initWithFrame:CGRectMake(10, lbl_tishi.frame.origin.y+lbl_tishi.frame.size.height+6, SCREEN_WIDTH-20, 60)];
    BackHeaderViewbottom.layer.masksToBounds=YES;
    BackHeaderViewbottom.backgroundColor=[UIColor whiteColor];
    [BackHeaderViewbottom.layer setBorderWidth:1.0]; //边框宽度
    CGColorRef colorref1 = CGColorCreate(colorSpace,(CGFloat[]){ 212/255.0, 190/255.0, 224/255.0, 1.0 });
    [BackHeaderViewbottom.layer setBorderColor:colorref1]; //边框颜色
    BackHeaderViewbottom.layer.cornerRadius=3;
    UIView * BackView_qianbao=[[UIView alloc] initWithFrame:CGRectMake(0, 0, BackHeaderViewbottom.frame.size.width/3, BackHeaderViewbottom.frame.size.height)];
    UILabel * lbl_priceNum=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, BackView_qianbao.frame.size.width, 20)];
    lbl_priceNum.text=[NSString stringWithFormat:@"¥%@",userinfoWithFile[@"predeposit"]];
    lbl_priceNum.textColor=[UIColor orangeColor];
    lbl_priceNum.font=[UIFont systemFontOfSize:15];
    lbl_priceNum.textAlignment=NSTextAlignmentCenter;
    [BackView_qianbao addSubview:lbl_priceNum];
    UILabel * lbl_backViewTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, BackView_qianbao.frame.size.width, 20)];
    lbl_backViewTitle.text=@"我的钱包";
    lbl_backViewTitle.textAlignment=NSTextAlignmentCenter;
    lbl_backViewTitle.font=[UIFont systemFontOfSize:15];
    [BackView_qianbao addSubview:lbl_backViewTitle];
    [BackHeaderViewbottom addSubview:BackView_qianbao];
    UIButton * btn_purse=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_qianbao.frame.size.width, BackView_qianbao.frame.size.height)];
    [btn_purse addTarget:self action:@selector(Btn_PurseClick) forControlEvents:UIControlEventTouchUpInside];
    [BackView_qianbao addSubview:btn_purse];
    UIView * fengeView=[[UIView alloc] initWithFrame:CGRectMake(BackView_qianbao.frame.size.width, 10, 1, 40)];
    fengeView.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [BackHeaderViewbottom addSubview:fengeView];
    [myHeaderView addSubview:BackHeaderViewbottom];
    UIView * BackView_jifen=[[UIView alloc] initWithFrame:CGRectMake(fengeView.frame.origin.x+1, 0, BackHeaderViewbottom.frame.size.width/3-15, BackHeaderViewbottom.frame.size.height)];
    UILabel * lbl_jifenNum=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, BackView_jifen.frame.size.width, 20)];
    lbl_jifenNum.text=[NSString stringWithFormat:@"%@",userinfoWithFile[@"member_points"]];
    lbl_jifenNum.font=[UIFont systemFontOfSize:15];
    lbl_jifenNum.textAlignment=NSTextAlignmentCenter;
    lbl_jifenNum.textColor=[UIColor orangeColor];
    [BackView_jifen addSubview:lbl_jifenNum];
    UILabel * lbl_jifenTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, BackView_jifen.frame.size.width, 20)];
    lbl_jifenTitle.text=@"积分";
    lbl_jifenTitle.font=[UIFont systemFontOfSize:15];
    lbl_jifenTitle.textAlignment=NSTextAlignmentCenter;
    [BackView_jifen addSubview:lbl_jifenTitle];
    UIButton * btn_jifen=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_jifen.frame.size.width, BackView_jifen.frame.size.height)];
    [btn_jifen addTarget:self action:@selector(jumpToJiFenDetial:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_jifen addSubview:btn_jifen];
    [BackHeaderViewbottom addSubview:BackView_jifen];
    UIView * BackView_qiandao=[[UIView alloc] initWithFrame:CGRectMake(BackView_jifen.frame.origin.x+BackView_jifen.frame.size.width, 0, BackHeaderViewbottom.frame.size.width/3+15, BackHeaderViewbottom.frame.size.height)];
    lbl_jifeneveryday=[[UILabel alloc] initWithFrame:CGRectMake(2, 1, 30, 30)];
    lbl_jifeneveryday.layer.masksToBounds=YES;
    lbl_jifeneveryday.layer.cornerRadius=15;
    lbl_jifeneveryday.text=@"+5";
    lbl_jifeneveryday.textAlignment=NSTextAlignmentCenter;
    lbl_jifeneveryday.backgroundColor=[UIColor colorWithRed:243/255.0 green:152/255.0 blue:1/255.0 alpha:1.0];
    lbl_jifeneveryday.textColor=[UIColor whiteColor];
    lbl_qiandaoBack=[[UILabel alloc] initWithFrame:CGRectMake(0, (BackView_qiandao.frame.size.height-32)/2, BackView_qiandao.frame.size.width+32, 32)];
    lbl_qiandaoBack.layer.masksToBounds=YES;
    lbl_qiandaoBack.text=@"签到送积分      ";
    lbl_qiandaoBack.layer.cornerRadius=16;
    lbl_qiandaoBack.font=[UIFont systemFontOfSize:13];
    lbl_qiandaoBack.textAlignment=NSTextAlignmentCenter;
    lbl_qiandaoBack.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    lbl_qiandaoBack.layer.borderWidth=1;
    lbl_qiandaoBack.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]);
    [lbl_qiandaoBack addSubview:lbl_jifeneveryday];
    UIButton * btn_sigein=[[UIButton alloc] initWithFrame:lbl_qiandaoBack.frame];
    [btn_sigein addTarget:self action:@selector(SigninFunc) forControlEvents:UIControlEventTouchUpInside];
    [BackView_qiandao addSubview:lbl_qiandaoBack];
    [BackView_qiandao addSubview:btn_sigein];
    [BackHeaderViewbottom addSubview:BackView_qiandao];
    [_TableView_Mine setTableHeaderView:myHeaderView];
    
}

-(void)jumpToJiFenDetial:(UIButton *)sender
{
    _myjifenDetial=[[JifenDetialViewController alloc] init];
    _myjifenDetial.userkey=userinfoWithFile[@"key"];
    [self.navigationController pushViewController:_myjifenDetial animated:YES];
}

-(void)SigninFunc
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"SigninClickBackcall:"];
    [dataprovider signIn:userinfoWithFile[@"key"]];
}
-(void)SigninClickBackcall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"datas"] isEqual:@"1"]) {
        [SVProgressHUD showSuccessWithStatus:@"签到成功" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"已签到" maskType:SVProgressHUDMaskTypeBlack];
    }
    if (lbl_qiandaoBack) {
        for (UIView * items in lbl_qiandaoBack.subviews) {
            [items removeFromSuperview];
        }
        lbl_qiandaoBack.text=@"已签到";
    }
}
-(void)changenickName
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"请输入需要修改的昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}
-(void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex==1) {
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        if (tf.text.length>0) {
            nickName=tf.text;
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"changeNickNamebackCall:"];
            [dataprovider ChangeUserName:tf.text andkey:userinfoWithFile[@"key"]];
        }
    }
}

-(void)changeNickNamebackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"data"] isEqual:@"1"]) {
        
        [userinfoWithFile setValue:nickName forKey:@"username"];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        BOOL result= [userinfoWithFile writeToFile:plistPath atomically:YES];
        if (result) {
            [self BuildHeaderViewAfterLogin];
            [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}

-(void)SetBtnclick
{
    _mySet=[[SetViewController alloc] initWithNibName:@"SetViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_mySet animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickRightButton:(UIButton *)sender
{
    if (!isLogin) {
        _myRegister=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]];
        _myRegister.viewTitle=@"注册";
        _myRegister.resetPwd=NO;
        [self.navigationController pushViewController:_myRegister animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}

-(void)ExistSuccess
{
    [self LoadDataUserInfo];
    [self initAllTheView];
}

/********************************上传图片开始*************************************/

-(void)Btn_touxiangClick
{
    NSLog(@"上传图片");
    [self editPortrait];
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage withName:@"avatar.jpg"];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.jpg"];
        NSLog(@"选择完成");
        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
        //        NSData* imageData = UIImagePNGRepresentation(editedImage);
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadBackCall:"];
        [dataprovider UpLoadImage:fullPath andkey:userinfoWithFile[@"key"]];
        
        
    }];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)UploadBackCall:(id)dict
{
    NSLog(@"%@",dict);
//    [img_touxiang setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]]
//     ];
    [SVProgressHUD dismiss];
    if (![dict[@"datas"] objectForKey:@"error"]&&dict[@"datas"][@"avatar"]) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"ChangeAvatarBackCall:"];
        [dataprovider SaveAvatarWithAvatarName:dict[@"datas"][@"avatar"] andkey:userinfoWithFile[@"key"]];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[dict[@"datas"] objectForKey:@"error"] maskType:SVProgressHUDMaskTypeBlack];
    }
    
}
-(void)ChangeAvatarBackCall:(id)dict
{
    NSLog(@"%@",dict);
    
    if(![dict[@"datas"] objectForKey:@"error"])
    {
        [userinfoWithFile setValue:dict[@"datas"][@"avatar"] forKey: @"avatar"];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        BOOL result= [userinfoWithFile writeToFile:plistPath atomically:YES];
        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_success" object:nil];
        }
        
    }
    
}

/*************************************上传图片结束******************************************/

-(void)Btn_PurseClick
{
    PurseViewController * purse=[[PurseViewController alloc] initWithNibName:@"PurseViewController" bundle:[NSBundle mainBundle]];
    purse.key=userinfoWithFile[@"key"];
    [self.navigationController pushViewController:purse animated:YES];
}

-(void)JumpToOrderListVC:(UIButton *)sender
{
    OrderListViewController *orderlist=[[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:[NSBundle mainBundle]];
    orderlist.key=userinfoWithFile[@"key"];
    orderlist.OrderStatus=[NSString stringWithFormat:@"%ld",sender.tag*10];
    [self.navigationController pushViewController:orderlist animated:YES];
}


@end
