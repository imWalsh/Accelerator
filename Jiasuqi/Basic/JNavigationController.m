#import "JNavigationController.h"
@interface JNavigationController ()
@end
@implementation JNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (void)initialize {
	UINavigationBar *bar = [UINavigationBar appearance];
	[bar setTintColor:kTintColor];
	[bar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
	[bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
	
	UIBarButtonItem *item = [UIBarButtonItem appearance];
	NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
	itemAttrs[NSForegroundColorAttributeName] = kTintColor;
	itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
	[item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
	NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
	itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
	[item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (self.viewControllers.count > 0) {
		viewController.hidesBottomBarWhenPushed = YES;
	}
	[super pushViewController:viewController animated:animated];
}
@end
