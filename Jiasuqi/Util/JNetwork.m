#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "JNetwork.h"

@interface JNetwork()<NSURLSessionDataDelegate>
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation JNetwork
{
	testBlock   					_testBlock;
	finishTestBlock   				_finishBlock;
	faildBlock   					_faildBlock;
	int                           	_second;
	NSMutableData                	*_connectData;
	NSMutableData                	*_oneMinData;
	NSURLSession					*_session;
	NSTimer                      	*_timer;
}

+ (instancetype)shared {
	static JNetwork *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[super allocWithZone:NULL] init];
	});
	return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
	return [JNetwork shared];
}

- (id)copyWithZone:(struct _NSZone *)zone {
	return [JNetwork shared];
}

- (instancetype)init {
	if (self = [super init]) {
		self.manager = [AFHTTPSessionManager manager];
	}
	return self;
}

#pragma mark -- methed
- (void)monitoring {
	AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
	[manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		switch (status) {
			case AFNetworkReachabilityStatusUnknown:
				NSLog(@"未知网络");
				break;
			case AFNetworkReachabilityStatusNotReachable:
				NSLog(@"没有网络(断网)");
				[NOTIFICATION_CENTER postNotificationName:kJNetStatusChangedNotification object:nil];
			case AFNetworkReachabilityStatusReachableViaWWAN:
				NSLog(@"手机自带网络");
				[NOTIFICATION_CENTER postNotificationName:kJNetStatusChangedNotification object:nil];
				break;
			case AFNetworkReachabilityStatusReachableViaWiFi:
				NSLog(@"WIFI");
				[NOTIFICATION_CENTER postNotificationName:kJNetStatusChangedNotification object:nil];
				break;
		}
	}];
	[manager startMonitoring];
}

#pragma mark - --
- (NSString *)formattedSize:(unsigned long long)size {
	NSString *formattedStr = nil;
	if (size == 0){
		formattedStr = NSLocalizedString(@"0 KB",@"");
	}else if (size > 0 && size < 1024){
		formattedStr = [NSString stringWithFormat:@"%qubytes", size];
	}else if (size >= 1024 && size < pow(1024, 2)){
		formattedStr = [NSString stringWithFormat:@"%quKB", (size / 1024)];
	}else if (size >= pow(1024, 2) && size < pow(1024, 3)){
		int intsize = size / pow(1024, 2);
		formattedStr = [NSString stringWithFormat:@"%dMB", intsize];
	}else if (size >= pow(1024, 3)){
		int intsize = size / pow(1024, 3);
		formattedStr = [NSString stringWithFormat:@"%dGB", intsize];
	}
	return formattedStr;
}

- (void)get:(NSString *)url
	 header:(nullable NSDictionary *)header
	  param:(nullable NSDictionary *)param
	success:(void(^)(id _Nonnull))success
	failure:(nullable void(^)(NSError * _Nonnull))failure {
	
	self.manager.requestSerializer.timeoutInterval = 15;
	[self.manager GET:url parameters:param headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		__Log(@"responseObject -- %@", responseObject);
		success(responseObject);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		if (error) {
			__Log(@"error -- %@",error);
			if (failure) {
				failure(error);
			}
		}
	}];
}

- (void)post:(NSString *)url
	  header:(nullable NSDictionary *)header
	   param:(nullable NSDictionary *)param
	 success:(void (^)(id _Nonnull))success
	 failure:(void (^)(NSError * _Nonnull))failure {
	
	self.manager.requestSerializer.timeoutInterval = 15;
	[self.manager POST:url parameters:param headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		__Log(@"responseObject -- %@", responseObject);
		success(responseObject);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		if (error) {
			__Log(@"error -- %@",error);
			failure(error);
		}
	}];
}
@end
