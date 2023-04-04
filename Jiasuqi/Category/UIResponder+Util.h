//
//  UIResponder+Util.h
//  Jiasuqi
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Util)
+ (UIViewController *)presentedController;
+ (UIViewController *)topController;
+ (UIViewController *)visibleController;
@end

NS_ASSUME_NONNULL_END
