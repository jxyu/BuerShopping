//
//  WXViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "WXViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HYSegmentedControl.h"
#import "DataProvider.h"

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin @"小虎-tiger"


@interface WXViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate,HYSegmentedControlDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    UITableView *mainTable;
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
    
    NSArray * RequestArray;
    
    BOOL getMineList;//是否获取我发表的额list
    
}

@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property(nonatomic,strong)HYSegmentedControl *segmentedControl;

@end

@implementation WXViewController

-(void)RequestData
{
    RequestArray=[[NSArray alloc] init];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"RequestDataBackCall:"];
    if (getMineList) {
        [dataprovider GetShowOrderForMySendWithKey:_key];
    }
    else
    {
        [dataprovider GetShowOrderForMyJuageWithKey:_key];
    }
    
}
-(void)RequestDataBackCall:(id)dict
{
    NSLog(@"晒单圈数据:%@",dict);
    if (!dict[@"datas"][@"error"]) {
        RequestArray=dict[@"datas"][@"circle_list"];
        [self configData];
        
        if (!mainTable) {
            [self initTableview];
        }
        
        [self loadTextData];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - 数据源
- (void)configData{
    
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    
    
    for (int i=0; i<RequestArray.count; i++) {
        WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
        messBody1.posterContent = RequestArray[i][@"description"];
        messBody1.circle_id=RequestArray[i][@"circle_id"];
        NSMutableArray * arrayimg=[[NSMutableArray alloc] init];
        NSDictionary * img_dict=[[NSDictionary alloc] initWithDictionary:RequestArray[i][@"image"]];
        for (int j=0; j<img_dict.count; j++) {
            [arrayimg addObject:img_dict[[NSString stringWithFormat:@"%d",j]]];
        }
        messBody1.posterPostImage = [[NSArray alloc] initWithArray:arrayimg];
        messBody1.posterImgstr = RequestArray[i][@"avatar"];
        messBody1.posterName = [RequestArray[i][@"member_name"] isKindOfClass:[NSNull class]]?@"":RequestArray[i][@"member_name"];
        messBody1.posterIntro = [RequestArray[i][@"addtime"] isKindOfClass:[NSNull class]]?@"":RequestArray[i][@"addtime"];
        messBody1.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
        messBody1.isFavour = NO;
        messBody1.liulanliang=[NSString stringWithFormat:@"%@人浏览过",RequestArray[i][@"views"]];
        NSMutableArray * posterReplies=[[NSMutableArray alloc] init];
        NSArray * pingjiaArray=[[NSArray alloc] initWithArray:RequestArray[i][@"quote"]];
        for (int j=0; j<pingjiaArray.count; j++) {
            WFReplyBody *body = [[WFReplyBody alloc] init];
            body.replyUser = [pingjiaArray[j][@"member_name"] isKindOfClass:[NSNull class]]?@"":pingjiaArray[j][@"member_name"];
            body.repliedUser = [pingjiaArray[j][@"member_name"] isEqualToString:@""]?RequestArray[i][@"member_name"]:pingjiaArray[j][@"member_name"];
            body.replyInfo = [pingjiaArray[j][@"reply_content"] isKindOfClass:[NSNull class]]?@"":pingjiaArray[j][@"reply_content"];
            [posterReplies addObject:body];
        }
        messBody1.posterReplies = posterReplies;
        [_contentDataSource addObject:messBody1];
    }
 
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightbuttontitle:@"发布"];
    _lblTitle.text=@"晒单圈";
    _lblTitle.textColor=[UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    getMineList=YES;
    
    [self RequestData];
   

}

#pragma mark -加载数据
- (void)loadTextData{

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
       NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
       
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
             
             WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
             YMTextData *ymData = [[YMTextData alloc] init ];
             ymData.messageBody = messBody;
            
             [ymDataArray addObject:ymData];
             
         }
         [self calculateHeight:ymDataArray];
         
    });
}



#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{

    
    NSDate* tmpStartData = [NSDate date];
    
    for (YMTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width-50];
        
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
        
        [_tableDataSource addObject:ymData];
        
    }
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
               [mainTable reloadData];
    });

   
}

-(void)BuildHeaderView
{
    UIView * headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    UIImageView * img_back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerview.frame.size.width, 150)];
    img_back.image=[UIImage imageNamed:@"my_title_bg"];
    [headerview addSubview:img_back];
    UILabel * lbl_nickName=[[UILabel alloc] initWithFrame:CGRectMake(0, img_back.frame.size.height-30, img_back.frame.size.width, 20)];
    lbl_nickName.text=_nickName;
    lbl_nickName.textAlignment=NSTextAlignmentCenter;
    [img_back addSubview:lbl_nickName];
    UIImageView * img_touxiang=[[UIImageView alloc] initWithFrame:CGRectMake((img_back.frame.size.width-70)/2, img_back.frame.size.height-100, 70, 70)];
    [img_touxiang sd_setImageWithURL:[NSURL URLWithString:_avatarImageHeader] placeholderImage:[UIImage imageNamed:@"head_icon_placeholder"]];
    img_touxiang.layer.masksToBounds=YES;
    img_touxiang.layer.cornerRadius=35;
    [headerview addSubview:img_touxiang];
    self.segmentedControl = [[HYSegmentedControl alloc] initWithOriginY:150 Titles:@[@"我发表的", @"我评论的"] delegate:self] ;
    [headerview addSubview:self.segmentedControl];
    mainTable.tableHeaderView=headerview;
}

//
//  HYSegmentedControlDelegate method
//
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    if (index==0) {
        getMineList=YES;
    }
    if (index==1) {
        getMineList=NO;
    }
    [self RequestData];
}

- (void) initTableview{

    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self BuildHeaderView];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];

}

//**
// *  ///////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance);
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];

    return cell;
}

////////////////////////////////////////////////////////////////////

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
     
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:mainTable rect:targetRect isFavour:ym.hasFavour];
}



- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        WS(ws);
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    
                    [ws addLike];
                    break;
                case WFOperationTypeReply:
                     [ws replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

#pragma mark - 赞
- (void)addLike{
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        [m.posterFavour removeObject:kAdmin];
        m.isFavour = NO;
    }else{
        [m.posterFavour addObject:kAdmin];
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    
    if (m.isFavour) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"ZanClickBackCall:"];
        [dataprovider zanClickWithKey:_key andcircle_id:m.circle_id];
    }
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    [mainTable reloadData];

}
-(void)ZanClickBackCall:(id)dict
{
    NSLog(@"%@",dict);
}


#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender{
    
    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = _selectedIndexPath.row;
    [self.view addSubview:replyView];

}


#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];

}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [mainTable reloadData];

}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
   
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
       
    }];

}

#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{

    [self.operationView dismiss];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;

}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    if (replyIndex==-1) {
        return;
    }
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:_nickName]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
        
        
        
    }else{
       //回复
        if (replyView) {
            return;
        }
        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
        replyView.delegate = self;
        replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
        replyView.replyTag = index;
        [self.view addSubview:replyView];
    }
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = _nickName;
        body.repliedUser = @"";
        body.replyInfo = replyText;
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = _nickName;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        
        [m.posterReplies addObject:body];
        ymData.messageBody = m;

    }
   
    
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [mainTable reloadData];
}

- (void)destorySelf{
    
  //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;

}

- (void)actionSheet:(WFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //delete
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies removeObjectAtIndex:_replyIndex];
        ymData.messageBody = m;
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
        
        [mainTable reloadData];
        
    }else{
        
    }
    _replyIndex = -1;
}

- (void)dealloc{
    
    NSLog(@"销毁");

}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


@end
