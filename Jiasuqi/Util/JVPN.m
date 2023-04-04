#import "JVPN.h"
#import "JConfModel.h"
#import "JCommon.h"

@implementation JVPN

+ (instancetype)shared {
	static JVPN *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[super allocWithZone:NULL] init];
	});
	return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
	return [JVPN shared];
}

- (id)copyWithZone:(struct _NSZone *)zone {
	return [JVPN shared];
}

- (instancetype)init {
	if (self = [super init]) {
		self.status = NEVPNStatusInvalid;
	}
	return self;
}

- (void)getTunnelProviderManager:(void (^)(NETunnelProviderManager * _Nullable))handle {
	[NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
		if (managers && managers.count > 0) {
			handle(managers.firstObject);
			return;
		}
		handle(nil);
	}];
}

- (void)savePreferences:(JConfModel *)model callback:(void(^)(NETunnelProviderManager * _Nullable))handle {
	[NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
		if (!managers) {
			handle(nil);
			return;
		}
		NETunnelProviderManager *manager = [[NETunnelProviderManager alloc] init];
		if (managers.count > 0) {
			manager = managers.firstObject;
		}
		NSDictionary *conf = @{@"host" : model.ip,
							  @"port" : model.port,
							  @"password" : @"",
							  @"authscheme" : @"",
							  @"ot_enable" : @"0",
							  @"protocol" : @"origin",
							  @"protocol_param" : @"",
							  @"obfs" : @"plain",
							  @"ot_path" : @"",
							  @"ota" : @"0",
							  @"ot_domain" : @"",
							  @"obfs_param" : @""
		};
		NSData *jsonData = [NSJSONSerialization dataWithJSONObject:conf options:NSJSONWritingPrettyPrinted error:nil];
		NSString *content = [[NSString alloc] initWithData:jsonData ?: [NSData new] encoding:NSUTF8StringEncoding] ?: @"";
		BOOL result = [content writeToURL:[JCommon ovpnURL] atomically:YES encoding:NSUTF8StringEncoding error:nil];
		__Log(@"%@", result ? @"保存conf成功":@"保存conf失败");
		
		NETunnelProviderProtocol *originConf = [NETunnelProviderProtocol new];
		originConf.providerConfiguration = conf;
		originConf.serverAddress = APP_NAME;
		manager.protocolConfiguration = originConf;
		manager.enabled = YES;
		manager.onDemandEnabled = YES;
		manager.localizedDescription = APP_NAME;
		[manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
			if (error) {
				handle(nil);
				return;
			}
			[manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
				if (error) {
					handle(nil);
					return;
				}
				handle(manager);
			}];
		}];
	}];
}

#pragma mark --
- (void)connect:(JConfModel *)model callback:(void(^)(NETunnelProviderManager *manager))handle {
	[self getTunnelProviderManager:^(NETunnelProviderManager * _Nullable manager) {
		if (self.status == NEVPNStatusConnecting ||
			self.status == NEVPNStatusDisconnecting ||
			self.status == NEVPNStatusReasserting) {
			return;
		}
		if (self.status == NEVPNStatusInvalid ||
			self.status == NEVPNStatusDisconnected) {
			[self savePreferences:model callback:^(NETunnelProviderManager * _Nullable manager) {
				if (manager) {
					if (manager.connection.status == NEVPNStatusInvalid ||
						manager.connection.status == NEVPNStatusDisconnected) {
						NSError *startError = nil;
						[manager.connection startVPNTunnelWithOptions:nil andReturnError:&startError];
						if(startError != nil) {
							handle(nil);
							__Log(@"startError: %@", startError);
						} else {
							__Log(@"startVPN");
							handle(manager);
						}
					}
					else {
						handle(manager);
					}
				}
			}];
		}
		else {
			if (manager) {
				[manager.connection stopVPNTunnel];
			}
		}
	}];
}

- (void)disconnect {
	__Log(@"stopVPN");
	[self getTunnelProviderManager:^(NETunnelProviderManager * _Nullable manager) {
		if (manager) {
			[manager.connection stopVPNTunnel];
		}
	}];
}


- (void)resavePreferencesWithCompletionHandler:(void (^)(NSError * _Nullable))completionHandler {
	[self disconnect];
	[self getTunnelProviderManager:^(NETunnelProviderManager * _Nullable manager) {
		[manager removeFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
			[manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
				if (error) {
					completionHandler(error);
					return;
				}
				
				completionHandler(nil);
			}];
		}];
	}];
}

@end
