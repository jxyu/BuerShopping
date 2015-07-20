//
//  ClassifyViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ClassifyViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "GoodListViewController.h"
#import "ShopViewController.h"

@interface ClassifyViewController ()

@end

@implementation ClassifyViewController
{
    UITextField * txt_searchtext;
    UIButton * btn_select;
    NSArray* selectArray;
    UIView * select_Backview;
    BOOL isSelectViewShow;
    NSString * searchType;
    NSArray * firstMenu;
    NSArray * secondMenu;
    UIScrollView * scroll_Mnue;
    UIView * backview_SecondClassify;
    BOOL keyboardZhezhaoShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    firstMenu=[[NSArray alloc] init];
    secondMenu=[[NSArray alloc] init];
    keyboardZhezhaoShow=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    int tabBarWitdh = SCREEN_WIDTH * 1.0f / 5;
    
    
    /**********************************head搜索栏开始***********************************/
    selectArray=@[@"宝贝",@"店铺"];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
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
    scroll_Mnue=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH/3, SCREEN_HEIGHT-65-tabBarWitdh)];
    scroll_Mnue.scrollEnabled=YES;
    backview_SecondClassify=[[UIView alloc] initWithFrame:CGRectMake(scroll_Mnue.frame.size.width, scroll_Mnue.frame.origin.y, SCREEN_WIDTH-scroll_Mnue.frame.size.width, scroll_Mnue.frame.size.height)];
    backview_SecondClassify.backgroundColor=[UIColor whiteColor];

    
    [self LoadAllData];
    
}


-(void)LoadAllData
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    NSDictionary * cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [self addLeftbuttontitle:cityinfoWithFile[@"area_name"]];
    _lblLeft.font=[UIFont systemFontOfSize:13];
    UIImageView * img_icon_down=[[UIImageView alloc] initWithFrame:CGRectMake(_btnLeft.frame.size.width-8, 18, 8, 5)];
    img_icon_down.image=[UIImage imageNamed:@"menu_down"];
    [_btnLeft addSubview:img_icon_down];
    
    
    DataProvider * dataprovider=[DataProvider alloc];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetClassifyBackCall:"];
    [dataprovider GetClassify];
}
-(void)GetClassifyBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if(![dict[@"datas"] objectForKey:@"error"])
    {
        firstMenu=dict[@"datas"][@"class_list"];
        NSArray * arrayClassList=dict[@"datas"][@"class_list"];
        [self BuildClassify];
        if (arrayClassList.count>0) {
            DataProvider * dataprovider=[DataProvider alloc];
            [dataprovider setDelegateObject:self setBackFunctionName:@"GetClassifyNextBackCall:"];
            [dataprovider GetClassifyNext:arrayClassList[0][@"gc_id"]];
        }
        
    }
}

-(void)GetClassifyNextBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if(![dict[@"datas"] objectForKey:@"error"])
    {
        secondMenu=dict[@"datas"][@"class_list"];
        [self BuildGNextClassify];
    }
}

-(void)BuildClassify
{
    
    for (int i=0; i<firstMenu.count; i++) {
        UIButton * btn_item=[[UIButton alloc] initWithFrame:CGRectMake(0,i*81, scroll_Mnue.frame.size.width, 80)];
        btn_item.tag=i;
        btn_item.backgroundColor=i==0?[UIColor whiteColor]:[UIColor colorWithRed:230/255.0 green:192/255.0 blue:253/255.0 alpha:1.0];
        [btn_item setTitle:firstMenu[i][@"gc_name"] forState:UIControlStateNormal];
        [btn_item setTitleColor:i==0?[UIColor colorWithRed:102/255.0 green:75/255.0 blue:120/255.0 alpha:1.0]:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_item addTarget:self action:@selector(GetsecondClassify:) forControlEvents:UIControlEventTouchUpInside];
        [scroll_Mnue addSubview:btn_item];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, btn_item.frame.size.height)];
        fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:192/255.0 blue:253/255.0 alpha:1.0];
        [btn_item addSubview:fenge];
        
    }
    UIView * lastview=[scroll_Mnue.subviews lastObject];
    [scroll_Mnue setContentSize:CGSizeMake(0, lastview.frame.origin.y+lastview.frame.size.height+5)];
    [self.view addSubview:scroll_Mnue];
    
    
