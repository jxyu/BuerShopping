//
//  JiFenShangChengViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/15.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "JiFenShangChengViewController.h"
#import "AppDelegate.h"
#import "JiFenCellTableViewCell.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "DuihuanDetialViewController.h"

@interface JiFenShangChengViewController ()
@property(nonatomic,strong)UITableView * mytableview;
@property(nonatomic,strong)DuihuanDetialViewController *myduihuan;
@end

@implementation JiFenShangChengViewController
{
    NSDictionary * alldatas;
    NSString *jifenStr;
    NSArray * prolist;
    NSDictionary * selectData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    alldatas=[[NSDictionary alloc] init];
    selectData=[[NSDictionary alloc] init];
    jifenStr=@"0";
    prolist=[[NSArray alloc] init];
    _lblTitle.text=@"积分商城";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightbuttontitle:@"兑换纪录"];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetProListBackCall:"];
    [dataprovider GetProList:_userkey];
}
-(void)InitAllView
{
    _mytableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
    _mytableview.delegate=self;
    _mytableview.dataSource=self;
    [self.view addSubview:_mytableview];
    [self BuildHeaderView];
}
-(void)GetProListBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        jifenStr=dict[@"datas"][@"member_points"];
        prolist=dict[@"datas"][@"pro_list"];
        [self InitAllView];
        [self BuildHeaderView];
    }
}

-(void)BuildHeaderView
{
    UIView * myheaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 44)];
    UILabel * lbl_jifenTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    lbl_jifenTitle.text=@"我的积分：";
    [myheaderView addSubview:lbl_jifenTitle];
    UILabel * lbl_jifenNum=[[UILabel alloc] initWithFrame:CGRectMake(lbl_jifenTitle.frame.size.width, 12, 80, 20)];
    lbl_jifenNum.text=jifenStr;
    lbl_jifenNum.textColor=[UIColor colorWithRed:115/255.0 green:73/255.0 blue:139/255.0 alpha:1.0];
    lbl_jifenNum.textAlignment=NSTextAlignmentRight;
    [myheaderView addSubview:lbl_jifenNum];
    UILabel * lbl_fen=[[UILabel alloc] initWithFrame:CGRectMake(lbl_jifenNum.frame.origin.x+lbl_jifenNum.frame.size.width, 12, 20, 20)];
    lbl_fen.text=@"分";
    [myheaderView addSubview:lbl_fen];
    [_mytableview setTableHeaderView:myheaderView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"jifencellTableViewCellIdentifier";
    JiFenCellTableViewCell *cell = (JiFenCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"JiFenCellTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height);
    cell.Btn_duihuan.layer.masksToBounds=YES;
    cell.Btn_duihuan.layer.cornerRadius=3;
    [cell.lipin_logo sd_setImageWithURL:[NSURL URLWithString:prolist[indexPath.row][@"pgoods_image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.lipin_title.text=prolist[indexPath.row][@"pgoods_name"];
    cell.lipin_lipindetial.text=prolist[indexPath.row][@"pgoods_body"];
    cell.lipin_jifen.text=prolist[indexPath.row][@"pgoods_points"];
    if ([prolist[indexPath.row][@"pgoods_points"] intValue]<[jifenStr intValue]) {
        cell.Btn_duihuan.backgroundColor=[UIColor colorWithRed:255/255.0 green:152/255.0 blue:1/255.0 alpha:1.0];
        [cell.Btn_duihuan addTarget:self action:@selector(duihuanBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        cell.Btn_duihuan.tag=indexPath.row;
    }
    return cell;
}

-(void)duihuanBtnclick:(UIButton *)sender
{
    NSLog(@"兑换");
    selectData=prolist[sender.tag];
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"确认使用%@积分兑换该%@",prolist[sender.tag][@"pgoods_points"],prolist[sender.tag][@"pgoods_name"]] message:@"兑换成功后，请在兑换纪录里查看你的兑换商品信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSLog(@"跳转兑换详情");
        _myduihuan=[[DuihuanDetialViewController alloc] initWithNibName:@"DuihuanDetialViewController" bundle:[NSBundle mainBundle]];
        _myduihuan.goods_dict=selectData;
        _myduihuan.userkey=_userkey;
        [self.navigationController pushViewController:_myduihuan animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return prolist.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)clickRightButton:(UIButton *)sender
{
    //DuiHuanJiluViewController
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
