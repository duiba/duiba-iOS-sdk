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
@property(nonatomic,strong) NSString *shareUrl;
@property(nonatomic,strong) NSString *shareTitle;
@property(nonatomic,strong) NSString *shareSubtitle;
@property(nonatomic,strong) NSString *shareThumbnail;

@property(nonatomic,strong) UIBarButtonItem *shareButton;


@property(nonatomic,strong) UIActivityIndicatorView *activity;

@end

static UINavigationController *navController;

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
    if(navController==nil){
        navController=self.navigationController;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBack:) name:@"dbback" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];
    }
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
    
    NSString *content=[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('duiba-share-url').getAttribute('content');"];
    if(content.length>0){
        NSArray *d=[content componentsSeparatedByString:@"|"];
        if(d.count==4){
            self.shareUrl=[d objectAtIndex:0];
            self.shareThumbnail=[d objectAtIndex:1];
            self.shareTitle=[d objectAtIndex:2];
            self.shareSubtitle=[d objectAtIndex:3];
            
            if(self.shareButton==nil){
                self.shareButton=[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(onShareClick)];
            }
            
            if(self.navigationItem.rightBarButtonItem==nil){
                self.navigationItem.rightBarButtonItem=self.shareButton;
            }
        }
    }else{
        if(self.shareButton!= nil && self.shareButton==self.navigationItem.rightBarButtonItem){
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
    [self.activity stopAnimating];
}



-(void)onShareClick{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:self.shareUrl forKey:@"shareUrl"];
    [dict setObject:self.shareThumbnail forKey:@"shareThumbnail"];
    [dict setObject:self.shareTitle forKey:@"shareTitle"];
    [dict setObject:self.shareSubtitle forKey:@"shareSubtitle"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duiba-share-click" object:self userInfo:dict];
}

#pragma mark 5 activite


-(void)shouldNewOpen:(NSNotification*)notification{
    UIViewController *last=[navController.viewControllers lastObject];
    
    CreditWebViewController *newvc=[[CreditWebViewController alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[notification.userInfo objectForKey:@"url"]]]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [last.navigationItem setBackBarButtonItem:backItem];
    
    [navController pushViewController:newvc animated:YES];
}
-(void)shouldBackRefresh:(NSNotification*) notification{
    NSInteger count=[navController.viewControllers count];
    
    
    if(count>1){
        CreditWebViewController *second=[navController.viewControllers objectAtIndex:count-2];
        second.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
    }
    
    [navController popViewControllerAnimated:YES];
}
-(void)shouldBack:(NSNotification*)notification{
    [navController popViewControllerAnimated:YES];
}
-(void)shouldBackRoot:(NSNotification*)notification{
    NSInteger count=navController.viewControllers.count;
    CreditWebViewController *rootVC=nil;
    for(int i=0;i<count;i++){
        UIViewController *vc=[navController.viewControllers objectAtIndex:i];
        if([vc isKindOfClass:[CreditWebViewController class]]){
            rootVC=(CreditWebViewController*)vc;
            break;
        }
    }
    if(rootVC!=nil){
        [navController popToViewController:rootVC animated:YES];
    }else{
        [navController popViewControllerAnimated:YES];
    }
}
-(void)shouldBackRootRefresh:(NSNotification*)notification{
    NSInteger count=navController.viewControllers.count;
    CreditWebViewController *rootVC=nil;
    for(int i=0;i<count;i++){
        UIViewController *vc=[navController.viewControllers objectAtIndex:i];
        if([vc isKindOfClass:[CreditWebViewController class]]){
            rootVC=(CreditWebViewController*)vc;
            break;
        }
    }
    if(rootVC!=nil){
        rootVC.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
        [navController popToViewController:rootVC animated:YES];
    }else{
        [navController popViewControllerAnimated:YES];
    }
}


@end
 