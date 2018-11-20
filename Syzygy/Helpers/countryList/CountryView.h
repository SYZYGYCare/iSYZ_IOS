//
//  CountryView.h
//  Syzygy
//
//  Created by manisha panse on 2/4/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryView : UIView<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UISearchBar *IBSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *countryTable;
@property (nonatomic, retain) NSArray *AllCountryArr;
@property (nonatomic, retain) NSArray *searchedArr;
@end
