//
//  CommonWebViewViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonWebViewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *commonWebView;

@property (strong, nonatomic) NSString *pageName;

@end
