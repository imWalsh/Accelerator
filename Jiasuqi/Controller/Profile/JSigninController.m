#import "JSigninController.h"
#import <SafariServices/SafariServices.h>

@interface JSigninController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@end

@implementation JSigninController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
	
}

- (void)_loadUI {
	[super _loadUI];
	self.navigationItem.title = @"登录";
	NSString *text = @"登录即表示接受《隐私政策》";
	NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
	[attri addAttribute:NSLinkAttributeName value:@"privacy://" range:[text rangeOfString:@"《隐私政策》"]];
	[attri addAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(0, text.length)];
	self.txtView.linkTextAttributes = @{NSForegroundColorAttributeName: kTintColor};
	self.txtView.attributedText = attri;
	self.txtView.delegate = self;
}

- (IBAction)code_clicked:(id)sender {
	if (self.phone.text.length == 0) {
		[self.view makeToast:@"手机号码不能为空" duration:3 position:CSToastPositionTop];
		return;
	}
	[self.view endEditing:YES];
	NSString *phone = self.phone.text;
#pragma mark 验证码接口
	
}
- (IBAction)signin_clicked:(id)sender {
	if (self.phone.text.length == 0) {
		[self.view makeToast:@"手机号码不能为空" duration:3 position:CSToastPositionTop];
		return;
	}
	if (self.code.text.length == 0) {
		[self.view makeToast:@"验证码不能为空" duration:3 position:CSToastPositionTop];
		return;
	}
	[self.view endEditing:YES];
	NSString *phone = self.phone.text;
	NSString *code = self.code.text;
#pragma mark 登录接口
	
}
#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
	if ([URL.scheme containsString:@"privacy"]) {
		SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APIURL, @"privacy.html"]]];
		[self presentViewController:safari animated:YES completion:nil];
		return NO;
	}
	return YES;
}
@end
