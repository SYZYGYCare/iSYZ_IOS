//
//  ToDoListViewController.m
//  Syzygy
//
//  Created by kamal gupta on 12/1/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "ToDoListViewController.h"
#import "MFSideMenu.h"

@interface ToDoListViewController ()

@end

@implementation ToDoListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Todo List";
    
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];

    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
