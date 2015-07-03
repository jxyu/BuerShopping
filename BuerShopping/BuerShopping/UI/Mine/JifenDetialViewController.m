//
//  JifenDetialViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/18.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "JifenDetialViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "JiFenDetialTableViewCell.h"

@interface JifenDetialViewController ()
@property(nonatomic,strong)UITableView *tb_myTableView;
@end

@implementation JifenDetialViewController
{
    NSArray * alldataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lblTitle.text=@"积分详情";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    alldataList=[[NSArray alloc] init];
    [self LoadAllData];
    [self initAllView];
}

-(void)LoadAllData
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetjifenDetialBackCall:"];
    [dataprovider GetjifenDetial:_userkey];
}

-(void)initAllView
{
    _tb_myTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
    _tb_myTableView.delegate=self;
    _tb_myTableView.dataSource=self;
    [self.view addSubview:_tb_myTableView];
}

-(void)GetjifenDetialBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        alldataList=dict[@"datas"][@"ponits_list"];
        [_tb_myTableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"jifendetialcellTableViewCellIdentifier";
    JiFenDetialTableViewCell *cell = (JiFenDetialTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"JiFenDetialTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height);
    cell.lbl_title.text=alldataList[indexPath.row][@"pl_desc"];
    cell.lbl_date.text=alldataList[indexPath.row][@"pl_addtime"];
    cell.lbl_totalPoints.text=[NSString stringWithFormat:@"总积分：%@",alldataList[indexPath.row][@"pl_total_points"]];
    if ([[NSString stringWithFormat:@"%@",alldataList[indexPath.row][@"pl_points"]] rangeOfString:@"-"].length >0) {
        cell.lbl_points.text=[NSString stringWithFormat:@"%@",alldataList[indexPath.row][@"pl_points"]];
        cell.lbl_points.textColor=[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0];
    }
    else
    {
        cell.lbl_points.text=[NSString stringWithFormat:@"+%@",alldataList[indexPath.row][@"pl_points"]];
        cell.lbl_points.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:35/255.0 alpha:1.0];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return alldataList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
