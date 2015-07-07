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

@interface ShopDetialViewController ()

@end

@implementation ShopDetialViewController
{
    NSDictionary *userinfoWithFile;
    NSArray * arrayslider;
    NSDictionary *storeInfo;
    NSArray * goods_list;
    BOOL isfooterrefresh;
    int curpage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    _lblTitle.text=@"商铺详情";
    _lblTitle.textColor=[UIColor whiteColor];
    isfooterrefresh=NO;
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
    UIView * myheaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 155)];
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
    [img_StoreLogo sd_setImageWithURL:[NSURL URLWithString:storeInfo[@"store_avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder@2x.png"]];
    [myheaderView addSubview:img_StoreLogo];
    UIView * BackView_StoreInfo=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.size.height+5, SCREEN_WIDTH, 50)];
    BackView_StoreInfo.backgroundColor=[UIColor whiteColor];
    UIImageView * img_location=[[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 12, 16)];
    img_location.image=[UIImage imageNamed:@"location_icon"];
    [BackView_StoreInfo addSubview:img_location];
    CGFloat x=img_location.frame.size.width+img_location.frame.origin.x;
    UILabel * lbl_address=[[UILabel alloc] initWithFrame:CGRectMake(img_location.frame.size.width+img_location.frame.origin.x, 9, SCREEN_WIDTH-x-66, 40)];
    lbl_address.textColor=[UIColor grayColor];
    lbl_address.text=storeInfo[@"location"];
    lbl_address.numberOfLines=2;
    [BackView_StoreInfo addSubview:lbl_address];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(lbl_address.frame.size.width+lbl_address.frame.origin.x, 10, 1, 30)];
    fenge.backgroundColor=[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [BackView_StoreInfo addSubview:fenge];
    [myheaderView addSubview:BackView_StoreInfo];
    UIButton * btn_location=[[UIButton alloc] initWithFrame:CGRectMake(0, BackView_StoreInfo.frame.origin.y, fenge.frame.origin.x, BackView_StoreInfo.frame.size.height)];
    [myheaderView addSubview:btn_location];
    UIButton * btn_Tel=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-47, BackView_StoreInfo.frame.origin.y+10, 30, 30)];
    [btn_Tel setImage:[UIImage imageNamed:@"Tel_icon"] forState:UIControlStateNormal];
    [btn_Tel addTarget:self action:@selector(MakeCallForStore) forControlEvents:UIControlEventTouchUpInside];
    [myheaderView addSubview:btn_Tel];
    _myTableVeiw.tableHeaderView=myheaderView;
}

-(void)InitAllView
{
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
}

-(void)TopRefresh
{
    if (userinfoWithFile[@"key"]) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetStoreDetialBackCall:"];
        [dataprovider GetStoreDetialInfoWithKey:userinfoWithFile[@"key"] andstoreid:@"2"];
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
    ++curpage;
    NSDictionary * prm=@{@"store_id":@"2",@"page":@"6",@"curpage":[NSString stringWithFormat:@"%d",curpage]};
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataprovider GetStoreGoodList:prm];
    [_myTableVeiw.footer endRefreshing];
}

-(void)FootRefireshBackCall:(id)dict
{
    
    NSLog(@"上拉刷新");
    
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:goods_list];
    if (!dict[@"datas"][@"error"]) {
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
    cell.lbl_goodsName.text=goods_list[indexPath.row][@"goods_name"];
    cell.lbl_goodsDetial.text=goods_list[indexPath.row][@"goods_jingle"];
    cell.lbl_long.text=goods_list[indexPath.row][@"juli"];
    cell.lbl_price.text=goods_list[indexPath.row][@"goods_price"];
    [cell.img_goodsicon sd_setImageWithURL:[NSURL URLWithString:goods_list[indexPath.row][@"goods_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //        cell.lbl_rescuncun.text=goods_like[indexPath.row][@""];
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