//    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
//    
//    
//    /**
//     *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
//     */
//    for (int i=0; i<firstMenu.count; i++) {
//        
//        rightMeun * meun=[[rightMeun alloc] init];
//        meun.meunName=firstMenu[i][@"gc_name"];
//        meun.ID=firstMenu[i][@"gc_id"];
//        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
//        rightMeun * meun1=[[rightMeun alloc] init];
//        meun1.meunName=[NSString stringWithFormat:@"头菜单"];
//        [sub addObject:meun1];
//        NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
//        for ( int z=0; z <secondMenu.count; z++) {
//            rightMeun * meun2=[[rightMeun alloc] init];
//            meun2.meunName=secondMenu[0][@"gc_name"];
//            meun2.urlName=secondMenu[0][@"image"];
//            meun2.ID=secondMenu[0][@"gc_id"];
//            [zList addObject:meun2];
//        }
//        meun1.nextArray=zList;
//        meun.nextArray=sub;
//        [lis addObject:meun];
//    }
//    
//    
//    MultilevelMenu * view=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
//        
//        NSLog(@"点击的 菜单%@",info.meunName);
//    }];
//    
//    //    view.leftSelectColor=[UIColor greenColor];
//    //  view.leftSelectBgColor=[UIColor redColor];
//    view.isRecordLastScroll=YES;
//    [self.view addSubview:view];
}

-(void)GetsecondClassify:(UIButton *)sender
{
    for (UIView * items in scroll_Mnue.subviews) {
        if ([items isKindOfClass:[UIButton class]]) {
            UIButton *item=(UIButton *)items;
            item.backgroundColor=[UIColor colorWithRed:230/255.0 green:192/255.0 blue:253/255.0 alpha:1.0];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:102/255.0 green:75/255.0 blue:120/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    for (UIView * item in backview_SecondClassify.subviews) {
        [item removeFromSuperview];
    }
    DataProvider * dataprovider=[DataProvider alloc];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetClassifyNextBackCall:"];
    [dataprovider GetClassifyNext:firstMenu[sender.tag][@"gc_id"]];
}

-(void)BuildGNextClassify
{
    
    CGFloat itemWidth=backview_SecondClassify.frame.size.width/3;
    for (int i=0; i<secondMenu.count; i++) {
        UIView * backView_item=[[UIView alloc] initWithFrame:CGRectMake((i%3)*itemWidth, 100*(i/3), itemWidth, 100)];
        UIImageView * img_iconClassify=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, itemWidth, itemWidth)];
        [img_iconClassify sd_setImageWithURL:[NSURL URLWithString:secondMenu[i][@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [backView_item addSubview:img_iconClassify];
        UILabel * lbl_classifytitle=[[UILabel alloc] initWithFrame:CGRectMake(0, backView_item.frame.size.height-20, backView_item.frame.size.width, 20)];
        lbl_classifytitle.textAlignment=NSTextAlignmentCenter;
        lbl_classifytitle.font=[UIFont systemFontOfSize:15];
        lbl_classifytitle.text=secondMenu[i][@"gc_name"];
        [backView_item addSubview:lbl_classifytitle];
        [backview_SecondClassify addSubview:backView_item];
        UIButton * btn_senondClassify=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, backView_item.frame.size.width, backView_item.frame.size.height)];
        btn_senondClassify.tag=i;
        [btn_senondClassify addTarget:self action:@selector(SecondClassifyClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView_item addSubview:btn_senondClassify];
    }
    [self.view addSubview:backview_SecondClassify];
    
}

-(void)SecondClassifyClick:(UIButton *)sender
{
    //点击准备跳转
    NSLog(@"准备跳转");
    GoodListViewController * goodlist=[[GoodListViewController alloc] initWithNibName:@"GoodListViewController" bundle:[NSBundle mainBundle]];
    goodlist.gc_id=secondMenu[sender.tag][@"gc_id"];
    [self.navigationController pushViewController:goodlist animated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([@"\n" isEqualToString:string] == YES)
    {
        [textField resignFirstResponder];
        NSRange range= [searchType rangeOfString:@"宝贝"];
        if (range.length>0) {
            GoodListViewController * goodlist=[[GoodListViewController alloc] initWithNibName:@"GoodListViewController" bundle:[NSBundle mainBundle]];
            goodlist.KeyWord=textField.text;
            [self.navigationController pushViewController:goodlist animated:YES];
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
    if (!keyboardZhezhaoShow) {
        UIButton * btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65-height)];
        [btn_zhezhao addTarget:self action:@selector(btn_zhezhaoClick:) forControlEvents:UIControlEventTouchUpInside];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}


@end
