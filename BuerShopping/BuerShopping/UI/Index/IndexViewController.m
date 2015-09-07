//
//  IndexViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "IndexViewController.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "GoodsTableViewCell.h"
#import "ResTableViewCell.h"
#import "CCLocationManager.h"
#import "DataProvider.h"
#import "CWStarRateView.h"
#import "GoodListViewController.h"
#import "ShopInsideViewController.h"
#import "AutoLocationViewController.h"
#import "GoodDetialViewController.h"
#import "ShopDetialViewController.h"
#import "ShowOrderViewController.h"


@interface IndexViewController ()
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic , strong) CycleScrollView *mainScorllView;
@end

@implementation IndexViewController
{
    UITextField * txt_searchtext;
    UIButton * btn_select;
    UITableView * tableView_GessYouLike;
    UITableView * tableView_GoodResEveryday;
    NSArray* selectArray;
    UIView * select_Backview;
    BOOL isSelectViewShow;
    NSString * lng;
    NSString * lat;
    NSString * areaid;
    NSArray * circle;
    NSArray * class;
    NSArray * day_special;
    NSArray * slide;
    NSArray * good_store;
    NSArray * goods_like;
    UIView * day_sprcial_more;
    NSString * searchType;
    BOOL keyboardZhezhaoShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"首页";
    isSelectViewShow=NO;
    keyboardZhezhaoShow=NO;
    searchType=@"宝贝";
    [self LoadData];
    
}

