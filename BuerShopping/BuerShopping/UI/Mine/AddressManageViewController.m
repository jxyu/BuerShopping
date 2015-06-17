//
//  AddressManageViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "AddressManageViewController.h"
#import "CommenDef.h"
#import "AddressCellTableViewCell.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "AddaddressViewController.h"

@interface AddressManageViewController ()
@property(nonatomic,strong)UITableView * mytbView;
@property(nonatomic,strong)AddaddressViewController * myaddaddress;
@end

@implementation AddressManageViewController
{
    NSArray * addressArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"收货地址";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    addressArray=[[NSArray alloc] init];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAddresData) name:@"Save_address_success" object:nil];
    [self loadAddresData];
    [self InitAllView];
}
-(void)loadAddresData
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetAddressListbackCall:"];
    [dataprovider GetAddressList:_userkey];
}
-(void)GetAddressListbackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        addressArray=dict[@"datas"][@"address_list"];
        [_mytbView reloadData];
    }
}

-(void)InitAllView
{
    _mytbView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-125)];
    _mytbView.delegate=self;
    _mytbView.dataSource=self;
    [self.view addSubview:_mytbView];
    UIView * footer=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    footer.backgroundColor=[UIColor whiteColor];
    UIButton * btn_addAddress=[[UIButton alloc] initWithFrame:CGRectMake((footer.frame.size.width-100)/2, 15, 100, 30)];
    [btn_addAddress setTitle:@"添加新地址" forState:UIControlStateNormal];
    btn_addAddress.layer.masksToBounds=YES;
    btn_addAddress.layer.cornerRadius=15;
    btn_addAddress.backgroundColor=[UIColor colorWithRed:255/255.0 green:152/255.0 blue:1/255.0 alpha:1.0];
    [btn_addAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_addAddress addTarget:self action:@selector(addressAddBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn_addAddress];
    [self.view addSubview:footer];
}
-(void)addressAddBtnclick:(UIButton *)sender
{
    NSLog(@"添加新地址");
    _myaddaddress=[[AddaddressViewController alloc] init];
    _myaddaddress.isChange=NO;
    _myaddaddress.userkey=_userkey;
    [self.navigationController pushViewController:_myaddaddress animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"addressTableViewCellIdentifier";
    AddressCellTableViewCell *cell = (AddressCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"AddressCellTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height);
    cell.address_name.text=addressArray[indexPath.row][@"true_name"]==[NSNull null]?@"":addressArray[indexPath.row][@"true_name"];
    cell.addres_tel.text=addressArray[indexPath.row][@"mob_phone"]==[NSNull null]?@"":addressArray[indexPath.row][@"mob_phone"];
    if ([addressArray[indexPath.row][@"is_default"] intValue]==1) {
        cell.addres_isdefault.image=[UIImage imageNamed:@"addres_isdefault"];
    }
    else
    {
        cell.Btn_setdefault.tag=indexPath.row;
        [cell.Btn_setdefault addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)setDefaultAddress:(UIButton * )sender
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"setDefaultBackCall:"];
    [dataprovider SetDefaultAddressWithaddressid:addressArray[sender.tag][@"address_id"] andkey:_userkey];
}
-(void)setDefaultBackCall:(id)dict
{
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqual:@"1"]) {
        [self loadAddresData];
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
