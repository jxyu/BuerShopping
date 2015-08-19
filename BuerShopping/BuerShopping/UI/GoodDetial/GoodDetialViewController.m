//
//  GoodDetialViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/2.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "GoodDetialViewController.h"
#import "DataProvider.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "CWStarRateView.h"
#import "PinglunViewController.h"
#import "OrderForSureViewController.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"

#define umeng_app_key @"557e958167e58e0b720041ff"

@interface GoodDetialViewController ()

@end

@implementation GoodDetialViewController
{
    NSDictionary * arrayslider;
    NSDictionary * goodInfo;
    NSDictionary * evaluate;
    NSDictionary * imgdict;
    NSArray * dictspectitle;
    NSDictionary * dictspecValue;
    NSDictionary * goodsID;
    NSDictionary * userinfoWithFile;
    NSDictionary * spec_list_goods;
    UIView * page;
    int select1;
    int select2;
    NSString * select1name;
    NSString * select2name;
    
    
    UILabel * lbl_tishi;
    UILabel * lbl_price;
    UILabel * lbl_kucun;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightButton:@"ShopCar_icon_goodslist@2x.png"];
    _lblTitle.text=@"产品详情";
    _lblTitle.textColor=[UIColor whiteColor];
    arrayslider=[[NSDictionary alloc] init];
    goodInfo=[[NSDictionary alloc] init];
    evaluate=[[NSDictionary alloc] init];
    imgdict=[[NSDictionary alloc] init];
    dictspectitle=[[NSArray alloc] init];
    dictspecValue=[[NSDictionary alloc] init];
    goodsID=[[NSDictionary alloc] init];
    spec_list_goods=[[NSDictionary alloc] init];
    userinfoWithFile=[[NSDictionary alloc] init];
    select1=0;
    select2=0;
    select1name=@"";
    select2name=@"";
    [self InitAllView];
    [self loadAllData];
}

-(void)InitAllView
{
    UIButton * btn_dianpu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0,_backviw_bottom.frame.size.width/6, _backviw_bottom.frame.size.height)];
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
    [btn_dianpu addTarget:self action:@selector(JumpTodianpu) forControlEvents:UIControlEventTouchUpInside];
    [_backviw_bottom addSubview:btn_dianpu];
    UIButton * btn_shoucang=[[UIButton alloc] initWithFrame:CGRectMake(btn_dianpu.frame.size.width+1, 0, _backviw_bottom.frame.size.width/6, _backviw_bottom.frame.size.height)];
    [btn_shoucang addTarget:self action:@selector(BtnCollectGood:) forControlEvents:UIControlEventTouchUpInside];
    btn_shoucang.backgroundColor=[UIColor whiteColor];
    UIImageView * img_shoucangicon=[[UIImageView alloc] initWithFrame:CGRectMake((btn_shoucang.frame.size.width-20)/2+1, 5, 20, 20)];
    img_shoucangicon.image=[UIImage imageNamed:@"star_gray_icon"];
    [btn_shoucang addSubview:img_shoucangicon];
    UILabel * lbl_shoucangTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, img_shoucangicon.frame.origin.y+img_shoucangicon.frame.size.height+10, btn_shoucang.frame.size.width, 15)];
    lbl_shoucangTitle.font=[UIFont systemFontOfSize:15];
    lbl_shoucangTitle.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    lbl_shoucangTitle.text=@"收藏";
    lbl_shoucangTitle.textAlignment=NSTextAlignmentCenter;
    [btn_shoucang addSubview:lbl_shoucangTitle];
    [_backviw_bottom addSubview:btn_shoucang];
    UIButton * btn_AddToShoppingCar=[[UIButton alloc] initWithFrame:CGRectMake(btn_shoucang.frame.origin.x+btn_shoucang.frame.size.width, 0, _backviw_bottom.frame.size.width/3, _backviw_bottom.frame.size.height)];
    btn_AddToShoppingCar.backgroundColor=[UIColor colorWithRed:255/255.0 green:204/255.0 blue:1/255.0 alpha:1.0];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, btn_AddToShoppingCar.frame.size.width, 20)];
    lbl_title.text=@"加入购物车";
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor whiteColor];
    
    [btn_AddToShoppingCar addSubview:lbl_title];
    [btn_AddToShoppingCar addTarget:self action:@selector(AddToShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [_backviw_bottom addSubview:btn_AddToShoppingCar];
    UIButton * btn_pryforShoppingCar=[[UIButton alloc] initWithFrame:CGRectMake(btn_AddToShoppingCar.frame.size.width+btn_AddToShoppingCar.frame.origin.x, 0, _backviw_bottom.frame.size.width/3, _backviw_bottom.frame.size.height)];
    btn_pryforShoppingCar.backgroundColor=[UIColor colorWithRed:255/255.0 green:152/255.0 blue:1/255.0 alpha:1.0];
    UILabel * lbl_title1=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, btn_AddToShoppingCar.frame.size.width, 20)];
    lbl_title1.text=@"立即购买";
    lbl_title1.textAlignment=NSTextAlignmentCenter;
    lbl_title1.textColor=[UIColor whiteColor];
    [btn_pryforShoppingCar addSubview:lbl_title1];
    [btn_pryforShoppingCar addTarget:self action:@selector(PayRithtNow:) forControlEvents:UIControlEventTouchUpInside];
    [_backviw_bottom addSubview:btn_pryforShoppingCar];
}

