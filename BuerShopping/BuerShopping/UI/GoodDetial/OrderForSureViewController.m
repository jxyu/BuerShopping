//
//  OrderForSureViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/14.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "OrderForSureViewController.h"
#import "AddressManageViewController.h"
#import "OrderCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DataProvider.h"
#import "Pingpp.h"
#import "OrderListViewController.h"

@interface OrderForSureViewController ()
@property(nonatomic,strong)AddressManageViewController *myaddressManager;
@end

@implementation OrderForSureViewController
{
    NSDictionary * addressdict;
    NSDictionary * gooddict;
    NSDictionary * storedict;
    NSString * sendWay;
    NSString * payWay;
    BOOL useRestMoney;
    UITextField * txt_message;
    NSString * message;
    NSString * payWayToPay;
    BOOL keyboardZhezhaoShow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"确认订单";
    _lblTitle.textColor=[UIColor whiteColor];
    addressdict=_OrderData[@"address_info"];
    message=@"";
    payWayToPay=@"";
    keyboardZhezhaoShow=NO;
    storedict=[[NSDictionary alloc] initWithDictionary:_OrderData[@"store_cart_list"][0]];
    gooddict=[[NSDictionary alloc] initWithDictionary:_OrderData[@"store_cart_list"][0][@"goods_list"][0]];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    useRestMoney=NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(JumpToOrderList) name:@"OrderPay_success" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FinishSelectAddress:) name:@"select_address_for_duihuan" object:nil];
    [self buildHeaderview];
    [self initAllView];
}
-(void)JumpToOrderList
{
    OrderListViewController *orderlist=[[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:[NSBundle mainBundle]];
    orderlist.key=_key;
    orderlist.OrderStatus=@"20";
    [self.navigationController pushViewController:orderlist animated:YES];
}

-(void)initAllView
{
    _mytableview.delegate=self;
    _mytableview.dataSource=self;
    _lbl_price.text=[NSString stringWithFormat:@"¥%@",gooddict[@"goods_price"]];
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
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionHeaderView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    sectionHeaderView.backgroundColor=[UIColor whiteColor];
    
    UIImageView * img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    img_icon.image=[UIImage imageNamed:@"dianpu_gray_icon"];
    [sectionHeaderView addSubview:img_icon];
    UILabel * lbl_StoreTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_icon.frame.size.width+img_icon.frame.origin.x+10, 15, 100, 20)];
    lbl_StoreTitle.text=storedict[@"store_name"];
    [sectionHeaderView addSubview:lbl_StoreTitle];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, sectionHeaderView.frame.size.height-1, sectionHeaderView.frame.size.width-20, 1)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [sectionHeaderView addSubview:fenge];
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=60;
    if (indexPath.row==0) {
        height=105;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"物流配送", @"自提", nil];
        choiceSheet.tag=1;
        [choiceSheet showInView:self.view];
    }
    if (indexPath.row==2) {
        if (!_OrderData[@"ifshow_offpay"]) {
            if ([_OrderData[@"ifshow_offpay"] intValue]==1) {
                UIActionSheet *choiceSheet1 = [[UIActionSheet alloc] initWithTitle:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:@"取消"
                                                            destructiveButtonTitle:nil
                                                                 otherButtonTitles:@"微信支付", @"支付宝支付",@"货到付款", nil];
                choiceSheet1.tag=2;
                [choiceSheet1 showInView:self.view];
            }
            else
            {
                UIActionSheet *choiceSheet1 = [[UIActionSheet alloc] initWithTitle:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:@"取消"
                                                            destructiveButtonTitle:nil
                                                                 otherButtonTitles:@"微信支付", @"支付宝支付", nil];
                choiceSheet1.tag=3;
                [choiceSheet1 showInView:self.view];
            }
            
        }else
        {
            UIActionSheet *choiceSheet1 = [[UIActionSheet alloc] initWithTitle:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"取消"
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:@"微信支付", @"支付宝支付", nil];
            choiceSheet1.tag=3;
            [choiceSheet1 showInView:self.view];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *CellIdentifier = @"orderTableViewCellIdentifier";
        OrderCellTableViewCell *cell = (OrderCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"OrderCellTableViewCell" owner:self options:nil] lastObject];
        cell.layer.masksToBounds=YES;
        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
        cell.lbl_orderTitle.text=[NSString stringWithFormat:@"%@",gooddict[@"goods_name"]];
        cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",gooddict[@"goods_price"]];
        cell.lbl_num.text=[NSString stringWithFormat:@"x%@",gooddict[@"goods_num"]];

        cell.lbl_guige.text=gooddict[@"goods_spec"];
        [cell.img_log sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",gooddict[@"goods_image_url"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //        cell.lbl_rescuncun.text=goods_like[indexPath.row][@""];
        return cell;
    }else if (indexPath.row==1)
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_cellTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 20)];
        lbl_cellTitle.text=@"配送方式";
        lbl_cellTitle.textColor=[UIColor grayColor];
        [cell addSubview:lbl_cellTitle];
        if (sendWay) {
            UILabel * lbl_sendWay=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, 20, 90, 20)];
            lbl_sendWay.textColor=[UIColor grayColor];
            lbl_sendWay.text=sendWay;
            lbl_sendWay.textAlignment=NSTextAlignmentRight;
            [cell addSubview:lbl_sendWay];
        }
        return cell;
    }
    else if(indexPath.row==2)
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_cellTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 20)];
        lbl_cellTitle.text=@"支付方式";
        lbl_cellTitle.textColor=[UIColor grayColor];
        [cell addSubview:lbl_cellTitle];
        UIButton *btn_userrestmoney=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-120, 0, 110, 60)];
        if (useRestMoney) {
            [btn_userrestmoney setImage:[UIImage imageNamed:@"shoppingcar_select_icon"] forState:UIControlStateNormal];
        }
        else
        {
            [btn_userrestmoney setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon"] forState:UIControlStateNormal];
        }
        btn_userrestmoney.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn_userrestmoney setTitle:@"使用钱包" forState:UIControlStateNormal];
        [btn_userrestmoney setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_userrestmoney addTarget:self action:@selector(usePurse:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_userrestmoney];
        if (payWay) {
            UILabel * lbl_sendWay=[[UILabel alloc] initWithFrame:CGRectMake(btn_userrestmoney.frame.origin.x-100, 20, 90, 20)];
            lbl_sendWay.textColor=[UIColor grayColor];
            lbl_sendWay.text=payWay;
            lbl_sendWay.textAlignment=NSTextAlignmentRight;
            [cell addSubview:lbl_sendWay];
        }
        return cell;
    }
    else if(indexPath.row==3)
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        txt_message=[[UITextField alloc] initWithFrame:CGRectMake(10, 15, cell.frame.size.width-20, 30)];
        txt_message.delegate=self;
        txt_message.placeholder=@"给卖家留言";
        [cell addSubview:txt_message];
        return cell;
    }
    else
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_price=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 20, 70, 20)];
        lbl_price.text=[NSString stringWithFormat:@"¥%@",storedict[@"store_goods_total"]];
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
        lbl_num.text=[NSString stringWithFormat:@"共1件商品"];
        [cell addSubview:lbl_num];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark headerview逻辑
