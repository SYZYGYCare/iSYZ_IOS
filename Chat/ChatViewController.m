//
//  ChatViewController.m
//  dinG
//
//  Created by iPhones on 8/14/15.
//  Copyright (c) 2015 ps. All rights reserved.
//

#import "ChatViewController.h"
#import "Constant.h"
#import "SMMessageViewTableCell.h"


#import "UIImageView+WebCache.h"

#import <MessageUI/MessageUI.h>

#import <CoreText/CoreText.h>
#import "NSString+HTML.h"
#import "ChatTableViewCell.h"
#import "ChatTableViewCellXIB.h"
#import "ChatCellSettings.h"
#import "MBProgressHUD.h"
#import "ClientNotificationUIView.h"
#import "UserRunningServices.h"
#import "SYUserDefault.h"

@interface ChatViewController ()<UITextFieldDelegate,MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,SMMessageViewTableCellDelegate>
{
    NSMutableArray *messagesArr;
    NSMutableArray *allArr;
    NSDictionary *userDic;
    NSArray *weekArr;
    NSMutableString *emojisText;
    NSMutableArray *ArrayOfCells;
    CGFloat tableCurrentH;
    CGFloat originalLoginImageHight;
    CGFloat originalTextViewHeight;
    CGFloat originalContentHight;
    CGFloat originalContentBottom;
    CGFloat originalbarHeight;
    CGRect TextInputAreaFrame;
    CGRect TextInputFrame;
    CGRect BarImageFrame;
    CGRect loginImageFrame;
    CGRect OriginalTextInputAreaFrame;
    CGRect OriginalTextInputFrame;
    CGRect OriginalBarImageFrame;
    CGRect OriginalloginImageFrame;
    UIButton *sendBtn;
    NSMutableDictionary *WebViewHight;
    BOOL isEditing;
    BOOL isEmojis;
    //BOOL isSendNotification;
    dinGInfo *ShowDing;
    ChatCellSettings *chatCellSettings;
    NSString *manager_id;
    NSString *empid;
    NSString *account_type;
    NSString *isSendNotification;
}

@property (strong,nonatomic) ChatTableViewCellXIB *chatCell;
@end

@implementation ChatViewController

@synthesize chatCell;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Done Button Clicked.");
    [self.TvChat resignFirstResponder];

    [self setupInitialViews];

   
    [self.view endEditing:YES];
}

-(void)setupInitialViews{
    self.ChatView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.ChatView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.ChatView.frame.size.height);
    self.tvBackimage.frame = CGRectMake(45, self.tvBackimage.frame.origin.y, sendBtn.frame.origin.x-self.tvBackimage.frame.origin.x, self.tvBackimage.frame.size.height);
    self.TvChat.frame = CGRectMake(self.TvChat.frame.origin.x, self.TvChat.frame.origin.y, self.tvBackimage.frame.size.width-50, self.TvChat.frame.size.height);
    self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(self.ChatTable.frame.origin.y+self.ChatView.frame.size.height));
    
    if ([self.TvChat.text isEqualToString:@""]) {
        self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH);
        self.ChatView.frame =TextInputAreaFrame;
        //  self.backbarImageVi.frame = BarImageFrame;
        self.tvBackimage.frame = loginImageFrame;
        self.TvChat.frame = TextInputFrame;
        
    }else{
        self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH);
        self.ChatView.frame =TextInputAreaFrame;
        //self.backbarImageVi.frame = BarImageFrame;
        self.tvBackimage.frame = loginImageFrame;
        self.TvChat.frame = TextInputFrame;
        self.labMsg.hidden=YES;
        
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"onchat"];
// [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateStatus) object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ChatTable.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];

   //  [AppDelegate sharedInstance].IsOnHome = NO;
     chatCellSettings = [ChatCellSettings getInstance];
    [chatCellSettings setSenderBubbleColorHex:@"FDC8A5"];
    [chatCellSettings setReceiverBubbleColorHex:@"EE5C1A"];
    [chatCellSettings setSenderBubbleNameTextColorHex:@"EE5C1A"];
    [chatCellSettings setReceiverBubbleNameTextColorHex:@"FFFFFF"];
    [chatCellSettings setSenderBubbleMessageTextColorHex:@"EE5C1A"];
    [chatCellSettings setReceiverBubbleMessageTextColorHex:@"FFFFFF"];
    [chatCellSettings setSenderBubbleTimeTextColorHex:@"EE5C1A"];
    [chatCellSettings setReceiverBubbleTimeTextColorHex:@"FFFFFF"];
    [chatCellSettings setSenderBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setSenderBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setReceiverBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setSenderBubbleFontWithSizeForTime:[UIFont systemFontOfSize:10]];
    [chatCellSettings setReceiverBubbleFontWithSizeForTime:[UIFont systemFontOfSize:10]];
    
    [chatCellSettings senderBubbleTailRequired:YES];
    [chatCellSettings receiverBubbleTailRequired:YES];
    
    UINib *nib = [UINib nibWithNibName:@"ChatSendCell" bundle:nil];
    
    [[self ChatTable] registerNib:nib forCellReuseIdentifier:@"chatSend"];
    
    nib = [UINib nibWithNibName:@"ChatReceiveCell" bundle:nil];
    
    [[self ChatTable] registerNib:nib forCellReuseIdentifier:@"chatReceive"];
    self.ChatImage.userInteractionEnabled=YES;
    self.ChatImage.layer.cornerRadius=self.ChatImage.frame.size.height/2;
    
    self.ChatImage.layer.masksToBounds=YES;
    self.CircleImage.layer.cornerRadius=self.CircleImage.frame.size.height/2;
    self.CircleImage.layer.masksToBounds=YES;
    weekArr=[self daysInWeek:0 fromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"onchat"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChathistoryServiceCall) name:@"chatCome" object:nil];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self ChathistoryServiceCall];
   // CGRect screenRect = [[UIScreen mainScreen] bounds];
  //  CGFloat screenWidth = screenRect.size.width;
   // CGFloat screenHeight = screenRect.size.height;
    _SendBtnout.layer.cornerRadius = 25;
    
   /* self.ChatView.frame = CGRectMake(0, screenHeight-60, screenWidth, 60);
    self.ChatTable.frame = CGRectMake(0, 60, screenWidth, screenHeight-130);

    tableCurrentH = screenHeight-130;
    TextInputAreaFrame = self.ChatView.frame;
    TextInputFrame = self.TvChat.frame;
    loginImageFrame = self.tvBackimage.frame;*/
    
   // sendBtn = (UIButton*)[self.view viewWithTag:612];
    self.ChatView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.ChatView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.ChatView.frame.size.height);
    self.tvBackimage.frame = CGRectMake(8, self.tvBackimage.frame.origin.y, _SendBtnout.frame.origin.x-(self.tvBackimage.frame.origin.x+10), self.tvBackimage.frame.size.height);
    self.TvChat.frame = CGRectMake(self.TvChat.frame.origin.x, self.TvChat.frame.origin.y, self.tvBackimage.frame.size.width-50, self.TvChat.frame.size.height);
    
    tableCurrentH = [UIScreen mainScreen].bounds.size.height - (self.ChatTable.frame.origin.y+self.ChatView.frame.size.height);
    self.ChatTable.frame = CGRectMake(0, self.ChatTable.frame.origin.y, [UIScreen mainScreen].bounds.size.width, tableCurrentH);

    TextInputAreaFrame = self.ChatView.frame;
    TextInputFrame = self.TvChat.frame;
    BarImageFrame = self.backbarImageVi.frame;
    loginImageFrame = self.tvBackimage.frame;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
