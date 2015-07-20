//
//  ShopInsideViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/1.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ShopInsideViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "MJRefresh.h"
#import "ResTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CWStarRateView.h"
#import "ShopDetialViewController.h"

@interface ShopInsideViewController ()
@property (nonatomic, strong) NSMutableArray *classifys;
@property (nonatomic, strong) NSArray *sorts;
@end

@implementation ShopInsideViewController
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self loadAllData];
    [self InitAllView];
}
-(void)loadAllData
{
    // 数据
    key=@"";
    order=@"";
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    page=@"8";
    curpage=1;
    isfooterrefresh=NO;
    keyboardZhezhaoShow=NO;
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
    curpage++;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    [dataprovider GetStoreList:[self BuildStorePrmfunc]];
}

-(void)FootRefireshBackCall:(id)dict
{
    
    NSLog(@"上拉刷新");
    [_myTableview reloadData];
    // 结束刷新
    [_myTableview.footer endRefreshing];
    isfooterrefresh=NO;
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


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (!keyboardZhezhaoShow) {
        UIButton * btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65-height)];
        [btn_zhezhao addTarget:self action:@selector(tuichuKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
        btn_zhezhao.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
        [self.view addSubview:btn_zhezhao];
        keyboardZhezhaoShow=YES;
    }
}

-(void)btn_zhezhaoClick:(UIButton *)sender
{
    keyboardZhezhaoShow=NO;
    [txt_searchtext resignFirstResponder];
    [sender removeFromSuperview];
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
        _sc_id=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    if (indexPath.column==0) {
        order=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    [self StoreTopRefresh];
}

-(NSDictionary * )BuildStorePrmfunc
{
    if (_keyWord) {
        NSDictionary * dict=@{@"page":page,@"curpage":[NSString stringWithFormat:@"%d",curpage],@"city_id":@"88",@"keyword":_keyWord,@"lng":@"1",@"lat":@"1",@"key":key,@"order":order};
        areaid=cityinfoWithFile[@"area_id"];
        return dict;
    }
    else if(_sc_id)
    {
        NSDictionary *dict=@{@"page":page,@"curpage":[NSString stringWithFormat:@"%d",curpage],@"city_id":@"88",@"sc_id":_sc_id,@"lng":@"1",@"lat":@"1",@"key":key,@"order":order};
        return dict;
    }
    else
    {
        NSDictionary *dict=@{@"page":page,@"curpage":[NSString stringWithFormat:@"%d",curpage],@"city_id":@"88",@"lng":@"1",@"lat":@"1",@"key":key,@"order":order};
        return dict;
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