-(void)initView
{
    /**********************************head搜索栏开始***********************************/
    selectArray=@[@"宝贝",@"店铺"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCityInfo) name:@"ChangeCity" object:nil];
    
    UIView * BackView_Serch=[[UIView alloc] initWithFrame:CGRectMake(_btnLeft.frame.size.width+_btnLeft.frame.origin.x+10, 20.5, SCREEN_WIDTH-_btnLeft.frame.size.width-_btnLeft.frame.origin.x-22, 35)];
    BackView_Serch.layer.masksToBounds=YES;
    BackView_Serch.layer.cornerRadius=3;
    BackView_Serch.backgroundColor=[UIColor whiteColor];
    btn_select=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    [btn_select setTitle:selectArray[0] forState:UIControlStateNormal];
    btn_select.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn_select setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_select addTarget:self action:@selector(changeSelectToSearch:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_Serch addSubview:btn_select];
    UIImageView * img_down=[[UIImageView alloc] initWithFrame:CGRectMake(btn_select.frame.size.width-10, 13, 10, 8)];
    img_down.image=[UIImage imageNamed:@"select_down"];
    [btn_select addSubview:img_down];
    txt_searchtext=[[UITextField alloc] initWithFrame:CGRectMake(btn_select.frame.origin.x+btn_select.frame.size.width+5, 4.5, BackView_Serch.frame.size.width-btn_select.frame.origin.x-btn_select.frame.size.width, 30)];
    txt_searchtext.placeholder=@"搜索附近商品、商铺";
    [txt_searchtext setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [BackView_Serch addSubview:txt_searchtext];
    txt_searchtext.delegate=self;
    [self.view addSubview:BackView_Serch];
     /**********************************head搜索栏结束***********************************/
    
    
    
    _TableView_BackView.delegate=self;
    _TableView_BackView.dataSource=self;
    _TableView_BackView.tag=1;
    _TableView_BackView.showsVerticalScrollIndicator=NO;
    /***************************headerView 开始 **************************/
    UIView * myheaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH- 10, 285)];
    myheaderView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    UIView * jianju=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH- 20, 5)];
    jianju.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [myheaderView addSubview:jianju];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<slide.count; i++) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:slide[i][@"pic_img"]] placeholderImage:[UIImage imageNamed:@"placeholder"] ];
        [images addObject:img];
    }
    // 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 5, SCREEN_WIDTH- 10, 135) imagesGroup:images ];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
    [myheaderView addSubview:_cycleScrollView];
    UIView * BackView_buttionlist=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.origin.y+_cycleScrollView.frame.size.height+5, myheaderView.frame.size.width, 135)];
    CGFloat x=(SCREEN_WIDTH- 10-200)/5;
    BackView_buttionlist.backgroundColor=[UIColor whiteColor];
    UIButton * btn_nvshi=[[UIButton alloc] initWithFrame:CGRectMake(x, 5, 50, 60)];
    [btn_nvshi setImage:[UIImage imageNamed:@"nvshi"] forState:UIControlStateNormal];
    btn_nvshi.tag=1099;
    [btn_nvshi addTarget:self action:@selector(JumpToGoodList:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_buttionlist addSubview:btn_nvshi];
    UIButton * btn_nanshi=[[UIButton alloc] initWithFrame:CGRectMake(x*2+50, 5, 50, 60)];
    [btn_nanshi setImage:[UIImage imageNamed:@"nanshi"] forState:UIControlStateNormal];
    btn_nanshi.tag=1100;
    [btn_nanshi addTarget:self action:@selector(JumpToGoodList:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_buttionlist addSubview:btn_nanshi];
    UIButton * btn_muying=[[UIButton alloc] initWithFrame:CGRectMake(x*3+100, 5, 50, 60)];
    [btn_muying setImage:[UIImage imageNamed:@"muying"] forState:UIControlStateNormal];
    btn_muying.tag=1063;
    [btn_muying addTarget:self action:@selector(JumpToGoodList:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_buttionlist addSubview:btn_muying];
    UIButton * btn_huazhuang=[[UIButton alloc] initWithFrame:CGRectMake(x*4+150, 5, 50, 60)];
    [btn_huazhuang setImage:[UIImage imageNamed:@"huazhuang"] forState:UIControlStateNormal];
    btn_huazhuang.tag=1064;
    [btn_huazhuang addTarget:self action:@selector(JumpToGoodList:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_buttionlist addSubview:btn_huazhuang];
    [myheaderView addSubview:BackView_buttionlist];
    UIButton * btn_shouji=[[UIButton alloc] initWithFrame:CGRectMake(x, btn_nvshi.frame.origin.y+btn_nvshi.frame.size.height+5, 50, 60)];
    [btn_shouji setImage:[UIImage imageNamed:@"shouji"] forState:UIControlStateNormal];
    btn_shouji.tag=1065;
    [btn_shouji addTarget:self action:@selector(JumpToGoodList:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_buttionlist addSubview:btn_shouji];
    UIButton * btn_bangong=[[UIButton alloc] initWithFrame:CGRectMake(x*2+50, btn_nvshi.frame.origin.y+btn_nvshi.frame.size.height+5, 50, 60)];
    [btn_bangong setImage:[UIImage imageNamed:@"bangong"] forState:UIControlStateNormal];
    btn_bangong.tag=1066;
    [btn_bangong addTarget:self action:@selector(JumpToGoodList:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_buttionlist addSubview:btn_bangong];
    UIButton * btn_shenghuo=[[UIButton alloc] initWithFrame:CGRectMake(x*3+100, btn_nvshi.frame.origin.y+btn_nvshi.frame.size.height+5, 50, 60)];
    [btn_shenghuo setImage:[UIImage imageNamed:@"shenghuo"] forState:UIControlStateNormal];
    btn_shenghuo.tag=1067;
    [btn_shenghuo addTarget:self action:@selector(JumpToGoodList:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_buttionlist addSubview:btn_shenghuo];
    UIButton * btn_techan=[[UIButton alloc] initWithFrame:CGRectMake(x*4+150, btn_nvshi.frame.origin.y+btn_nvshi.frame.size.height+5, 50, 60)];
    [btn_techan setImage:[UIImage imageNamed:@"techan"] forState:UIControlStateNormal];
    btn_techan.tag=1068;
    [btn_techan addTarget:self action:@selector(JumpToGoodList:) forControlEvents:UIControlEventTouchUpInside];
    [BackView_buttionlist addSubview:btn_techan];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, btn_techan.frame.origin.y+btn_techan.frame.size.height+5, BackView_buttionlist.frame.size.width, 5)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [BackView_buttionlist addSubview:fenge];
    [myheaderView addSubview:BackView_buttionlist];
    _TableView_BackView.tableHeaderView=myheaderView;
    /***************************headerView 结束 **************************/

    
    UIView*view =[ [UIView alloc]init];
    view.backgroundColor= [UIColor clearColor];
    [_TableView_BackView setTableFooterView:view];
    [self addLeftButton:@"ic_actionbar_back.png"];
}
-(void)LoadData
{
    circle=[[NSArray alloc] init];
    class=[[NSArray alloc] init];
    day_special=[[NSArray alloc] init];
    slide=[[NSArray alloc] init];
    good_store=[[NSArray alloc] init];
    goods_like=[[NSArray alloc] init];
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetCityBackCall:"];
        lng=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
        [dataprovider GetcityInfoWithlng:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude] andlat:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
    }];
}

-(void)GetCityBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        areaid=dict[@"datas"][@"area_id"];
        [self addLeftbuttontitle:dict[@"datas"][@"area_name"]];
        _lblLeft.font=[UIFont systemFontOfSize:13];
        UIImageView * img_icon_down=[[UIImageView alloc] initWithFrame:CGRectMake(_btnLeft.frame.size.width-8, 18, 8, 5)];
        img_icon_down.image=[UIImage imageNamed:@"menu_down"];
        [_btnLeft addSubview:img_icon_down];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetIndexData:"];
        [dataprovider GetIndexDataWithAreaid:areaid andlng:lng andlat:lat];//areaid
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
        NSDictionary * cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
        if (!cityinfoWithFile) {
            NSDictionary * areaData=@{@"area_id":areaid,@"area_name":dict[@"datas"][@"area_name"]};
            BOOL result= [areaData writeToFile:plistPath atomically:YES];
            if (result) {
                
            }

        }
    }
    
}
-(void)GetIndexData:(id)dict
{
    NSLog(@"首页数据");
    if (!dict[@"datas"][@"error"]) {
        slide=dict[@"datas"][@"slide"];
        good_store=dict[@"datas"][@"good_store"];
        circle=dict[@"datas"][@"circle"];
        goods_like=dict[@"datas"][@"goods_like"];
        day_special=dict[@"datas"][@"day_special"];
        class=dict[@"datas"][@"class"];
        [self initView];
    }
}

-(void)changeSelectToSearch:(UIButton *)sender
{
    if (!isSelectViewShow) {
        CGFloat x=sender.superview.frame.origin.x;
        select_Backview=[[UIView alloc] initWithFrame:CGRectMake(x, 50, 80, 90)];
        UIImageView * img_backimage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, select_Backview.frame.size.width, select_Backview.frame.size.width)];
        img_backimage.image=[UIImage imageNamed:@"Select_BackImage"];
        [select_Backview addSubview:img_backimage];
        UIButton * btn_baobei=[[UIButton alloc] initWithFrame:CGRectMake(0, 10, select_Backview.frame.size.width, 35)];
        [btn_baobei setImage:[UIImage imageNamed:@"icon_baobei"] forState:UIControlStateNormal];
        btn_baobei.imageView.frame=CGRectMake(5, 10, 20, 20);
        btn_baobei.titleLabel.frame=CGRectMake(btn_baobei.imageView.frame.origin.x+btn_baobei.imageView.frame.size.width+20, 10, 40, 20);
        btn_baobei.titleLabel.font=[UIFont systemFontOfSize:15];
        btn_baobei.tag=0;
        [btn_baobei setTitle:@"   宝贝" forState:UIControlStateNormal];
        [btn_baobei addTarget:self action:@selector(selectChangeToSearch:) forControlEvents:UIControlEventTouchUpInside];
        [select_Backview addSubview:btn_baobei];
        UIButton * btn_dianpu=[[UIButton alloc] initWithFrame:CGRectMake(0, btn_baobei.frame.origin.y+btn_baobei.frame.size.height, select_Backview.frame.size.width, 35)];
        btn_dianpu.imageView.frame=CGRectMake(5, 10, 20, 20);
        btn_dianpu.titleLabel.frame=CGRectMake(btn_dianpu.imageView.frame.origin.x+btn_dianpu.imageView.frame.size.width+20, 10, 40, 20);
        btn_dianpu.titleLabel.font=[UIFont systemFontOfSize:15];
        btn_dianpu.tag=1;
        [btn_dianpu setImage:[UIImage imageNamed:@"icon_dianpu"] forState:UIControlStateNormal];
        [btn_dianpu setTitle:@"   店铺" forState:UIControlStateNormal];
        [btn_dianpu addTarget:self action:@selector(selectChangeToSearch:) forControlEvents:UIControlEventTouchUpInside];
        [select_Backview addSubview:btn_dianpu];
        [self.view addSubview:select_Backview];
        isSelectViewShow=YES;
    }
    else
    {
        [select_Backview removeFromSuperview];
        isSelectViewShow=NO;
    }
    
}
-(void)selectChangeToSearch:(UIButton *)sender
{
    [btn_select setTitle:selectArray[sender.tag] forState:UIControlStateNormal];
    searchType= sender.currentTitle;
    [select_Backview removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        if (indexPath.section==0) {
            GoodDetialViewController * gooddetial=[[GoodDetialViewController alloc] initWithNibName:@"GoodDetialViewController" bundle:[NSBundle mainBundle]];
            gooddetial.gc_id=day_special[0][@"goods_id"];
            [self.navigationController pushViewController:gooddetial animated:YES];
        }
    }
    if (tableView.tag==2) {
        GoodDetialViewController * gooddetial=[[GoodDetialViewController alloc] initWithNibName:@"GoodDetialViewController" bundle:[NSBundle mainBundle]];
        gooddetial.gc_id=goods_like[indexPath.row][@"goods_id"];
        [self.navigationController pushViewController:gooddetial animated:YES];
    }
    if (tableView.tag==3) {
        ShopDetialViewController * shopdetial=[[ShopDetialViewController alloc] initWithNibName:@"ShopDetialViewController" bundle:[NSBundle mainBundle]];
        shopdetial.sc_id=good_store[indexPath.row][@"store_id"];
        [self.navigationController pushViewController:shopdetial animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * BackView_SpecialPrice=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
    if (tableView.tag==1) {
        BackView_SpecialPrice.backgroundColor=[UIColor whiteColor];
        switch (section) {
            case 0:
            {
                UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
                lbl_specialpriceTitle.text=@"天天特价";
                [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
                UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-10-60, 10, 60, 20)];
                lbl_moreSpecialprice.text=@"更多";
                lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
                lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
                lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
                [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
                UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+3, 14, 7, 12)];
                img_go.image=[UIImage imageNamed:@"index_go"];
                [BackView_SpecialPrice addSubview:img_go];
                UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, BackView_SpecialPrice.frame.size.height)];
                [btn_morespecialprice addTarget:self action:@selector(btn_MorespecialPriceClick) forControlEvents:UIControlEventTouchUpInside];
                [BackView_SpecialPrice addSubview:btn_morespecialprice];
                UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, BackView_SpecialPrice.frame.size.height, BackView_SpecialPrice.frame.size.width-10, 1)];
                fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
                [BackView_SpecialPrice addSubview:fenge];
            }
                break;
            case 1:
            {
                UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
                lbl_specialpriceTitle.text=@"晒单圈";
                [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
                UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-10-100, 10, 100, 20)];
                lbl_moreSpecialprice.text=@"N条内容更新";
                lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
                lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
                lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
                [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
                UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+3, 14, 7, 12)];
                img_go.image=[UIImage imageNamed:@"index_go"];
                [BackView_SpecialPrice addSubview:img_go];
                UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, BackView_SpecialPrice.frame.size.height)];
                [btn_morespecialprice addTarget:self action:@selector(Btn_MoreshowOrderClick) forControlEvents:UIControlEventTouchUpInside];
                [BackView_SpecialPrice addSubview:btn_morespecialprice];
                UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, BackView_SpecialPrice.frame.size.height, BackView_SpecialPrice.frame.size.width-10, 1)];
                fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
                [BackView_SpecialPrice addSubview:fenge];
            }
                break;
            case 2:
            {            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
                lbl_specialpriceTitle.text=@"猜你喜欢";
                [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
                UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-10-100, 10, 100, 20)];
                lbl_moreSpecialprice.text=@"查看更多";
                lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
                lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
                lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
                [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
                UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+3, 14, 7, 12)];
                img_go.image=[UIImage imageNamed:@"index_go"];
                [BackView_SpecialPrice addSubview:img_go];
                UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, BackView_SpecialPrice.frame.size.height)];
                [btn_morespecialprice addTarget:self action:@selector(Btn_GuessYoulike) forControlEvents:UIControlEventTouchUpInside];
                [BackView_SpecialPrice addSubview:btn_morespecialprice];
                UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, BackView_SpecialPrice.frame.size.height, BackView_SpecialPrice.frame.size.width-10, 1)];
                fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
                [BackView_SpecialPrice addSubview:fenge];
            }
                break;
            case 3:
            {
                UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
                lbl_specialpriceTitle.text=@"每日好店";
                [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
                UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-10-100, 10, 100, 20)];
                lbl_moreSpecialprice.text=@"你中意的店铺";
                lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
                lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
                lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
                [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
                UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+3, 14, 7, 12)];
                img_go.image=[UIImage imageNamed:@"index_go"];
                [BackView_SpecialPrice addSubview:img_go];
                UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, BackView_SpecialPrice.frame.size.height)];
                [btn_morespecialprice addTarget:self action:@selector(btn_GoodResEveryDay) forControlEvents:UIControlEventTouchUpInside];
                [BackView_SpecialPrice addSubview:btn_morespecialprice];
                UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, BackView_SpecialPrice.frame.size.height, BackView_SpecialPrice.frame.size.width-10, 1)];
                fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
                [BackView_SpecialPrice addSubview:fenge];
            }
                break;
            default:
                break;
        }

    }
    else
    {
        
        return nil;
    }
    return BackView_SpecialPrice;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        if (section<=3) {
            return 40;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag!=1) {
        return 0;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=80;
    if (tableView.tag==1) {
        switch (indexPath.section) {
            case 0:
                height=100;
                break;
            case 1:
                height=150;
                break;
            case 2:
                height=goods_like.count*80;
                break;
            case 3:
                height=good_store.count*80;
                break;
            default:
                break;
        }
    }
    
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat cellheight=95;
    switch (indexPath.section) {
        case 0:
            cellheight=85;
            break;
        case 1:
            cellheight=170;
            break;
        case 2:
            cellheight=80*goods_like.count;
            break;
        case 3:
            cellheight=80*good_store.count;
            break;
        default:
            break;
    }
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, cellheight)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView.tag==1) {
        if (indexPath.section==0) {
            UIView * BackView_Specialprice=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 85)];
            UIImageView * img_Specialprice=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 75, 75)];
            if (day_special.count>0) {
                [img_Specialprice sd_setImageWithURL:[NSURL URLWithString:day_special[0][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                [BackView_Specialprice addSubview:img_Specialprice];
                UIImageView * icon_special=[[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 40, 15)];
                icon_special.image=[UIImage imageNamed:@"Specialprice"];
                [BackView_Specialprice addSubview:icon_special];
                UILabel * lbl_icon_special=[[UILabel alloc] initWithFrame:icon_special.frame];
                lbl_icon_special.font=[UIFont systemFontOfSize:13];
                lbl_icon_special.textColor=[UIColor whiteColor];
                lbl_icon_special.text=@"9.2折";
                [BackView_Specialprice addSubview:lbl_icon_special];
                UILabel * lbl_goodName=[[UILabel alloc] initWithFrame:CGRectMake(img_Specialprice.frame.origin.x+img_Specialprice.frame.size.width+10, 15, 150, 20)];
                lbl_goodName.text=day_special[0][@"goods_name"];
                [BackView_Specialprice addSubview:lbl_goodName];
                
                UILabel * lbl_GoodDetial=[[UILabel alloc] initWithFrame:CGRectMake(lbl_goodName.frame.origin.x, lbl_goodName.frame.origin.y+lbl_goodName.frame.size.height, SCREEN_WIDTH-img_Specialprice.frame.origin.x-img_Specialprice.frame.size.width-40, 40)];
                lbl_GoodDetial.text=day_special[0][@"goods_jingle"];
                lbl_GoodDetial.textColor=[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
                lbl_GoodDetial.numberOfLines=2;
                lbl_GoodDetial.font=[UIFont systemFontOfSize:14];
                [BackView_Specialprice addSubview:lbl_GoodDetial];
                UILabel * lbl_priceNow=[[UILabel alloc] initWithFrame:CGRectMake(lbl_goodName.frame.origin.x, lbl_GoodDetial.frame.origin.y+lbl_GoodDetial.frame.size.height, 60, 20)];
                lbl_priceNow.text=[NSString stringWithFormat:@"¥%@",day_special[0][@"goods_promotion_price"]];
                lbl_priceNow.textColor=[UIColor redColor];
                [BackView_Specialprice addSubview:lbl_priceNow];
                UILabel * lbl_priceOld=[[UILabel alloc] initWithFrame:CGRectMake(lbl_priceNow.frame.origin.x+lbl_priceNow.frame.size.width+10, lbl_priceNow.frame.origin.y+5, 40, 15)];
                lbl_priceOld.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
                lbl_priceOld.text=[NSString stringWithFormat:@"¥%@",day_special[0][@"goods_price"]];
                lbl_priceOld.font=[UIFont systemFontOfSize:13];
                [BackView_Specialprice addSubview:lbl_priceOld];
                UIView * del_view=[[UIView alloc] initWithFrame:CGRectMake(lbl_priceOld.frame.origin.x, lbl_priceOld.frame.origin.y+7.5, 40, 1)];
                del_view.backgroundColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
                [BackView_Specialprice addSubview:del_view];
                UIButton *btn_morebtn=[[UIButton alloc] initWithFrame:CGRectMake(BackView_Specialprice.frame.size.width-50, lbl_priceNow.frame.origin.y, 40, 20)];
                [btn_morebtn setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
                [BackView_Specialprice addSubview:btn_morebtn];
                day_sprcial_more=[[UIView alloc] initWithFrame:CGRectMake(BackView_Specialprice.frame.size.width-150, 0, 150, BackView_Specialprice.frame.size.height)];
                day_sprcial_more.backgroundColor=[UIColor colorWithRed:244/255.0 green:240/255.0 blue:241/255.0 alpha:1.0];
                day_sprcial_more.hidden=YES;
                //            UILabel * lbl_juliTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, day_sprcial_more.frame.size.width/2, 15)];
                
                [BackView_Specialprice addSubview:day_sprcial_more];
            }
            [cell addSubview:BackView_Specialprice];
            
        }
        if (indexPath.section==1) {
            NSMutableArray *viewsArray = [@[] mutableCopy];
            for (int i = 0; i < circle.count; ++i) {
                UIView *item=[[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 150)];
                item.backgroundColor=[UIColor whiteColor];
                UIImageView * img_head=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20,20)];
                [img_head sd_setImageWithURL:[NSURL URLWithString:circle[i][@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                [item addSubview:img_head];
                UILabel * lbl_niceName=[[UILabel alloc] initWithFrame:CGRectMake(img_head.frame.origin.x+img_head.frame.size.width+10, 10, 100, 20)];
                lbl_niceName.text=circle[i][@"member_name"];
                [item addSubview:lbl_niceName];
                UIView * BackView_OrderDetial=[[UIView alloc] initWithFrame:CGRectMake(10, img_head.frame.origin.y+img_head.frame.size.height+10, item.frame.size.width-10, 160)];
//                BackView_OrderDetial.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
                UIImageView * img_orderImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 75, 75)];
                [img_orderImg sd_setImageWithURL:[NSURL URLWithString:circle[i][@"image"][@"0"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                [BackView_OrderDetial addSubview:img_orderImg];
                UILabel * lbl_orderTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_orderImg.frame.size.width+10, img_orderImg.frame.origin.y, BackView_OrderDetial.frame.size.width-img_orderImg.frame.size.width-20, 18)];
                lbl_orderTitle.font=[UIFont systemFontOfSize:15];
                lbl_orderTitle.text=@"觉得撒附近的索科洛夫绝世独立开发建设独立开发建设的旅客福建省大力开发建设的快乐见风";
                [BackView_OrderDetial addSubview:lbl_orderTitle];
                UILabel * lbl_OrderDetial=[[UILabel alloc] initWithFrame:CGRectMake(lbl_orderTitle.frame.origin.x, lbl_orderTitle.frame.origin.y+lbl_orderTitle.frame.size.height, lbl_orderTitle.frame.size.width, 40)];
                lbl_OrderDetial.numberOfLines=2;
                lbl_OrderDetial.text=circle[i][@"description"];
                [lbl_OrderDetial setLineBreakMode:NSLineBreakByWordWrapping];
                lbl_OrderDetial.font=[UIFont systemFontOfSize:14];
                lbl_OrderDetial.textColor=[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0];
                [BackView_OrderDetial addSubview:lbl_OrderDetial];
                UIButton * btn_dianzan=[[UIButton alloc] initWithFrame:CGRectMake(lbl_OrderDetial.frame.origin.x, lbl_OrderDetial.frame.origin.y+lbl_OrderDetial.frame.size.height, 80, 15)];
                btn_dianzan.imageView.layer.masksToBounds=YES;
                btn_dianzan.titleLabel.layer.masksToBounds=YES;
                
                [btn_dianzan setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
                btn_dianzan.imageView.bounds=CGRectMake(0, 0, 12, 15);
                btn_dianzan.titleLabel.font=[UIFont systemFontOfSize:15];
                [btn_dianzan setTitle:[NSString stringWithFormat:@"  %@",circle[i][@"praise"]] forState:UIControlStateNormal];
                [btn_dianzan setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [BackView_OrderDetial addSubview:btn_dianzan];
                UIButton * btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(btn_dianzan.frame.origin.x+btn_dianzan.frame.size.width+5, btn_dianzan.frame.origin.y, 80, 15)];
                [btn_pinglun setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
                btn_pinglun.imageView.bounds=CGRectMake(0, 0, 15, 15);
                btn_pinglun.titleLabel.font=[UIFont systemFontOfSize:15];
                [btn_pinglun setTitle:[ NSString stringWithFormat:@"  %@",circle[i][@"replys"]] forState:UIControlStateNormal];
                [btn_pinglun setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [BackView_OrderDetial addSubview:btn_pinglun];
                [item addSubview:BackView_OrderDetial];
                [viewsArray addObject:item];
            }
            
            self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(10,10, SCREEN_WIDTH-30, 150) animationDuration:2];
            self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
            self.mainScorllView.totalPagesCount = ^NSInteger(void){
                return viewsArray.count;
            };
            self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };
            
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                NSLog(@"点击了第%ld个",(long)pageIndex);
            };
            [cell addSubview:_mainScorllView];
        }
        if (indexPath.section==2) {
            tableView_GessYouLike=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20 ,cellheight)];
            tableView_GessYouLike.delegate=self;
            tableView_GessYouLike.dataSource=self;
            tableView_GessYouLike.tag=2;
            tableView_GessYouLike.scrollEnabled=NO;
            [tableView_GessYouLike setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
            [cell addSubview:tableView_GessYouLike];
        }
        if (indexPath.section==3) {
            tableView_GoodResEveryday =[[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH-20, cellheight)];
            tableView_GoodResEveryday.delegate=self;
            tableView_GoodResEveryday.dataSource=self;
            tableView_GoodResEveryday.tag=3;
            tableView_GoodResEveryday.scrollEnabled=NO;
            [tableView_GessYouLike setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
            [cell addSubview:tableView_GoodResEveryday];
        }
    }
    if (tableView.tag==2) {
        static NSString *CellIdentifier = @"GoodsTableViewCellIdentifier";
        GoodsTableViewCell *cell = (GoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:self options:nil] lastObject];
        cell.layer.masksToBounds=YES;
        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
        cell.lbl_goodsName.text=goods_like[indexPath.row][@"goods_name"];
        cell.lbl_goodsDetial.text=goods_like[indexPath.row][@"goods_jingle"];
        cell.lbl_long.text=goods_like[indexPath.row][@"juli"];
        cell.lbl_rescuncun.text=goods_like[indexPath.row][@"goods_storage"];
        cell.lbl_resxiaoliang.text=goods_like[indexPath.row][@"goods_salenum"];
        cell.lbl_liulanliang.text=goods_like[indexPath.row][@"goods_click"];
        cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",goods_like[indexPath.row][@"goods_price"]];
        if ([goods_like[indexPath.row][@"is_special"] intValue]==1)
        {
            cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",goods_like[indexPath.row][@"goods_promotion_price"]];
            cell.lbl_oldprice.text=[NSString stringWithFormat:@"¥%@",goods_like[indexPath.row][@"goods_price"]];
            NSString * stroldprice=[NSString stringWithFormat:@"¥%@",goods_like[indexPath.row][@"goods_price"]];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, cell.lbl_oldprice.frame.size.height/2, stroldprice.length*7, 1)];
            fenge.backgroundColor=[UIColor lightGrayColor];
            [cell.lbl_oldprice addSubview:fenge];
        }
        [cell.img_goodsicon sd_setImageWithURL:[NSURL URLWithString:goods_like[indexPath.row][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//        cell.lbl_rescuncun.text=goods_like[indexPath.row][@""];
        return cell;
    }
    if (tableView.tag==3) {
        static NSString *CellIdentifier = @"ResTableViewCellIdentifier";
        ResTableViewCell *cell = (ResTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"ResTableViewCell" owner:self options:nil] lastObject];
        cell.layer.masksToBounds=YES;
        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
        [cell.img_resLogo sd_setImageWithURL:[NSURL URLWithString:good_store[indexPath.row][@"store_label"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.lbl_resTitle.text=good_store[indexPath.row][@"store_name"];
        cell.lbl_resaddress.text=good_store[indexPath.row][@"store_address"];
        cell.lbl_pingjia.text=[NSString stringWithFormat:@"%@评价",good_store[indexPath.row][@"store_evaluate_count"]];
        cell.lbl_juli.text=good_store[indexPath.row][@"juli"];
        cell.lbl_classify.text=good_store[indexPath.row][@"sc_name"];
        
        CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,cell.starView.frame.size.width,15) numberOfStars:5];
        weisheng.scorePercent = [good_store[indexPath.row][@"store_desccredit"] floatValue]/5;
        weisheng.allowIncompleteStar = NO;
        weisheng.hasAnimation = YES;
        [cell.starView addSubview:weisheng];
        return cell;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return 1;
    }
    else if(tableView.tag==2)
    {
        return goods_like.count;
    }else
    {
        return good_store.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==1) {
        return 4;
    }
    else
    {
        return 1;
    }
    
}


//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([@"\n" isEqualToString:string] == YES)
//    {
//        [textField resignFirstResponder];
//        NSRange range= [searchType rangeOfString:@"宝贝"];
//        if (range.length>0) {
//            GoodListViewController * goodlist=[[GoodListViewController alloc] initWithNibName:@"GoodListViewController" bundle:[NSBundle mainBundle]];
//            goodlist.KeyWord=textField.text;
//            [self.navigationController pushViewController:goodlist animated:YES];
//        }
//        else
//        {
//            ShopInsideViewController * shoplist=[[ShopInsideViewController alloc] initWithNibName:@"ShopInsideViewController" bundle:[NSBundle mainBundle]];
//            shoplist.keyWord=textField.text;
//            [self.navigationController pushViewController:shoplist animated:YES];
//        }
//        return NO;
//    }
//    
//    return YES;
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"表格tag%ld",(long)textField.tag);
    [textField resignFirstResponder];
    NSRange range= [searchType rangeOfString:@"宝贝"];
    if (range.length>0) {
        GoodListViewController * goodlist=[[GoodListViewController alloc] initWithNibName:@"GoodListViewController" bundle:[NSBundle mainBundle]];
        goodlist.KeyWord=textField.text;
        [self.navigationController pushViewController:goodlist animated:YES];
    }
    else
    {
        ShopInsideViewController * shoplist=[[ShopInsideViewController alloc] initWithNibName:@"ShopInsideViewController" bundle:[NSBundle mainBundle]];
        shoplist.keyWord=textField.text;
        [self.navigationController pushViewController:shoplist animated:YES];
    }
    return YES;
}