//    dispatch_async(queue, ^{
//        // Perform async operation
//        // Call your method/function here
//        // Example:
//        // NSString *result = [anObject calculateSomething];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSTimer *TimeOfActiveUser;
//            TimeOfActiveUser = [NSTimer scheduledTimerWithTimeInterval:3.0  target:self selector:@selector(ChathistoryServiceCall) userInfo:nil repeats:YES];
//        });
//    });
}
- (IBAction)ActionOnbutton:(id)sender {
    
}

-(void)setupViews{
    UIColor *color = [UIColor lightGrayColor];
    [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"IsnotifictionAlert"];
    _labMsg.text = NSLocalizedString(@"Type message",nil);
    [self.SendBtnout setTitle:NSLocalizedString(@"Send",nil) forState:UIControlStateNormal];
    
    WebViewHight = [[NSMutableDictionary alloc]init];
    
    isEditing = NO;
    originalContentBottom = self.ScrollBottomConstant.constant;
    originalContentHight = self.ScrollHeightConstant.constant;
    originalLoginImageHight = self.LoginHeightConstant.constant;
    originalTextViewHeight = self.TextViewHeightConstant.constant;
    originalbarHeight = self.BarimageHieght.constant;
    sendBtn = (UIButton*)[self.view viewWithTag:612];
    
    sendBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, sendBtn.frame.origin.y, 70, 37);
    self.ChatView.frame = CGRectMake(0, self.view.frame.size.height-57, self.view.frame.size.width, self.ChatView.frame.size.height);
    self.tvBackimage.frame = CGRectMake(10, self.tvBackimage.frame.origin.y, self.view.frame.size.width-100, self.tvBackimage.frame.size.height);
    self.TvChat.frame = CGRectMake(10, self.TvChat.frame.origin.y, self.tvBackimage.frame.size.width, self.TvChat.frame.size.height);
    
    tableCurrentH = self.view.frame.size.height - (self.ChatTable.frame.origin.y+self.ChatView.frame.size.height);
    TextInputAreaFrame = self.ChatView.frame;
    TextInputFrame = self.TvChat.frame;
    BarImageFrame = self.backbarImageVi.frame;
    loginImageFrame = self.tvBackimage.frame;
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"IsOnChat"];
    
    ArrayOfCells=[[NSMutableArray alloc]init];
    emojisText=[[NSMutableString alloc]init];
    messagesArr=[[NSMutableArray alloc]init];
    
    isSendNotification= @"YES";
    
    self.TitleLab.text=self.ReciverInfo.full_name;
    if (self.ReciverInfo.online_status == 0) {
        self.onlineStatusLab.text = @"Online";
    }else{
        self.onlineStatusLab.text = @"Offline";
    }
    //    self.emojiKeyboardView = [[EmojiKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)] ;
    //    self.emojiKeyboardView.delegate = self;
    //    self.emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
    [ViewForDoneButtonOnKeyboard sizeToFit];
    UIBarButtonItem *btnDoneOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStyleBordered target:self
                                                                         action:@selector(doneBtnFromKeyboardClicked:)];
    [ViewForDoneButtonOnKeyboard setItems:[NSArray arrayWithObjects:btnDoneOnKeyboard, nil]];
    
  //  self.TvChat.inputAccessoryView = ViewForDoneButtonOnKeyboard;
   
    self.ChatView.layer.masksToBounds = NO;
    self.ChatView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ChatView.layer.shadowOffset = CGSizeMake(0.0f, -0.5f);
    self.ChatView.layer.shadowOpacity = 0.5f;
    self.TvChat.autocorrectionType = UITextAutocorrectionTypeNo;
    //selectChatcustomer
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"selectChat"]isEqualToString:@"Yes"]) {
        
        userDic=[[NSUserDefaults standardUserDefaults]objectForKey:@"Chatuserdata"];
        empid=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"login_id"]];
        NSDictionary* userDicnew=[[NSUserDefaults standardUserDefaults]objectForKey:@"userdata"];
        manager_id=[NSString stringWithFormat:@"%@",[userDicnew objectForKey:@"admin_id"]];
        account_type =[NSString stringWithFormat:@"%@",[userDic objectForKey:@"account_type"]];
        [self ChathistoryServiceCall];
        
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"manager_customerchat"]isEqualToString:@"Yes"]) {
        
        userDic=[[NSUserDefaults standardUserDefaults]objectForKey:@"userdata"];
        empid = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"Userid"];
        
        manager_id=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"admin_id"]];
        account_type =[NSString stringWithFormat:@"%@",[userDic objectForKey:@"account_type"]];
        [self ChathistoryServiceCall];
        
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"selectChatcustomer"]isEqualToString:@"Yes"]) {
        
        userDic=[[NSUserDefaults standardUserDefaults]objectForKey:@"Chatuserdata"];
        
        empid = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"login_id"]];;
        
        manager_id=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"manager_id"]];
        account_type =[NSString stringWithFormat:@"%@",[userDic objectForKey:@"account_type"]];
        [self ChathistoryServiceCall];
        
    }else{
        userDic=[[NSUserDefaults standardUserDefaults]objectForKey:@"userdata"];
        empid=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"admin_id"]];
        
        manager_id=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"manager_id"]];
        //manager_id= @"1";
        account_type =[NSString stringWithFormat:@"%@",[userDic objectForKey:@"account_type"]];
        [self ChathistoryServiceCall];
     }
}

