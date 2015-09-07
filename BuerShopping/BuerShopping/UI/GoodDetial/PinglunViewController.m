//
//  PinglunViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/6.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "PinglunViewController.h"
#import "MJRefresh.h"
#import "DataProvider.h"
#import "CWStarRateView.h"
#import "UIImageView+WebCache.h"

@interface PinglunViewController ()

@end

@implementation PinglunViewController
{
    BOOL isfooterrefresh;
    BOOL ishasMore;
    int curpage;
    NSArray * arrayPinglun;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addLeftButton:@"Icon_Back@2x.png"];
    _lblTitle.text=@"评价（0）";
    _lblTitle.textColor=[UIColor whiteColor];
    arrayPinglun=[[NSArray alloc] init];
    isfooterrefresh=NO;
    ishasMore=YES;
    curpage=0;
    [self InitAllView];
}

-(void)InitAllView
{
    __myTableview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    __myTableview.delegate=self;
    __myTableview.dataSource=self;
    // 下拉刷新
    [__myTableview addLegendHeaderWithRefreshingBlock:^{
        [self StoreTopRefresh];
    }];
    [__myTableview.header beginRefreshing];
    
    // 上拉刷新
    [__myTableview addLegendFooterWithRefreshingBlock:^{
        if (!isfooterrefresh) {
            isfooterrefresh=YES;
            [self StoreFootRefresh];
            [__myTableview reloadData];
            // 结束刷新
            [__myTableview.footer endRefreshing];
        }
    }];
    // 默认先隐藏footer
    __myTableview.footer.hidden = NO;
}

-(void)StoreTopRefresh
{
    curpage=1;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetMorepinglunBackCall:"];
    [dataprovider GetMorePinglun:_good_id andcurpage:[NSString stringWithFormat:@"%d",curpage]];
}

-(void)StoreFootRefresh
{
    if (ishasMore) {
        curpage++;
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
        [dataprovider GetMorePinglun:_good_id andcurpage:[NSString stringWithFormat:@"%d",curpage]];
        [__myTableview.footer endRefreshing];
    }
    else
    {
         [__myTableview.footer endRefreshing];
    }
    
}

-(void)FootRefireshBackCall:(id)dict
{
    
    NSLog(@"上拉刷新");
    
    isfooterrefresh=NO;
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:arrayPinglun];
    if (!dict[@"datas"][@"error"]) {
        if ([dict[@"hasmore"] intValue]==1) {
            ishasMore=YES;
        }
        else
        {
            ishasMore=NO;
        }
        NSArray * arrayitem=dict[@"datas"][@"evaluate_list"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        arrayPinglun=[[NSArray alloc] initWithArray:itemarray];
        [__myTableview reloadData];
        
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    // 结束刷新
    [__myTableview.footer endRefreshing];
}

-(void)GetMorepinglunBackCall:(id)dict
{
    NSLog(@"更多评论%@",dict);
    if (!dict[@"datas"][@"error"]) {
        if ([dict[@"hasmore"] intValue]==1) {
            ishasMore=YES;
        }
        else
        {
            ishasMore=NO;
        }
        arrayPinglun=dict[@"datas"][@"evaluate_list"];
        _lblTitle.text=[NSString stringWithFormat:@"评价（%lu）",(unsigned long)arrayPinglun.count];
        [__myTableview reloadData];
        [__myTableview.header endRefreshing];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    UIImageView * img_avatar=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [img_avatar sd_setImageWithURL:[NSURL URLWithString:arrayPinglun[indexPath.row][@"geval_avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    img_avatar.layer.masksToBounds=YES;
    img_avatar.layer.cornerRadius=15;
    [cell addSubview:img_avatar];
    UILabel * lbl_pingluner=[[UILabel alloc] initWithFrame:CGRectMake(img_avatar.frame.size.width+img_avatar.frame.origin.x+10, img_avatar.frame.origin.y+5, 200, 20)];
    lbl_pingluner.text=arrayPinglun[indexPath.row][@"geval_frommembername"];
    [cell addSubview:lbl_pingluner];
    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(10,img_avatar.frame.origin.y+img_avatar.frame.size.height+10,150,15) numberOfStars:5];
    weisheng.scorePercent = [arrayPinglun[indexPath.row][@"geval_scores"] floatValue]/5;
    weisheng.allowIncompleteStar = NO;
    weisheng.hasAnimation = YES;
    [cell addSubview:weisheng];
    UILabel * lbl_content=[[UILabel alloc] initWithFrame:CGRectMake(10, weisheng.frame.size.height+weisheng.frame.origin.y+10, SCREEN_WIDTH, 20)];
    lbl_content.text=arrayPinglun[indexPath.row][@"geval_content"];
    lbl_content.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [cell addSubview:lbl_content];
    NSDictionary* imgdict=[[NSDictionary alloc] init];
    imgdict=arrayPinglun[indexPath.row][@"geval_image"];
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
    lbl_spec.text=[NSString stringWithFormat:@"%@ %@",arrayPinglun[indexPath.row][@"geval_addtime"],arrayPinglun[indexPath.row][@"geval_spec"]];
    lbl_spec.textColor=[UIColor grayColor];
    lbl_spec.font=[UIFont systemFontOfSize:15];
    [cell addSubview:lbl_spec];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayPinglun.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
