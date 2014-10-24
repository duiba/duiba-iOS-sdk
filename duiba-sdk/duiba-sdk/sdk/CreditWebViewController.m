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


@property(nonatomic,strong) UIActivityIndicatorView *activity;

@end

@implementation CreditWebViewController

-(id)initWithUrl:(NSString *)url{
    self=[super init];
    self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
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
    
       
    return self;
}

-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.webView=[[CreditWebView alloc]initWithFrame:self.view.bounds andUrl:[[self.request URL] absoluteString]];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
    self.webView.webDelegate=self;
    
    self.title=@"加载中";
    
    
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];//指定进度轮的大小
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.activity hidesWhenStopped];
    [self.activity setCenter:self.view.center];//指定进度轮中心点
    
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
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




-(void)refreshParentPage:(NSURLRequest *)request{
    [self.webView loadRequest:request];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark WebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activity startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.activity stopAnimating];
}

@end
 