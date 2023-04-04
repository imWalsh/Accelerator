#import "JProfileController.h"
#import "JSettingsController.h"
#import "JSigninController.h"
#import "JNavigationController.h"
#import "JAboutController.h"

@interface JProfileController ()
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (weak, nonatomic) IBOutlet UILabel *notinLbl;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;
@property (weak, nonatomic) IBOutlet UIButton *cpyBtn;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *restoreView;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
@end

@implementation JProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)_loadUI {
	[super _loadUI];
	self.navigationItem.title = @"我的账号";
	
	self.navigationController.navigationBar.prefersLargeTitles = YES;
	self.navigationController.navigationItem.largeTitleDisplayMode =  UINavigationItemLargeTitleDisplayModeAutomatic;
	NSString *token = [USER_DEFAULTS stringForKey:KEY_TOKEN];
	NSString *uid = [USER_DEFAULTS stringForKey:KEY_UID];
	if (token.length && uid.length) {
		self.idLbl.text = uid;
		self.cpyBtn.hidden = NO;
		self.notinLbl.hidden = YES;
	}
	[NOTIFICATION_CENTER addObserver:self selector:@selector(sign_changed) name:kJSignChangedNotification object:nil];
	UITapGestureRecognizer *itap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(id_tap)];
	UITapGestureRecognizer *rtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restore_tap)];
	UITapGestureRecognizer *stap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settings_tap)];
	UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(about_tap)];
	[self.accountView addGestureRecognizer:itap];
	[self.restoreView addGestureRecognizer:rtap];
	[self.settingsView addGestureRecognizer:stap];
	[self.aboutView addGestureRecognizer:atap];
}

- (void)_loadData {
	
}

- (void)sign_changed {
	NSString *uid = [USER_DEFAULTS stringForKey:KEY_UID];
	if (!uid.length) {
		self.idLbl.text = @"未登录";
		self.cpyBtn.hidden = YES;
		self.notinLbl.hidden = NO;
	}
	else {
		self.idLbl.text = uid;
		self.cpyBtn.hidden = NO;
		self.notinLbl.hidden = YES;
	}
}

- (IBAction)copy_clicked:(id)sender {
	UIPasteboard *board = [UIPasteboard generalPasteboard];
	[board setString:self.idLbl.text];
	
	[self.view makeToast:@"ID复制成功" duration:3 position:CSToastPositionTop];
}

- (void)id_tap {
	NSString *token = [USER_DEFAULTS stringForKey:KEY_TOKEN];
	if (!token.length) {
		JSigninController *vc = [JSigninController new];
		JNavigationController *nc = [[JNavigationController alloc] initWithRootViewController:vc];
		[self presentViewController:nc animated:YES completion:nil];
	}
}

- (void)restore_tap {
	[[XYStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
	} failure:^(NSError *error) {
	}];
}

- (void)settings_tap {
	JSettingsController *vc = [[JSettingsController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)about_tap {
	JAboutController *vc = [[JAboutController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
