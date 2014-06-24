//
//  MainViewController.m
//  fb-detailed-view
//
//  Created by Robert Thompson on 6/22/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "MainViewController.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIView *postCard;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UITextField *commentBox;
@property (weak, nonatomic) IBOutlet UIView *commentBarUIView;
- (IBAction)commentEditingDidBeing:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)PostButtonTouchUp:(id)sender;

- (IBAction)commentTouchDown:(id)sender;
- (IBAction)touchUpLikeButton:(id)sender;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    //formatting post card background
    
    self.postCard.layer.cornerRadius=2.0f;
    self.postCard.layer.shadowOffset=CGSizeMake(0.0f,2.0f);
    self.postCard.layer.shadowRadius = 1;
    self.postCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.postCard.layer.shadowOpacity = 0.4;

    //disable post button
    self.postButton.enabled = NO;
   
    //comment box formatting
    self.commentBox.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.commentBox.layer.borderWidth = 1.0f;
    self.commentBox.layer.cornerRadius=4.0f;

// TTTAttributedLabel stuff
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(100,90,300,100)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    
    NSString *text = @"This is a test of the emergency broadcast http://www.google.com";
    [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"ipsum dolar" options:NSCaseInsensitiveSearch];
        NSRange strikeRange = [[mutableAttributedString string] rangeOfString:@"sit amet" options:NSCaseInsensitiveSearch];
        
        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
            [mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:[NSNumber numberWithBool:YES] range:strikeRange];
            CFRelease(font);
        }
        
        return mutableAttributedString;
    }];
    
    [self.postCard addSubview:label];
    
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    label.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)
    
    label.text = @"http://bit.ly/1jV9zm8"; // Repository URL will be automatically detected and linked
    
    NSRange range = [label.text rangeOfString:@"me"];
    [label addLinkToURL:[NSURL URLWithString:@"http://github.com/mattt/"] withRange:range]; // Embedding a custom link in a substring
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








- (IBAction)commentEditingDidBeing:(id)sender {
    
    //enable post button
    self.postButton.enabled = YES;
}

- (IBAction)PostButtonTouchUp:(id)sender {
    [self.view endEditing:YES];
        
        [UIView animateWithDuration:0.2 animations:^{self.commentBarUIView.frame = CGRectMake(6,471,308,46); }];
    
    
}

- (IBAction)commentTouchDown:(id)sender {
      [UIView animateWithDuration:0.5 animations:^{  self.commentBarUIView.frame = CGRectMake(0,306, 320,self.commentBarUIView.frame.size.height); }];
    
}

- (IBAction)touchUpLikeButton:(id)sender {
    
    [self updateLikeButton];
}

- (void)updateLikeButton {
    
    self.likeButton.selected = !self.likeButton.selected;
    

    
}


- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
}

@end
