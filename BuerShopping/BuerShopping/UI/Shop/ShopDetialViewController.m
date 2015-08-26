//
//  ShopDetialViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/1.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ShopDetialViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "CWStarRateView.h"
#import "GoodsTableViewCell.h"
#import "MJRefresh.h"
#import "GoodDetialViewController.h"
#import "RoutePlanViewController.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"
#import "CCLocationManager.h"

#define umeng_app_key @"557e958167e58e0b720041ff"

@interface ShopDetialViewController ()<UIAlertViewDelegate>

@end

@implementation ShopDetialViewController
{
    NSDictionary *userinfoWithFile;
    NSArray * arrayslider;
    NSDictionary *storeInfo;
    NSArray * goods_list;
    BOOL isfooterrefresh;
    int curpage;
    
    int ishasmore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    _lblTitle.text=@"商铺详情";
    _lblTitle.textColor=[UIColor whiteColor];
    isfooterrefresh=NO;
    ishasmore=0;
    arrayslider=[[NSArray alloc] init];
    goods_list=[[NSArray alloc] init];
    curpage=0;
    [self LoadAllData];
    [self InitAllView];
}

-(void)LoadAllData
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
}

-(void)GetStoreDetialBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        ishasmore=(int)dict[@"hasmore"];
        arrayslider=dict[@"datas"][@"store_info"][@"mb_sliders"];
        storeInfo=dict[@"datas"][@"store_info"];
        goods_list=dict[@"datas"][@"goods_list"];
        [self BuildHeaderView];
    }
    [_myTableVeiw reloadData];
}

-(void)BuildHeaderView
{
    /***************************headerView 开始 **************************/
    UIView * myheaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 225)];
    myheaderView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    UIView * jianju=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH- 20, 5)];
    jianju.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [myheaderView addSubview:jianju];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<arrayslider.count; i++) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:arrayslider[i]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
        [images addObject:img];
    }
    if (arrayslider.count<=0) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
        [images addObject:img];
    }
    // 创建带标题的图片轮播器
    SDCycleScrollView *_cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 5, myheaderView.frame.size.width, 175) imagesGroup:images ];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [myheaderView addSubview:_cycleScrollView];
    UIView * BackVeiw_StoreTitle=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.size.height-45, myheaderView.frame.size.width, 50)];
    BackVeiw_StoreTitle.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UILabel * lbl_StoreName=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 20)];
    lbl_StoreName.text=storeInfo[@"store_name"];
    lbl_StoreName.textColor=[UIColor whiteColor];
    [BackVeiw_StoreTitle addSubview:lbl_StoreName];
    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(100,lbl_StoreName.frame.size.height+5,100,15) numberOfStars:5];
    weisheng.scorePercent = [storeInfo[@"store_credit_composite"] floatValue]/5;
    weisheng.allowIncompleteStar = NO;
    weisheng.hasAnimation = YES;
    [BackVeiw_StoreTitle addSubview:weisheng];
    [myheaderView addSubview:BackVeiw_StoreTitle];
    UIImageView * img_StoreLogo=[[UIImageView alloc] initWithFrame:CGRectMake(10, _cycleScrollView.frame.size.height-75, 80, 80)];
    [img_StoreLogo sd_setImageWithURL:[NSURL URLWithString:storeInfo[@"store_avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [myheaderView addSubview:img_StoreLogo];
    UIView * BackView_StoreInfo=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.size.height+5, SCREEN_WIDTH, 50)];
    BackView_StoreInfo.backgroundColor=[UIColor whiteColor];
    UIImageView * img_location=[[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 12, 16)];
    img_location.image=[UIImage imageNamed:@"location_icon"];
    [BackView_StoreInfo addSubview:img_location];
    CGFloat x=img_location.frame.size.width+img_location.frame.origin.x;
    UILabel * lbl_address=[[UILabel alloc] initWithFrame:CGRectMake(img_location.frame.size.width+img_location.frame.origin.x, 9, SCREEN_WIDTH-x-66, 40)];
    lbl_address.textColor=[UIColor grayColor];
    lbl_address.text=storeInfo[@"location"]?storeInfo[@"location"]:@"";
    lbl_address.numberOfLines=2;
    [BackView_StoreInfo addSubview:lbl_address];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(lbl_address.frame.size.width+lbl_address.frame.origin.x, 10, 1, 30)];
    fenge.backgroundColor=[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [BackView_StoreInfo addSubview:fenge];
    [myheaderView addSubview:BackView_StoreInfo];
    UIButton * btn_location=[[UIButton alloc] initWithFrame:CGRectMake(0, BackView_StoreInfo.frame.origin.y, fenge.frame.origin.x, BackView_StoreInfo.frame.size.height)];
    [btn_location addTarget:self action:@selector(JumptoNavi:) forControlEvents:UIControlEventTouchUpInside];
    [myheaderView addSubview:btn_location];
    UIButton * btn_Tel=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-47, BackView_StoreInfo.frame.origin.y+10, 30, 30)];
    [btn_Tel setImage:[UIImage imageNamed:@"Tel_icon"] forState:UIControlStateNormal];
    [btn_Tel addTarget:self action:@selector(MakeCallForStore) forControlEvents:UIControlEventTouchUpInside];
    [myheaderView addSubview:btn_Tel];
    _myTableVeiw.tableHeaderView=myheaderView;
}

