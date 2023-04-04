#import <Foundation/Foundation.h>

#ifdef DEBUG
#define APIURL					@"https://"
#else
#define APIURL					@"https://"
#endif

NS_ASSUME_NONNULL_BEGIN
@interface JNetwork : NSObject
typedef void (^testBlock)(float speed);
typedef void (^finishTestBlock)(float speed);
typedef void (^faildBlock)(NSError *error);


+ (instancetype)shared;


- (void)monitoring;


- (void)get:(NSString *)url
	header:(nullable NSDictionary *)header
	param:(nullable NSDictionary *)param
	success:(void(^)(id _Nonnull response))success
	failure:(nullable void(^)(NSError * _Nonnull))failure;

- (void)post:(NSString *)url
	  header:(nullable NSDictionary *)header
	   param:(nullable NSDictionary *)param
	 success:(void(^)(id _Nonnull response))success
	 failure:(nullable void(^)(NSError * _Nonnull))failure;
@end
NS_ASSUME_NONNULL_END