-(void)clickLeftButton:(UIButton *)sender
{
    AutoLocationViewController * location=[[AutoLocationViewController alloc] init];
    [self.navigationController pushViewController:location animated:YES];
}
/**
 *  点击第一个轮播图
 *
 *  @param cycleScrollView <#cycleScrollView description#>
 *  @param index           <#index description#>
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}
/**
 *  更多天天特价
 */
-(void)btn_MorespecialPriceClick
{
    NSLog(@"天天特价");
    GoodListViewController * goodlist=[[GoodListViewController alloc] initWithNibName:@"GoodListViewController" bundle:[NSBundle mainBundle]];
    goodlist.type=1;
    [self.navigationController pushViewController:goodlist animated:YES];
}
/**
 *  更多晒单圈
 */
-(void)Btn_MoreshowOrderClick
{
    NSLog(@"晒单圈");
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary * userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (userinfoWithFile[@"key"]) {
        ShowOrderViewController * showorder=[[ShowOrderViewController alloc] init];
        showorder.key=userinfoWithFile[@"key"];
        showorder.nickName=userinfoWithFile[@"username"];
        showorder.avatarImageHeader=userinfoWithFile[@"avatar"];
        [self.navigationController pushViewController:showorder animated:YES];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}
/**
 *  更多猜你喜欢
 */
-(void)Btn_GuessYoulike
{
    NSLog(@"猜你喜欢");
    GoodListViewController * goodlist=[[GoodListViewController alloc] initWithNibName:@"GoodListViewController" bundle:[NSBundle mainBundle]];
    goodlist.type=2;
    [self.navigationController pushViewController:goodlist animated:YES];
}
/**
 *  每日好店
 */
-(void)btn_GoodResEveryDay
{
    NSLog(@"每日好店");
    ShopInsideViewController * shoplist=[[ShopInsideViewController alloc] initWithNibName:@"ShopInsideViewController" bundle:[NSBundle mainBundle]];
//    shoplist.keyWord=textField.text;
    [self.navigationController pushViewController:shoplist animated:YES];
}


-(void)JumpToGoodList:(UIButton *)sender
{
    GoodListViewController * goodlist=[[GoodListViewController alloc] initWithNibName:@"GoodListViewController" bundle:[NSBundle mainBundle]];
    goodlist.gc_id=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self.navigationController pushViewController:goodlist animated:YES];
}
-(void)changeCityInfo
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    NSDictionary * cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (cityinfoWithFile) {
        areaid=cityinfoWithFile[@"area_id"];
        _lblLeft.text=cityinfoWithFile[@"area_name"];
    }
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetIndexData:"];
    [dataprovider GetIndexDataWithAreaid:areaid andlng:lng andlat:lat];//areaid
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}

@end
