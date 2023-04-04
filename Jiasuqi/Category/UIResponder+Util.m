//
//  UIResponder+Util.m
//  Jiasuqi
//

#import "UIResponder+Util.h"
#import "JNavigationController.h"

@implementation UIResponder (Util)

+ (UIViewController *)presentedController {
	UIViewController *root = APPLICATION.windows.firstObject.rootViewController;
	UIViewController *presented = root.presentedViewController;
	return presented ? presented : root;
}

+ (UIViewController *)topController {
	JNavigationController *controller = (JNavigationController *)[self presentedController];
	return controller.topViewController;
}

+ (UIViewController *)visibleController {
	UIViewController *controller = [self presentedController];
	while (YES) {
		if ([controller isKindOfClass:[UINavigationController class]]) {
			controller = ((UINavigationController *)controller).visibleViewController;
		}
		else if ([controller isKindOfClass:[UITabBarController class]]) {
			controller = ((UITabBarController *)controller).selectedViewController;
		}
		else {
			return controller;
		}
	}
}

@end