- (IBAction)doneBtnFromKeyboardClicked:(id)sender
{
    NSLog(@"Done Button Clicked.");
    [self.TvChat resignFirstResponder];
   
    self.ChatView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.ChatView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.ChatView.frame.size.height);
    self.tvBackimage.frame = CGRectMake(45, self.tvBackimage.frame.origin.y, sendBtn.frame.origin.x-self.tvBackimage.frame.origin.x, self.tvBackimage.frame.size.height);
    self.TvChat.frame = CGRectMake(self.TvChat.frame.origin.x, self.TvChat.frame.origin.y, self.tvBackimage.frame.size.width-50, self.TvChat.frame.size.height);
    self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(self.ChatTable.frame.origin.y+self.ChatView.frame.size.height));
    if ([self.TvChat.text isEqualToString:@""]) {
        self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH);
        self.ChatView.frame =TextInputAreaFrame;
        self.backbarImageVi.frame = BarImageFrame;
        self.tvBackimage.frame = loginImageFrame;
        self.TvChat.frame = TextInputFrame;
        
    }else{
        self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH);
        self.ChatView.frame =TextInputAreaFrame;
        self.backbarImageVi.frame = BarImageFrame;
        self.tvBackimage.frame = loginImageFrame;
        self.TvChat.frame = TextInputFrame;
        self.labMsg.hidden=YES;
    
    }

    //Hide Keyboard by endEditing or Anything you want.
    // [self.view endEditing:YES];
}

- (void)SendmessageCall
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        [parameter setObject:[_requestDic objectForKey:@"caregiver_id"] forKey:@"receiver"];
    }else{
        [parameter setObject:[_requestDic objectForKey:@"client_id"] forKey:@"receiver"];
    }
    [parameter setObject:self.TvChat.text forKey:@"msg"];
  
    [parameter setObject:[[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"token_user_type"];
    [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"sendChat"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        [self ChathistoryServiceCall];
                    
                });
            }
        });
    });
}
- (void)ChathistoryServiceCall {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            [parameter setObject:[_requestDic objectForKey:@"caregiver_id"] forKey:@"receiver"];
        }else{
            [parameter setObject:[_requestDic objectForKey:@"client_id"] forKey:@"receiver"];
        }
        [parameter setObject:[[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"token_user_type"];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"getChat"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *chatHistory = [responceDict objectForKey:@"data"];
                    messagesArr = [chatHistory mutableCopy];
                    
                    
                    
                   /* for (NSDictionary *msgDic in chatHistory) {
                        
                        dinGInfo *msginfo=[[dinGInfo alloc]init];
                        msginfo.message_id=[[msgDic objectForKey:@"id"]integerValue];
                        msginfo.sender_id=[[msgDic objectForKey:@"idUser"]integerValue];
                        msginfo.receiver_id=[[msgDic objectForKey:@"idOther"]integerValue];
                        msginfo.message_type=[[msgDic objectForKey:@"status"]integerValue];
                        msginfo.created=[msgDic objectForKey:@"time"];
                        NSString *mmmm= [msgDic objectForKey:@"content"];
                        // NSLog(@"mmm : %@",mmmm);
                        msginfo.message_text=[self stringByStrippingHTML:mmmm];
                        NSString *jsonString = [msginfo.message_text stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
                        
                        //  NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
                        //  NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
                        msginfo.message_text=jsonString;
                        msginfo.message_status=0;
                        msginfo.other_id=[msgDic objectForKey:@"idOther"];
                        msginfo.is_deleted=0;
                        msginfo.user_id=[msgDic objectForKey:@"idUser"];
                        [messagesArr addObject:msginfo];
                        
                        
                    }*/
                    [self.ChatTable reloadData];
                    self.SendBtnout.userInteractionEnabled = YES;
                    CGFloat height = self.ChatTable.contentSize.height - self.ChatTable.bounds.size.height;
                    [self.ChatTable setContentOffset:CGPointMake(0, height) animated:YES];
                    
                    
                });
            }
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Go to friend Profile

-(void)GoToConnectionProfile:(id)sender
{
   // [self performSegueWithIdentifier:@"ConnProfile" sender:self];
//    if (self.isFromNot==YES) {
//        
//        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        OthersProfileViewController* PeopleDetailView =[main instantiateViewControllerWithIdentifier:@"OthersProfileViewController" ];
//        PeopleDetailView.delegate=self;
//        PeopleDetailView.IsPeopleDetail=NO;
//        PeopleDetailView.isFromConnections=NO;
//        PeopleDetailView.IsFromMessages = NO;
//        PeopleDetailView.PeopleInfo=self.ReciverInfo;
//     //   [self.delegates goToOthersProfilewithInfo:self.ReciverInfo];
//    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.delegates goToOthersProfilewithInfo:self.ReciverInfo];
    //}
   
    
}


