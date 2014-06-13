//
//  CreditWebView.h
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-6-13.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CreditWebDelegate <UIWebViewDelegate>

-(void)newPage:(NSURLRequest*)request;
-(void)back;

@end

@protocol CreditRefreshDelegate <NSObject>

-(void)refreshParentPage:(NSURLRequest*)request;

@end

@interface CreditWebView : UIWebView<UIWebViewDelegate>
@property (nonatomic,strong) id<CreditWebDelegate> webDelegate;
@property (nonatomic,strong) id<CreditRefreshDelegate> refreshDelegate;

-(id)initWithFrame:(CGRect)frame andUrl:(NSString*)url;
@end


