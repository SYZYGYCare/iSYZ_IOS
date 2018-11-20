//
//  ChatViewController.h
//  dinG
//
//  Created by iPhones on 8/14/15.
//  Copyright (c) 2015 ps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dinGInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>
@class ChatViewController;

@protocol ChatViewControllerdelegates <NSObject>
@optional
-(void)getBackToMessageTab;
-(void)goToOthersProfilewithInfo:(dinGInfo*)other;
@end
@interface ChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property (weak, nonatomic) IBOutlet UITableView *ChatTable;
@property (weak, nonatomic) IBOutlet UITextField *TFChat;
@property (nonatomic ,strong) dinGInfo *ReciverInfo;
@property (nonatomic ,assign) BOOL isfromConn;

@property (weak, nonatomic) IBOutlet UIImageView *ChatImage;
@property (weak, nonatomic) IBOutlet UITextView *TvChat;

@property (weak, nonatomic) IBOutlet UIImageView *tvBackimage;
@property (weak, nonatomic) IBOutlet UIImageView *backbarImageVi;
@property (weak, nonatomic) IBOutlet UILabel *labMsg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollBottomConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LoginHeightConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TextViewHeightConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableViewBottomConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BarimageHieght;

@property (weak, nonatomic) IBOutlet UIView *ChatView;
@property (weak, nonatomic) IBOutlet UIImageView *CircleImage;

@property (weak, nonatomic) IBOutlet UILabel *onlineStatusLab;
@property (weak, nonatomic) IBOutlet UIButton *EmojisBtn;
@property (weak, nonatomic) IBOutlet UIButton *SendLocationBtn;
@property (strong, nonatomic) IBOutlet UIView *ShowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageInFullSize;
@property (weak, nonatomic) IBOutlet UIButton *SaveBtn;
@property (weak, nonatomic) IBOutlet UITableView *SaveImageTab;
@property (weak, nonatomic) IBOutlet UIView *SaveImageView;
@property (nonatomic,assign) BOOL isFromNot;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (strong, nonatomic) NSDictionary *requestDic;

@property (nonatomic,strong)id<ChatViewControllerdelegates>delegates;
- (IBAction)ActionOnEmojis:(id)sender;
- (IBAction)ActiononAttachment:(id)sender;
- (IBAction)ActionOnSend:(id)sender;
- (IBAction)ActionOnBack:(id)sender;
- (IBAction)ActionOnSendLocation:(id)sender;
- (IBAction)ActionOnSave:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SendBtnout;
- (IBAction)ActionOnbutton:(id)sender;

-(void)setupViews;
@end
