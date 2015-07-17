//
//  ShoppingCarViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "MJRefresh.h"
#import "CarCellNormalTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "EditCellTableViewCell.h"
#import "ShoppingCarOrderForSureViewController.h"


@interface ShoppingCarViewController ()

@end

@implementation ShoppingCarViewController
{
    BOOL isSelectAll;
    NSMutableArray *CarListArray;
    BOOL isSectionSelect;
    NSMutableArray * editArray;
    BOOL isEdit;
    NSMutableArray * Orderdata;
    NSMutableArray * CellSelectData;
    NSDictionary *userinfoWithFile;
    NSMutableArray * sectionArray;
    NSMutableArray * cellArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"购物车(20)";
    _lblTitle.textColor=[UIColor whiteColor];
    isSelectAll=NO;
    isSectionSelect=NO;
    isEdit=NO;
    CarListArray=[[NSMutableArray alloc] init];
    editArray=[[NSMutableArray alloc] init];
    Orderdata=[[NSMutableArray alloc] init];
    CellSelectData=[[NSMutableArray alloc]init];
    sectionArray =[[NSMutableArray alloc] init];
    cellArray=[[NSMutableArray alloc] init];
    _myTableview.delegate=self;
    _myTableview.dataSource=self;
    [self LoadeAllData];
}

