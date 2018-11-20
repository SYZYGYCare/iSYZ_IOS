//
//  CountryView.m
//  Syzygy
//
//  Created by manisha panse on 2/4/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import "CountryView.h"

@implementation CountryView
/*
 }*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    dispatch_async(dispatch_get_main_queue(), ^{
        self.popView.layer.cornerRadius = 10;
    self.IBSearchBar.delegate = self;
    self.AllCountryArr = [self JSONFromFile];
    self.searchedArr = [self JSONFromFile];
        self.countryTable.dataSource = self;
        self.countryTable.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
     //   [self addGestureRecognizer:tap];
        [tap setCancelsTouchesInView:NO];
        [self.countryTable reloadData];

    });
}

- (NSArray *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - UITableView DataSource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchedArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"countryCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    UIImageView *flagImage = (UIImageView*)[cell viewWithTag:10];
    UILabel *countryName = (UILabel*)[cell viewWithTag:20];
    UILabel *DialcodeNumber = (UILabel*)[cell viewWithTag:30];
    NSDictionary *countryDic = [self.searchedArr objectAtIndex:indexPath.row];
    //{"name":"Afghanistan","dial_code":"+93","code":"AF"}
    flagImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[countryDic objectForKey:@"code"] lowercaseString]]];
    countryName.text = [NSString stringWithFormat:@"%@ (%@)",[countryDic objectForKey:@"name"],[countryDic objectForKey:@"code"]];
    DialcodeNumber.text = [countryDic objectForKey:@"dial_code"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview];
    [self endEditing:YES];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"country_selected"
     object:[self.searchedArr objectAtIndex:indexPath.row]];
}

#pragma mark - UISearchBar delegates

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        self.searchedArr = self.AllCountryArr;
    }else{
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@ ",searchText];
        self.searchedArr = [self.AllCountryArr filteredArrayUsingPredicate:filter];
    }
    [self.countryTable reloadData];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap{
    [self removeFromSuperview];
    [self endEditing:YES];
}
@end
