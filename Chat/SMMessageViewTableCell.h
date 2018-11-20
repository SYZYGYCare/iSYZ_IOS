
//

#import <UIKit/UIKit.h>
#import "MyBubbles.h"

@class SMMessageViewTableCell;

@protocol SMMessageViewTableCellDelegate <NSObject>

@optional
- (void)customQuestionCell:(SMMessageViewTableCell *)cell shouldAssignHeight:(CGFloat)newHeight;

@end

@interface SMMessageViewTableCell : UITableViewCell<UIWebViewDelegate> {

	UILabel	*lblTime;
	UITextView *lblMessage;
	UIImageView *bgImageView;
    UIImageView *BubbleImage;
    UIWebView *cellWebView;
 
 }
@property (nonatomic, retain) UILabel *lblTime;
@property (nonatomic, retain) UITextView *lblMessage;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) MyBubbles *BubbleImageView;
@property (nonatomic, retain) UIImageView *BubbleImage;
@property (nonatomic, retain) UIImageView *imgViewProfile;
@property (nonatomic, retain) UIImageView *StatusImage;
@property (nonatomic, retain) UIWebView *cellWebView;

@property (nonatomic, assign) id <SMMessageViewTableCellDelegate>delegate;

- (void)checkHeight;

@end
