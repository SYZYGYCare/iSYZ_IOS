

#import "SMMessageViewTableCell.h"
//#import "AsyncImageView.h"


@implementation SMMessageViewTableCell

@synthesize lblTime, lblMessage, bgImageView, imgViewProfile , StatusImage,BubbleImageView,cellWebView,BubbleImage;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:bgImageView];

        BubbleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:BubbleImage];
               
        BubbleImageView = [[MyBubbles alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:BubbleImageView];
        
      
        
     //   cellWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
       // [self.contentView addSubview:cellWebView];
       // cellWebView.delegate = self;
        
        StatusImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:StatusImage];
        
        imgViewProfile=[[UIImageView alloc] init];
        
        [imgViewProfile.layer setMasksToBounds:YES];
        [self.contentView addSubview:imgViewProfile];
        [imgViewProfile setBackgroundColor:[UIColor clearColor]];

		lblMessage = [[UITextView alloc] init];
		lblMessage.backgroundColor = [UIColor clearColor];
		lblMessage.editable = NO;
		lblMessage.scrollEnabled = NO;
        
		[lblMessage sizeToFit];
		[self addSubview:lblMessage];
        
        lblTime = [[UILabel alloc] init];
		lblTime.textColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
        [lblTime setBackgroundColor:[UIColor clearColor]];
        [lblTime setTextAlignment:NSTextAlignmentRight];
		[self addSubview:lblTime];
        
        lblMessage.font = [UIFont boldSystemFontOfSize:14.0];
        [imgViewProfile.layer setCornerRadius:3.0f];
        lblTime.font = [UIFont systemFontOfSize:8.0];
       // self.backgroundColor=[UIColor clearColor];
      //  self.contentView.backgroundColor=[UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       // self.backgroundColor = [UIColor clearColor];
       // self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - UIWebView Delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)];  // Pass about any size
    
    CGRect mWebViewFrame = webView.frame;
    
    
    mWebViewFrame.size.height = mWebViewTextSize.height;
    
    cellWebView.frame=mWebViewFrame;
  //  CommentWebView.frame = mWebViewFrame;
    
    
    for (id subview in webView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            [subview setBounces:NO];
        }
    }
    

}

- (void)checkHeight {
    if([self.delegate respondsToSelector:@selector(customQuestionCell:shouldAssignHeight:)]) {
        [self.delegate customQuestionCell:self shouldAssignHeight:cellWebView.frame.size.height];
    }
}

@end
