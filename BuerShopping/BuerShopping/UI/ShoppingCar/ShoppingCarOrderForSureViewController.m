//
//  ShoppingCarOrderForSureViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ShoppingCarOrderForSureViewController.h"
#import "AddressManageViewController.h"
#import "OrderCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DataProvider.h"
#import "Pingpp.h"
#import "AppDelegate.h"

@interface ShoppingCarOrderForSureViewController ()
@property(nonatomic,strong)AddressManageViewController *myaddressManager;
@end

@implementation ShoppingCarOrderForSureViewController
{
    NSDictionary * addressdict;
    NSArray * storeArray;
    NSMutableDictionary * sendWay;
    BOOL useRestMoney;
    NSString * payWay;
    NSString * payWayToPay;
    NSMutableDictionary * messageDict;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"确认订单";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    addressdict=[[NSDictionary alloc] initWithDictionary:_OrderData[@"address_info"]];
    storeArray=[[NSArray alloc] initWithArray:_OrderData[@"store_cart_list"]];
    sendWay=[[NSMutableDictionary alloc] init];
    messageDict=[[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    useRestMoney=NO;
    payWay=@"";
    payWayToPay=@"";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FinishSelectAddress:) name:@"select_address_for_duihuan" object:nil];
    [self buildHeaderview];
    [self initAllView];
}
-(void)initAllView
{
    _mytableview.delegate=self;
    _mytableview.dataSource=self;
//    _lbl_price.text=[NSString stringWithFormat:@"¥%@",gooddict[@"goods_price"]];
}
#pragma mark 构建tableview
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerview=[[UIView alloc] init];
    footerview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    return footerview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==storeArray.count) {
        return 0;
    }
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (section!=storeArray.count) {
        sectionHeaderView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        sectionHeaderView.backgroundColor=[UIColor whiteColor];
        
        UIImageView * img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        img_icon.image=[UIImage imageNamed:@"dianpu_gray_icon"];
        [sectionHeaderView addSubview:img_icon];
        UILabel * lbl_StoreTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_icon.frame.size.width+img_icon.frame.origin.x+10, 15, 100, 20)];
        lbl_StoreTitle.text=storeArray[section][@"store_name"];
        [sectionHeaderView addSubview:lbl_StoreTitle];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, sectionHeaderView.frame.size.height-1, sectionHeaderView.frame.size.width-20, 1)];
        fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [sectionHeaderView addSubview:fenge];
    }
    else
    {
        sectionHeaderView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 0);
    }
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==storeArray.count) {
        return 60;
    }
    NSArray * gooditemArray=[[NSArray alloc] initWithArray:storeArray[indexPath.section][@"goods_list"]];
    CGFloat height=60;
    if (indexPath.row<gooditemArray.count) {
        height=105;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==storeArray.count) {
        if ([_OrderData[@"ifshow_offpay"] intValue]==1) {
            UIActionSheet *choiceSheet1 = [[UIActionSheet alloc] initWithTitle:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"取消"
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:@"钱包支付",@"微信支付", @"支付宝支付",@"货到付款", nil];
            choiceSheet1.tag=2;
            [choiceSheet1 showInView:self.view];
        }
//        else
//        {
//            UIActionSheet *choiceSheet1 = [[UIActionSheet alloc] initWithTitle:nil
//                                                                      delegate:self
//                                                             cancelButtonTitle:@"取消"
//                                                        destructiveButtonTitle:nil
//                                                             otherButtonTitles:@"钱包支付",@"微信支付", @"支付宝支付", nil];
//            choiceSheet1.tag=3;
//            [choiceSheet1 showInView:self.view];
//        }
        
        
    }
    else
    {
        NSArray * gooditemArray=[[NSArray alloc] initWithArray:storeArray[indexPath.section][@"goods_list"]];
        if (indexPath.row==gooditemArray.count) {
            UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"物流配送", @"自提", nil];
            choiceSheet.tag=10+indexPath.section;
            [choiceSheet showInView:self.view];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==storeArray.count) {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_cellTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 20)];
        lbl_cellTitle.text=@"支付方式";
        lbl_cellTitle.textColor=[UIColor grayColor];
        [cell addSubview:lbl_cellTitle];
