//
//  CreditNavigationController.m
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import "CreditNavigationController.h"
#import "CreditWebViewController.h"

@interface CreditNavigationController ()

@property(nonatomic) BOOL notificatinInit;

@end

@implementation CreditNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!self.notificatinInit){
        self.notificatinInit=YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBack:) name:@"dbback" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];
    }
    
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    
}

-(void)setNavColorStyle:(UIColor *)color{
    if([self.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        self.navigationBar.barTintColor=color;
        self.navigationBar.tintColor=[UIColor whiteColor];
    }else{
        self.navigationBar.tintColor=color;
    }
    
}


-(void)shouldNewOpen:(NSNotification*)notification{
    UIViewController *last=[self.viewControllers lastObject];
    
    CreditWebViewController *newvc=[[CreditWebViewController alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[notification.userInfo objectForKey:@"url"]]]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [last.navigationItem setBackBarButtonItem:backItem];
    
    [self pushViewController:newvc animated:YES];
}
-(void)shouldBackRefresh:(NSNotification*) notification{
    NSInteger count=[self.viewControllers count];
    
    
    if(count>1){
        CreditWebViewController *second=[self.viewControllers objectAtIndex:count-2];
        second.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
    }
    
    [self popViewControllerAnimated:YES];
}
-(void)shouldBack:(NSNotification*)notification{
    [self popViewControllerAnimated:YES];
}
-(void)shouldBackRoot:(NSNotification*)notification{
    NSInteger count=self.viewControllers.count;
    CreditWebViewController *rootVC=nil;
    for(int i=0;i<count;i++){
        UIViewController *vc=[self.viewControllers objectAtIndex:i];
        if([vc isKindOfClass:[CreditWebViewController class]]){
            rootVC=(CreditWebViewController*)vc;
            break;
        }
    }
    if(rootVC!=nil){
        [self popToViewController:rootVC animated:YES];
    }else{
        [self popViewControllerAnimated:YES];
    }
}
-(void)shouldBackRootRefresh:(NSNotification*)notification{
    NSInteger count=self.viewControllers.count;
    CreditWebViewController *rootVC=nil;
    for(int i=0;i<count;i++){
        UIViewController *vc=[self.viewControllers objectAtIndex:i];
        if([vc isKindOfClass:[CreditWebViewController class]]){
            rootVC=(CreditWebViewController*)vc;
            break;
        }
    }
    if(rootVC!=nil){
        rootVC.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
        [self popToViewController:rootVC animated:YES];
    }else{
        [self popViewControllerAnimated:YES];
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    if(self.notificatinInit){
        self.notificatinInit=NO;
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
}
@end
