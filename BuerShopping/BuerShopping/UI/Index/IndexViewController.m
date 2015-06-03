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


@interface IndexViewController ()
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic , strong) CycleScrollView *mainScorllView;
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    
    
}

-(void)initView
{
    
    _TableView_BackView.delegate=self;
    _TableView_BackView.dataSource=self;
    /***************************headerView 开始 **************************/
    UIView * myheaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH- 20, 285)];
    myheaderView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    UIView * jianju=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH- 20, 5)];
    jianju.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [myheaderView addSubview:jianju];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder@2x.png"] ];
        
        [images addObject:img];
    }
    NSArray *titles = @[@"",
                        @"",
                        @"",
                        @""
                        ];
    // 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 5, SCREEN_WIDTH- 20, 135) imagesGroup:images ];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
    _cycleScrollView.titlesGroup = titles;
    [myheaderView addSubview:_cycleScrollView];
    UIView * BackView_buttionlist=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.origin.y+_cycleScrollView.frame.size.height+5, myheaderView.frame.size.width, 135)];
    
    BackView_buttionlist.backgroundColor=[UIColor whiteColor];
    UIButton * btn_nvshi=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 20-200)/5, 5, 50, 60)];
    [btn_nvshi setImage:[UIImage imageNamed:@"nvshi"] forState:UIControlStateNormal];
    [BackView_buttionlist addSubview:btn_nvshi];
    UIButton * btn_nanshi=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 20-200)/5*2+50, 5, 50, 60)];
    [btn_nanshi setImage:[UIImage imageNamed:@"nanshi"] forState:UIControlStateNormal];
    [BackView_buttionlist addSubview:btn_nanshi];
    UIButton * btn_muying=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 20-200)/5*3+100, 5, 50, 60)];
    [btn_muying setImage:[UIImage imageNamed:@"muying"] forState:UIControlStateNormal];
    [BackView_buttionlist addSubview:btn_muying];
    UIButton * btn_huazhuang=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 20-200)/5*4+150, 5, 50, 60)];
    [btn_huazhuang setImage:[UIImage imageNamed:@"huazhuang"] forState:UIControlStateNormal];
    [BackView_buttionlist addSubview:btn_huazhuang];
    [myheaderView addSubview:BackView_buttionlist];
    UIButton * btn_shouji=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 20-200)/5, btn_nvshi.frame.origin.y+btn_nvshi.frame.size.height+5, 50, 60)];
    [btn_shouji setImage:[UIImage imageNamed:@"shouji"] forState:UIControlStateNormal];
    [BackView_buttionlist addSubview:btn_shouji];
    UIButton * btn_bangong=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 20-200)/5*2+50, btn_nvshi.frame.origin.y+btn_nvshi.frame.size.height+5, 50, 60)];
    [btn_bangong setImage:[UIImage imageNamed:@"bangong"] forState:UIControlStateNormal];
    [BackView_buttionlist addSubview:btn_bangong];
    UIButton * btn_shenghuo=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 20-200)/5*3+100, btn_nvshi.frame.origin.y+btn_nvshi.frame.size.height+5, 50, 60)];
    [btn_shenghuo setImage:[UIImage imageNamed:@"shenghuo"] forState:UIControlStateNormal];
    [BackView_buttionlist addSubview:btn_shenghuo];
    UIButton * btn_techan=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 20-200)/5*4+150, btn_nvshi.frame.origin.y+btn_nvshi.frame.size.height+5, 50, 60)];
    [btn_techan setImage:[UIImage imageNamed:@"techan"] forState:UIControlStateNormal];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * BackView_SpecialPrice=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
    BackView_SpecialPrice.backgroundColor=[UIColor whiteColor];
    switch (section) {
        case 0:
        {
            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
            lbl_specialpriceTitle.text=@"天天特价";
            [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
            UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-30-60, 5, 60, 20)];
            lbl_moreSpecialprice.text=@"更多";
            lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
            lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+3, 7, 8, 16)];
            img_go.image=[UIImage imageNamed:@"index_go"];
            [BackView_SpecialPrice addSubview:img_go];
            UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, 30)];
            [btn_morespecialprice addTarget:self action:@selector(btn_MorespecialPriceClick) forControlEvents:UIControlEventTouchUpInside];
            [BackView_SpecialPrice addSubview:btn_morespecialprice];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, btn_morespecialprice.frame.size.height, BackView_SpecialPrice.frame.size.width-20, 1)];
            fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:fenge];
        }
            break;
        case 1:
        {
            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
            lbl_specialpriceTitle.text=@"晒单圈";
            [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
            UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-30-100, 5, 100, 20)];
            lbl_moreSpecialprice.text=@"N条内容更新";
            lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
            lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
            lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
            [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+3, 7, 8, 16)];
            img_go.image=[UIImage imageNamed:@"index_go"];
            [BackView_SpecialPrice addSubview:img_go];
            UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, 30)];
            [btn_morespecialprice addTarget:self action:@selector(Btn_MoreshowOrderClick) forControlEvents:UIControlEventTouchUpInside];
            [BackView_SpecialPrice addSubview:btn_morespecialprice];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, btn_morespecialprice.frame.size.height, BackView_SpecialPrice.frame.size.width-20, 1)];
            fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:fenge];
        }
            break;
        case 2:
        {            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
            lbl_specialpriceTitle.text=@"猜你喜欢";
            [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
            UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-30-100, 5, 100, 20)];
            lbl_moreSpecialprice.text=@"查看更多";
            lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
            lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
            lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
            [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+3, 7, 8, 16)];
            img_go.image=[UIImage imageNamed:@"index_go"];
            [BackView_SpecialPrice addSubview:img_go];
            UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, 30)];
            [btn_morespecialprice addTarget:self action:@selector(Btn_GuessYoulike) forControlEvents:UIControlEventTouchUpInside];
            [BackView_SpecialPrice addSubview:btn_morespecialprice];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, btn_morespecialprice.frame.size.height, BackView_SpecialPrice.frame.size.width-20, 1)];
            fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:fenge];
        }
            break;
        case 3:
        {
            UILabel * lbl_specialpriceTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
            lbl_specialpriceTitle.text=@"每日好店";
            [BackView_SpecialPrice addSubview:lbl_specialpriceTitle];
            UILabel * lbl_moreSpecialprice=[[UILabel alloc] initWithFrame:CGRectMake(BackView_SpecialPrice.frame.size.width-30-100, 5, 100, 20)];
            lbl_moreSpecialprice.text=@"你中意的店铺";
            lbl_moreSpecialprice.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
            lbl_moreSpecialprice.font=[UIFont systemFontOfSize:13];
            lbl_moreSpecialprice.textAlignment=NSTextAlignmentRight;
            [BackView_SpecialPrice addSubview:lbl_moreSpecialprice];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_moreSpecialprice.frame.origin.x+lbl_moreSpecialprice.frame.size.width+3, 7, 8, 16)];
            img_go.image=[UIImage imageNamed:@"index_go"];
            [BackView_SpecialPrice addSubview:img_go];
            UIButton * btn_morespecialprice=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_SpecialPrice.frame.size.width, 30)];
            [btn_morespecialprice addTarget:self action:@selector(btn_GoodResEveryDay) forControlEvents:UIControlEventTouchUpInside];
            [BackView_SpecialPrice addSubview:btn_morespecialprice];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, btn_morespecialprice.frame.size.height, BackView_SpecialPrice.frame.size.width-20, 1)];
            fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [BackView_SpecialPrice addSubview:fenge];
        }
            break;
        default:
            break;
    }
    return BackView_SpecialPrice;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=80;
    switch (indexPath.section) {
        case 0:
            height=120;
            break;
        case 1:
            height=150;
            break;
        case 2:
            height=500;
            break;
        case 3:
            height=500;
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellheight=95;
    switch (indexPath.section) {
        case 0:
            cellheight=95;
            break;
        case 1:
            cellheight=150;
            break;
        case 2:
            cellheight=500;
            break;
        case 3:
            cellheight=500;
            break;
        default:
            break;
    }
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, cellheight)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        UIView * BackView_Specialprice=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 95)];
        UIImageView * img_Specialprice=[[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 75, 75)];
        [img_Specialprice sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"muying"]];
        [BackView_Specialprice addSubview:img_Specialprice];
        UIImageView * icon_special=[[UIImageView alloc] initWithFrame:CGRectMake(8, 28, 40, 15)];
        icon_special.image=[UIImage imageNamed:@"Specialprice"];
        [BackView_Specialprice addSubview:icon_special];
        UILabel * lbl_icon_special=[[UILabel alloc] initWithFrame:icon_special.frame];
        lbl_icon_special.font=[UIFont systemFontOfSize:13];
        lbl_icon_special.textColor=[UIColor whiteColor];
        lbl_icon_special.text=@"9.2折";
        [BackView_Specialprice addSubview:lbl_icon_special];
        UILabel * lbl_goodName=[[UILabel alloc] initWithFrame:CGRectMake(img_Specialprice.frame.origin.x+img_Specialprice.frame.size.width+10, 30, 150, 20)];
        lbl_goodName.text=@"产品名称";
        [BackView_Specialprice addSubview:lbl_goodName];
        UITextView * txt_goodDetial=[[UITextView alloc] initWithFrame:CGRectMake(lbl_goodName.frame.origin.x, lbl_goodName.frame.origin.y+lbl_goodName.frame.size.height+4, SCREEN_WIDTH-img_Specialprice.frame.origin.x-img_Specialprice.frame.size.width-40, 40)];
        txt_goodDetial.text=@"产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介产品简介";
        txt_goodDetial.scrollEnabled=YES;
        txt_goodDetial.editable=NO;
        [BackView_Specialprice addSubview:txt_goodDetial];
        UILabel * lbl_priceNow=[[UILabel alloc] initWithFrame:CGRectMake(lbl_goodName.frame.origin.x, txt_goodDetial.frame.origin.y+txt_goodDetial.frame.size.height+4, 60, 20)];
        lbl_priceNow.text=@"¥88";
        lbl_priceNow.textColor=[UIColor redColor];
        [BackView_Specialprice addSubview:lbl_priceNow];
        UILabel * lbl_priceOld=[[UILabel alloc] initWithFrame:CGRectMake(lbl_priceNow.frame.origin.x+lbl_priceNow.frame.size.width+10, lbl_priceNow.frame.origin.y+5, 40, 15)];
        lbl_priceOld.textColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
        lbl_priceOld.text=@"¥98";
        lbl_priceOld.font=[UIFont systemFontOfSize:13];
        [BackView_Specialprice addSubview:lbl_priceOld];
        UIView * del_view=[[UIView alloc] initWithFrame:CGRectMake(lbl_priceOld.frame.origin.x, lbl_priceOld.frame.origin.y+7.5, 40, 1)];
        del_view.backgroundColor=[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
        [BackView_Specialprice addSubview:del_view];
        UIButton *btn_morebtn=[[UIButton alloc] initWithFrame:CGRectMake(BackView_Specialprice.frame.size.width-50, lbl_priceNow.frame.origin.y, 40, 20)];
        [btn_morebtn setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
        [BackView_Specialprice addSubview:btn_morebtn];
        [cell addSubview:BackView_Specialprice];
        
    }
    if (indexPath.section==1) {
        NSMutableArray *viewsArray = [@[] mutableCopy];
        for (int i = 0; i < 5; ++i) {
            UIView *item=[[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 140)];
            item.backgroundColor=[UIColor whiteColor];
            UIImageView * img_head=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20,20)];
            [img_head sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"myying"]];
            [item addSubview:img_head];
            UILabel * lbl_niceName=[[UILabel alloc] initWithFrame:CGRectMake(img_head.frame.origin.x+img_head.frame.size.width+10, 10, 100, 20)];
            lbl_niceName.text=@"晒单人昵称";
            [item addSubview:lbl_niceName];
            UIView * BackView_OrderDetial=[[UIView alloc] initWithFrame:CGRectMake(0, img_head.frame.origin.y+img_head.frame.size.height+10, item.frame.size.width, 90)];
            BackView_OrderDetial.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
            UIImageView * img_orderImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [img_orderImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"muying"]];
            [BackView_OrderDetial addSubview:img_orderImg];
            UILabel * lbl_orderTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_orderImg.frame.size.width+10, 10, BackView_OrderDetial.frame.size.width-100, 18)];
            lbl_orderTitle.font=[UIFont systemFontOfSize:15];
            lbl_orderTitle.text=@"觉得撒附近的索科洛夫绝世独立开发建设独立开发建设的旅客福建省大力开发建设的快乐见风";
            [BackView_OrderDetial addSubview:lbl_orderTitle];
            UILabel * lbl_OrderDetial=[[UILabel alloc] initWithFrame:CGRectMake(lbl_orderTitle.frame.origin.x, lbl_orderTitle.frame.origin.y+lbl_orderTitle.frame.size.height+3, lbl_orderTitle.frame.size.width, 20)];
            lbl_OrderDetial.numberOfLines=2;
            lbl_OrderDetial.text=@"到了旷古绝今反对设立科技发动机范德雷克撒娇说的对是非得失了空间的索科洛夫就阿萨德飞";
            lbl_OrderDetial.textColor=[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0];
            [BackView_OrderDetial addSubview:lbl_OrderDetial];
