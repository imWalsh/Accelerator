#import "JSettingsController.h"
@interface JSettingsController ()
@property (weak, nonatomic) IBOutlet UISwitch *killSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *connectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notiSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *timeoutSwitch;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIView *outView;
@end
@implementation JSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)_loadUI {
	[super _loadUI];
	self.navigationItem.title = @"设置";
	UITapGestureRecognizer *stap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share_tap)];
	UITapGestureRecognizer *rtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rating_tap)];
	UITapGestureRecognizer *otap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signout_tap)];
	[self.shareView addGestureRecognizer:stap];
	[self.ratingView addGestureRecognizer:rtap];
	[self.outView addGestureRecognizer:otap];
}

- (void)_loadData {
	self.connectSwitch.on = [USER_DEFAULTS boolForKey:KEY_CONNECT];
	self.notiSwitch.on = [USER_DEFAULTS boolForKey:KEY_NOTIFY];
	self.timeoutSwitch.on = [USER_DEFAULTS boolForKey:KEY_TIMEOUT];
	NSString *t = [USER_DEFAULTS stringForKey:KEY_TOKEN];
	self.outView.hidden = [t isEqualToString:@""];
}

- (IBAction)kill_changed:(UISwitch *)sender {
	
}

- (IBAction)connect_changed:(UISwitch *)sender {
	[USER_DEFAULTS setBool:sender.isOn forKey:KEY_CONNECT];
	[USER_DEFAULTS synchronize];
}

- (IBAction)noti_changed:(UISwitch *)sender {
	[USER_DEFAULTS setBool:sender.isOn forKey:KEY_NOTIFY];
	[USER_DEFAULTS synchronize];
}

- (IBAction)timeout_changed:(UISwitch *)sender {
	[USER_DEFAULTS setBool:sender.isOn forKey:KEY_TIMEOUT];
	[USER_DEFAULTS synchronize];
}

- (void)share_tap {
	NSString *url = @"https://apps.apple.com/zh/app/id";
	NSArray *activityItems = @[url];
	UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
	vc.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeAirDrop];
	[self presentViewController:vc animated:YES completion:nil];
	vc.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
		if (completed) {
			[self.view makeToast:@"分享成功" duration:3 position:CSToastPositionTop];
		} else {
			[self.view makeToast:@"分享取消" duration:3 position:CSToastPositionTop];
		}
	};
}

- (void)rating_tap {
	if ([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
		[self.view endEditing:YES];
		[SKStoreReviewController requestReview];
	}
}

- (void)signout_tap {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		[USER_DEFAULTS setObject:@"" forKey:KEY_TOKEN];
		[USER_DEFAULTS setObject:@"" forKey:KEY_UID];
		[USER_DEFAULTS synchronize];
		self.outView.hidden = YES;
		[NOTIFICATION_CENTER postNotificationName:kJSignChangedNotification object:nil];
	}];
	UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:a1];
	[alert addAction:a2];
	[self presentViewController:alert animated:YES completion:nil];
}

@end