//        UIButton *btn_userrestmoney=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-120, 0, 110, 60)];
//        if (useRestMoney) {
//            [btn_userrestmoney setImage:[UIImage imageNamed:@"shoppingcar_select_icon"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [btn_userrestmoney setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon"] forState:UIControlStateNormal];
//        }
//        btn_userrestmoney.titleLabel.font=[UIFont systemFontOfSize:15];
//        [btn_userrestmoney setTitle:@"使用钱包" forState:UIControlStateNormal];
//        [btn_userrestmoney setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn_userrestmoney addTarget:self action:@selector(usePurse:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:btn_userrestmoney];
        if (payWay) {
            UILabel * lbl_sendWay=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, 20, 90, 20)];
            lbl_sendWay.textColor=[UIColor grayColor];
            lbl_sendWay.text=payWay;
            lbl_sendWay.textAlignment=NSTextAlignmentRight;
            [cell addSubview:lbl_sendWay];
        }
        return cell;

    }
    else
    {
        NSArray * gooditemArray=[[NSArray alloc] initWithArray:storeArray[indexPath.section][@"goods_list"]];
        if (indexPath.row<gooditemArray.count) {
            
            static NSString *CellIdentifier = @"orderTableViewCellIdentifier";
            OrderCellTableViewCell *cell = (OrderCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor whiteColor];
            cell.layer.masksToBounds=YES;
            cell.layer.cornerRadius=5;
            cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
            cell  = [[[NSBundle mainBundle] loadNibNamed:@"OrderCellTableViewCell" owner:self options:nil] lastObject];
            cell.layer.masksToBounds=YES;
            cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
            cell.lbl_orderTitle.text=[NSString stringWithFormat:@"%@",gooditemArray[indexPath.row][@"goods_name"]];
            cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",gooditemArray[indexPath.row][@"goods_price"]];
            cell.lbl_num.text=[NSString stringWithFormat:@"x%@",gooditemArray[indexPath.row][@"goods_num"]];
            //        cell.lbl_guige.text=gooditemArray[indexPath.row][@"goods_spec"];
            [cell.img_log sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",gooditemArray[indexPath.row][@"goods_image_url"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            //        cell.lbl_rescuncun.text=goods_like[indexPath.row][@""];
            return cell;
        }else if (indexPath.row==gooditemArray.count)
        {
            UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            UILabel * lbl_cellTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 20)];
            lbl_cellTitle.text=@"配送方式";
            lbl_cellTitle.textColor=[UIColor grayColor];
            [cell addSubview:lbl_cellTitle];
            if (sendWay[[NSString stringWithFormat:@"%@",gooditemArray[0][@"store_id"]]]) {
                UILabel * lbl_sendWay=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, 20, 90, 20)];
                lbl_sendWay.textColor=[UIColor grayColor];
                lbl_sendWay.text=sendWay[[NSString stringWithFormat:@"%@",gooditemArray[0][@"store_id"]]];
                lbl_sendWay.textAlignment=NSTextAlignmentRight;
                [cell addSubview:lbl_sendWay];
            }
            return cell;
        }
        
        else if(indexPath.row==gooditemArray.count+1)
        {
            UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            UITextField * txt_message=[[UITextField alloc] initWithFrame:CGRectMake(10, 15, cell.frame.size.width-20, 30)];
            txt_message.delegate=self;
            txt_message.tag=indexPath.section;
            if (messageDict[[NSString stringWithFormat:@"%@",gooditemArray[0][@"store_id"]]]) {
                txt_message.text=messageDict[[NSString stringWithFormat:@"%@",gooditemArray[0][@"store_id"]]];
            }
            else
            {
                txt_message.placeholder=@"给卖家留言";
            }
            
            
            [cell addSubview:txt_message];
            return cell;
        }
        else
        {
            UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            UILabel * lbl_price=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 20, 70, 20)];
            lbl_price.text=[NSString stringWithFormat:@"¥%@",storeArray[indexPath.section][@"store_goods_total"]];
            lbl_price.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lbl_price];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(lbl_price.frame.origin.x-50, 20, 50, 20)];
            lbl_title.text=@"实付:";
            lbl_title.textColor=[UIColor grayColor];
            lbl_title.textAlignment=NSTextAlignmentRight;
            lbl_title.font=[UIFont systemFontOfSize:15];
            [cell addSubview:lbl_title];
            UILabel * lbl_num=[[UILabel alloc] initWithFrame:CGRectMake(lbl_title.frame.origin.x-100, 20, 100, 20)];
            lbl_num.textAlignment=NSTextAlignmentCenter;
            lbl_num.font=[UIFont systemFontOfSize:15];
            lbl_num.text=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)gooditemArray.count];
            [cell addSubview:lbl_num];
            return cell;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==storeArray.count) {
        return 1;
    }
    NSArray * gooditemArray=[[NSArray alloc] initWithArray:storeArray[section][@"goods_list"]];
    return gooditemArray.count+3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return storeArray.count+1;
}