//            UIButton * btn_dianzan=[[UIButton alloc] initWithFrame:CGRectMake(lbl_OrderDetial.frame.origin.x, lbl_OrderDetial.frame.origin.x+lbl_OrderDetial.frame.size.height, 40, 20)];
//            [btn_dianzan setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
//            [btn_dianzan setTitle:@"2" forState:UIControlStateNormal];
//            [btn_dianzan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [BackView_OrderDetial addSubview:btn_dianzan];
//            UIButton * btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(btn_dianzan.frame.origin.x+btn_dianzan.frame.size.width+5, btn_dianzan.frame.origin.y, 40, 20)];
//            btn_pinglun.backgroundColor=[UIColor greenColor];
//            [btn_pinglun setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
//            [btn_pinglun setTitle:@"6" forState:UIControlStateNormal];
//            [BackView_OrderDetial addSubview:btn_pinglun];
            [item addSubview:BackView_OrderDetial];
            [viewsArray addObject:item];
        }
        
        self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0,10, SCREEN_WIDTH-20, 120) animationDuration:2];
        self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        self.mainScorllView.totalPagesCount = ^NSInteger(void){
            return 5;
        };
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%ld个",(long)pageIndex);
        };
        [cell addSubview:_mainScorllView];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


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
}
/**
 *  更多晒单圈
 */
-(void)Btn_MoreshowOrderClick
{
    NSLog(@"晒单圈");
}
/**
 *  更多猜你喜欢
 */
-(void)Btn_GuessYoulike
{
    NSLog(@"猜你喜欢");
}
/**
 *  每日好店
 */
-(void)btn_GoodResEveryDay
{
    NSLog(@"每日好店");
}
@end
