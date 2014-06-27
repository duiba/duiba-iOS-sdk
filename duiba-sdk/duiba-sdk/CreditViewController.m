//
//  CreditViewController.m
//  duiba-sdk
//
//  Created by xuhengfei on 14-6-13.
//  Copyright (c) 2014年 duiba. All rights reserved.
//

#import "CreditViewController.h"
#import "CreditWebViewController.h"
@interface CreditViewController ()

@end

@implementation CreditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title=@"个人中心";
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars =NO;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.navigationController.navigationBar.translucent =NO;
    
    
    UIImage *image=[UIImage imageNamed:@"snapshot"];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageView];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
    btn.frame=CGRectMake(320-40-70, 60, 70, 27);
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
}

-(void)enter{
    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:@"http://baidu.com"];//实际中需要改为带签名的地址
    
    [self.navigationController pushViewController:web animated:YES];
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
@end