#pragma mark headerview逻辑
-(void)buildHeaderview
{
    UIView * headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    if (addressdict) {
        UIImageView * img_location=[[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 15, 20)];
        img_location.image=[UIImage imageNamed:@"location_icon"];
        [headerview addSubview:img_location];
        UILabel * lbl_addressTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_location.frame.origin.x+img_location.frame.size.width+10, 10, 120, 20)];
        lbl_addressTitle.text=[NSString stringWithFormat:@"收货人:%@",[addressdict[@"true_name"] isKindOfClass:[NSNull class]]?@"":addressdict[@"true_name"]];
        [headerview addSubview:lbl_addressTitle];
        UILabel * lbl_phone=[[UILabel alloc] initWithFrame:CGRectMake(lbl_addressTitle.frame.origin.x+lbl_addressTitle.frame.size.width, 10, headerview.frame.size.width-lbl_addressTitle.frame.origin.x-lbl_addressTitle.frame.size.width-20, 20)];
        lbl_phone.text=[addressdict[@"tel_phone"] isKindOfClass:[NSNull class]]?@"4":addressdict[@"tel_phone"];
        [headerview addSubview:lbl_phone];
        UILabel * lbl_address=[[UILabel alloc] initWithFrame:CGRectMake(lbl_addressTitle.frame.origin.x, lbl_addressTitle.frame.origin.y+lbl_addressTitle.frame.size.height+5, lbl_phone.frame.size.width+lbl_phone.frame.origin.x-lbl_addressTitle.frame.origin.x, 40)];
        lbl_address.text=[NSString stringWithFormat:@"收货地址:%@",[addressdict[@"address"] isKindOfClass:[NSNull class]]?@"":addressdict[@"address"]];
        lbl_address.numberOfLines=2;
        lbl_address.font=[UIFont systemFontOfSize:14];
        [headerview addSubview:lbl_address];
        UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_address.frame.origin.x+lbl_address.frame.size.width+3, 34, 7, 12)];
        img_go.image=[UIImage imageNamed:@"index_go"];
        [headerview addSubview:img_go];
        UIButton *btn_JumptoAddressManager=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerview.frame.size.height)];
        [btn_JumptoAddressManager addTarget:self action:@selector(JumpToAddressManager:) forControlEvents:UIControlEventTouchUpInside];
        [headerview addSubview:btn_JumptoAddressManager];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, headerview.frame.size.height-1, headerview.frame.size.width-20, 1)];
        fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [headerview addSubview:fenge];
    }
    else
    {
        UIImageView * img_add=[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
        img_add.image=[UIImage imageNamed:@"addressAdd_icon"];
        [headerview addSubview:img_add];
        UILabel * lbl_addtitle=[[UILabel alloc] initWithFrame:CGRectMake(img_add.frame.origin.x+img_add.frame.size.width+10, 20, 200, 20)];
        lbl_addtitle.text=@"新增收餐地址";
        lbl_addtitle.textColor=[UIColor colorWithRed:115/255.0 green:73/255.0 blue:139/255.0 alpha:1.0];
        [headerview addSubview:lbl_addtitle];
        UIButton * btn_addaddress=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerview.frame.size.width, headerview.frame.size.height)];
        [btn_addaddress addTarget:self action:@selector(JumpToAddressManager:) forControlEvents:UIControlEventTouchUpInside];
        [headerview addSubview:btn_addaddress];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, headerview.frame.size.height-1, headerview.frame.size.width-20, 1)];
        fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [headerview addSubview:fenge];
        
    }
    _mytableview.tableHeaderView=headerview;
}

