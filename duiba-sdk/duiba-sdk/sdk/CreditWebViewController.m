//
//  CreditWebViewController.m
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import "CreditWebViewController.h"
#import "CreditWebView.h"

@interface CreditWebViewController ()<UIWebViewDelegate>
    
@property(nonatomic,strong) NSURLRequest *request;
@property(nonatomic,strong) CreditWebView *webView;

@property(nonatomic,strong) NSString *needRefreshUrl;

@property(nonatomic,strong) UIActivityIndicatorView *activity;

@end

@implementation CreditWebViewController

-(id)initWithUrl:(NSString *)url{
    self=[super init];
    self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
    return self;
}
-(id)initWithUrlByPresent:(NSString *)url{
    self=[self initWithUrl:url];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem=leftButton;
    return self;
}
-(id)initWithRequest:(NSURLRequest *)request{
    self=[super init];
    self.request=request;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
    
    return self;
}
-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)shouldBackRoot:(NSNotificationCenter*)notification{
    [self.navigationController popToViewController:self animated:YES];
}
-(void)shouldNewOpen:(NSNotification*)notification{
    UIViewController *vc=[self.navigationController.viewControllers lastObject];
    if(vc==self){
        CreditWebViewController *newvc=[[CreditWebViewController alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[notification.userInfo objectForKey:@"url"]]]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        
        [self.navigationController pushViewController:newvc animated:YES];
    }
}
-(void)shouldBackRefresh:(NSNotification*) notification{
    UIViewController *vc=[self.navigationController.viewControllers lastObject];
    NSInteger count=[self.navigationController.viewControllers count];
    
    if(count>1){
        CreditWebViewController *second=[self.navigationController.viewControllers objectAtIndex:count-2];
        if(second==self){
            self.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
        }
    }
    
    if(vc==self){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.webView=[[CreditWebView alloc]initWithFrame:self.view.bounds andUrl:[[self.request URL] absoluteString]];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
    self.webView.webDelegate=self;
    
    self.title=@"加载中";
    
    
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.activity hidesWhenStopped];
    [self.activity setCenter:self.view.center];//指定进度轮中心点
    
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    self.activity.color=[UIColor blackColor];
    
    [self.view addSubview:self.activity];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.webView.frame=self.view.bounds;
    if(self.needRefreshUrl!=nil){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.needRefreshUrl]]];
        self.needRefreshUrl=nil;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.activity stopAnimating];
}


-(void)refreshParentPage:(NSURLRequest *)request{
    [self.webView loadRequest:request];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activity startAnimating];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
 