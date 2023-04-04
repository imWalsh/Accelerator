//
//  JPacketManager.m
//  TunTarget
//
//  Created by Walsh on 2022/11/20.
//

#import "JCommon.h"
#import "JPacketManager.h"
#import "JClearlyChair.h"
#import "JSalt.h"
#import "JAsket.h"
@import PacketProcessor;

@implementation JPacketManager

+ (void)confServer:(void(^)(dispatch_group_t group))handler {
	dispatch_group_t group = dispatch_group_create();
	
	NSError *err;
	
	dispatch_group_enter(group);
	
	handler(group);
	
	long result = dispatch_group_wait(group, DISPATCH_TIME_NOW + 2);
	
	if (result == 1) {
		err = [NSError errorWithDomain:@"timeout" code:0 userInfo:nil];
	}
	
	if (err) {
		exit(1);
	}
}

+ (void)stopServer {
	[TunnelInterface stop];
}


+ (void)shadowsocksServers:(void(^)(NSInteger port))completionHandler {
	[self confServer:^(dispatch_group_t group) {
		[[JAsket shared] shadowsocksServers:[JCommon ovpnURL] completion:^(int port, NSError *error) {
			completionHandler(port);
			dispatch_group_leave(group);
		}];
	}];
}

+ (void)httpServers:(void(^)(NSInteger port))completionHandler {
	[self confServer:^(dispatch_group_t group) {
		[[JAsket shared] httpTunnelServers:[JCommon ovpnURL] completion:^(int port, NSError *error) {
			completionHandler(port);
			dispatch_group_leave(group);
		}];
	}];
}

+ (void)startTunn:(NEPacketTunnelFlow *)packetFlow _:(void(^)(NSError *error))completionHandler {
	NSLog(@"startTunn");
	
	NSError *err = [TunnelInterface setupWithPacketTunnelFlow:packetFlow];
	
	if (err) {
		completionHandler(err);
		return;
	}

	NSError *error;
	NSString *content = [NSString stringWithContentsOfURL:[JCommon ovpnURL] encoding:NSUTF8StringEncoding error:&error];
	
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
	
	NSInteger cs = connectServer([server cStringUsingEncoding:NSUTF8StringEncoding], serverPort, 10000);
	
	if (cs != 0) {
		completionHandler([NSError errorWithDomain:@"port is nil" code:0 userInfo:nil]);
		return;
	}
}



@end
