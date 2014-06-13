//
//  CreditWebViewController.h
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditWebView.h"

@interface CreditWebViewController : UIViewController

-(id)initWithUrl:(NSString*)url;
-(id)initWithUrl:(NSURLRequest*)request andDelegate:(id<CreditRefreshDelegate>)creditDelegate;

@end
