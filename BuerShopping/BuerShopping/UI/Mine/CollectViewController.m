//
//  CollectViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/21.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "CollectViewController.h"
#import "MJRefresh.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "HYSegmentedControl.h"
#import "CollectTableViewCell.h"
#import "AppDelegate.h"

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)HYSegmentedControl *segmentedControl;
@end

@implementation CollectViewController
{
    BOOL isfooterrefresh;
    int curpage;
    NSArray *arrayGoodList;
    BOOL isGetGoodsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"我的收藏";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    isfooterrefresh=NO;
    curpage=1;
    isGetGoodsList=YES;
    arrayGoodList=[[NSArray alloc] init];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self LoadAllData];
}
-(void)LoadAllData
{
    [self createSegmentedControl];
    _myTableView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    // 下拉刷新
    [_myTableView addLegendHeaderWithRefreshingBlock:^{
        
        [self TopRefresh];
    }];
    [_myTableView.header beginRefreshing];
    
//    // 上拉刷新
//    [_myTableView addLegendFooterWithRefreshingBlock:^{
//        if (!isfooterrefresh) {
//            isfooterrefresh=YES;
//            [self FootRefresh];
//        }
//        // 结束刷新
//        [_myTableView.footer endRefreshing];
//    }];
//    // 默认先隐藏footer
//    _myTableView.footer.hidden = NO;
}

-(void)GetCollectListBackcall:(id)dict
{
    [SVProgressHUD dismiss];
    [_myTableView.header endRefreshing];
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        arrayGoodList=dict[@"datas"][@"favorites_list"];
        [_myTableView reloadData];
    }
}


-(void)TopRefresh
{
    curpage=1;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetCollectListBackcall:"];
    if (isGetGoodsList) {
        [dataprovider GetGoodCollectList:_key];
    }
    else
    {
        [dataprovider GetStoreCollectList:_key];
    }
    
}

-(void)FootRefresh
{
    curpage++;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    if (isGetGoodsList) {
        [dataprovider GetGoodCollectList:_key];
    }
    else
    {
        [dataprovider GetStoreCollectList:_key];
    }

}

-(void)FootRefireshBackCall:(id)dict
{
    isfooterrefresh=NO;
    NSLog(@"上拉刷新");
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:arrayGoodList];
    if (!dict[@"datas"][@"error"]) {
        NSArray * arrayitem=dict[@"datas"][@"favorites_list"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        arrayGoodList=[[NSArray alloc] initWithArray:itemarray];
    }
    [_myTableView reloadData];
}

//
//  init SegmentedControl
//
- (void)createSegmentedControl
{
    self.segmentedControl = [[HYSegmentedControl alloc] initWithOriginY:65 Titles:@[@"产品", @"商铺"] delegate:self] ;
    _myTableView.tableHeaderView=self.segmentedControl;
}

//
//  HYSegmentedControlDelegate method
//
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    switch (index) {
        case 0:
            isGetGoodsList=YES;
            break;
        case 1:
            isGetGoodsList=NO;
            break;
        default:
            break;
    }
    [_myTableView.header beginRefreshing];
}

#pragma mark 左划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray * itemmurablearray=[[NSMutableArray alloc] initWithArray:arrayGoodList];
        
        // Delete the row from the data source.
        //        [TableView_orderList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"DelCollectBackCall:"];
        if (isGetGoodsList) {
            [dataprovider DelGoodsCollectWithKey:_key andfav_id:arrayGoodList[indexPath.section][@"fav_id"]];
        }
        else
        {
            [dataprovider DelStoreCollectWithKey:_key andstore_id:arrayGoodList[indexPath.section][@"store_id"]];
        }
        [itemmurablearray removeObjectAtIndex:indexPath.section];
        arrayGoodList=[[NSArray alloc] initWithArray:itemmurablearray];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
-(void)DelCollectBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
        [SVProgressHUD showSuccessWithStatus:@"删除成功" maskType:SVProgressHUDMaskTypeBlack];
        [_myTableView reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"datas"][@"error"] maskType:SVProgressHUDMaskTypeBlack];
    }
}



#pragma mark uitableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"collectTableViewCellIdentifier";
    CollectTableViewCell *cell = (CollectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"CollectTableViewCell" owner:self options:nil] lastObject];
    if (isGetGoodsList) {
        [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:arrayGoodList[indexPath.section][@"goods_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.lbl_Title.text=[arrayGoodList[indexPath.section][@"goods_name"] isKindOfClass:[NSNull class]]?@"":arrayGoodList[indexPath.section][@"goods_name"];
        cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",arrayGoodList[indexPath.section][@"goods_price"]];
        cell.lbl_date.text=[NSString stringWithFormat:@"%@的收藏",arrayGoodList[indexPath.section][@"fav_time"]];
    }
    else
    {
        [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:arrayGoodList[indexPath.section][@"store_avatar_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.lbl_Title.text=[arrayGoodList[indexPath.section][@"store_name"] isKindOfClass:[NSNull class]]?@"":arrayGoodList[indexPath.section][@"store_name"];
        cell.lbl_price.hidden=YES;
        cell.lbl_date.text=[NSString stringWithFormat:@"%@的收藏",arrayGoodList[indexPath.section][@"fav_time_text"]];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayGoodList.count;
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
