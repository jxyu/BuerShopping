//
//  AddaddressViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "AddaddressViewController.h"
#import "DataProvider.h"
#import "AppDelegate.h"

@interface AddaddressViewController ()
@property(nonatomic,strong)UITableView * mytbView;
@property(nonatomic,strong)UIPickerView * mypicker;
@end

@implementation AddaddressViewController
{
    
    UITextField * txt_name;
    UITextField * txt_phone;
    UITextField * txt_zip;
    UITextField * txt_Detialaddress;
    
    UIButton * btn_selectArray;
    NSArray * firstAreaArray;
    NSArray * secondAreaArray;
    NSArray * thirdAreaArray;
    UIView * BackView;
    NSString * provient;
    NSString * city;
    NSString * city_id;
    NSString * xianqu_id;
    NSString * xianqu;
    UIButton * doneButton;
    NSString * address_id;
    BOOL keyboardZhezhaoShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"收货地址";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    keyboardZhezhaoShow=NO;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [self loadAddresData];
    [self InitAllView];
}


-(void)loadAddresData
{
    firstAreaArray=[[NSArray alloc] init];
    secondAreaArray=[[NSArray alloc] init];
    thirdAreaArray=[[NSArray alloc] init];
    provient=@"";
    city=@"";
    city_id=@"";
    xianqu_id=@"";
    xianqu=@"";
    address_id=@"";
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetAreaListbackCall:"];
    [dataprovider GetArrayListwithareaid:@"" andkey:_userkey];
}

