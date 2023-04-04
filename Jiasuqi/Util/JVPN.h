#import <Foundation/Foundation.h>
@class JConfModel;

NS_ASSUME_NONNULL_BEGIN

@interface JVPN : NSObject

@property (nonatomic, assign) NEVPNStatus status;

+ (instancetype)shared;

- (void)getTunnelProviderManager:(void (^)(NETunnelProviderManager * _Nullable))handle;
- (void)resavePreferencesWithCompletionHandler:(nullable void (^)(NSError * __nullable error))completionHandler;

- (void)connect:(JConfModel *)model callback:(void(^)(NETunnelProviderManager *manager))handle;
- (void)disconnect;

- (BOOL)configFileExists;
- (void)saveConfig:(JConfModel *)model;

@end
NS_ASSUME_NONNULL_END
