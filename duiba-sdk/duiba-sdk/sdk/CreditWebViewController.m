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

@end

@implementation CreditWebViewController

-(id)initWithUrl:(NSString *)url{
    self=[super init];
    self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
    return self;
}
-(id)initWithRequest:(NSURLRequest *)request{
    self=[super init];
    self.request=request;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
    
    return self;
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
-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.webView=[[CreditWebView alloc]initWithFrame:self.view.bounds andUrl:[[self.request URL] absoluteString]];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
    self.webView.webDelegate=self;
    
    self.title=@"加载中";
    
    
    
    
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
}


-(void)refreshParentPage:(NSURLRequest *)request{
    [self.webView loadRequest:request];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
 