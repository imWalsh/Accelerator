#import "TXTunnelManager.h"
@implementation TXTunnelManager
+ (void)configServer:(void(^)(dispatch_group_t group))handle {
	dispatch_group_t group = dispatch_group_create();
	NSError *err;
	dispatch_group_enter(group);
	handle(group);
	long result = dispatch_group_wait(group, DISPATCH_TIME_NOW + 2);
	if (result == 1) {
		err = [NSError errorWithDomain:@"error" code:-1 userInfo:nil];
	}
	if (err) {
		exit(1);
	}
}
+ (void)shadowsocksServer:(void(^)(NSInteger port))completionHandler {
	[self configServer:^(dispatch_group_t group) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			completionHandler(443);
			dispatch_group_leave(group);
		});
	}];
}
+ (void)httpServer:(void(^)(NSInteger port))completionHandler {
	[self configServer:^(dispatch_group_t group) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			completionHandler(443);
			dispatch_group_leave(group);
		});
	}];
}
+ (void)openTunnel:(NEPacketTunnelFlow *)packetFlow _:(void(^)(NSError *error))completionHandler {
	NSLog(@"openTunnel");
	
	NSURL *url = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@""];
	
	NSError *error;
	NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	NSData *objectData = [content dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:&error];
	if (error) {
		completionHandler([NSError errorWithDomain:@"conf is nil" code:0 userInfo:nil]);
		return;
	}
	NSString *server = [dic[@"server"] stringValue];
	int serverPort = [dic[@"server"] intValue];
	if (!server.length || serverPort == 0) {
		completionHandler([NSError errorWithDomain:@"server is nil" code:0 userInfo:nil]);
		return;
	}
	
	completionHandler(nil);
}
+ (void)closeTunnel {
	NSLog(@"closeTunnel");
}
@end
