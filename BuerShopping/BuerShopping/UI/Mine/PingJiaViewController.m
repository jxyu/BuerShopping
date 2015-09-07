//
//  PingJiaViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/22.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "PingJiaViewController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "OrderCellTableViewCell.h"
#import "CWStarRateView.h"
#import "ZLPhoto.h"

@interface PingJiaViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,CWStarRateViewDelegate,ZLPhotoPickerViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate>
@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UIScrollView *scrollView;

@end

@implementation PingJiaViewController
{
    NSArray * goodList;
    NSMutableDictionary * startdict;
    NSMutableDictionary * messagedict;
    NSMutableDictionary * imagedict;
    UITextView * txtview;
    BOOL keyboardZhezhaoShow;
    int uplodaimage;
    NSMutableArray * img_array;
    NSInteger * sectionNow;
}
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"宝贝评价";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    startdict=[[NSMutableDictionary alloc] init];
    messagedict=[[NSMutableDictionary alloc] init];
    imagedict=[[NSMutableDictionary alloc] init];
    keyboardZhezhaoShow=NO;
    uplodaimage=0;
    sectionNow=0;
    img_array=[[NSMutableArray alloc] init];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pingjiakeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    goodList=[[NSArray alloc] initWithArray:self.orderData[@"extend_order_goods"]];
    [self BuildAllView];
}
-(void)BuildAllView
{
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    // 这个属性不能少
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, 300, SCREEN_WIDTH+280, 300);
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
    
    // 属性scrollView
    [self reloadScrollView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        cell.lbl_orderTitle.text=[NSString stringWithFormat:@"%@",goodList[indexPath.section][@"goods_name"]];
        cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",goodList[indexPath.section][@"goods_price"]];
        cell.lbl_num.text=[NSString stringWithFormat:@"x%@",goodList[indexPath.section][@"goods_num"]];
        cell.lbl_guige.text=goodList[indexPath.section][@"goods_spec"];
        [cell.img_log sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodList[indexPath.section][@"goods_image_url"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        return cell;
    }else if (indexPath.row==1) {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_storePingija=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 80, 20)];
        lbl_storePingija.textColor=[UIColor grayColor];
        lbl_storePingija.text=@"店铺评分";
        [cell addSubview:lbl_storePingija];
        CGFloat x=lbl_storePingija.frame.size.width+lbl_storePingija.frame.origin.x+30;
        CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(x,20,cell.frame.size.width-x-10,20) numberOfStars:5];
        weisheng.scorePercent = 0;
        weisheng.allowIncompleteStar = NO;
        weisheng.tag=indexPath.section;
        weisheng.hasAnimation = YES;
        weisheng.delegate=self;
        [cell addSubview:weisheng];
        return cell;
    }
    else {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UITextView * txt_message=[[UITextView alloc] initWithFrame:CGRectMake(10, 10, cell.frame.size.width-100, 70)];
        txt_message.scrollEnabled=YES;
        txt_message.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        txt_message.delegate=self;
        txt_message.tag=indexPath.section;
        [cell addSubview:txt_message];
        UIButton * btn_addImg=[[UIButton alloc] initWithFrame:CGRectMake(txt_message.frame.size.width+txt_message.frame.origin.x+10, 10, 70, 70)];
        [btn_addImg setImage:[UIImage imageNamed:@"Upload_img_icon"] forState:UIControlStateNormal];
        btn_addImg.tag=indexPath.section;
        [btn_addImg addTarget:self action:@selector(uploadImg:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_addImg];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        return 60;
    }
    return 95;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return goodList.count;
}



-(void)BuildDataAndRequest
{
    NSArray * imgarray=[[NSArray alloc] initWithArray:[self.scrollView subviews]];
    if ([imgarray[uplodaimage] isKindOfClass:[UIButton class]]) {
        UIButton * item=(UIButton *)imgarray[uplodaimage];
        NSData * imgData=UIImageJPEGRepresentation(item.imageView.image, 1.0);
        [SVProgressHUD showWithStatus:@"正在保存图片" maskType:SVProgressHUDMaskTypeBlack];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        ++uplodaimage;
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadeImgBackCall:"];
        [dataprovider UploadPingJiaImg:imgData andkey:_key];
    }
}