-(NSArray*)daysInWeek:(int)weekOffset fromDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //ask for current week
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps=[calendar components:NSWeekCalendarUnit|NSYearCalendarUnit fromDate:date];
    //create date on week start
    NSDate* weekstart=[calendar dateFromComponents:comps];
    //  if (weekOffset>0) {
    NSDateComponents* moveWeeks=[[NSDateComponents alloc] init];
    moveWeeks.week=weekOffset;
    weekstart=[calendar dateByAddingComponents:moveWeeks toDate:weekstart options:0];
    // }
    
    //add 7 days
    NSDateFormatter *dateFormate=[[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    for (int i=1; i<=7; i++) {
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [calendar dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        NSString *d=[dateFormate stringFromDate:nextDate];
        [week addObject:d];
        
    }
    return [NSArray arrayWithArray:week];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
   
}

#pragma mark - table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return messagesArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *CellIdentifier = @"ChatCell";
        SMMessageViewTableCell *cell = (SMMessageViewTableCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell==nil) {
            cell = [[SMMessageViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
       NSString *pmamDateString;
       // NSArray *mArr=[[messagesArr objectAtIndex:indexPath.section]objectForKey:@"Messages"];
    NSDictionary *ChatDic = [messagesArr objectAtIndex:indexPath.row];
       // dinGInfo *dingChat=[messagesArr objectAtIndex:indexPath.row];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[ChatDic objectForKey:@"created_date"] doubleValue]];
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm a dd MMMM yyyy";
        pmamDateString = [dateFormatter stringFromDate:date];
            const char *jsonString = [[ChatDic objectForKey:@"msg"] UTF8String];
            NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
            NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
            if ([goodMsg rangeOfString:@"\n"].location != NSNotFound ) {
                goodMsg = [goodMsg stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            }
           // goodMsg = dingChat.message_text;
            NSString *message;
            message = [ChatDic objectForKey:@"msg"];
            CGSize size;
            CGSize  textSize = { 200, 500.0 };
            size = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15.0f]
                       constrainedToSize:textSize
                           lineBreakMode:NSLineBreakByWordWrapping];
            if (size.width<39) {
                size = CGSizeMake(size.width+30, size.height);
            }
    
    int senderType = [[ChatDic objectForKey:@"sender_type"] intValue];
    int userType = [[[SYUserDefault sharedManager] getUserAuthorityId] intValue];
            if (senderType == userType) {
                chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
                chatCell.chatMessageLabel.text = message;
                chatCell.chatTimeLabel.text = @"";

                return chatCell;

            }else{
                
                chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
                
                chatCell.chatMessageLabel.text = message;
                chatCell.chatTimeLabel.text = @"";
//                chatCell.chatUserImage.image = [UIImage imageNamed:@"Avtar.png"];
//                chatCell.chatUserImage.layer.cornerRadius = chatCell.chatUserImage.frame.size.height/2;
                

                return chatCell;
                
            }
    
    
        return cell;

}

#pragma mark - table view delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.SaveImageTab) {
        self.SaveImageView.hidden = YES;
        self.SaveBtn.selected = NO;
//        NSData *imgData = [[Database getSharedInstance]LoadImagesFromSql:[NSString stringWithFormat:@"%ld",ShowDing.message_id]];
//        __block UIImage *messageImage;
//        if (imgData) {
//            messageImage = [UIImage imageWithData:imgData];
//            
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            
//            [library writeImageToSavedPhotosAlbum:[messageImage CGImage] orientation:(ALAssetOrientation)[messageImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
//                if (error) {
//                    // TODO: error handling
//                } else {
//                    // TODO: success handling
//                    UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Photo Saved" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                    [Alert show];
//                }
//            }];
//        }else{
//            
//            
//            dispatch_async(dispatch_get_global_queue(0,0), ^{
//                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: ShowDing.message_text]];
//                if ( data != nil )
//                    [[Database getSharedInstance]SaveImagesToSql:data withImageUrl:[NSString stringWithFormat:@"%li", ShowDing.message_id]];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //                            // WARNING: is the cell still using the same data by this point??
//                    messageImage = [UIImage imageWithData: data];
//                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//                    
//                    [library writeImageToSavedPhotosAlbum:[messageImage CGImage] orientation:(ALAssetOrientation)[messageImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
//                        if (error) {
//                            // TODO: error handling
//                        } else {
//                            // TODO: success handling
//                            UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Photo Saved" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                            [Alert show];
//                        }
//                    }];
//                });
//                
//            });
//        }
    }else{
        [self.TvChat resignFirstResponder];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (tableView==self.SaveImageTab) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.ChatTable) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            NSMutableArray *oldArr=[[NSMutableArray alloc]initWithArray:[[messagesArr objectAtIndex:indexPath.section]objectForKey:@"Messages"]];
            dinGInfo *dingur=[oldArr objectAtIndex:indexPath.row];
            //BOOL dele=[[Database getSharedInstance]deleteMessageWhereId:dingur];
            BOOL isChanged=NO;
            [oldArr removeObjectAtIndex:indexPath.row];
            
            NSDictionary *newDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[messagesArr objectAtIndex:indexPath.section]objectForKey:@"Date"],@"Date",oldArr,@"Messages", nil];
            [messagesArr replaceObjectAtIndex:indexPath.section withObject:newDict];
            
            // [messagesArr removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
//    content = " bjjjjn";
//    id = 2281;
//    idOther = 1;
//    idUser = 604;
//    ip = "49.202.32.201";
//    name = "\U05e9\U05de\U05e2\U05d5\U05df";
//    status = notseen;
//    time = 1486292635;
    
 
    NSDictionary *ChatDic = [messagesArr objectAtIndex:indexPath.row];

   // dinGInfo *dingChat=[messagesArr objectAtIndex:indexPath.row];
        NSString *pmamDateString;
      //  ;
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:[ChatDic objectForKey:@"created_date"]];
        dateFormatter.dateFormat = @"HH:mm a dd MMMM yyyy";
        pmamDateString = [dateFormatter stringFromDate:date];
            CGSize size;
            CGSize Namesize;
            CGSize Timesize;
            CGSize Messagesize;
            NSArray *fontArray = [[NSArray alloc] init];
            const char *jsonString = [[ChatDic objectForKey:@"msg"] UTF8String];
            NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
            NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
            if ([goodMsg rangeOfString:@"\n"].location != NSNotFound ) {
                goodMsg = [goodMsg stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            }
    if ([NSNumber numberWithInt:[[ChatDic objectForKey:@"sender_type"] intValue]] == [[SYUserDefault sharedManager] getUserAuthorityId]) {
        fontArray = chatCellSettings.getSenderBubbleFontWithSize;

    }else{
        fontArray = chatCellSettings.getReceiverBubbleFontWithSize;

    }
    
            Messagesize = [[ChatDic objectForKey:@"msg"] boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:fontArray[1]}
                                                            context:nil].size;
            
            
            Timesize = [pmamDateString boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:fontArray[2]}
                                             context:nil].size;
            
            
            size.height = Messagesize.height  + 48.0f;
            return size.height;
    
}

