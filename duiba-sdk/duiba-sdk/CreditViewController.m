//
//  CreditViewController.m
//  duiba-sdk
//
//  Created by xuhengfei on 14-6-13.
//  Copyright (c) 2014年 duiba. All rights reserved.
//

#import "CreditViewController.h"
#import "CreditWebViewController.h"
#import "CreditNavigationController.h"
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
    
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars =NO;
    }
    if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)]){
        self.modalPresentationCapturesStatusBarAppearance =NO;
    }
    if([self respondsToSelector:@selector(navigationController)]){
        if([self.navigationController.navigationBar respondsToSelector:@selector(setTranslucent:)]){
            self.navigationController.navigationBar.translucent =NO;
        }
    }
    
    
    
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
    
    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:@"http://www.dui88.com/test/demoRedirectSAdfjosfdjdsa"];
    
    //如果已经有UINavigationContoller了，就 创建出一个 CreditWebViewController 然后 push 进去
    [self.navigationController pushViewController:web animated:YES];
    
    //如果没有UINavigationController，就创建一个 CreditNavigationController 然后 present 出来
    /*
    CreditNavigationController *nav=[[CreditNavigationController alloc]initWithRootViewController:web];
    [nav setNavColorStyle:[UIColor colorWithRed:195/255.0 green:0 blue:19/255.0 alpha:1]];
    [self presentViewController:nav animated:YES completion:nil];
    */
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
@end
