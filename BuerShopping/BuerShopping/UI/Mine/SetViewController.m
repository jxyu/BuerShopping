//
//  SetViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/12.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "SetViewController.h"
#import "AppDelegate.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lblTitle.text=@"设置";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    _my_tableView.delegate=self;
    _my_tableView.dataSource=self;
    [self initAllView];
}

-(void)initAllView
{
    UIView*view1 =[ [UIView alloc]init];
    view1.backgroundColor= [UIColor clearColor];
    [_my_tableView setTableHeaderView:view1];
    UIView*view =[ [UIView alloc]init];
    view.backgroundColor= [UIColor clearColor];
    [_my_tableView setTableFooterView:view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellheight=40;
    if (indexPath.section==3) {
        cellheight=40;
    }
    if (indexPath.section==4) {
        cellheight=60;
    }
    return cellheight;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        UIView * BackView_exit=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        BackView_exit.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        return BackView_exit;
    }
    else
    {
        UIView*view =[ [UIView alloc]init];
        view.backgroundColor= [UIColor clearColor];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 25;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds=YES;
    cell.bounds=CGRectMake(0, 0, _my_tableView.frame.size.width, 40);
    switch (indexPath.section) {
        case 0:
        {
            UILabel * lbl_shimingrenzheng=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            lbl_shimingrenzheng.text=@"实名认证";
            [cell addSubview:lbl_shimingrenzheng];
            UIImageView * img_Go=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-17, 15, 7, 12)];
            img_Go.image=[UIImage imageNamed:@"index_go"];
            [cell addSubview:img_Go];
            UIButton * btn_shimingrenzheng=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 38)];
            [cell addSubview:btn_shimingrenzheng];
        }
            break;
        case 1:
        {
            UILabel * lbl_shimingrenzheng=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            lbl_shimingrenzheng.text=@"重置密码";
            [cell addSubview:lbl_shimingrenzheng];
            UIImageView * img_Go=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-17, 15, 7, 12)];
            img_Go.image=[UIImage imageNamed:@"index_go"];
            [cell addSubview:img_Go];
            UIButton * btn_shimingrenzheng=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 38)];
            [cell addSubview:btn_shimingrenzheng];
        }
            break;
        case 2:
        {
            UILabel * lbl_shimingrenzheng=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            switch (indexPath.row) {
                case 0:
                {
                    lbl_shimingrenzheng.text=@"关于我们";
                    UIImageView * img_Go=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-17, 15, 7, 12)];
                    img_Go.image=[UIImage imageNamed:@"index_go"];
                    [cell addSubview:img_Go];
                }
                    break;
                case 1:
                {
                    lbl_shimingrenzheng.text=@"应用说明";
                    UIImageView * img_Go=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-17, 15, 7, 12)];
                    img_Go.image=[UIImage imageNamed:@"index_go"];
                    [cell addSubview:img_Go];
                }
                    break;
                case 2:
                {
                    lbl_shimingrenzheng.text=@"版本更新";
                    UILabel * lbl_banben=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, 10, 90, 20)];
                    lbl_banben.text=@"最新版本1.0";
                    lbl_banben.textColor=[UIColor grayColor];
                    lbl_banben.font=[UIFont systemFontOfSize:15];
                    lbl_banben.textAlignment=NSTextAlignmentRight;
                    [cell addSubview:lbl_banben];
                }
                    break;
                    
                default:
                    break;
            }
            
            
            [cell addSubview:lbl_shimingrenzheng];
            
            UIButton * btn_shimingrenzheng=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 38)];
            [cell addSubview:btn_shimingrenzheng];
        }
            break;
        case 3:
        {
            UIView * BackView_exit=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            BackView_exit.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            UIButton * btn_shimingrenzheng1=[[UIButton alloc] initWithFrame:CGRectMake(30,0, tableView.frame.size.width-60, 35)];
            btn_shimingrenzheng1.layer.masksToBounds=YES;
            btn_shimingrenzheng1.layer.cornerRadius=5;
            btn_shimingrenzheng1.backgroundColor=[UIColor colorWithRed:115/255.0 green:73/255.0 blue:139/255.0 alpha:1.0];
            [btn_shimingrenzheng1 setTitle:@"退出登录" forState:UIControlStateNormal];
            [btn_shimingrenzheng1 addTarget:self action:@selector(ExitFunc:) forControlEvents:UIControlEventTouchUpInside];
            [btn_shimingrenzheng1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [BackView_exit addSubview:btn_shimingrenzheng1];
            [cell addSubview:BackView_exit];
        }
            break;
        case 4:
        {
            UIView * BackView_exit=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
            BackView_exit.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            UILabel * lbl_banquan=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, tableView.frame.size.width, 20)];
            lbl_banquan.text=@"Coryright©2015-2018";
            [lbl_banquan setTextAlignment:NSTextAlignmentCenter];
            lbl_banquan.font=[UIFont fontWithName:@"Helvetica" size:12];
            lbl_banquan.textColor=[UIColor grayColor];
            [BackView_exit addSubview:lbl_banquan];
            UILabel * lbl_banquan1=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, tableView.frame.size.width, 20)];
            lbl_banquan1.text=@"佛山市不二海淘电子商务有限公司";
            [lbl_banquan1 setTextAlignment:NSTextAlignmentCenter];
            lbl_banquan1.font=[UIFont fontWithName:@"Helvetica" size:12];
            lbl_banquan1.textColor=[UIColor grayColor];
            [BackView_exit addSubview:lbl_banquan1];
            [cell addSubview:BackView_exit];
        }
            break;
        default:
            cell.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            break;
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section!=2) {
        return 1;
    }
    else
    {
        return 4;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)ExitFunc:(UIButton *)sender
{
    @try {
        NSDictionary * dict=[[NSDictionary alloc] init];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        BOOL result= [dict writeToFile:plistPath atomically:YES];
        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Exit_success" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"退出登录%@",exception);
    }
    @finally {
        
    }
}

@end