-(void)loadAllData
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetGoodInfoBackCall:"];
    [dataprovider GetGoodDetialInfoWithid:_gc_id];
}
-(void)GetGoodInfoBackCall:(id)dict
{
    NSLog(@"获取商品数据%@",dict);
    if (!dict[@"datas"][@"error"]) {
        arrayslider=dict[@"datas"][@"goods_image"];
        goodInfo=dict[@"datas"][@"goods_info"];
        evaluate=dict[@"datas"][@"evaluate"];
        if (evaluate.count>0) {
            imgdict=dict[@"datas"][@"evaluate"][@"image"];
        }
        if (dict[@"datas"][@"goods_info"]) {
            dictspectitle=dict[@"datas"][@"goods_info"][@"spec_name"];
            dictspecValue=dict[@"datas"][@"goods_info"][@"spec_value"];
        }
        goodsID=dict[@"datas"][@"spec_list"];
        spec_list_goods=dict[@"datas"][@"spec_list_goods"];
        [self BuildHeaderView];
        [self BuildBodyTableView];
    }
}

-(void)JumpTodianpu
{
    
}
-(void)BuildHeaderView
{
    UIView * backview_HeaderVeiw=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    backview_HeaderVeiw.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<arrayslider.count; i++) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:arrayslider[[NSString stringWithFormat:@"%d",i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
//        [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
        [images addObject:img];
    }
    // 创建带标题的图片轮播器
    SDCycleScrollView *_cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 5,backview_HeaderVeiw.frame.size.width, 250) imagesGroup:images ];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [backview_HeaderVeiw addSubview:_cycleScrollView];
    
    UIView * backview_titleandShare=[[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView.frame.size.height+_cycleScrollView.frame.origin.y+1, SCREEN_WIDTH, 50)];
    backview_titleandShare.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-81, 40)];
    lbl_title.numberOfLines=2;
    lbl_title.font=[UIFont systemFontOfSize:15];
    lbl_title.text=goodInfo[@"goods_name"];
    [backview_titleandShare addSubview:lbl_title];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(lbl_title.frame.size.width+lbl_title.frame.origin.x
                                                            , 5, 1, 40)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [backview_titleandShare addSubview:fenge];
    
    UIButton * btn_share=[[UIButton alloc] initWithFrame:CGRectMake(fenge.frame.size.width+fenge.frame.origin.x, 0, 50, 50)];
    [btn_share addTarget:self action:@selector(btnShare:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(btn_share.frame.size.width-26, 5, 20, 20)];
    img_icon.image=[UIImage imageNamed:@"Share_icon"];
    [btn_share addSubview:img_icon];
    UILabel * lbl_iconTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, img_icon.frame.origin.y+img_icon.frame.size.height+5, btn_share.frame.size.width, 20)];
    lbl_iconTitle.text=@"分享";
    lbl_iconTitle.textAlignment=NSTextAlignmentRight;
    lbl_iconTitle.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [btn_share addSubview:lbl_iconTitle];
    [backview_titleandShare addSubview:btn_share];
    [backview_HeaderVeiw addSubview:backview_titleandShare];
    UIView * backview_goodinfo2=[[UIView alloc] initWithFrame:CGRectMake(0, backview_titleandShare.frame.size.height+backview_titleandShare.frame.origin.y+1, SCREEN_WIDTH, 80)];
    backview_goodinfo2.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_price1=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    lbl_price1.font=[UIFont systemFontOfSize:18];
    if ([goodInfo[@"is_special"] intValue]==1)
    {
        lbl_price1.text=[NSString stringWithFormat:@"¥%@",goodInfo[@"goods_promotion_price"]];
    }
    else
    {
        lbl_price1.text=[NSString stringWithFormat:@"¥%@",goodInfo[@"goods_price"]];
    }
    
    lbl_price1.textColor=[UIColor redColor];
    [backview_goodinfo2 addSubview:lbl_price1];
    CGFloat x=lbl_price1.frame.size.height+lbl_price1.frame.origin.y+5;
    if ([goodInfo[@"is_special"] intValue]==1) {
        UILabel * lbl_proformprice=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_price1.frame.size.height+lbl_price1.frame.origin.y, 100, 20)];
        lbl_proformprice.textColor=[UIColor grayColor];
        lbl_proformprice.text=[NSString stringWithFormat:@"价格:¥%@",goodInfo[@"goods_price"]];
        lbl_proformprice.font=[UIFont systemFontOfSize:15];
        lbl_proformprice.textAlignment=NSTextAlignmentCenter;
        [backview_goodinfo2 addSubview:lbl_proformprice];
        UIView * delLine=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_proformprice.frame.size.height/2, lbl_proformprice.frame.size.width, 1)];
        delLine.backgroundColor=[UIColor blackColor];
        [lbl_proformprice addSubview:delLine];
        x=lbl_proformprice.frame.size.height+lbl_proformprice.frame.origin.y+5;
    }
    UILabel * lbl_class=[[UILabel alloc] initWithFrame:CGRectMake(0, x, SCREEN_WIDTH/3, 20)];
    lbl_class.text=[NSString stringWithFormat:@"所属%@分类",goodInfo[@"gc_name"]];
    lbl_class.textColor=[UIColor grayColor];
    lbl_class.textAlignment=NSTextAlignmentCenter;
    lbl_class.font=[UIFont systemFontOfSize:15];
    [backview_goodinfo2 addSubview:lbl_class];
    UILabel * lbl_sell=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, x, SCREEN_WIDTH/3, 20)];
    lbl_sell.text=[NSString stringWithFormat:@"已售%@件",goodInfo[@"goods_salenum"]];
    lbl_sell.textColor=[UIColor grayColor];
    lbl_sell.textAlignment=NSTextAlignmentCenter;
    lbl_sell.font=[UIFont systemFontOfSize:15];
    [backview_goodinfo2 addSubview:lbl_sell];
    UILabel * lbl_liulan=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, x, SCREEN_WIDTH/3, 20)];
    lbl_liulan.text=[NSString stringWithFormat:@"浏览%@",goodInfo[@"goods_click"]];
    lbl_liulan.textColor=[UIColor grayColor];
    lbl_liulan.textAlignment=NSTextAlignmentCenter;
    lbl_liulan.font=[UIFont systemFontOfSize:15];
    [backview_goodinfo2 addSubview:lbl_liulan];
    backview_goodinfo2.frame=CGRectMake(backview_goodinfo2.frame.origin.x, backview_goodinfo2.frame.origin.y, backview_goodinfo2.frame.size.width, x+30);
    [backview_HeaderVeiw addSubview:backview_goodinfo2];
    backview_HeaderVeiw.frame=CGRectMake(backview_HeaderVeiw.frame.origin.x, backview_HeaderVeiw.frame.origin.y, backview_HeaderVeiw.frame.size.width, backview_goodinfo2.frame.size.height+backview_goodinfo2.frame.origin.y+10);
    _mytableview.tableHeaderView=backview_HeaderVeiw;
    
    UIView * tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    tableFooterView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UILabel * lbl_footer=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20)];
    lbl_footer.text=@"继续拖动，查看图文详情";
    lbl_footer.textAlignment=NSTextAlignmentCenter;
    lbl_footer.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [tableFooterView addSubview:lbl_footer];
    _mytableview.tableFooterView=tableFooterView;
    
}
-(void)btnShare:(UIButton *)sender
{
    NSLog(@"分享");
    //分享巴国榜
    NSString *shareText = @"快来加入不二海淘，享受生活的乐趣吧！";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"1136-1"];          //分享内嵌图片
    NSArray* snsList=    [NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToTencent,nil];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:umeng_app_key
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:snsList
                                       delegate:nil];
    

}
-(void)BtnCollectGood:(UIButton *)sender
{
    NSLog(@"收藏");
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"CollectGoodBackCall:"];
    [dataprovider CollectGoodWithKey:userinfoWithFile[@"key"] andgoods_id:_gc_id];
}
-(void)CollectGoodBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
        [SVProgressHUD showSuccessWithStatus:@"收藏成功" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"datas"][@"error"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)BuildBodyTableView
{
    _mytableview.delegate=self;
    _mytableview.dataSource=self;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerview=[[UIView alloc] init];
    footerview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    return footerview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h=50;
    if (indexPath.section==1) {
        h=260;
    }
    return h;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (page) {
            page.frame=CGRectMake(page.frame.origin.x, 0, page.frame.size.width, page.frame.size.height);
        }
        else
        {
            [self BuildPageForSelect];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (indexPath.section==0) {
        UILabel * lbl_select=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 20)];
        lbl_select.text=@"选择规格类型";
        lbl_select.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [cell addSubview:lbl_select];
        UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-22,21.5, 7, 12)];
        img_go.image=[UIImage imageNamed:@"index_go"];
        [cell addSubview:img_go];
    }
    if (indexPath.section==1) {
        if (evaluate.count>0) {
            UILabel * lbl_pinglunTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
            lbl_pinglunTitle.text=[NSString stringWithFormat:@"宝贝评价(%@)",goodInfo[@"evaluation_count"]];
            [cell addSubview:lbl_pinglunTitle];
            UILabel * lbl_zogpingfen=[[UILabel alloc] initWithFrame:CGRectMake(lbl_pinglunTitle.frame.size.width+lbl_pinglunTitle.frame.origin.x, 10, SCREEN_WIDTH-(lbl_pinglunTitle.frame.size.width+lbl_pinglunTitle.frame.origin.x)-20, 20)];
            lbl_zogpingfen.text=[NSString stringWithFormat:@"总评分:%@",goodInfo[@"evaluation_good_star"]];
            lbl_zogpingfen.textColor=[UIColor colorWithRed:243/255.0 green:152/255.0 blue:0/255.0 alpha:1.0];
            lbl_zogpingfen.textAlignment=NSTextAlignmentRight;
            [cell addSubview:lbl_zogpingfen];
            UIImageView * img_avatar=[[UIImageView alloc] initWithFrame:CGRectMake(10, lbl_pinglunTitle.frame.origin.y+lbl_pinglunTitle.frame.size.height+5, 30, 30)];
            [img_avatar sd_setImageWithURL:[NSURL URLWithString:evaluate[@"geval_avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            img_avatar.layer.masksToBounds=YES;
            img_avatar.layer.cornerRadius=15;
            [cell addSubview:img_avatar];
            UILabel * lbl_pingluner=[[UILabel alloc] initWithFrame:CGRectMake(img_avatar.frame.size.width+img_avatar.frame.origin.x+10, img_avatar.frame.origin.y+5, 200, 20)];
            lbl_pingluner.text=evaluate[@"geval_frommembername"];
            [cell addSubview:lbl_pingluner];
            CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(10,img_avatar.frame.origin.y+img_avatar.frame.size.height+10,150,15) numberOfStars:5];
            weisheng.scorePercent = [evaluate[@"geval_scores"] floatValue]/5;
            weisheng.allowIncompleteStar = NO;
            weisheng.hasAnimation = YES;
            [cell addSubview:weisheng];
            UILabel * lbl_content=[[UILabel alloc] initWithFrame:CGRectMake(10, weisheng.frame.size.height+weisheng.frame.origin.y+10, SCREEN_WIDTH, 20)];
            lbl_content.text=evaluate[@"geval_content"];
            lbl_content.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            [cell addSubview:lbl_content];
            CGFloat y=lbl_content.frame.size.height+lbl_content.frame.origin.y;
            if (imgdict&&imgdict.count>0) {
                for (int i=0; i<imgdict.count; i++) {
                    UIView * backview_item=[[UIView alloc] initWithFrame:CGRectMake(50*(i%6), y+(50*(i/6)), 50, 50)];
                    backview_item.backgroundColor=[UIColor whiteColor];
                    UIImageView * img_item=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
                    [img_item sd_setImageWithURL:[NSURL URLWithString:imgdict[[NSString stringWithFormat:@"%d",i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [backview_item addSubview:img_item];
                    [cell addSubview:backview_item];
                }
            }
            UIView * lastview=[cell.subviews lastObject];
            UILabel * lbl_spec=[[UILabel alloc] initWithFrame:CGRectMake(10, lastview.frame.size.height+lastview.frame.origin.y+10, SCREEN_WIDTH-20, 20)];
            lbl_spec.text=evaluate[@"geval_spec"];
            lbl_spec.textColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            lbl_spec.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lbl_spec];
            UIView * backview_fenge=[[UIView alloc] initWithFrame:CGRectMake(10, lbl_spec.frame.origin.y+lbl_spec.frame.size.height+5, SCREEN_WIDTH-20, 1)];
            backview_fenge.backgroundColor=[UIColor grayColor];
            [cell addSubview:backview_fenge];
            UIButton * btn_morePinglun=[[UIButton alloc] initWithFrame:CGRectMake(0, backview_fenge.frame.origin.y+backview_fenge.frame.size.height, SCREEN_WIDTH, 50)];
            [btn_morePinglun setTitle:@"查看更多评价" forState:UIControlStateNormal];
            [btn_morePinglun setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn_morePinglun.tag=indexPath.row;
            [btn_morePinglun addTarget:self action:@selector(MorePinglun:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_morePinglun];
        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)MorePinglun:(UIButton * )sender
{
    NSLog(@"更多评论");
    PinglunViewController * pinglun=[[PinglunViewController alloc] initWithNibName:@"PinglunViewController" bundle:[NSBundle mainBundle]];
    pinglun.num_pinglun=goodInfo[@"evaluation_count"];
    [self.navigationController pushViewController:pinglun animated:YES];
}

-(void)BuildPageForSelect
{
    @try {
        page=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        page.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UIView * backview_form=[[UIView alloc] initWithFrame:CGRectMake(0, page.frame.size.height-400, page.frame.size.width, 400)];
        backview_form.backgroundColor=[UIColor whiteColor];
        UIButton * btn_addtoshoppingcar=[[UIButton alloc] initWithFrame:CGRectMake(0, backview_form.frame.size.height-50, backview_form.frame.size.width/2, 50)];
        btn_addtoshoppingcar.backgroundColor=[UIColor colorWithRed:254/255.0 green:205/255.0 blue:1/255.0 alpha:1.0];
        [btn_addtoshoppingcar setTitle:@"加入购物车" forState:UIControlStateNormal];
        [btn_addtoshoppingcar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_addtoshoppingcar addTarget:self action:@selector(AddToShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
        [backview_form addSubview:btn_addtoshoppingcar];
        UIButton * btn_payrightnow=[[UIButton alloc] initWithFrame:CGRectMake(btn_addtoshoppingcar.frame.size.width, backview_form.frame.size.height-50, backview_form.frame.size.width/2, 50)];
        btn_payrightnow.backgroundColor=[UIColor colorWithRed:255/255.0 green:154/255.0 blue:1/255.0 alpha:1.0];
        [btn_payrightnow setTitle:@"立即购买" forState:UIControlStateNormal];
        [btn_payrightnow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_payrightnow addTarget:self action:@selector(PayRithtNow:) forControlEvents:UIControlEventTouchUpInside];
        [backview_form addSubview:btn_payrightnow];
        UIView * BackVew_selectTitle=[[UIView alloc] initWithFrame:CGRectMake(0, 0, backview_form.frame.size.width, 110)];
        UIButton * btn_cancel=[[UIButton alloc] initWithFrame:CGRectMake(BackVew_selectTitle.frame.size.width-35, 10, 25, 25)];
        [btn_cancel setImage:[UIImage imageNamed:@"cancel_for_select@2x.png"] forState:UIControlStateNormal];
        [btn_cancel addTarget:self action:@selector(cancelPageSelect:) forControlEvents:UIControlEventTouchUpInside];
        [BackVew_selectTitle addSubview:btn_cancel];
        lbl_price=[[UILabel alloc] initWithFrame:CGRectMake(140, btn_cancel.frame.size.height+btn_cancel.frame.origin.y+5, BackVew_selectTitle.frame.size.width-150, 20)];
        lbl_price.textColor=[UIColor colorWithRed:255/255.0 green:154/255.0 blue:1/255.0 alpha:1.0];
        lbl_price.text=goodInfo[@"goods_price"];
        [BackVew_selectTitle addSubview:lbl_price];
        lbl_kucun=[[UILabel alloc] initWithFrame:CGRectMake(lbl_price.frame.origin.x, lbl_price.frame.origin.y+lbl_price.frame.size.height+5, lbl_price.frame.size.width, 20)];
        lbl_kucun.font=[UIFont systemFontOfSize:13];
        lbl_kucun.text=[NSString stringWithFormat:@"库存%@件",goodInfo[@"goods_storage"]];
        [BackVew_selectTitle addSubview:lbl_kucun];
        lbl_tishi=[[UILabel alloc] initWithFrame:CGRectMake(lbl_kucun.frame.origin.x, lbl_kucun.frame.size.height+lbl_kucun.frame.origin.y+5, lbl_kucun.frame.size.width, 20)];
        lbl_tishi.text=@"请选择规格";
        lbl_tishi.font=[UIFont systemFontOfSize:13];
        [BackVew_selectTitle addSubview:lbl_tishi];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, BackVew_selectTitle.frame.size.height-1, BackVew_selectTitle.frame.size.width-20, 1)];
        fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [BackVew_selectTitle addSubview:fenge];
        [backview_form addSubview:BackVew_selectTitle];
        UIScrollView * scrollviw=[[UIScrollView alloc] initWithFrame:CGRectMake(0, BackVew_selectTitle.frame.size.height, backview_form.frame.size.width, backview_form.frame.size.height-BackVew_selectTitle.frame.size.height-50)];
        scrollviw.scrollEnabled=YES;
        if (![dictspectitle isKindOfClass:[NSNull class]]) {
            for (int i=1; i<=dictspectitle.count; i++) {
                UIView * lastview=[scrollviw.subviews lastObject];
                UIView * firstselect=[[UIView alloc] initWithFrame:CGRectMake(0, lastview.frame.size.height+lastview.frame.origin.y, scrollviw.frame.size.width, 100)];
                UILabel * lbl_firstselectTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, firstselect.frame.size.width, 20)];
                lbl_firstselectTitle.text=dictspectitle[i-1][@"name"];
                [firstselect addSubview:lbl_firstselectTitle];
                NSArray * arrayitem=[[NSArray alloc] initWithArray:dictspecValue[[NSString stringWithFormat:@"%@",dictspectitle[i-1][@"id"]]]];
                if (arrayitem.count>0) {
                    for (int j=0; j<arrayitem.count; j++) {
                        int num=j/4;
                        int yushu=j%4;
                        UIButton * btn_item=[[UIButton alloc] initWithFrame:CGRectMake( yushu==0?10:((firstselect.frame.size.width-50)/4)*(j%4)+(j+1)*10, num==0?lbl_firstselectTitle.frame.size.height+lbl_firstselectTitle.frame.origin.y+10:50*num, (firstselect.frame.size.width-50)/4, 40)];
                        btn_item.layer.masksToBounds=YES;
                        btn_item.tag=i*1000+[arrayitem[j][@"id"]  intValue];
                        [btn_item setTitle:arrayitem[j][@"name"] forState:UIControlStateNormal];
                        btn_item.titleLabel.font=[UIFont systemFontOfSize:15];
                        [btn_item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn_item addTarget:self action:@selector(itemselectchange:) forControlEvents:UIControlEventTouchUpInside];
                        btn_item.layer.cornerRadius=5;
                        btn_item.layer.borderWidth=1;
                        btn_item.layer.borderColor=[RGB(102, 102, 102) CGColor];
                        [firstselect addSubview:btn_item];
                    }
                }
                UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, firstselect.frame.size.height-1, firstselect.frame.size.width-20, 1)];
                fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
                [firstselect addSubview:fenge];
                [scrollviw addSubview:firstselect];
                
            }
            UIView * lastview=[scrollviw.subviews lastObject];
            scrollviw.contentSize=CGSizeMake(0, lastview.frame.size.height+lastview.frame.origin.y+50);
        }
        
        
        [backview_form addSubview:scrollviw];
        [page addSubview:backview_form];
        UIImageView * img_good=[[UIImageView alloc] initWithFrame:CGRectMake(10, backview_form.frame.origin.y-30, 120, 120)];
        [img_good sd_setImageWithURL:[NSURL URLWithString:arrayslider[@"0"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        img_good.layer.masksToBounds=YES;
        img_good.layer.cornerRadius=5;
        img_good.layer.borderWidth=2;
        img_good.layer.borderColor=[RGB(255, 255, 255) CGColor];
        [page addSubview:img_good];
        [self.view addSubview:page];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

-(void)itemselectchange:(UIButton * )sender
{
    @try {
        for (UIView *items in [[sender superview] subviews]) {
            if (items.tag!=0) {
                UIButton * item=(UIButton *)items;
                [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                item.backgroundColor=[UIColor whiteColor];
                item.layer.borderWidth=1;
            }
        }
        sender.backgroundColor=[UIColor colorWithRed:255/255.0 green:152/255.0 blue:1/255.0 alpha:1.0];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.layer.borderWidth=0;
        if (sender.tag>2000) {
            select2=(int)sender.tag-2000;
            select2name=sender.currentTitle;
        }
        else
        {
            select1=(int)sender.tag-1000;
            select1name=sender.currentTitle;
        }
        switch (dictspectitle.count) {
            case 0:
                
                break;
            case 1:
                if (select1||select2) {
                    NSDictionary * dict=spec_list_goods[[NSString stringWithFormat:@"%d%d",select1,select2]];
                    lbl_price.text=[NSString stringWithFormat:@"¥%@",dict[@"goods_price"]];
                    lbl_kucun.text=[NSString stringWithFormat:@"库存%@件",dict[@"goods_storage"]];
                }
                break;
            case 2:
                if (select1&&select2) {
                    NSDictionary * dict=spec_list_goods[[NSString stringWithFormat:@"%d|%d",select1,select2]];
                    lbl_price.text=[NSString stringWithFormat:@"¥%@",dict[@"goods_price"]];
                    lbl_kucun.text=[NSString stringWithFormat:@"库存%@件",dict[@"goods_storage"]];
                }
                break;
            default:
                break;
        }
        [self changeTishi];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
-(void)changeTishi
{
    lbl_tishi.text=[NSString stringWithFormat:@"%@ %@",select1name,select2name];
}
-(void)cancelPageSelect:(UIButton * )sender
{
    page.frame=CGRectMake(page.frame.origin.x, SCREEN_HEIGHT, page.frame.size.width, page.frame.size.height);
}

-(void)AddToShoppingCar:(UIButton *)sender
{
    
    
    @try {
        if (userinfoWithFile[@"key"]) {
            switch (dictspectitle.count) {
                case 0:
                {
                    DataProvider * dataprovider=[[DataProvider alloc] init];
                    [dataprovider setDelegateObject:self setBackFunctionName:@"AddToshoppingCarBackCall:"];
                    [dataprovider AddToShoppingCar:userinfoWithFile[@"key"] andgoods_id:@"" andquantity:@"1"];
                    
                    
                }
                    break;
                case 1:
                {
                    if (select1||select2) {
                        if (goodsID[[NSString stringWithFormat:@"%d|%d",select1,select2]]) {
                            DataProvider * dataprovider=[[DataProvider alloc] init];
                            [dataprovider setDelegateObject:self setBackFunctionName:@"AddToshoppingCarBackCall:"];
                            [dataprovider AddToShoppingCar:userinfoWithFile[@"key"] andgoods_id:goodsID[[NSString stringWithFormat:@"%d%d",select1,select2]] andquantity:@"1"];
                        }
                    }
                    else
                    {
                        if (page) {
                            page.frame=CGRectMake(page.frame.origin.x, 0, page.frame.size.width, page.frame.size.height);
                        }
                        else
                        {
                            [self BuildPageForSelect];
                        }
                    }
                }
                    break;
                case 2:
                {
                    if (select1&&select2) {
                        if (goodsID[[NSString stringWithFormat:@"%d|%d",select1,select2]]) {
                            DataProvider * dataprovider=[[DataProvider alloc] init];
                            [dataprovider setDelegateObject:self setBackFunctionName:@"AddToshoppingCarBackCall:"];
                            [dataprovider AddToShoppingCar:userinfoWithFile[@"key"] andgoods_id:goodsID[[NSString stringWithFormat:@"%d|%d",select1,select2]] andquantity:@"1"];
                        }
                    }
                    else
                    {
                        if (page) {
                            page.frame=CGRectMake(page.frame.origin.x, 0, page.frame.size.width, page.frame.size.height);
                        }
                        else
                        {
                            [self BuildPageForSelect];
                        }
                    }
                }
                    break;
                default:
                    break;
            }
            
        }
        else
        {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
        NSLog(@"加入购物车");
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
-(void)AddToshoppingCarBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqual:@"1"]) {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已加入到购物车" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        if (dict[@"datas"][@"error"]) {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }
    
}

-(void)PayRithtNow:(UIButton *)sender
{
    NSLog(@"立即购买");
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (userinfoWithFile[@"key"]) {
        switch (dictspectitle.count) {
            case 0:
            {
//                DataProvider * dataprovider=[[DataProvider alloc] init];
//                [dataprovider setDelegateObject:self setBackFunctionName:@"buyrightBackCall:"];
//                [dataprovider Buy_Stepone:userinfoWithFile[@"key"] andcart_id:[NSString stringWithFormat:@"%@|%d",,1] andifcart:@"0"];
            }
                break;
            case 1:
                if (select1||select2) {
                    if (goodsID[[NSString stringWithFormat:@"%d|%d",select1,select2]]) {
                        DataProvider * dataprovider=[[DataProvider alloc] init];
                        [dataprovider setDelegateObject:self setBackFunctionName:@"buyrightBackCall:"];
                        [dataprovider Buy_Stepone:userinfoWithFile[@"key"] andcart_id:[NSString stringWithFormat:@"%@|%d",goodsID[[NSString stringWithFormat:@"%d%d",select1,select2]],1] andifcart:@"0"];
                    }
                }
                else
                {
                    if (page) {
                        page.frame=CGRectMake(page.frame.origin.x, 0, page.frame.size.width, page.frame.size.height);
                    }
                    else
                    {
                        [self BuildPageForSelect];
                    }
                }
                break;
            case 2:
                if (select1&&select2) {
                    if (goodsID[[NSString stringWithFormat:@"%d|%d",select1,select2]]) {
                        DataProvider * dataprovider=[[DataProvider alloc] init];
                        [dataprovider setDelegateObject:self setBackFunctionName:@"buyrightBackCall:"];
                        [dataprovider Buy_Stepone:userinfoWithFile[@"key"] andcart_id:[NSString stringWithFormat:@"%@|%d",goodsID[[NSString stringWithFormat:@"%d|%d",select1,select2]],1] andifcart:@"0"];
                    }
                }
                else
                {
                    if (page) {
                        page.frame=CGRectMake(page.frame.origin.x, 0, page.frame.size.width, page.frame.size.height);
                    }
                    else
                    {
                        [self BuildPageForSelect];
                    }
                }
                break;
            default:
                break;
        }
        
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)buyrightBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        OrderForSureViewController * orderforsure=[[OrderForSureViewController alloc] initWithNibName:@"OrderForSureViewController" bundle:[NSBundle mainBundle]];
        orderforsure.OrderData=dict[@"datas"];
        orderforsure.key=userinfoWithFile[@"key"];
        [self.navigationController pushViewController:orderforsure animated:YES];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)clickRightButton:(UIButton *)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] selectTableBarIndex:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


@end
