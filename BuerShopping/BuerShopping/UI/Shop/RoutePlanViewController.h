//
//  RoutePlanViewController.h
//  officialDemoNavi
//
//  Created by LiuX on 14-9-1.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "BaseNaviViewController.h"

@interface RoutePlanViewController : BaseNaviViewController
@property (nonatomic, strong) AMapNaviPoint* startPoint;
@property (nonatomic, strong) AMapNaviPoint* endPoint;

@end
