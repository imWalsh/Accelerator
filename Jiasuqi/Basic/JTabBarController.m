#import "JNavigationController.h"
#import "JTabBarController.h"
#import "JHomeController.h"
#import "JProController.h"
#import "JProfileController.h"
@interface JTabBarController () <UITabBarControllerDelegate>
@property (nonatomic, assign) NSUInteger lastIndex;
@end
@implementation JTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.delegate = self;
	[self addChildren];
}

- (void)addChildren {
	JHomeController 		*vc1 = [[JHomeController alloc] init];
	JProController 			*vc2 = [[JProController alloc] init];
	JProfileController		*vc3 = [[JProfileController alloc] init];
	UIImage *n1 = [UIImage imageNamed:@"home"];
	UIImage *s1 = [[UIImage imageNamed:@"home"] imageWithTintColor:kTintColor];
	vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:n1 selectedImage:s1];

	vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@" " image:[UIImage imageNamed:@"logo"] selectedImage:[UIImage imageNamed:@"logo"]];
	
	UIImage *n3 = [UIImage imageNamed:@"profile"];
	UIImage *s3 = [[UIImage imageNamed:@"profile"] imageWithTintColor:kTintColor];
	vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"账号" image:n3 selectedImage:s3];
	[UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:kNormalColor,
													  NSFontAttributeName: [UIFont systemFontOfSize:13]}
										   forState:UIControlStateNormal];
	[UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:kTintColor,
													  NSFontAttributeName: [UIFont systemFontOfSize:13]}
										   forState:UIControlStateSelected];
	self.viewControllers = @[[[JNavigationController alloc] initWithRootViewController:vc1],
							 [[JNavigationController alloc] initWithRootViewController:vc2],
							 [[JNavigationController alloc] initWithRootViewController:vc3]];
	self.tabBar.barTintColor = kNormalColor;
	self.tabBar.backgroundColor = kBackgroundColor;
	self.tabBar.backgroundImage = [UIImage new];
	self.tabBar.shadowImage = [UIImage new];
	self.lastIndex = 0;
}
- (void)didSelected:(NSInteger)index {
	self.lastIndex = index;
	self.selectedIndex = index;
	self.selectedViewController = self.viewControllers[index];
}

#pragma mark - delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	NSInteger index = [self.viewControllers indexOfObject:viewController];
	if(index == self.lastIndex) { return NO; }
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.2f];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
	[animation setType:kCATransitionFade];
	[tabBarController.view.layer addAnimation:animation forKey:nil];
	NSInteger index = [self.viewControllers indexOfObject:viewController];
	if (index == 2) {
		
	}
	self.lastIndex = index;
}
@end