-(void)JumpToAddressManager:(UIButton * )sender
{
    NSLog(@"跳转地址管理页面");
    _myaddressManager=[[AddressManageViewController alloc] init];
    _myaddressManager.userkey=_key;
    _myaddressManager.isfromDuihuan=YES;
    [self.navigationController pushViewController:_myaddressManager animated:YES];
}
-(void)FinishSelectAddress:(NSNotification*) notification
{
    NSDictionary * addressInfo=[notification object];
    if (addressInfo) {
        addressdict=addressInfo;
        [self buildHeaderview];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    NSLog(@"%ld",(long)actionSheet.tag);
    NSString * sendwayItem=@"";
    
    if (actionSheet.tag>=10) {
        NSArray * itemarray=[[NSArray alloc] initWithArray:storeArray[actionSheet.tag-10][@"goods_list"]];
        NSString * store_id=itemarray[0][@"store_id"];
        if (buttonIndex==0) {
            sendwayItem=@"物流配送";
//            float lastprice=[ gooddict[@"goods_price"] floatValue]+[storedict[@"store_freight_price"] floatValue];
//            _lbl_price.text=[NSString stringWithFormat:@"¥%.2f",lastprice];
        }
        if (buttonIndex==1) {
            sendwayItem=@"自提";
        }
        [sendWay setObject:sendwayItem forKey:store_id];
    }
    else if(actionSheet.tag==2)
    {
        if (buttonIndex==0) {
            payWay=@"钱包支付";
            payWayToPay=@"qb";
        }
        if (buttonIndex==1) {
            payWay=@"微信支付";
            payWayToPay=@"wx";
        }
        if (buttonIndex==2) {
            payWay=@"支付宝支付";
            payWayToPay=@"alipay";
        }
        if (buttonIndex==3) {
            payWay=@"货到付款";
            payWayToPay=@"";
        }
    }
    else
    {
        if (buttonIndex==0) {
            payWay=@"钱包支付";
            payWayToPay=@"qb";
        }
        if (buttonIndex==1) {
            payWay=@"微信支付";
            payWayToPay=@"wx";
        }
        if (buttonIndex==2) {
            payWay=@"支付宝支付";
            payWayToPay=@"alipay";
        }
    }
    [_mytableview reloadData];
}

-(void)usePurse:(UIButton *)sender
{
    useRestMoney=!useRestMoney;
    [_mytableview reloadData];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    UIButton * btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65-height)];
    [btn_zhezhao addTarget:self action:@selector(tuichuKeyBoard1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_zhezhao];
    _mytableview.frame=CGRectMake(_mytableview.frame.origin.x, _mytableview.frame.origin.y, _mytableview.frame.size.width, _mytableview.frame.size.height-height);
}

-(void)tuichuKeyBoard1:(UIButton *)sender
{
//    [txt_message resignFirstResponder];
    [sender removeFromSuperview];
    _mytableview.frame=CGRectMake(_mytableview.frame.origin.x, _mytableview.frame.origin.y, _mytableview.frame.size.width, SCREEN_HEIGHT-115);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _mytableview.frame=CGRectMake(_mytableview.frame.origin.x, _mytableview.frame.origin.y, _mytableview.frame.size.width, SCREEN_HEIGHT-115);
    [textField resignFirstResponder];//等于上面两行的代码
    NSString * store_id=storeArray[textField.tag][@"goods_list"][0][@"store_id"];
    [messageDict setObject:textField.text forKey:store_id];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)payForOrderBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        if ([payWayToPay isEqualToString:@""]) {
            
        }
        else
        {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"GetChargeBackCall:"];
            [dataprovider OrderPayWithKey:_key andpay_sn:dict[@"datas"][@"pay_sn"] andchannel:payWayToPay];
        }
    }
}
-(void)GetChargeBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str_data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [Pingpp createPayment:str_data
               viewController:self
                 appURLScheme:@"BuerShopping.zykj"
               withCompletion:^(NSString *result, PingppError *error) {
                   if ([result isEqualToString:@"success"]) {
                       // 支付成功
                   } else {
                       // 支付失败或取消
                       NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                   }
               }];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (IBAction)payfororderClick:(UIButton *)sender {
    NSString *prmpayWay=@"online";
    NSRange range=[payWay rangeOfString:@"货到付款"];
    if (range.length>0) {
        prmpayWay=@"offline";
    }
    range=[payWay rangeOfString:@"钱包"];
    if (range.length>0) {
        prmpayWay=@"offline";
    }
    else
    {
        NSMutableDictionary * paywaydict=[[NSMutableDictionary alloc] init];
        NSString * strprm=@"";
        for (int i=0; i<storeArray.count; i++) {
            NSArray * itemgoodsArray=[[NSArray alloc] initWithArray:storeArray[i][@"goods_list"]];
            [paywaydict setObject:prmpayWay forKey:itemgoodsArray[0][@"store_id"]];
            for (int j=0; j<itemgoodsArray.count; j++) {
                if (j==0&&i==0) {
                    strprm=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@|%@",itemgoodsArray[j][@"cart_id"],itemgoodsArray[j][@"goods_num"]]];
                }
                else
                {
                    strprm=[strprm stringByAppendingString:[NSString stringWithFormat:@",%@|%@",itemgoodsArray[j][@"cart_id"],itemgoodsArray[j][@"goods_num"]]];
                }
            }
        }
        
        if (sendWay&&payWay&&_key&&addressdict[@"address_id"]) {
            NSDictionary * prm=[[NSDictionary alloc] initWithObjectsAndKeys:
                                _key,@"key",
                                strprm,@"cart_id",
                                @"1",@"ifcart",
                                addressdict[@"address_id"],@"address_id",
                                sendWay,@"dlyo_pickup_type",
                                paywaydict,@"pay_type",
                                @"0",@"pd_pay",
                                messageDict,@"pay_message",
                                nil];
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"payForOrderBackCall:"];
            [dataprovider Buy_StepTwo:prm];
        }
        else
        {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
        
    }
}
@end
