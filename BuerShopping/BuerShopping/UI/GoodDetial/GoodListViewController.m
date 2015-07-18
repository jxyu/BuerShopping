//
//  GoodListViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "GoodListViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "DataProvider.h"
#import "CCLocationManager.h"
#import "GoodsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommenDef.h"
#import "ShopViewController.h"
#import "GoodDetialViewController.h"


@interface GoodListViewController ()

@end

@implementation GoodListViewController
{
    UITextField * txt_searchtext;
    UIButton * btn_select;
    NSArray* selectArray;
    UIView * select_Backview;
    BOOL isSelectViewShow;
    NSString * searchType;
    NSString * page;
    int curpage;
    NSString * areaid;
    NSString *lat;
    NSString *lng;
    NSString *key;
    NSString *order;
    NSArray * arrayGoodList;
    BOOL isfooterrefresh;
    BOOL isxiaoliangup;
    BOOL isjiageup;
    UIView * backView_order;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightButton:@"ShopCar_icon_goodslist@2x.png"];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    arrayGoodList=[[NSArray alloc] init];
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
        lng=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
    }];
    isfooterrefresh=NO;
    isSelectViewShow=NO;
    isxiaoliangup=NO;
    isjiageup=NO;
    [self loadAllData];
    [self InitAllVeiw];
}