-(void)buildHeaderview
{
    UIView * headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    if (addressdict.count>0) {
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
    if (actionSheet.tag==1) {
        if (buttonIndex==0) {
            sendWay=@"物流配送";
            float lastprice=[ gooddict[@"goods_price"] floatValue]+[storedict[@"store_freight_price"] floatValue];
            _lbl_price.text=[NSString stringWithFormat:@"¥%.2f",lastprice];
        }
        if (buttonIndex==1) {
            sendWay=@"自提";
        }
        
    }
    else if(actionSheet.tag==2)
    {
        if (buttonIndex==0) {
            payWay=@"微信支付";
            payWayToPay=@"wx";
        }
        if (buttonIndex==1) {
            payWay=@"支付宝支付";
            payWayToPay=@"alipay";
        }
        if (buttonIndex==2) {
            payWay=@"货到付款";
            payWayToPay=@"";
        }
    }
    else
    {
        if (buttonIndex==0) {
            payWay=@"微信支付";
            payWayToPay=@"wx";
        }
        if (buttonIndex==1) {
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
    _mytableview.frame=CGRectMake(_mytableview.frame.origin.x, _mytableview.frame.origin.y, _mytableview.frame.size.width, _mytableview.frame.size.height-height);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    keyboardZhezhaoShow=NO;
    _mytableview.frame=CGRectMake(_mytableview.frame.origin.x, 64, _mytableview.frame.size.width, SCREEN_HEIGHT-114);
    [textField resignFirstResponder];//等于上面两行的代码
    message=textField.text;
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payForOrder:(UIButton *)sender {
    NSString *prmpayWay=@"online";
    NSRange range=[payWay rangeOfString:@"货到付款"];
    if (range.length>0) {
        prmpayWay=@"offline";
    }
    if (sendWay&&payWay&&_key&&addressdict[@"address_id"]) {
        NSDictionary *dlyo_pickup_type=@{gooddict[@"store_id"]:sendWay};//配送方式
        NSDictionary *pay_type=@{gooddict[@"store_id"]:prmpayWay};//支付方式
        NSDictionary *pay_message=@{gooddict[@"store_id"]:message};//卖家留言
        NSDictionary * prm=[[NSDictionary alloc] initWithObjectsAndKeys:
                            _key,@"key",
                            [NSString stringWithFormat:@"%@|%@",gooddict[@"goods_id"],@"1"],@"cart_id",
                            @"0",@"ifcart",
                            addressdict[@"address_id"],@"address_id",
                            dlyo_pickup_type,@"dlyo_pickup_type",
                            pay_type,@"pay_type",
                             useRestMoney?@"1":@"0",@"pd_pay",
                             pay_message,@"pay_message",
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

-(void)payForOrderBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        if ([payWayToPay isEqualToString:@""]) {
            
        }
        else
        {
            if ([dict[@"datas"][@"order_amount"] intValue]==0) {
                OrderListViewController *orderlist=[[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:[NSBundle mainBundle]];
                orderlist.key=_key;
                orderlist.OrderStatus=@"20";
                [self.navigationController pushViewController:orderlist animated:YES];
            }
            else
            {
                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider setDelegateObject:self setBackFunctionName:@"GetChargeBackCall:"];
                [dataprovider OrderPayWithKey:_key andpay_sn:dict[@"datas"][@"pay_sn"] andchannel:payWayToPay];
            }
        }
    }else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
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
@end
