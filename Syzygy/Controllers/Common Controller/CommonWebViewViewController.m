//
//  CommonWebViewViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "CommonWebViewViewController.h"
#import "Constant.h"
#import "MBProgressHUD.h"

@interface CommonWebViewViewController ()<UIWebViewDelegate>


@end

@implementation CommonWebViewViewController {
    MBProgressHUD *hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = _pageName;
    if ([_pageName isEqualToString:@"About"] || [_pageName isEqualToString:@"Privacy Policy"] ||[_pageName isEqualToString:@"Term & Conditions"] || [_pageName isEqualToString:@"Support"]) {
        
    }
    NSString *urlStr = kBaseUrl;
    if ([_pageName isEqualToString:@"About"])
    {
        urlStr = @"http://syzygycare.com/page/about";
    }else if ([_pageName isEqualToString:@"Privacy Policy"])
    {
        urlStr = @"http://syzygycare.com/page/privacy";
    }else if ([_pageName isEqualToString:@"Terms & Conditions"])
    {
        urlStr = @"http://syzygycare.com/page/term_condition";
    }else if ([_pageName isEqualToString:@"Support"])
    {
        urlStr = @"http://syzygycare.com/page/disclaimer";
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [_commonWebView loadRequest:requestObj];
    _commonWebView.delegate = self;
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [hud hideAnimated:YES];
    
    
}


@end
