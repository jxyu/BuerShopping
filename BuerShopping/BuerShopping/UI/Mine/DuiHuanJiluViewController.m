//
//  DuiHuanJiluViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/18.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DuiHuanJiluViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "DataProvider.h"
#import "JiFenCellTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface DuiHuanJiluViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * myTableview;

@end

@implementation DuiHuanJiluViewController
{
    BOOL isfooterrefresh;
    int curpage;
    int ishasmorepage;
    BOOL isShowNoMore;
    NSArray * arrayStoreList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"兑换记录";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    
    
    
    isfooterrefresh=NO;
    curpage=1;
    ishasmorepage=0;
    isShowNoMore=NO;
    
    arrayStoreList=[[NSArray alloc] init];
    
    _myTableview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    _myTableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-19)];
    _myTableview.delegate=self;
    _myTableview.dataSource=self;
    [self.view addSubview:_myTableview];
    // 下拉刷新
    [_myTableview addLegendHeaderWithRefreshingBlock:^{
        
        [self StoreTopRefresh];
    }];
    [_myTableview.header beginRefreshing];
    
    // 上拉刷新
    [_myTableview addLegendFooterWithRefreshingBlock:^{
        if (!isfooterrefresh) {
            isfooterrefresh=YES;
            [self StoreFootRefresh];
        }
        // 结束刷新
        [_myTableview.footer endRefreshing];
    }];
    // 默认先隐藏footer
    _myTableview.footer.hidden = NO;
}


-(void)StoreTopRefresh
{
    curpage=1;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetStoreListBackCall:"];
    [dataprovider GetDuihuanJilu:_key];
}

-(void)StoreFootRefresh
{
    if (ishasmorepage==1) {
        curpage++;
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
        [dataprovider GetDuihuanJilu:_key];
    }else{
        if (!isShowNoMore) {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"亲，" message:@"没有更多数据了哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
            [_myTableview.footer endRefreshing];
            isfooterrefresh=NO;
            isShowNoMore=YES;
        }
        
    }
    
}

-(void)FootRefireshBackCall:(id)dict
{
    isShowNoMore=NO;
    NSLog(@"上拉刷新");
    [_myTableview reloadData];
    // 结束刷新
    [_myTableview.footer endRefreshing];
    isfooterrefresh=NO;
    ishasmorepage=(int)dict[@"hasmore"];
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:arrayStoreList];
    if (!dict[@"datas"][@"error"]) {
        NSArray * arrayitem=dict[@"datas"][@"goods_list"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        arrayStoreList=[[NSArray alloc] initWithArray:itemarray];
    }
    [_myTableview reloadData];
}

-(void)GetStoreListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    [_myTableview reloadData];
    [_myTableview.header endRefreshing];
    NSLog(@"店铺列表%@",dict);
    if (!dict[@"datas"][@"error"]) {
        ishasmorepage=(int)dict[@"hasmore"];
        arrayStoreList=dict[@"datas"][@"order_list"];
        [_myTableview reloadData];
    }
}










-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * footerview=[[UIView alloc] init];
    footerview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UILabel * lbl_time=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-20, 20)];
    lbl_time.text=arrayStoreList[section][@"point_addtime"];
    [footerview addSubview:lbl_time];
    return footerview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ShopDetialViewController * shopdetial=[[ShopDetialViewController alloc] initWithNibName:@"ShopDetialViewController" bundle:[NSBundle mainBundle]];
//    shopdetial.sc_id=arrayStoreList[indexPath.section][@"store_id"];
//    [self.navigationController pushViewController:shopdetial animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"jifencellTableViewCellIdentifier";
    JiFenCellTableViewCell *cell = (JiFenCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"JiFenCellTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    cell.Btn_duihuan.hidden=YES;
    [cell.lipin_logo sd_setImageWithURL:[NSURL URLWithString:arrayStoreList[indexPath.row][@"point_goodsimage"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.lipin_title.text=arrayStoreList[indexPath.row][@"point_goodsname"];
    cell.lipin_lipindetial.text=arrayStoreList[indexPath.row][@"pgoods_body"];
    cell.lipin_jifen.text=arrayStoreList[indexPath.row][@"point_goodspoints"];

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
    return arrayStoreList.count;
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