-(void)InitAllVeiw
{
    
    
    /**********************************head搜索栏开始***********************************/
    selectArray=@[@"宝贝",@"店铺"];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    UIView * BackView_Serch=[[UIView alloc] initWithFrame:CGRectMake(_btnLeft.frame.size.width-20, 22.5, SCREEN_WIDTH-_btnLeft.frame.size.width-_btnLeft.frame.origin.x-22, 35)];
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
    
    backView_order=[[UIView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 40)];
    backView_order.backgroundColor=[UIColor whiteColor];
    float itemwidth=(backView_order.frame.size.width-3)/4;
    UIButton * btn_default=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemwidth, 40)];
    [btn_default setTitle:@"默认" forState:UIControlStateNormal];
    btn_default.tag=1000;
    [btn_default setTitleColor:[UIColor colorWithRed:115/255.0 green:73/255.0 blue:139/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn_default addTarget:self action:@selector(ChangeOrder:) forControlEvents:UIControlEventTouchUpInside];
    [backView_order addSubview:btn_default];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(btn_default.frame.size.width, 10, 1, 20)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [backView_order addSubview:fenge];
    UIButton * btn_xiaoliang=[[UIButton alloc] initWithFrame:CGRectMake(fenge.frame.size.width+fenge.frame.origin.x, 0, itemwidth, 40)];
    [btn_xiaoliang setTitleColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn_xiaoliang setTitle:@"销量" forState:UIControlStateNormal];
    btn_xiaoliang.tag=1001;
    [btn_xiaoliang addTarget:self action:@selector(ChangeOrder:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * img_icon1=[[UIImageView alloc] initWithFrame:CGRectMake(btn_xiaoliang.frame.size.width-20, 12.5, 8, 15)];
    img_icon1.image=[UIImage imageNamed:@"order_normal_icon"];
    img_icon1.tag=5;
    [btn_xiaoliang addSubview:img_icon1];
    [backView_order addSubview:btn_xiaoliang];
    UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(btn_xiaoliang.frame.size.width+btn_xiaoliang.frame.origin.x, 10, 1, 20)];
    fenge1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [backView_order addSubview:fenge1];
    UIButton * btn_jiage=[[UIButton alloc] initWithFrame:CGRectMake(fenge1.frame.size.width+fenge1.frame.origin.x, 0, itemwidth, 40)];
    [btn_jiage setTitleColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn_jiage setTitle:@"价格" forState:UIControlStateNormal];
    btn_jiage.tag=1002;
    [btn_jiage addTarget:self action:@selector(ChangeOrder:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * img_icon2=[[UIImageView alloc] initWithFrame:CGRectMake(btn_xiaoliang.frame.size.width-20, 12.5, 8, 15)];
    img_icon2.image=[UIImage imageNamed:@"order_normal_icon"];
    img_icon2.tag=5;
    [btn_jiage addSubview:img_icon2];
    [backView_order addSubview:btn_jiage];
    UIView * fenge2=[[UIView alloc] initWithFrame:CGRectMake(btn_jiage.frame.size.width+btn_jiage.frame.origin.x, 10, 1, 20)];
    fenge2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [backView_order addSubview:fenge2];
    UIButton * btn_haoping=[[UIButton alloc] initWithFrame:CGRectMake(fenge2.frame.size.width+fenge2.frame.origin.x, 0, itemwidth, 40)];
    [btn_haoping setTitleColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn_haoping setTitle:@"好评" forState:UIControlStateNormal];
    btn_haoping.tag=1003;
    [btn_haoping addTarget:self action:@selector(ChangeOrder:) forControlEvents:UIControlEventTouchUpInside];
    [backView_order addSubview:btn_haoping];
    [self.view addSubview:backView_order];
    _myTableView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    // 下拉刷新
    [_myTableView addLegendHeaderWithRefreshingBlock:^{
        
        [self TopRefresh];
    }];
    [_myTableView.header beginRefreshing];
    
    // 上拉刷新
    [_myTableView addLegendFooterWithRefreshingBlock:^{
        if (!isfooterrefresh) {
            isfooterrefresh=YES;
            [self FootRefresh];
        }
        // 结束刷新
        [_myTableView.footer endRefreshing];
    }];
    // 默认先隐藏footer
    _myTableView.footer.hidden = NO;
}
-(void)loadAllData
{
    key=@"";
    order=@"";
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    page=@"8";
    curpage=1;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetGoodsListBackcall:"];
    [dataprovider GetGoodsListWithKeyWord:[self BuildPrmfunc]];
}

-(void)GetGoodsListBackcall:(id)dict
{
    [SVProgressHUD dismiss];
    [_myTableView reloadData];
    [_myTableView.header endRefreshing];
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        arrayGoodList=dict[@"datas"][@"goods_list"];
        [_myTableView reloadData];
    }
}

-(NSDictionary * )BuildPrmfunc
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    NSDictionary * cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (_KeyWord) {
        NSDictionary * dict=@{@"page":page,@"curpage":[NSString stringWithFormat:@"%d",curpage],@"city_id":@"88",@"keyword":_KeyWord,@"lng":@"1",@"lat":@"1",@"key":key,@"order":order};
        areaid=cityinfoWithFile[@"area_id"];
        return dict;
    }
    else
    {
        NSDictionary *dict=@{@"page":page,@"curpage":[NSString stringWithFormat:@"%d",curpage],@"city_id":@"88",@"gc_id":@"1067",@"lng":@"1",@"lat":@"1",@"key":key,@"order":order};
        return dict;
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([@"\n" isEqualToString:string] == YES)
    {
        [textField resignFirstResponder];
        NSRange range= [searchType rangeOfString:@"宝贝"];
        if (range.length>0) {
            _KeyWord=textField.text;
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"GetGoodsListBackcall:"];
            [dataprovider GetGoodsListWithKeyWord:[self BuildPrmfunc]];
        }
        else
        {
            ShopViewController * shoplist=[[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:[NSBundle mainBundle]];
            shoplist.keyWord=textField.text;
            [self.navigationController pushViewController:shoplist animated:YES];
        }
        return NO;
    }
    
    return YES;
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


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    UIButton * btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-height)];
    [btn_zhezhao addTarget:self action:@selector(btn_zhezhaoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn_zhezhao];
}

-(void)btn_zhezhaoClick:(UIButton *)sender
{
    [txt_searchtext resignFirstResponder];
    [sender removeFromSuperview];
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
    gooddetial.gc_id=arrayGoodList[indexPath.section][@"goods_id"];
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
    cell.lbl_goodsName.text=arrayGoodList[indexPath.row][@"goods_name"];
    cell.lbl_goodsDetial.text=arrayGoodList[indexPath.row][@"goods_jingle"];
    cell.lbl_long.text=arrayGoodList[indexPath.row][@"juli"];
    cell.lbl_price.text=arrayGoodList[indexPath.row][@"goods_price"];
    [cell.img_goodsicon sd_setImageWithURL:[NSURL URLWithString:arrayGoodList[indexPath.row][@"goods_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
    return arrayGoodList.count;
}

-(void)TopRefresh
{
    curpage=1;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetGoodsListBackcall:"];
    [dataprovider GetGoodsListWithKeyWord:[self BuildPrmfunc]];
}

-(void)FootRefresh
{
    curpage++;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataprovider GetGoodsListWithKeyWord:[self BuildPrmfunc]];
}

-(void)FootRefireshBackCall:(id)dict
{
    isfooterrefresh=NO;
    NSLog(@"上拉刷新");
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:arrayGoodList];
    if (!dict[@"datas"][@"error"]) {
        NSArray * arrayitem=dict[@"datas"][@"goods_list"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        arrayGoodList=[[NSArray alloc] initWithArray:itemarray];
    }
    [_myTableView reloadData];
}

-(void)ChangeOrder:(UIButton *)sender
{
    for (UIView *items in backView_order.subviews) {
        NSLog(@"%ld",(long)items.tag);
        if (items.tag>=1000) {
            UIButton *item=(UIButton *)items;
            [item setTitleColor:[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
            for (UIView * img_item in item.subviews) {
                if (img_item.tag==5) {
                    UIImageView *img_icon=(UIImageView *)img_item;
                    [img_icon setImage:[UIImage imageNamed:@"order_normal_icon"]];
                }
            }
        }
    }
    
    [sender setTitleColor:[UIColor colorWithRed:115/255.0 green:73/255.0 blue:139/255.0 alpha:1.0] forState:UIControlStateNormal];
    switch (sender.tag) {
        case 1000:
            
            break;
        case 1001:
            for (UIView * img_item in sender.subviews) {
                if (img_item.tag==5) {
                    UIImageView *img_icon=(UIImageView *)img_item;
                    if (!isxiaoliangup) {
                        [img_icon setImage:[UIImage imageNamed:@"order_up_icon"]];
                        isxiaoliangup=YES;
                    }else
                    {
                        [img_icon setImage:[UIImage imageNamed:@"order_down_icon"]];
                        isxiaoliangup=NO;
                    }
                    
                }
            }
            break;
        case 1002:
            for (UIView * img_item in sender.subviews) {
                if (img_item.tag==5) {
                    UIImageView *img_icon=(UIImageView *)img_item;
                    if (!isjiageup) {
                        [img_icon setImage:[UIImage imageNamed:@"order_up_icon"]];
                        isjiageup=YES;
                    }else
                    {
                        [img_icon setImage:[UIImage imageNamed:@"order_down_icon"]];
                        isjiageup=NO;
                    }
                    
                }
            }
            break;
        case 1003:
            
            break;
        default:
            break;
    }
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