/*-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.ChatTable) {
        BOOL isCurrentWeekD=NO;
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        // headerView.backgroundColor=[UIColor colorWithRed:229/255.f green:230/255.f blue:231/255.f alpha:1];
        headerView.backgroundColor=[UIColor whiteColor];
        UIView *headerImge=[[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 5, 200, 30)];
        headerImge.layer.cornerRadius = 10;
        headerImge.backgroundColor=[UIColor colorWithRed:253/255.f green:200/255.f blue:165/255.f alpha:1];
        //headerImge.image = [UIImage imageNamed:@"datebg.png"];
        [headerView addSubview:headerImge];
        UILabel *headerLab=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 5, 200, 30)];
        headerLab.textColor = [UIColor colorWithRed:239/255.f green:69/255.f blue:22/255.f alpha:1];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy:MM:dd"];
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
        [dayFormatter setDateFormat:@"EEEE"];
        NSString *datStr=[[messagesArr objectAtIndex:section]objectForKey:@"Date"];
        if (datStr.length>10) {
            datStr=[datStr stringByReplacingCharactersInRange:NSMakeRange(10, 9) withString:@""];
        }
        
        NSDate *dates=[dateFormatter dateFromString:datStr];
        if (!dates) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dates=[dateFormatter dateFromString:datStr];
        }
        NSString* dayStr=[dayFormatter stringFromDate:dates];
        for (int i=0; i<weekArr.count; i++) {
            if ([datStr isEqualToString:[weekArr objectAtIndex:i]]) {
                isCurrentWeekD=YES;
                break;
            }
        }
        //NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*1];
        NSString *today = [dayFormatter stringFromDate:[NSDate date]];
        NSString *yesterday = [dayFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*1]];
        //mon, sep 21, hh:mm am
        NSString *pmamDateString = [[messagesArr objectAtIndex:section]objectForKey:@"time"];
        
        if ([pmamDateString rangeOfString:@"a.m."].location != NSNotFound ) {
            pmamDateString = [pmamDateString stringByReplacingOccurrencesOfString:@"a.m." withString:@"AM"];
        }else if ([pmamDateString rangeOfString:@"p.m."].location != NSNotFound){
            pmamDateString = [pmamDateString stringByReplacingOccurrencesOfString:@"p.m." withString:@"PM"];
        }

        if (isCurrentWeekD) {
            
            if ([today isEqualToString:dayStr]) {
                headerLab.text=[NSString stringWithFormat:@"Today %@",pmamDateString];
            }else if ([yesterday isEqualToString:dayStr]){
                headerLab.text=[NSString stringWithFormat:@"Yesterday %@",pmamDateString];
            }else{
                [dayFormatter setDateFormat:@"EEE, MMM, dd"];
                headerLab.text=[NSString stringWithFormat:@"%@, %@",[dayFormatter stringFromDate:dates],pmamDateString];
            }
            
        }else{
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            
            headerLab.text=[NSString stringWithFormat:@"%@ %@",datStr,pmamDateString];
        }
        
        NSString *message;
        message=headerLab.text;
        CGSize size;
        CGSize  textSize = { 200, 500.0 };
        size = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0f]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
        
        headerImge.frame =CGRectMake((self.view.frame.size.width-(size.width+20))/2, 5, size.width+20, 30);
        headerLab.textAlignment=NSTextAlignmentCenter;
        headerLab.font=[UIFont systemFontOfSize:14];
        [headerView addSubview:headerLab];
        
        UILabel *Line1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, headerImge.frame.origin.x-10, 1)];
        Line1.backgroundColor = [UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1];
        [headerView addSubview:Line1];
        
        UILabel *Line2 = [[UILabel alloc]initWithFrame:CGRectMake(headerImge.frame.origin.x+headerImge.frame.size.width+5, 20, (self.view.frame.size.width-(headerImge.frame.origin.x+headerImge.frame.size.width)-10) , 1)];
        Line2.backgroundColor = [UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1];
        [headerView addSubview:Line2];
        return headerView;
    }
   
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.SaveImageTab) {
        return 0;
    }
    return 40;
}*/
//- (UIImage *)balloonImageWithRect:(CGRect)rect imageText:(NSString*)text{
//    //create two images, ballon image with cap corners
//    UIImage *ballonImage = [[UIImage imageNamed:@"balloon"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 0, 15, 34) resizingMode:UIImageResizingModeStretch];
//    UIImage *arrowImage = [UIImage imageNamed:@"arrow"];
//    
//    //drawing area
//    CGSize newSize = rect.size;
//    UIGraphicsBeginImageContext(newSize);
//    
//    //leave some space for arrow at the bottom
//    [ballonImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height - arrowImage.size.height)];
//    //draw arrow at the bottom
//    [arrowImage drawInRect:CGRectMake((newSize.width - arrowImage.size.width)/2, newSize.height - arrowImage.size.height, arrowImage.size.width, arrowImage.size.height)];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}
#pragma mark - IBActions
- (IBAction)ActionOnEmojis:(id)sender {
    UIButton *but=(UIButton*)sender;

    if (but.selected==NO) {
        isEmojis = YES;
         [self.EmojisBtn setImage:[UIImage imageNamed:@"ic_keyboard_variant_grey600_48dp.png"] forState:UIControlStateNormal];
        
         // self.TvChat.inputView = self.emojiKeyboardView;
        emojisText=[self.TvChat.text mutableCopy];
          [self.TvChat resignFirstResponder];
         [self.TvChat becomeFirstResponder];
        but.selected=YES;
    }else{
        isEmojis = NO;
       [self.EmojisBtn setImage:[UIImage imageNamed:@"smiley.png"] forState:UIControlStateNormal];
        [self.TvChat resignFirstResponder];
       [self.TvChat setInputAccessoryView:nil];
        [self.TvChat setInputView:UIKeyboardAppearanceDefault];
        [self.TvChat setKeyboardType:UIKeyboardTypeDefault];
        [self.TvChat becomeFirstResponder];
        but.selected=NO;
    }
}