-(void)InitAllView
{
    UIButton * btn_collect=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 25, 40, 30)];
    [btn_collect setImage:[UIImage imageNamed:@"collect_no_icon"] forState:UIControlStateNormal];
    [btn_collect addTarget:self action:@selector(CollectShop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_collect];
    UIButton * btn_share=[[UIButton alloc] initWithFrame:CGRectMake(btn_collect.frame.origin.x-45, 25, 40, 30)];
    [btn_share setImage:[UIImage imageNamed:@"share_icon_shop"] forState:UIControlStateNormal];
    [btn_share addTarget:self action:@selector(shareShop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_share];
//    btn_collect
    _myTableVeiw.delegate=self;
    _myTableVeiw.dataSource=self;
    // 下拉刷新
    [_myTableVeiw addLegendHeaderWithRefreshingBlock:^{
        
        [self TopRefresh];
        [_myTableVeiw reloadData];
        [_myTableVeiw.header endRefreshing];
    }];
    [_myTableVeiw.header beginRefreshing];
    
    // 上拉刷新
    [_myTableVeiw addLegendFooterWithRefreshingBlock:^{
        if (!isfooterrefresh) {
            isfooterrefresh=YES;
            
            [self FootRefresh];
            [_myTableVeiw reloadData];
        }
        // 结束刷新
        [_myTableVeiw.footer endRefreshing];
    }];
    // 默认先隐藏footer
    _myTableVeiw.footer.hidden = NO;
}
-(void)MakeCallForStore
{
    NSLog(@"打电话");
    if (storeInfo[@"store_phone"]) {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:storeInfo[@"store_phone"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        [alert show];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"商家未设置电话" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        // 直接拨号，拨号完成后会停留在通话记录中
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",storeInfo[@"store_phone"]]]];
    }
}
-(void)CollectShop:(UIButton *)sender
{
    NSLog(@"收藏");
    if (storeInfo[@"store_id"]) {
        [SVProgressHUD showWithStatus:@"正在收藏" maskType:SVProgressHUDMaskTypeBlack];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"CollectshopBackCall:"];
        [dataprovider CollectShopWithKey:userinfoWithFile[@"key"] andstore_id:storeInfo[@"store_id"]];
    }
}
-(void)CollectshopBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
        [SVProgressHUD showSuccessWithStatus:@"收藏成功" maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)shareShop:(UIButton *)sender
{
    NSLog(@"分享店铺");
    
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

-(void)JumptoNavi:(UIButton * )sender
{
    [SVProgressHUD showWithStatus:@"正在加载导航信息" maskType:SVProgressHUDMaskTypeBlack];
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [SVProgressHUD dismiss];
        RoutePlanViewController * routeplanVC=[[RoutePlanViewController alloc] init];
        routeplanVC.startPoint= [AMapNaviPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
        routeplanVC.endPoint= [AMapNaviPoint locationWithLatitude:[storeInfo[@"lat"] floatValue] longitude:[storeInfo[@"lng"] floatValue]];
        [self.navigationController pushViewController:routeplanVC animated:YES];
    }];
    
}

-(void)TopRefresh
{
    if (userinfoWithFile[@"key"]) {
        curpage=1;
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetStoreDetialBackCall:"];
        [dataprovider GetStoreDetialInfoWithKey:userinfoWithFile[@"key"] andstoreid:_sc_id];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"请先登录" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)FootRefresh
{
    isfooterrefresh=NO;
    if (ishasmore==1) {
        ++curpage;
        NSDictionary * prm=@{@"store_id":_sc_id,@"page":@"6",@"curpage":[NSString stringWithFormat:@"%d",curpage]};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
        [dataprovider GetStoreGoodList:prm];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有更多商品了哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
    [_myTableVeiw.footer endRefreshing];
}

-(void)FootRefireshBackCall:(id)dict
{
    
    NSLog(@"上拉刷新");
    
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:goods_list];
    if (!dict[@"datas"][@"error"]) {
        ishasmore=(int)dict[@"hasmore"];
        NSArray * arrayitem=dict[@"datas"][@"goods_list"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        goods_list=[[NSArray alloc] initWithArray:itemarray];
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerview=[[UIView alloc] init];
    footerview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    return footerview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetialViewController * gooddetial=[[GoodDetialViewController alloc] initWithNibName:@"GoodDetialViewController" bundle:[NSBundle mainBundle]];
    gooddetial.gc_id=goods_list[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:gooddetial animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GoodsTableViewCellIdentifier";
    GoodsTableViewCell *cell = (GoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    cell.lbl_goodsName.text=goods_list[indexPath.section][@"goods_name"]?goods_list[indexPath.section][@"goods_name"]:@"";
    cell.lbl_goodsDetial.text=goods_list[indexPath.section][@"goods_jingle"]?goods_list[indexPath.section][@"goods_jingle"]:@"";
    cell.lbl_long.text=goods_list[indexPath.section][@"juli"]?goods_list[indexPath.section][@"juli"]:@"";
    cell.lbl_price.text=goods_list[indexPath.section][@"goods_price"]?goods_list[indexPath.section][@"goods_price"]:@"";
    cell.lbl_rescuncun.text=goods_list[indexPath.section][@"goods_storage"]?goods_list[indexPath.section][@"goods_storage"]:@"";
    cell.lbl_resxiaoliang.text=goods_list[indexPath.section][@"goods_salenum"]?goods_list[indexPath.section][@"goods_salenum"]:@"";
    cell.lbl_liulanliang.text=goods_list[indexPath.section][@"goods_click"]?goods_list[indexPath.section][@"goods_click"]:@"";
    [cell.img_goodsicon sd_setImageWithURL:[NSURL URLWithString:goods_list[indexPath.section][@"goods_image_url"]?goods_list[indexPath.section][@"goods_image_url"]:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
    return goods_list.count;
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
