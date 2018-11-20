//
//  SeniorListViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/15/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeniorListViewController;
@protocol SeniorListViewControllerDelegate <NSObject>
@optional
-(void)didSelectSenior:(NSDictionary*)senior;
@end

@interface SeniorListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *seniorListTableView;
@property (strong, nonatomic) id <SeniorListViewControllerDelegate> delegate;
@property (assign) BOOL isAddSomeOne;
@end
