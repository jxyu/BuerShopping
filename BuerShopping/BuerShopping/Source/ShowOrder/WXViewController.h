//
//  WXViewController.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface WXViewController : BaseNavigationController
@property (nonatomic ,strong) NSString * key;
@property (nonatomic ,strong) NSString * avatarImageHeader;
@property (nonatomic ,strong) NSString * nickName;
@end