-(void)UploadeImgBackCall:(id)dict
{
    
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        [img_array addObject:dict[@"datas"][@"image_name"]];
        if (uplodaimage<self.assets.count) {
            
            [self BuildDataAndRequest];
        }
        else
        {
            [SVProgressHUD dismiss];
            NSString *images=@"";
            for (int i=0; i<img_array.count; i++) {
                if (i==0) {
                    images=[NSString stringWithFormat:@"%@",img_array[i]];
                }
                else
                {
                    images=[images stringByAppendingString:[NSString stringWithFormat:@",%@",img_array[i]]];
                }
            }
            [imagedict setObject:images forKey:[goodList objectAtIndex:sectionNow][@"goods_id"]];
//            DataProvider *dataprovider=[[DataProvider alloc] init];
//            [dataprovider setDelegateObject:self setBackFunctionName:@"showorderSendBackCall:"];
//            [dataprovider ShowOrderSendWithKey:_key anddescription:self.txt_text.text andimage:images];
            NSLog(@"%@",images);
            [SVProgressHUD showSuccessWithStatus:@"图片保存成功" maskType:SVProgressHUDMaskTypeBlack];
            
        }
    }
}
-(void)uploadImg:(UIButton *)sender
{
    sectionNow=sender.tag;
    [self photoSelecte];
}
#pragma mark - select Photo Library
- (void)photoSelecte {
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.minCount = 9 - self.assets.count;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.rootvc=self;
    pickerVc.callBack = ^(NSArray *status){
        [self.assets addObjectsFromArray:status];
        [self reloadScrollView];
        [self BuildDataAndRequest];
    };
    [self.navigationController pushViewController:pickerVc animated:YES];
    /**
     *
     传值可以用代理，或者用block来接收，以下是block的传值
     __weak typeof(self) weakSelf = self;
     pickerVc.callBack = ^(NSArray *assets){
     weakSelf.assets = assets;
     [weakSelf.tableView reloadData];
     };
     */
}

- (void)reloadScrollView{
    
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 4;
    // 加一是为了有个添加button
    NSUInteger assetCount = self.assets.count + 1;
    
    CGFloat width = SCREEN_WIDTH / column;
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(width * col, row * width, width, width);
        
        // UIButton
        if (i == self.assets.count){
            // 最后一个Button
            [btn setImage:[UIImage imageNamed:@"Add_img_icom"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(photoSelecte) forControlEvents:UIControlEventTouchUpInside];
        }else{
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
                NSLog(@"%@",[self.assets[i] thumbImage]);
            }else{
                [btn sd_setImageWithURL:[NSURL URLWithString:self.assets[i % (self.assets.count)]] forState:UIControlStateNormal];
                NSLog(@"%@",self.assets[i % (self.assets.count)]);
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}
- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    //    pickerBrowser.toView = btn;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [self.navigationController pushViewController:pickerBrowser animated:YES];
}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.assets.count;
}

#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoAssets *imageObj = [self.assets objectAtIndex:indexPath.row];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    
    UIButton *btn = self.scrollView.subviews[indexPath.row];
    photo.toView = btn.imageView;
    // 缩略图
    photo.thumbImage = btn.imageView.image;
    return photo;
}



//当键盘出现或改变时调用
- (void)pingjiakeyboardWillShow:(NSNotification *)aNotification
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
    [txtview resignFirstResponder];
    [sender removeFromSuperview];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    txtview= textView;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [messagedict setObject:textView.text forKey:goodList[textView.tag][@"goods_id"]];
}
#pragma mark 星星评价代理方法
-(void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    NSLog(@"%f",newScorePercent);
    [startdict setObject:[NSString stringWithFormat:@"%.0f",newScorePercent*5] forKey:goodList[starRateView.tag][@"goods_id"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitClick:(UIButton *)sender {
    NSMutableDictionary * prm=[[NSMutableDictionary alloc] init];
    for (int i=0; i<goodList.count; i++) {
        NSString * goods_id=goodList[i][@"goods_id"];
        NSMutableDictionary *itemprm=[[NSMutableDictionary alloc] init];
        [itemprm setObject:messagedict[goods_id] forKey:@"comment"];
        [itemprm setObject:startdict[goods_id] forKey:@"score"];
        if (imagedict[goods_id]) {
            [itemprm setObject:imagedict[goods_id] forKey:@"image"];
        }
        [prm setObject:itemprm forKey:goods_id];
    }
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:prm
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding];
    
    NSDictionary * sendprm=@{@"key":_key,@"order_id":_orderData[@"order_id"],@"goods":prm};
    DataProvider * dataprovider=[[DataProvider alloc] init];
    
    [dataprovider setDelegateObject:self setBackFunctionName:@"submitBackcall:"];
    [dataprovider SubmitPingjia:sendprm];
}
-(void)submitBackcall:(id)dict
{
    NSLog(@"%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