- (IBAction)ActiononAttachment:(id)sender {
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Select Photo", nil];
    action.tag=1;
    [action showInView:self.view];
}

- (IBAction)ActionOnSend:(id)sender {
    if (self.TvChat.text.length==0) {
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:nil message:@"Type a message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Alert show];
    }else{
        [self SendmessageCall];
        self.TvChat.text=@"";
        self.labMsg.hidden=NO;
        [self.view endEditing:YES];
     /*   self.TvChat.text=@"";
        self.labMsg.hidden=NO;
        self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH);
        self.ChatView.frame =TextInputAreaFrame;
        //  self.backbarImageVi.frame = BarImageFrame;
        self.tvBackimage.frame = loginImageFrame;
        self.TvChat.frame = TextInputFrame;*/
        [self setupInitialViews];
        //[self textBecomeActive];
    }
}

- (IBAction)ActionOnBack:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"endChat"
     object:nil];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"onchat"];

}


- (IBAction)ActionOnSave:(id)sender {
    
   
    if (self.SaveBtn.selected == YES) {
        self.SaveBtn.selected = NO;
        self.SaveImageView.hidden = YES;;

    }else{
        self.SaveBtn.selected = YES;
        self.SaveImageView.hidden = NO;
    }
    
    
}

#pragma mark - UITextField Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  //  self.TableHight.constant=tableCurrentH-235;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
 //self.TableHight.constant=tableCurrentH;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITextView Delegates

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isEditing = YES;
   
    if ([textView.text isEqualToString:@""]) {
        self.TvChat.enablesReturnKeyAutomatically = YES;
       
    }else{
        self.TvChat.enablesReturnKeyAutomatically = NO;
    }
    CGFloat height = self.ChatTable.contentSize.height - self.ChatTable.bounds.size.height;
 //   [self.ChatTable setContentOffset:CGPointMake(0, height) animated:YES];
   // self.TableHight.constant=tableCurrentH-216;
    [self performSelector:@selector(textBecomeActive) withObject:nil afterDelay:0.01];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //self.TableHight.constant=tableCurrentH;
    self.ScrollBottomConstant.constant = originalContentBottom;
    self.TableViewBottomConstant.constant = tableCurrentH;
    self.TextViewHeightConstant.constant = originalTextViewHeight;
    self.LoginHeightConstant.constant = originalLoginImageHight;
    self.BarimageHieght.constant = originalbarHeight;
    self.ScrollHeightConstant.constant = originalContentHight;
    //if ([textView.text isEqualToString:@""]) {
    self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH);
    CGRect chatFrame = self.ChatView.frame;
    chatFrame.origin.y = chatFrame.origin.y+216;
    self.ChatView.frame = chatFrame;
//    }else{
//    
//    }
    
   // self.backbarImageVi.frame = BarImageFrame;
  //  self.tvBackimage.frame = loginImageFrame;
  //  self.TvChat.frame = TextInputFrame;
}
- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    isEditing = NO;
   // [self performSelector:@selector(resizeTextInputArea) withObject:nil afterDelay:0.01];
    return YES;
}
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   // [self performSelector:@selector(resizeTextInputArea) withObject:nil afterDelay:0.01];
    NSMutableString *newString=[[NSMutableString alloc]initWithString:textView.text];
    if ([text isEqualToString: @""])
    {
        
        if (newString.length==0) {
            
        }else{
            
            NSRange ran=NSMakeRange(0, newString.length-1);
            //
            NSString *str=[newString stringByReplacingCharactersInRange:ran withString:@""];
            
            NSRange NewRan=[newString rangeOfString:str];
            
            newString=[newString stringByReplacingCharactersInRange:NewRan withString:@""];
        }
    }else{
        [newString appendString:text];
    }
    
    if ([newString isEqualToString:@""]) {
        self.labMsg.hidden=NO;
    }else{
        self.labMsg.hidden=YES;
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    CGRect inputAreaFrame = self.ChatView.frame;
    CGRect inputFrame = self.tvBackimage.frame;
    if (newSize.height>80) {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), 80);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, 110);
        inputAreaFrame.origin.y = inputAreaFrame.origin.y - (110 - self.ChatView.frame.size.height);
        inputFrame.size = CGSizeMake(inputFrame.size.width, 90);
    }else if (newSize.height==33){
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height-10);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, newSize.height+20);
        
        inputFrame.size = CGSizeMake(inputFrame.size.width, newSize.height+8);
    }
    else{
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height-10);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, newSize.height);
        inputAreaFrame.origin.y = inputAreaFrame.origin.y - (newSize.height - self.ChatView.frame.size.height);
        inputFrame.size = CGSizeMake(inputFrame.size.width, newSize.height);
    }
    textView.frame = newFrame;
    self.ChatView.frame = inputAreaFrame;
    self.tvBackimage.frame = inputFrame;
    self.ChatTable.frame = CGRectMake(0, self.ChatTable.frame.origin.y, [UIScreen mainScreen].bounds.size.width, tableCurrentH-(inputAreaFrame.size.height+170));
    CGFloat height = self.ChatTable.contentSize.height - self.ChatTable.bounds.size.height;
    [self.ChatTable setContentOffset:CGPointMake(0, height) animated:YES];
}
#pragma mark - OtherProfileDelegate methods

-(void)ConnectionRequestSend
{
    //[self.PeopleView GetPeopleByDistanceWs];
}

-(void)OthersMail
{
    if ([MFMailComposeViewController canSendMail]) {
        [self displayMailComposerSheet];
    }else{
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:nil message:@"You need to configure your mail composer before send you send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Alert show];
    }
}

-(void)ConnectionRemoved
{
   // [self.ConnectionView FetchConnectionList];
}
#pragma mark - Compose Mail/SMS

- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"dinG Ios App"];
    NSString *emailBody;
    
    // NSArray *toRecipients;
    emailBody=@"";
    //        toRecipients = [NSArray arrayWithObjects:@"",
    //                        nil];
    //        [picker setToRecipients:toRecipients];
    
    [picker setMessageBody:emailBody isHTML:NO];
    if (picker) {
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - Mail Composer Delegate Method


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultSent:
            
            
            break;
        case MFMailComposeResultFailed:
            
            break;
        default:
            
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Emojis delegate

/*- (void)emojiKeyBoardView:(EmojiKeyBoardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
   // self.TFChat.text=emoji;
   // NSLog(@"Controller: %@ pressed", emoji);
    [self appendStringInChat:emoji];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(EmojiKeyBoardView *)emojiKeyBoardView {
   // NSLog(@"Controller: Back pressed");
    if ([emojisText length] > 0) {
        
        if ([self stringContainsEmoji:emojisText]) {
            emojisText = [[emojisText substringToIndex:[emojisText length] - 2] mutableCopy];
        }else
        emojisText = [[emojisText substringToIndex:[emojisText length] - 1] mutableCopy];
    }
    
    CGFloat fixedWidth = self.TvChat.frame.size.width;
    CGSize newSize = [self.TvChat sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.TvChat.frame;
    CGRect inputAreaFrame = self.ChatView.frame;
    CGRect inputFrame = self.tvBackimage.frame;
    if (newSize.height>80) {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), 85);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, 115);
        inputAreaFrame.origin.y = inputAreaFrame.origin.y - (115 - self.ChatView.frame.size.height);
        inputFrame.size = CGSizeMake(inputFrame.size.width, 95);
    }else if (newSize.height==33){
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height-10);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, newSize.height+20);
       
        inputFrame.size = CGSizeMake(inputFrame.size.width, newSize.height+8);
        
       
    
    }
    else{
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height-5);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, newSize.height+20);
        inputAreaFrame.origin.y = inputAreaFrame.origin.y - (newSize.height+20 - self.ChatView.frame.size.height);
        inputFrame.size = CGSizeMake(inputFrame.size.width, newSize.height);
    }
    self.TvChat.frame = newFrame;
    self.ChatView.frame = inputAreaFrame;
    self.tvBackimage.frame = inputFrame;
    if (newSize.height == 33) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
            // code here
            self.ScrollBottomConstant.constant=originalContentBottom+216;
            self.TableViewBottomConstant.constant = tableCurrentH-216;
            self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
            self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
        }else{
            self.ScrollBottomConstant.constant=originalContentBottom+250;
            self.TableViewBottomConstant.constant = tableCurrentH-250;
           
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
            
            
        }
    }
    if ([emojisText isEqualToString:@""]) {
        self.labMsg.hidden=NO;
    }else{
        self.labMsg.hidden=YES;
    }
     self.TvChat.text=emojisText;
}*/

-(void)appendStringInChat:(NSString*)emojis
{
    [emojisText appendString:emojis];
    self.TvChat.text=emojisText;
    
    CGFloat fixedWidth = self.TvChat.frame.size.width;
    CGSize newSize = [self.TvChat sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.TvChat.frame;
    CGRect inputAreaFrame = self.ChatView.frame;
    CGRect inputFrame = self.tvBackimage.frame;
    if (newSize.height>80) {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), 85);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, 115);
        inputAreaFrame.origin.y = inputAreaFrame.origin.y - (115 - self.ChatView.frame.size.height);
        inputFrame.size = CGSizeMake(inputFrame.size.width, 95);
    }else if (newSize.height==33){
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height-10);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, newSize.height+20);
        
        inputFrame.size = CGSizeMake(inputFrame.size.width, newSize.height+8);
    }
    else{
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        inputAreaFrame.size = CGSizeMake(inputAreaFrame.size.width, newSize.height+25);
        inputAreaFrame.origin.y = inputAreaFrame.origin.y - (newSize.height+25 - self.ChatView.frame.size.height);
        inputFrame.size = CGSizeMake(inputFrame.size.width, newSize.height);
    }
    self.TvChat.frame = newFrame;
    self.ChatView.frame = inputAreaFrame;
    self.tvBackimage.frame = inputFrame;
    if ([emojis isEqualToString:@""]) {
        self.labMsg.hidden=NO;
    }else{
        self.labMsg.hidden=YES;
    }
}

-(BOOL)containsEmojis:(NSString*)message
{
    for (int i=0; i<message.length; i++) {
        unichar unicodevalue = [message characterAtIndex:i];
        if (unicodevalue == 55357) {
            
            return YES;
            break;
        }
    }
   
    return NO;
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}


#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Take Photo"]) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController*   imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                //  imagePicker.showsCameraControls = NO;
                //        [self addChildViewController:imagePicker];
                //        [self.view addSubview:imagePicker.view];
                [self presentViewController:imagePicker animated:YES completion:nil];
                // [self.navigationController pushViewController:imagePicker animated:YES];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                               message:@"Unable to find a camera on your device."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                alert = nil;
            }
        }else if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Select Photo"]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
    }
}

#pragma mark - ImagePickerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* SelectedImage = info[UIImagePickerControllerEditedImage];
    [self sendImage:SelectedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - send image

-(void)sendImage:(UIImage*)image{
    
}

- (CGFloat)heightStringWithEmojis:(NSString*)str fontType:(UIFont *)uiFont ForWidth:(CGFloat)width {
    
    // Get text
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef) str );
    CFIndex stringLength = CFStringGetLength((CFStringRef) attrString);

    // Change font
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) uiFont.fontName, uiFont.pointSize, NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, stringLength), kCTFontAttributeName, ctFont);
    
    // Calc the size
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), &fitRange);
    
    CFRelease(ctFont);
    CFRelease(framesetter);
    CFRelease(attrString);
    
    return frameSize.height + 10;
    
}

