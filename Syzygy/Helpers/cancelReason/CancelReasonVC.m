//
//  CancelReasonVC.m
//  Syzygy
//
//  Created by manisha panse on 2/24/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import "CancelReasonVC.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UserRunningServices.h"
#import "Constant.h"
#import "FinishProcessUIView.h"
#import "UIView+Toast.h"

@interface CancelReasonVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSArray *cancelReasonArr;
    NSString *cancelReason;
    NSIndexPath *selectedIndexpath;
}
@end

@implementation CancelReasonVC

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
}

-(void)setupInitialViews{
    _anyReasonTF.layer.cornerRadius = 4;
    _anyReasonTF.layer.borderWidth = 1;
    _anyReasonTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _cancelView.layer.cornerRadius = 4;
    cancelReasonArr = @[@"Caregiver delayed",@"Ambulance Delayed",@"Changed my mind",@"Unable to contact caregiver",@"Unable to contact ambulance",@"Caregiver denied duty",@"Ambulance denied duty"];
    self.viewHieght.constant = self.view.frame.size.height - 160;
    [self.cancelReasonTable reloadData];
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

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cancelReasonArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.tintColor = CAREGIVER_COLOR;
    cell.textLabel.text = [cancelReasonArr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (selectedIndexpath != nil && indexPath == selectedIndexpath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexpath = indexPath;
    cancelReason = [cancelReasonArr objectAtIndex:indexPath.row];
    self.anyReasonTF.enabled = false;
    self.cancelBtn.enabled = YES;
    [tableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * trimmedText;
    trimmedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (trimmedText.length > 0) {
        self.cancelBtn.enabled = YES;
    }else{
        self.cancelBtn.enabled = NO;
    }
    return YES;
}

-(void)cancelRequestAPI{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        if(_requestDic == nil)
        {
            [parameter setObject:@"" forKey:@"reciever_id"];
        }
        else {
            [parameter setObject:[_requestDic objectForKey:@"caregiver_id"] forKey:@"reciever_id"];
            [parameter setObject:[_requestDic objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
        }
        if (cancelReason.length > 0) {
            [parameter setObject:cancelReason forKey:@"cancel_reason"];
        }else{
            [parameter setObject:self.anyReasonTF.text forKey:@"cancel_reason"];
        }
        
        [parameter setObject:@"caregiver" forKey:@"reciever_type"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"cancel_request"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
               // [self removeFromSuperview];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"endCancelRequest2"
                 object:nil];
            }
            
        });
    });
}

- (IBAction)ActionOnDontCancel:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"endCancelRequest"
     object:nil];
}

- (IBAction)ActionOnCancelHire:(id)sender {
    if (cancelReason.length == 0 && self.anyReasonTF.text.length == 0) {
        [self.view makeToast:@"Please give some reason" duration:0.2 position: CSToastPositionBottom];
    }else{
        
        [self cancelRequestAPI];
    }
}



@end