-(void)GetAreaListbackCall:(id)dict
{
    NSLog(@"%@",dict);
    firstAreaArray=dict[@"datas"][@"area_list"];
    provient=dict[@"datas"][@"area_name"];
    [_mypicker reloadComponent:0];
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

-(void)tuichuKeyBoard:(UIButton *)sender
{
    keyboardZhezhaoShow=NO;
    [txt_name resignFirstResponder];
    [txt_phone resignFirstResponder];
    [txt_zip resignFirstResponder];
    [txt_Detialaddress resignFirstResponder];
    [sender removeFromSuperview];
}


-(void)InitAllView
{
    if (_isChange) {
        [self addRightbuttontitle:@"修改"];
    }
    else
    {
        [self addRightbuttontitle:@"保存"];
    }
    BackView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 50)];
    [BackView setBackgroundColor:[UIColor whiteColor]];
    UIButton * btn_cancel=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 50)];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake(BackView.frame.size.width-70, 0, 60, 50)];
    [btn_sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(sureForSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, BackView.frame.size.height-1, BackView.frame.size.width, 1)];
    fenge.backgroundColor=[UIColor grayColor];
    [BackView addSubview:btn_sure];
    [BackView addSubview:btn_cancel];
    [BackView addSubview:fenge];
    [self.view addSubview:BackView];
    _mypicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200)];
    _mypicker.delegate=self;
    _mypicker.dataSource=self;
    _mytbView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-125)];
    _mytbView.delegate=self;
    _mytbView.dataSource=self;
    [_mytbView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_mytbView];
    UIView * footer=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    footer.backgroundColor=[UIColor whiteColor];
    UIButton * btn_addAddress=[[UIButton alloc] initWithFrame:CGRectMake((footer.frame.size.width-150)/2, 15, 150, 30)];
    [btn_addAddress setTitle:@"设为默认地址" forState:UIControlStateNormal];
    btn_addAddress.layer.masksToBounds=YES;
    [btn_addAddress addTarget:self action:@selector(btn_setDefault:) forControlEvents:UIControlEventTouchUpInside];
    btn_addAddress.layer.cornerRadius=15;
    btn_addAddress.backgroundColor=[UIColor colorWithRed:255/255.0 green:152/255.0 blue:1/255.0 alpha:1.0];
    [btn_addAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn_addAddress addTarget:self action:@selector(addressAddBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn_addAddress];
    [self.view addSubview:footer];
}
-(void)btn_setDefault:(UIButton * )sender
{
    if (address_id) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"setDefaultBackCall:"];
        [dataprovider SetDefaultAddressWithaddressid:address_id andkey:_userkey];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"请先保存" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)setDefaultBackCall:(id)dict
{
    NSLog(@"%@",dict);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelSelect:(UIButton * )sender
{
    [BackView removeFromSuperview];
    [_mypicker removeFromSuperview];
}
-(void)sureForSelect:(UIButton *)sender
{
    [btn_selectArray setTitle:[NSString stringWithFormat:@"%@%@%@",provient,city,xianqu] forState:UIControlStateNormal];
    [btn_selectArray setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_selectArray.layer.masksToBounds=YES;
//    btn_selectArray.titleLabel.frame=CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    btn_selectArray.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [BackView removeFromSuperview];
    [_mypicker removeFromSuperview];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
    lbl_title.textColor=[UIColor grayColor];
    
    if (indexPath.row==3) {
        btn_selectArray=[[UIButton alloc] initWithFrame:CGRectMake(lbl_title.frame.size.width+lbl_title.frame.origin.x, 10, cell.frame.size.width-lbl_title.frame.size.width-lbl_title.frame.origin.x, 30)];
        btn_selectArray.tag=indexPath.row;
        if (_isChange) {
            btn_selectArray.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
            [btn_selectArray setTitle:_data[@"area_info"] forState:UIControlStateNormal];
        }
        else
        {
            [btn_selectArray setTitle:@"省 市 区" forState:UIControlStateNormal];
        }
        
        [btn_selectArray setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn_selectArray addTarget:self action:@selector(showpicker) forControlEvents:UIControlEventTouchUpInside];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            txt_name=[[UITextField alloc] initWithFrame:CGRectMake(lbl_title.frame.size.width+lbl_title.frame.origin.x, 10, cell.frame.size.width-lbl_title.frame.size.width-lbl_title.frame.origin.x, 30)];
            [txt_name setKeyboardType:UIKeyboardTypeDefault];
            txt_name.tag=indexPath.row;
            if (_isChange) {
                txt_name.text=_data[@"true_name"];
            }
            lbl_title.text=@"收货人";
            [cell addSubview:lbl_title];
            [cell addSubview:txt_name];
        }
            break;
        case 1:
        {
            txt_phone=[[UITextField alloc] initWithFrame:CGRectMake(lbl_title.frame.size.width+lbl_title.frame.origin.x, 10, cell.frame.size.width-lbl_title.frame.size.width-lbl_title.frame.origin.x, 30)];
            [txt_phone setKeyboardType:UIKeyboardTypeNumberPad];
            txt_phone.tag=indexPath.row;
            if (_isChange) {
                txt_phone.text=_data[@"mob_phone"];
            }
            lbl_title.text=@"手机号码";
            [cell addSubview:lbl_title];
            [cell addSubview:txt_phone];
        }
            break;
        case 2:
        {
            txt_zip=[[UITextField alloc] initWithFrame:CGRectMake(lbl_title.frame.size.width+lbl_title.frame.origin.x, 10, cell.frame.size.width-lbl_title.frame.size.width-lbl_title.frame.origin.x, 30)];
            [txt_zip setKeyboardType:UIKeyboardTypeNumberPad];
            txt_zip.tag=indexPath.row;
            if (_isChange) {
                txt_zip.text=_data[@"zip"];
            }
            lbl_title.text=@"邮政编码";
            [cell addSubview:lbl_title];
            [cell addSubview:txt_zip];
        }
            break;
        case 3:
            lbl_title.text=@"所在地区";
            [cell addSubview:lbl_title];
            [cell addSubview:btn_selectArray];

            break;
        case 4:
        {
            txt_Detialaddress=[[UITextField alloc] initWithFrame:CGRectMake(lbl_title.frame.size.width+lbl_title.frame.origin.x, 10, cell.frame.size.width-lbl_title.frame.size.width-lbl_title.frame.origin.x, 30)];
            [txt_Detialaddress setKeyboardType:UIKeyboardTypeDefault];
            txt_Detialaddress.tag=indexPath.row;
            if (_isChange) {
                txt_Detialaddress.text=_data[@"address"];
            }
            lbl_title.text=@"详细地址";
            [cell addSubview:lbl_title];
            [cell addSubview:txt_Detialaddress];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)showpicker
{
    [self.view addSubview:BackView];
    [self.view addSubview:_mypicker];
}
#pragma mark--UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return [firstAreaArray count];
    }
    if (component==1) {
        return [secondAreaArray count];
    }
    if (component==2) {
        return [thirdAreaArray count];
    }
    return 0;
}

#pragma mark--UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return [firstAreaArray objectAtIndex:row][@"area_name"];
    }
    if (component==1) {
        return [secondAreaArray objectAtIndex:row][@"area_name"];;
    }
    if (component==2) {
        return [thirdAreaArray objectAtIndex:row][@"area_name"];;
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"row is %ld,Component is %ld",(long)row,(long)component);
    if (component==0) {
        provient=firstAreaArray[row][@"area_name"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetAreaCityListBackCall:"];
        [dataprovider GetArrayListwithareaid:firstAreaArray[row][@"area_id"] andkey:_userkey];
    }
    if (component==1) {
        city=secondAreaArray[row][@"area_name"];
        city_id=secondAreaArray[row][@"area_id"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetAreaxianchengListBackCall:"];
        [dataprovider GetArrayListwithareaid:secondAreaArray[row][@"area_id"] andkey:_userkey];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }
//    [pickerView reloadComponent:2];
    if (component==2) {
        xianqu=thirdAreaArray[row][@"area_name"];
        xianqu_id=thirdAreaArray[row][@"area_id"];
    }
    
}

-(void)GetAreaCityListBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        secondAreaArray=dict[@"datas"][@"area_list"];
        city=secondAreaArray[0][@"area_name"];
        city_id=secondAreaArray[0][@"area_id"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetAreaxianchengListBackCall:"];
        [dataprovider GetArrayListwithareaid:secondAreaArray[0][@"area_id"] andkey:_userkey];

        [_mypicker selectedRowInComponent:1];
        [_mypicker reloadComponent:1];
        [_mypicker selectedRowInComponent:2];
    }
}
-(void)GetAreaxianchengListBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        thirdAreaArray=dict[@"datas"][@"area_list"];
        xianqu=thirdAreaArray[0][@"area_name"];
        xianqu_id=thirdAreaArray[0][@"area_id"];
        [_mypicker reloadComponent:2];
    }
}

-(void)clickRightButton:(UIButton *)sender
{
    NSDictionary * prm=@{@"key":_userkey,@"true_name":txt_name.text,@"city_id":city_id,@"area_id":xianqu_id,@"area_info":btn_selectArray.currentTitle,@"address":txt_Detialaddress.text,@"zip":txt_zip.text,@"mob_phone":txt_phone.text};
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"saveBackCall:"];
    if (_isChange) {
        [dataprovider EditAddressWithPrm:prm];
    }
    else
    {
        [dataprovider addAddress:prm];
    }
}

-(void)saveBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]){
        if (dict[@"datas"][@"address_id"]) {
            address_id=dict[@"datas"][@"address_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Save_address_success" object:nil];
        }
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