#pragma mark - Resizable method
- (void) resizeTextInputArea
{
    CGSize contentSize = self.TvChat.contentSize;
    CGFloat heightDifference = contentSize.height - TextInputFrame.size.height;
    if(heightDifference > 3)
    {
        CGRect newTextInputAreaFrame = self.ChatView.frame;
        newTextInputAreaFrame.size.height += heightDifference;
        newTextInputAreaFrame.origin.y -= heightDifference;
        self.ChatView.frame = newTextInputAreaFrame;
       
    }else{
        if (isEditing==NO) {
            self.ChatView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.ChatView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.ChatView.frame.size.height);
            self.tvBackimage.frame = CGRectMake(45, self.tvBackimage.frame.origin.y, sendBtn.frame.origin.x-self.tvBackimage.frame.origin.x, self.tvBackimage.frame.size.height);
            self.TvChat.frame = CGRectMake(self.TvChat.frame.origin.x, self.TvChat.frame.origin.y, self.tvBackimage.frame.size.width-50, self.TvChat.frame.size.height);
            self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(self.ChatTable.frame.origin.y+self.ChatView.frame.size.height));
        }else{
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                // code here
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH-216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
            }else{
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH+216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
            }
        }
       
    }
}
-(void)resizeTextView:(NSString*)text
{
    CGSize textContenSize = self.TvChat.contentSize;
    CGFloat heightDifference = textContenSize.height - originalTextViewHeight;
    if (heightDifference>3) {
        if (heightDifference<71) {
            CGFloat newTextInputAreaHight = originalLoginImageHight;
            newTextInputAreaHight += heightDifference;
            //newTextInputAreaFrame.origin.y -= heightDifference;
            
            self.LoginHeightConstant.constant = newTextInputAreaHight;
            CGFloat newTextInputHight = originalLoginImageHight;
            newTextInputHight += heightDifference-15;
            self.TextViewHeightConstant.constant = textContenSize.height;
            
            CGFloat scrollHight = originalLoginImageHight;
            scrollHight += heightDifference-25;
            self.ScrollHeightConstant.constant = scrollHight;
            
            CGFloat barHight = originalbarHeight;
            barHight += heightDifference;
            self.BarimageHieght.constant = barHight;
        }else{
            heightDifference=70;
            CGFloat newTextInputAreaHight = originalLoginImageHight;
            newTextInputAreaHight += heightDifference;
            //newTextInputAreaFrame.origin.y -= heightDifference;
            
            self.LoginHeightConstant.constant = newTextInputAreaHight;
            CGFloat newTextInputHight = originalLoginImageHight;
            newTextInputHight += heightDifference-15;
            self.TextViewHeightConstant.constant = newTextInputHight;
            
            CGFloat scrollHight = originalLoginImageHight;
            scrollHight += heightDifference-25;
            self.ScrollHeightConstant.constant = scrollHight;
            
            CGFloat barHight = originalbarHeight;
            barHight += heightDifference;
            self.BarimageHieght.constant = barHight;
        }
        
    }else{
        self.TextViewHeightConstant.constant = textContenSize.height;
        self.LoginHeightConstant.constant = originalLoginImageHight;
        self.BarimageHieght.constant = originalbarHeight;
        self.ScrollHeightConstant.constant = originalContentHight;
        
    }
}

#pragma mark - change this if have any issue related to chat view frame

-(void)textBecomeActive
{
    if ([self.TvChat.text isEqualToString:@""]) {
        
        if (isEmojis==YES) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                // code here
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH-216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
            }else{
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH-216;
                if (self.TvChat.text.length>0) {
                    self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-226);
                    self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-226, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
                }else{
                    self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                    self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
                   // self.tvBackimage.frame = loginImageFrame;
//                    self.tvBackimage.frame = CGRectMake(45, self.tvBackimage.frame.origin.y, sendBtn.frame.origin.x-self.tvBackimage.frame.origin.x, self.tvBackimage.frame.size.height);

                }
               
            }
        }else{
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                // code here
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH-216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
            }else{
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH+216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, TextInputAreaFrame.size.height);
//                self.tvBackimage.frame = CGRectMake(45, self.tvBackimage.frame.origin.y, sendBtn.frame.origin.x-self.tvBackimage.frame.origin.x, self.tvBackimage.frame.size.height);

            }
        }
        
    }else{
        if (isEmojis) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                // code here
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH-216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, self.ChatView.frame.size.height);
            }else{
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH+216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, self.ChatView.frame.size.height);
            }
        }else{
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                // code here
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH-216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, self.ChatView.frame.size.height);
            }else{
                self.ScrollBottomConstant.constant=originalContentBottom+216;
                self.TableViewBottomConstant.constant = tableCurrentH+216;
                self.ChatTable.frame = CGRectMake(self.ChatTable.frame.origin.x, self.ChatTable.frame.origin.y, self.ChatTable.frame.size.width, tableCurrentH-216);
                self.ChatView.frame = CGRectMake(TextInputAreaFrame.origin.x, TextInputAreaFrame.origin.y-216, TextInputAreaFrame.size.width, self.ChatView.frame.size.height);
            }
        }
        
    }
    CGFloat height = self.ChatTable.contentSize.height - self.ChatTable.bounds.size.height;
    [self.ChatTable setContentOffset:CGPointMake(0, height) animated:YES];
}

-(void)customQuestionCell:(SMMessageViewTableCell *)cell shouldAssignHeight:(CGFloat)newHeight
{
    NSIndexPath *indexPath = [self.ChatTable indexPathForCell:cell];
    [WebViewHight setObject:[NSString stringWithFormat:@"%.f",newHeight] forKey:[NSString stringWithFormat:@"%li",indexPath.row]];
    [self.ChatTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(NSString *) stringByStrippingHTML:(NSString*)message {
    NSRange r;
    NSString *s = [message copy] ;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

-(NSString *) stringByConvertingToHTML:(NSString*)message {
   
    message = [message stringByEncodingHTMLEntities];
    NSString *s = [NSString stringWithFormat:@"<p dir=\"ltr\">%@</p>",message] ;
   // s = [s stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
   // s = [s stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
   //s = [s stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    return s;
}

-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

-(void)ActionOnSaveBtn:(UITapGestureRecognizer*)sender
{
    self.ShowImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.ShowImageView];
    CGPoint buttonPosition = [sender.view convertPoint:CGPointZero toView:self.ChatTable];
    NSIndexPath *indexPath = [self.ChatTable indexPathForRowAtPoint:buttonPosition];
    NSArray *mArr=[[messagesArr objectAtIndex:indexPath.section]objectForKey:@"Messages"];
    ShowDing=[mArr objectAtIndex:indexPath.row];
  
}

-(void)ImageSavedWithError:(NSError*)sender
{

}
@end