-(void)LoadeAllData
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    // 下拉刷新
    [_myTableview addLegendHeaderWithRefreshingBlock:^{
        isSelectAll=NO;
        isSectionSelect=NO;
        isEdit=NO;
        _img_selectAll.image=[UIImage imageNamed:@"shoppingcar_unselect_icon"];
        [self TopRefresh];
    }];
    [_myTableview.header beginRefreshing];
    [_btn_payfororder addTarget:self action:@selector(btn_PayForOrderClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btn_PayForOrderClick:(UIButton *)sender
{
    NSLog(@"立即购买");
    NSString * strprm=@"";
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (userinfoWithFile[@"key"]) {
        if (Orderdata.count>0) {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"buyrightBackCall:"];
            for (int i=0; i<Orderdata.count; i++) {
                NSArray * itemarray=[[NSArray alloc] initWithArray:Orderdata[i][@"store_list"]];
                for (int j=0; j<itemarray.count; j++) {
                    if (j==0&&i==0) {
                        strprm=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@|%@",itemarray[j][@"cart_id"],itemarray[j][@"goods_num"]]];
                    }
                    else
                    {
                        strprm=[strprm stringByAppendingString:[NSString stringWithFormat:@",%@|%@",itemarray[j][@"cart_id"],itemarray[j][@"goods_num"]]];
                    }
                }
            }
            [dataprovider Buy_Stepone:userinfoWithFile[@"key"] andcart_id:strprm andifcart:@"1"];
            
        }
        else
        {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)buyrightBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        ShoppingCarOrderForSureViewController * orderforsure=[[ShoppingCarOrderForSureViewController alloc] initWithNibName:@"ShoppingCarOrderForSureViewController" bundle:[NSBundle mainBundle]];
        orderforsure.OrderData=dict[@"datas"];
        orderforsure.key=userinfoWithFile[@"key"];
        [self.navigationController pushViewController:orderforsure animated:YES];
    }
}
-(void)TopRefresh
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderListBackCall:"];
    [dataprovider GetShopCarList:userinfoWithFile[@"key"]];
}
-(void)GetOrderListBackCall:(id)dict
{
    NSLog(@"%@",dict);
    
    if (!dict[@"datas"][@"error"]) {
        CarListArray=[dict[@"datas"][@"cart_list"] mutableCopy];
        [_myTableview reloadData];
    }
    
    [_myTableview.header endRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionHeaderView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    sectionHeaderView.backgroundColor=[UIColor whiteColor];
    UIButton * btn_sectionselect=[[UIButton alloc] initWithFrame:CGRectMake(3, 0, 38, sectionHeaderView.frame.size.height)];
    if (isSelectAll||[self isSectionExist:[NSString stringWithFormat:@"%ld",(long)section]]) {
        [btn_sectionselect setImage:[UIImage imageNamed:@"shoppingcar_select_icon"] forState:UIControlStateNormal];
        btn_sectionselect.tag=section;
    }
    else
    {
        [btn_sectionselect setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon"] forState:UIControlStateNormal];
        btn_sectionselect.tag=1000+section;
    }
    [btn_sectionselect addTarget:self action:@selector(SectionSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:btn_sectionselect];
    UIImageView * img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(btn_sectionselect.frame.size.width+btn_sectionselect.frame.origin.x+10, 15, 20, 20)];
    img_icon.image=[UIImage imageNamed:@"dianpu_gray_icon"];
    [sectionHeaderView addSubview:img_icon];
    UILabel * lbl_StoreTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_icon.frame.size.width+img_icon.frame.origin.x+10, 15, 100, 20)];
    lbl_StoreTitle.text=CarListArray[section][@"store_name"];
    [sectionHeaderView addSubview:lbl_StoreTitle];
    UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_StoreTitle.frame.origin.x+lbl_StoreTitle.frame.size.width+3, 19, 7, 12)];
    img_go.image=[UIImage imageNamed:@"index_go"];
    [sectionHeaderView addSubview:img_go];
    UIButton * btn_edit=[[UIButton alloc] initWithFrame:CGRectMake(sectionHeaderView.frame.size.width-60, 0, 60, sectionHeaderView.frame.size.height)];
    if (isEdit) {
        [btn_edit setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        [btn_edit setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    btn_edit.tag=section;
    [btn_edit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_edit.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_edit addTarget:self action:@selector(EditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:btn_edit];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(sectionHeaderView.frame.size.width-61, 10, 1, 20)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [sectionHeaderView addSubview:fenge];
    UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(10, sectionHeaderView.frame.size.height-1, sectionHeaderView.frame.size.width-20, 1)];
    fenge1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [sectionHeaderView addSubview:fenge1];
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%ld",(long)indexPath.section);
    NSArray * itemarray=CarListArray[indexPath.section][@"store_list"];
    if (isEdit) {
        static NSString *CellIdentifier = @"editcarTableViewCellIdentifier";
        EditCellTableViewCell *cell = (EditCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"EditCellTableViewCell" owner:self options:nil] lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
        [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:itemarray[indexPath.row][@"goods_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        if (isSelectAll||[self isSectionExist:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]||[self isCellExist:[NSString stringWithFormat:@"%ld|%ld",(long)indexPath.section,(long)indexPath.row]]) {
            [cell.btn_select setImage:[UIImage imageNamed:@"shoppingcar_select_icon"] forState:UIControlStateNormal];
            cell.btn_select.tag=1;
        }
        else
        {
            [cell.btn_select setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon"] forState:UIControlStateNormal];
            cell.btn_select.tag=0;
        }
        [cell.btn_select addTarget:self action:@selector(CellBtnSelectclick:) forControlEvents:UIControlEventTouchUpInside];
        cell.lbl_num.text=@"1";
        cell.lbl_detial.text=itemarray[indexPath.row][@"goods_jingle"];
        cell.lbl_num.text=itemarray[indexPath.row][@"goods_num"];
        [cell.btn_add addTarget:self action:@selector(BtnAddGood:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_jian addTarget:self action:@selector(jianGoodClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_del addTarget:self action:@selector(DelGoods:) forControlEvents:UIControlEventTouchUpInside];
        return  cell;
        
    }
    else
    {
        static NSString *CellIdentifier = @"carTableViewCellIdentifier";
        CarCellNormalTableViewCell *cell = (CarCellNormalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"CarCellNormalTableViewCell" owner:self options:nil] lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
        [cell.img_GoodLogo sd_setImageWithURL:[NSURL URLWithString:itemarray[indexPath.row][@"goods_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        if (isSelectAll||[self isSectionExist:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]||[self isCellExist:[NSString stringWithFormat:@"%ld|%ld",(long)indexPath.section,(long)indexPath.row]]) {
            [cell.btn_cellselect setImage:[UIImage imageNamed:@"shoppingcar_select_icon"] forState:UIControlStateNormal];
            cell.btn_cellselect.tag=1;
        }
        else
        {
            [cell.btn_cellselect setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon"] forState:UIControlStateNormal];
            cell.btn_cellselect.tag=0;
        }
        [cell.btn_cellselect addTarget:self action:@selector(CellBtnSelectclick:) forControlEvents:UIControlEventTouchUpInside];
        cell.lbl_title.text=itemarray[indexPath.row][@"goods_name"];
        cell.lbl_detial.text=itemarray[indexPath.row][@"goods_jingle"];
        cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",itemarray[indexPath.row][@"goods_price"]];
        cell.lbl_num.text=[NSString stringWithFormat:@"x%@",itemarray[indexPath.row][@"goods_num"]];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * itemarray=CarListArray[section][@"store_list"];
    return itemarray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return CarListArray.count;
}

#pragma mark tablecell选择操作
-(void)EditBtnClick:(UIButton *)sender
{
    BOOL isexist=NO;
    if (editArray&&editArray.count>0) {
        
        for (int i=0; i<editArray.count; i++) {
            if ([[NSString stringWithFormat:@"%ld",(long)sender.tag] isEqualToString:editArray[i]]) {
                isexist=YES;
                break;
            }
        }
        if (isexist) {
            if (isEdit) {
                isEdit=NO;
                [editArray removeObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
                [sender setTitle:@"编辑" forState:UIControlStateNormal];
                [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                isEdit=YES;
                [editArray addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
                [sender setTitle:@"完成" forState:UIControlStateNormal];
                [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else
        {
            isEdit=YES;
            [editArray addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            [sender setTitle:@"完成" forState:UIControlStateNormal];
            [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        isEdit=YES;
        [editArray addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void)SectionSelectBtnClick:(UIButton *)sender
{
    if (isSelectAll) {
        return;
    }
    if (sender.tag>=1000) {
//        _img_selectAll.image=[UIImage imageNamed:@"shoppingcar_unselect_icon"];
        int section=sender.tag-1000;
        [sectionArray addObject:[NSString stringWithFormat:@"%d",section]];
        isSectionSelect=YES;
//        isSelectAll=YES;
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        sender.tag=section;
        if (Orderdata.count>0) {
            for (int i=0; i<Orderdata.count; i++) {
                if ([Orderdata[i][@"store_id"] isEqual:CarListArray[sender.tag][@"store_id"]]) {
                    [Orderdata removeObject:Orderdata[i]];
                    break;
                }
            }
        }

        [Orderdata addObject:CarListArray[section]];
        
    }
    else
    {
        isSectionSelect=NO;
        if ([self isSectionExist:[NSString stringWithFormat:@"%ld",(long)sender.tag]]) {//判断该section是否已被选中
            if (sectionArray) {
                for (NSString *items in sectionArray) {
                    if ([items isEqualToString:[NSString stringWithFormat:@"%ld",(long)sender.tag]]) {
                        [sectionArray removeObject:items];
                    }
                }
            }

        }
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
        if (Orderdata.count>0) {
            for (int i=0; i<Orderdata.count; i++) {
                if ([Orderdata[i][@"store_id"] isEqual:CarListArray[sender.tag][@"store_id"]]) {
                    [Orderdata removeObject:Orderdata[i]];
                    break;
                }
            }
        }
        sender.tag=sender.tag+1000;
    }
    [self AddAllOrderForPrice];
}
-(void)CellBtnSelectclick:(UIButton *)sender
{
    if (isSelectAll) {
        return;
    }
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_myTableview indexPathForCell:cell];
    if (sender.tag==1) {
        [sender setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon"] forState:UIControlStateNormal];
        if (cellArray) {
            for (NSString *items in cellArray) {
                if ([items isEqualToString:[NSString stringWithFormat:@"%ld|%ld",(long)indexPath.section,(long)indexPath.row]]) {
                    [cellArray removeObject:items];
                }
            }
        }
        sender.tag=0;
        for (int i=0; i<Orderdata.count; i++) {
            NSMutableArray * itemArray=[[NSMutableArray alloc] initWithArray:Orderdata[i][@"store_list"]];
            for (id d in itemArray) {
                NSMutableDictionary*item =[NSMutableDictionary dictionaryWithDictionary:d];
                if ([item[@"goods_id"] isEqual:CarListArray[indexPath.section][@"store_list"][indexPath.row][@"goods_id"]]) {
                    [itemArray removeObject:item];
                    NSArray *noarray=[[NSArray alloc] initWithArray:itemArray];
                    [Orderdata[i] setObject:noarray forKey:@"store_list" ];
                    break;
                }
            }
        }
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"shoppingcar_select_icon"] forState:UIControlStateNormal];
        sender.tag=1;
        BOOL isexist=NO;
        [cellArray addObject:[NSString stringWithFormat:@"%ld|%ld",(long)indexPath.section,(long)indexPath.row]];
        for (int i=0; i<Orderdata.count; i++) {
            if ([Orderdata[i][@"store_id"] isEqualToString:CarListArray[indexPath.section][@"store_id"]]) {
                isexist=YES;
                break;
            }
        }
        
        if (!isexist) {
            NSArray *item=[[NSArray alloc] init];
            NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithDictionary:CarListArray[indexPath.section]];
            [dict setObject:item forKey:@"store_list"];
            [Orderdata addObject:dict];
        }
        for (int i=0; i<Orderdata.count; i++) {
            if ([Orderdata[i][@"store_id"] isEqualToString:CarListArray[indexPath.section][@"store_id"]]) {
                NSMutableArray * itemArray=[[NSMutableArray alloc] initWithArray:Orderdata[i][@"store_list"]];
                [itemArray addObject:CarListArray[indexPath.section][@"store_list"][indexPath.row]];
                NSArray *noarray=[[NSArray alloc] initWithArray:itemArray];
                [Orderdata[i] setObject:noarray forKey:@"store_list" ];
                break;
            }
        }
    }
    [self AddAllOrderForPrice];
}

- (IBAction)btn_SelectAllClick:(UIButton *)sender {
    if (isSelectAll) {
        [sectionArray removeAllObjects];
        [cellArray removeAllObjects];
        _img_selectAll.image=[UIImage imageNamed:@"shoppingcar_unselect_icon"];
        [_myTableview reloadData];
        isSelectAll=NO;
        isSectionSelect=NO;
        [Orderdata removeAllObjects];
    }
    else
    {
        [_myTableview reloadData];
        _img_selectAll.image=[UIImage imageNamed:@"shoppingcar_select_icon"];
        isSelectAll=YES;
        isSectionSelect=YES;
        Orderdata=[[NSMutableArray alloc] initWithArray:CarListArray];
    }
    [self AddAllOrderForPrice];
}


#pragma mark 编辑tablecell
-(void)BtnAddGood:(UIButton * )sender
{
    NSLog(@"货物加一");
    @try {
        UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
        NSIndexPath *indexPath = [_myTableview indexPathForCell:cell];
        NSMutableDictionary * itemdict=[NSMutableDictionary dictionaryWithDictionary:CarListArray[indexPath.section]];
        NSMutableArray *goodsArray=[[NSMutableArray alloc] initWithArray:itemdict[@"store_list"]];
        NSMutableDictionary * gooddict=[NSMutableDictionary dictionaryWithDictionary:goodsArray[indexPath.row]];
        [gooddict setObject:[NSString stringWithFormat:@"%d",[CarListArray[indexPath.section][@"store_list"][indexPath.row][@"goods_num"] intValue]+1] forKey:@"goods_num"];
        [goodsArray setObject:gooddict atIndexedSubscript:indexPath.row];
        [itemdict setObject:goodsArray forKey:@"store_list"];
        [CarListArray replaceObjectAtIndex:indexPath.section withObject:itemdict];
        
        [self EditGoodNum:CarListArray[indexPath.section][@"store_list"][indexPath.row][@"goods_num"] andcartid:CarListArray[indexPath.section][@"store_list"][indexPath.row][@"cart_id"]];
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [self AddAllOrderForPrice];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}
-(void)jianGoodClick:(UIButton *)sender
{
    NSLog(@"货物减一");
    @try {
        UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
        NSIndexPath *indexPath = [_myTableview indexPathForCell:cell];
        NSMutableDictionary * itemdict=[NSMutableDictionary dictionaryWithDictionary:CarListArray[indexPath.section]];
        NSMutableArray *goodsArray=[[NSMutableArray alloc] initWithArray:itemdict[@"store_list"]];
        NSMutableDictionary * gooddict=[NSMutableDictionary dictionaryWithDictionary:goodsArray[indexPath.row]];
        if ([CarListArray[indexPath.section][@"store_list"][indexPath.row][@"goods_num"] intValue]>1) {
            [gooddict setObject:[NSString stringWithFormat:@"%d",[CarListArray[indexPath.section][@"store_list"][indexPath.row][@"goods_num"] intValue]-1] forKey:@"goods_num"];
        }else
        {
//            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"宝贝不能再减少了哦" delegate:nil cancelButtonTitle:@"" otherButtonTitles: nil];
            [SVProgressHUD showErrorWithStatus:@"宝贝不能再减少了哦" ];
        }
        [goodsArray setObject:gooddict atIndexedSubscript:indexPath.row];
        [itemdict setObject:goodsArray forKey:@"store_list"];
        [CarListArray replaceObjectAtIndex:indexPath.section withObject:itemdict];
        [self EditGoodNum:CarListArray[indexPath.section][@"store_list"][indexPath.row][@"goods_num"] andcartid:CarListArray[indexPath.section][@"store_list"][indexPath.row][@"cart_id"]];
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        
        [self AddAllOrderForPrice];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

-(void)DelGoods:(UIButton * )sender
{
    NSLog(@"货物删除");
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_myTableview indexPathForCell:cell];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"delgoodsBackCall:"];
    [dataprovider DelGoodsWithKey:@"3ae653eb52824dbc4ba977de343e2e12" andcartid:CarListArray[indexPath.section][@"store_list"][indexPath.row][@"cart_id"]];
    NSMutableDictionary * itemdict=[NSMutableDictionary dictionaryWithDictionary:CarListArray[indexPath.section]];
    NSMutableArray *goodsArray=[[NSMutableArray alloc] initWithArray:itemdict[@"store_list"]];
    if (goodsArray.count>1) {
        [goodsArray removeObjectAtIndex:indexPath.row];
        [itemdict setObject:goodsArray forKey:@"store_list"];
        [CarListArray replaceObjectAtIndex:indexPath.section withObject:itemdict];
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }else
    {
        [CarListArray removeObjectAtIndex:indexPath.section];
        [_myTableview reloadData];
    }
    
    
    [self AddAllOrderForPrice];
    
    
}
-(void)delgoodsBackCall:(id)dict
{
    NSLog(@"%@",dict);
}

-(void)EditGoodNum:(NSString *)num andcartid:(NSString *)cartid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"EditGoodBackCall:"];
    [dataprovider EditGoodsNumWithKey:@"3ae653eb52824dbc4ba977de343e2e12" andCartid:cartid andnum:num];
}
-(void)EditGoodBackCall:(id)dict
{
    NSLog(@"%@",dict);
}

-(void)AddAllOrderForPrice
{
    int num=0;
    float price=0.00;
    if (Orderdata&&Orderdata.count>0) {
        for (int i=0; i<Orderdata.count; i++) {
            NSArray * arrayItem=[[NSArray alloc] initWithArray:Orderdata[i][@"store_list"]];
            for (int j=0; j<arrayItem.count; j++) {
                num+=[arrayItem[j][@"goods_num"] intValue];
                price+=[arrayItem[j][@"goods_num"] intValue]*[arrayItem[j][@"goods_price"] floatValue];
            }
        }
    }
    _lbl_price.text=[NSString stringWithFormat:@"%.2f",price];
    [_btn_payfororder setTitle:[NSString stringWithFormat:@"结算(%d)",num] forState:UIControlStateNormal];
}

-(BOOL)isSectionExist:(NSString *)section
{
    BOOL isexist=NO;
    if (sectionArray) {
        for (NSString *items in sectionArray) {
            if ([items isEqualToString:section]) {
                isexist= YES;
            }
        }
    }
    return isexist;
}
-(BOOL)isCellExist:(NSString *)sectionandcell
{
    BOOL isexist=NO;
    if (cellArray) {
        for (NSString *items in cellArray) {
            if ([items isEqualToString:sectionandcell]) {
                isexist= YES;
            }
        }
    }
    return isexist;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animatedjavascript
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}
@end
