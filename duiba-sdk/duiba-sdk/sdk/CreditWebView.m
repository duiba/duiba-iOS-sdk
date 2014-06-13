//
//  CreditWebView.m
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-6-13.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import "CreditWebView.h"


@interface CreditWebView()
@property (nonatomic,strong) NSString *url;
@end

@implementation CreditWebView

-(id)init{
    self=[super init];
    self.delegate=self;
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.delegate=self;
    return self;
}
-(id)initWithFrame:(CGRect)frame andUrl:(NSString *)url{
    self=[self initWithFrame:frame];
    self.url=url;
    return self;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(self.webDelegate!=nil){
        if(![[[request URL] absoluteString] isEqualToString:self.url]){
            if([[request.URL description]rangeOfString:@"dbnewopen"].location!=NSNotFound){
                [self.webDelegate newPage:request];
                return NO;
            }else if([[request.URL description]rangeOfString:@"dbbackrefresh"].location!=NSNotFound){
                if(self.refreshDelegate !=nil){
                    [self.webDelegate back];
                    [self.refreshDelegate refreshParentPage:request];
                    return NO;
                }
            }else{
                NSURL *requestURL =[request URL];
                NSURL *current=[NSURL URLWithString:self.url];
                if(![[requestURL host]isEqualToString:[current host]]){
                    return ![ [ UIApplication sharedApplication ] openURL:requestURL ];
                }
            }
        }
        
    }
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(self.webDelegate!=nil){
        [self.webDelegate webView:webView didFailLoadWithError:error];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webDelegate webViewDidFinishLoad:webView];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.webDelegate webViewDidStartLoad:webView];
}


@end
