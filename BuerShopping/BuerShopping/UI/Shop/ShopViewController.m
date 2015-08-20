//
//  ShopViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ShopViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "MJRefresh.h"
#import "ResTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CWStarRateView.h"
#import "ShopDetialViewController.h"
#import "CCLocationManager.h"

@interface ShopViewController ()
@property (nonatomic, strong) NSMutableArray *classifys;
@property (nonatomic, strong) NSArray *sorts;
@end

@implementation ShopViewController
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
    BOOL isfooterrefresh;
    NSArray * arrayStoreList;
    NSDictionary * cityinfoWithFile;
    BOOL keyboardZhezhaoShow;
    NSDictionary * UserinfoWithFile;
    
    int ishasmorepage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    keyboardZhezhaoShow=NO;
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self loadAllData];
    [self InitAllView];
}
-(void)loadAllData
{
    // 数据
    key=@"1";
    order=@"1";
    lat=@"";
    lng=@"";
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    page=@"8";
    curpage=1;
    isfooterrefresh=NO;
    ishasmorepage=0;
    self.classifys=[[NSMutableArray alloc] initWithObjects:@"全部分类", nil];
    self.sorts = @[@"智能排序",@"好评优先",@"离我最近"];
    
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"GetStoreListBackCall:"];
//    [dataprovider GetStoreList:[self BuildStorePrmfunc]];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetClassifyBackCall:"];
    [dataprovider getClassifyForStore];
    
}

-(void)InitAllView
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    areaid=cityinfoWithFile[@"area_id"];
    [self addLeftbuttontitle:cityinfoWithFile[@"area_name"]];
//    plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
//    UserinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    key=UserinfoWithFile[@"key"];
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        lng=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
        if (!cityinfoWithFile[@"area_name"]) {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"GetCityBackCall:"];
            [dataprovider GetcityInfoWithlng:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude] andlat:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
        }
    }];
    
    _lblLeft.font=[UIFont systemFontOfSize:13];
    UIImageView * img_icon_down=[[UIImageView alloc] initWithFrame:CGRectMake(_btnLeft.frame.size.width-8, 18, 8, 5)];
    img_icon_down.image=[UIImage imageNamed:@"menu_down"];
    [_btnLeft addSubview:img_icon_down];
    
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
    _myTableview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    _myTableview.delegate=self;
    _myTableview.dataSource=self;
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
    }];
    // 默认先隐藏footer
    _myTableview.footer.hidden = NO;
    
    
    
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
    ShopDetialViewController * shopdetial=[[ShopDetialViewController alloc] initWithNibName:@"ShopDetialViewController" bundle:[NSBundle mainBundle]];
    shopdetial.sc_id=arrayStoreList[indexPath.section][@"store_id"];
    [self.navigationController pushViewController:shopdetial animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResTableViewCellIdentifier";
    ResTableViewCell *cell = (ResTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"ResTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    [cell.img_resLogo sd_setImageWithURL:[NSURL URLWithString:arrayStoreList[indexPath.section][@"store_avatar"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.lbl_resTitle.text=arrayStoreList[indexPath.section][@"store_name"];
    cell.lbl_resaddress.text=arrayStoreList[indexPath.section][@"store_address"];
    cell.lbl_pingjia.text=[NSString stringWithFormat:@"%@评价",arrayStoreList[indexPath.section][@"store_evaluate_count"]];
    cell.lbl_juli.text=arrayStoreList[indexPath.section][@"juli"];
    cell.lbl_classify.text=arrayStoreList[indexPath.section][@"sc_name"];
    
    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,cell.starView.frame.size.width,15) numberOfStars:5];
    weisheng.scorePercent = [arrayStoreList[indexPath.section][@"store_desccredit"] floatValue]/5;
    weisheng.allowIncompleteStar = NO;
    weisheng.hasAnimation = YES;
    [cell.starView addSubview:weisheng];
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

-(void)StoreTopRefresh
{
    curpage=1;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetStoreListBackCall:"];
    [dataprovider GetStoreList:[self BuildStorePrmfunc]];
}

-(void)StoreFootRefresh
{
    if (ishasmorepage==1) {
        curpage++;
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
        [dataprovider GetStoreList:[self BuildStorePrmfunc]];
    }else{
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"亲，" message:@"没有更多数据了哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [_myTableview.footer endRefreshing];
        isfooterrefresh=NO;
    }
    
}

-(void)FootRefireshBackCall:(id)dict
{
    
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
        arrayStoreList=dict[@"datas"][@"goods_list"];
        [_myTableview reloadData];
    }
}
-(void)GetClassifyBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if (!dict[@"datas"][@"error"]) {
        
        self.classifys=dict[@"datas"][@"class_list"];
        // 添加下拉菜单
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
        menu.delegate = self;
        menu.dataSource = self;
        [self.view addSubview:menu];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([@"\n" isEqualToString:string] == YES)
    {
        [textField resignFirstResponder];
        NSRange range= [searchType rangeOfString:@"宝贝"];
        if (range.length>0) {
            //            GoodListViewController * goodlist=[[GoodListViewController alloc] initWithNibName:@"GoodListViewController" bundle:[NSBundle mainBundle]];
            //            goodlist.KeyWord=textField.text;
            //            [self.navigationController pushViewController:goodlist animated:YES];
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"表格tag%ld",(long)textField.tag);
    [textField resignFirstResponder];
    return YES;
}



- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
    }else {
        return self.sorts.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row][@"sc_name"];
    } else {
        return self.sorts[indexPath.row];
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
    if (indexPath.column==0) {
        _sc_id=[NSString stringWithFormat:@"%@",self.classifys[indexPath.row][@"sc_id"]];
    }
    if (indexPath.column==1) {
        key=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    [self StoreTopRefresh];
}

-(NSDictionary * )BuildStorePrmfunc
{
    if (_keyWord) {
        NSDictionary * dict=@{@"page":page,@"curpage":[NSString stringWithFormat:@"%d",curpage],@"city_id":areaid,@"keyword":_keyWord,@"lng":lng,@"lat":lat,@"key":key,@"order":order};
        areaid=cityinfoWithFile[@"area_id"];
        return dict;
    }
    else if(_sc_id)
    {
        NSDictionary *dict=@{@"page":page,@"curpage":[NSString stringWithFormat:@"%d",curpage],@"city_id":areaid,@"sc_id":_sc_id,@"lng":lng,@"lat":lat,@"key":key,@"order":order};
        return dict;
    }
    else
    {
        NSDictionary *dict=@{@"page":page,@"curpage":[NSString stringWithFormat:@"%d",curpage],@"city_id":areaid,@"lng":lng,@"lat":lat,@"key":key,@"order":order};
        return dict;
    }
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
        
        [self StoreTopRefresh];
    }
    
}
-(void)changeCityInfo
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (cityinfoWithFile[@"area_name"]) {
        areaid=cityinfoWithFile[@"area_id"];
        _lblLeft.text=cityinfoWithFile[@"area_name"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}
@end
