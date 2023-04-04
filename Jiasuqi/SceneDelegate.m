#import "SceneDelegate.h"
#import "JTabBarController.h"
#import "JNavigationController.h"
@interface SceneDelegate ()
@end
@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
	UIWindowScene *windowScene = (UIWindowScene *)scene;
	self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
	self.window.frame = windowScene.coordinateSpace.bounds;
	self.window.backgroundColor = UIColor.blackColor;
	self.window.rootViewController = [[JTabBarController alloc] init];
	[self.window makeKeyAndVisible];
	
	XYStoreiTunesReceiptVerifier *shareRVer = [XYStoreiTunesReceiptVerifier shareInstance];
	shareRVer.sharedSecretKey = @"";
	[[XYStore defaultStore] registerReceiptVerifier:[XYStoreiTunesReceiptVerifier shareInstance]];
	[[XYStore defaultStore] registerTransactionPersistor:[XYStoreUserDefaultsPersistence shareInstance]];
	[[JNetwork shared] monitoring];
}

@end
