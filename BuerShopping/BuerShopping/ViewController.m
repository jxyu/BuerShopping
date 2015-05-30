//
//  ViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.indexview=[[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:[NSBundle mainBundle]];
//    UIView *itemview=_indexview.view;
//    
//    [self.view addSubview:itemview];
    self.myindexVC=[[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:[NSBundle mainBundle]];
    [self.view addSubview:_myindexVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
