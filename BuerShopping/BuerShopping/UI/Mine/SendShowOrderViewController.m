//
//  SendShowOrderViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/20.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "SendShowOrderViewController.h"
#import "ZLPhoto.h"
#import "DataProvider.h"

#define kImgWidth (SCREEN_WIDTH-50)/4

@interface SendShowOrderViewController () <ZLPhotoPickerViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate>
@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UIScrollView *scrollView;

@end

@implementation SendShowOrderViewController
{
    NSString * orderText;
    BOOL keyboardZhezhaoShow;
    int uplodaimage;
    NSMutableArray * img_array;
}
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    uplodaimage=0;
    _lblTitle.text=@"发布详情";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightbuttontitle:@"发布"];
    img_array=[[NSMutableArray alloc] init];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    keyboardZhezhaoShow=NO;
//    [self ButildAllView];
    // 这个属性不能少
    self.automaticallyAdjustsScrollViewInsets = NO;
    int y= self.txt_text.frame.size.height+self.txt_text.frame.origin.y+100;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, y, SCREEN_WIDTH+280, SCREEN_HEIGHT-y);
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
    
    // 属性scrollView
    [self reloadScrollView];
    
}

-(void)clickRightButton:(UIButton *)sender
{
    [self BuildDataAndRequest];
    [SVProgressHUD showWithStatus:@"正在上传图片。。"];
}
-(void)BuildDataAndRequest
{
    NSArray * imgarray=[[NSArray alloc] initWithArray:[self.scrollView subviews]];
    if ([imgarray[uplodaimage] isKindOfClass:[UIButton class]]) {
        UIButton * item=(UIButton *)imgarray[uplodaimage];
        NSData * imgData=UIImageJPEGRepresentation(item.imageView.image, 1.0);
        DataProvider * dataprovider=[[DataProvider alloc] init];
        ++uplodaimage;
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadeImgBackCall:"];
        [dataprovider ShowOrderUpLoadImg:imgData andkey:_key];
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
            
            DataProvider *dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"showorderSendBackCall:"];
            [dataprovider ShowOrderSendWithKey:_key anddescription:self.txt_text.text andimage:images];
            
        }
    }
}

-(void)showorderSendBackCall:(id)dict
{
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (dict[@"datas"][@"error"]) {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
        }
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [self.txt_text resignFirstResponder];
    [sender removeFromSuperview];
}
- (void)textChanged:(NSNotification *)notification
{
    if (self.txt_text.text.length == 0) {
        _lbl_placeholder.text = @"推荐详情";
        self.lbl_xing.text=@"＊";
    }else{
        self.lbl_placeholder.text = @"";
        self.lbl_xing.text=@"";
    }
}


@end
