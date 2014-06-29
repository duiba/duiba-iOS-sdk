//
//  CreditWebViewController.m
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import "CreditWebViewController.h"
#import "CreditWebView.h"

@interface CreditWebViewController ()<CreditWebDelegate,CreditRefreshDelegate>
    
@property(nonatomic,strong) NSURLRequest *request;
@property(nonatomic,strong) CreditWebView *webView;
@property(nonatomic,strong) id<CreditRefreshDelegate> parentRefreshDelegate;

@end

@implementation CreditWebViewController

-(id)initWithUrl:(NSString *)url{
    self=[super init];
    self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    return self;
}
-(id)initWithUrl:(NSURLRequest *)request andDelegate:(id<CreditRefreshDelegate>)creditDelegate{
    self=[super init];
    self.request=request;
    self.parentRefreshDelegate=creditDelegate;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.webView=[[CreditWebView alloc]initWithFrame:self.view.bounds andUrl:[[self.request URL] absoluteString]];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
    self.webView.webDelegate=self;
    self.webView.refreshDelegate=self.parentRefreshDelegate;
    
    self.title=@"加载中";
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.webView.frame=self.view.bounds;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)newPage:(NSURLRequest *)request{
    CreditWebViewController *vc=[[CreditWebViewController alloc]initWithUrl:request andDelegate:self];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshParentPage:(NSURLRequest *)request{
    [self.webView loadRequest:request];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

@end
